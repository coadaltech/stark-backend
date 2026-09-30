import { Elysia, t } from "elysia";
import { and, eq, isNull, ne, sql } from "drizzle-orm";
import { db } from "../db";
import { authSession, login, sysRole } from "../db/legacy";
import { authGuard } from "../auth/guard";
import {
  issueAccessToken,
  issueRefreshToken,
  MAIN_SITE,
  REFRESH_TTL_SECONDS,
  verifyRefreshToken,
  type AuthUser,
} from "../auth/tokens";

type Tx = Parameters<Parameters<typeof db.transaction>[0]>[0];

const DEVELOPER_ROLE_ID = 1;
/** A refresh token replaced less than this long ago is still accepted (parallel refreshes). */
const ROTATION_GRACE_MS = 30_000;
const INVALID_CREDENTIALS = "Invalid username or password.";
const INACTIVE = "Your account is inactive. Please contact your administrator.";
const SESSION_ENDED = "Your session has ended. Please sign in again.";

// Checked when the username isn't found, so response time doesn't reveal which usernames exist.
const DUMMY_HASH = await Bun.password.hash(crypto.randomUUID(), {
  algorithm: "bcrypt",
  cost: 10,
});

type Account = {
  LoginId: number;
  UserName: string;
  LoginName: string;
  Password: string;
  LoginType: number;
  OrganizationId: number | null;
  AccountStatus: string;
  RoleName: string;
};

function selectAccount(executor: typeof db | Tx) {
  return executor
    .select({
      LoginId: login.LoginId,
      UserName: login.UserName,
      LoginName: login.LoginName,
      Password: login.Password,
      LoginType: login.LoginType,
      OrganizationId: login.OrganizationId,
      AccountStatus: login.AccountStatus,
      RoleName: sql<string>`coalesce(${sysRole.RoleName}, '')`,
    })
    .from(login)
    .leftJoin(sysRole, eq(sysRole.RoleId, login.LoginType))
    .$dynamic();
}

/**
 * Accounts that may sign in to a site. Main app: developers only (platform accounts with no
 * organization). Organization sites are added in layer 08.
 */
function accountsOfSite(site: string) {
  if (site !== MAIN_SITE) return sql`false`;
  return and(
    isNull(login.OrganizationId),
    eq(login.LoginType, DEVELOPER_ROLE_ID),
    ne(login.RecordStatus, "D"),
  );
}

const toAuthUser = (
  account: Account,
  sessionId: string,
  site: string,
): AuthUser => ({
  loginId: account.LoginId,
  userName: account.UserName,
  name: account.LoginName,
  roleId: account.LoginType,
  roleName: account.RoleName,
  organizationId: account.OrganizationId,
  sessionId,
  site,
});

const publicUser = (user: AuthUser) => ({
  loginId: user.loginId,
  userName: user.userName,
  name: user.name,
  roleId: user.roleId,
  roleName: user.roleName,
  organizationId: user.organizationId,
  site: user.site,
});

const UserSchema = t.Object({
  loginId: t.Number(),
  userName: t.String(),
  name: t.String(),
  roleId: t.Number(),
  roleName: t.String(),
  organizationId: t.Nullable(t.Number()),
  site: t.String(),
});

const TokenPair = t.Object({
  user: UserSchema,
  accessToken: t.String(),
  /** Unix seconds. */
  accessTokenExpiresAt: t.Number(),
  refreshToken: t.String(),
  refreshTokenExpiresAt: t.Number(),
});

const Message = t.Object({ message: t.String() });
const RefreshBody = t.Object({
  refreshToken: t.String({ minLength: 1, maxLength: 2000 }),
});

async function tokenPair(
  account: Account,
  sessionId: string,
  site: string,
  refresh: { token: string; expiresAt: number },
) {
  const user = toAuthUser(account, sessionId, site);
  const access = await issueAccessToken(user);
  return {
    user: publicUser(user),
    accessToken: access.token,
    accessTokenExpiresAt: access.expiresAt,
    refreshToken: refresh.token,
    refreshTokenExpiresAt: refresh.expiresAt,
  };
}

const clientIp = (
  headers: Record<string, string | undefined>,
  fallback: string | undefined,
) =>
  (headers["x-forwarded-for"]?.split(",")[0]?.trim() || fallback || "").slice(
    0,
    64,
  ) || null;

export const auth = new Elysia({ prefix: "/auth", tags: ["Auth"] })
  .post(
    "/login",
    async ({ body, headers, server, request, status }) => {
      const site = MAIN_SITE; // Layer 08: resolved from the site the user is signing in to.
      const userName = body.UserName.trim();
      const [account] = await selectAccount(db)
        .where(
          and(
            sql`lower(${login.UserName}) = lower(${userName})`,
            accountsOfSite(site),
          ),
        )
        .limit(1);

      const passwordOk = await Bun.password
        .verify(body.Password, account?.Password ?? DUMMY_HASH)
        .catch(() => false); // e.g. a legacy non-bcrypt value
      if (!account || !passwordOk)
        return status(401, { message: INVALID_CREDENTIALS });
      if (account.AccountStatus !== "1")
        return status(403, { message: INACTIVE });

      const sessionId = crypto.randomUUID();
      const refresh = await issueRefreshToken(account.LoginId, sessionId, site);
      await db.insert(authSession).values({
        SessionId: sessionId,
        LoginId: account.LoginId,
        Site: site,
        RefreshTokenHash: refresh.hash,
        ExpiresAt: new Date(refresh.expiresAt * 1000),
        UserAgent: headers["user-agent"]?.slice(0, 300) ?? null,
        Ip: clientIp(headers, server?.requestIP(request)?.address),
      });
      return tokenPair(account, sessionId, site, refresh);
    },
    {
      body: t.Object({
        UserName: t.String({
          minLength: 1,
          maxLength: 30,
          error: "Username is required",
        }),
        Password: t.String({
          minLength: 1,
          maxLength: 72,
          error: "Password is required",
        }),
      }),
      response: { 200: TokenPair, 401: Message, 403: Message },
      detail: {
        summary:
          "Sign in with username and password (main app: developers only)",
      },
    },
  )
  .post(
    "/refresh",
    async ({ body, status }) => {
      const presented = await verifyRefreshToken(body.refreshToken);
      if (!presented) return status(401, { message: SESSION_ENDED });

      const result = await db.transaction(async (tx) => {
        const [session] = await tx
          .select()
          .from(authSession)
          .where(eq(authSession.SessionId, presented.sessionId))
          .for("update");
        if (
          !session ||
          session.LoginId !== presented.loginId ||
          session.Site !== presented.site ||
          session.RevokedAt ||
          session.ExpiresAt <= new Date()
        ) {
          return { kind: "ended" } as const;
        }

        const revoke = (reason: string) =>
          tx
            .update(authSession)
            .set({ RevokedAt: new Date(), RevokedReason: reason })
            .where(eq(authSession.SessionId, session.SessionId));

        const isCurrent = presented.hash === session.RefreshTokenHash;
        const inGrace =
          presented.hash === session.PreviousRefreshTokenHash &&
          session.RotatedAt !== null &&
          Date.now() - session.RotatedAt.getTime() < ROTATION_GRACE_MS;
        if (!isCurrent && !inGrace) {
          // An old token was replayed: assume it leaked and end the session.
          await revoke("reuse");
          return { kind: "ended" } as const;
        }

        // The account must still be allowed on this site.
        const [account] = await selectAccount(tx)
          .where(
            and(
              eq(login.LoginId, session.LoginId),
              accountsOfSite(session.Site),
            ),
          )
          .limit(1);
        if (!account) {
          await revoke("account");
          return { kind: "ended" } as const;
        }
        if (account.AccountStatus !== "1") {
          await revoke("inactive");
          return { kind: "forbidden", message: INACTIVE } as const;
        }

        const refresh = await issueRefreshToken(
          account.LoginId,
          session.SessionId,
          session.Site,
        );
        await tx
          .update(authSession)
          .set({
            RefreshTokenHash: refresh.hash,
            PreviousRefreshTokenHash: session.RefreshTokenHash,
            RotatedAt: new Date(),
            ExpiresAt: new Date(Date.now() + REFRESH_TTL_SECONDS * 1000),
          })
          .where(eq(authSession.SessionId, session.SessionId));
        return {
          kind: "ok",
          pair: await tokenPair(
            account,
            session.SessionId,
            session.Site,
            refresh,
          ),
        } as const;
      });

      if (result.kind === "ended")
        return status(401, { message: SESSION_ENDED });
      if (result.kind === "forbidden")
        return status(403, { message: result.message });
      return result.pair;
    },
    {
      body: RefreshBody,
      response: { 200: TokenPair, 401: Message, 403: Message },
      detail: {
        summary:
          "Exchange a refresh token for a new pair (rotates the refresh token)",
      },
    },
  )
  .post(
    "/logout",
    async ({ body, set }) => {
      // Always succeeds for the client; ends the session when the token is valid.
      const presented = await verifyRefreshToken(body.refreshToken);
      if (presented) {
        await db
          .update(authSession)
          .set({ RevokedAt: new Date(), RevokedReason: "logout" })
          .where(
            and(
              eq(authSession.SessionId, presented.sessionId),
              eq(authSession.LoginId, presented.loginId),
              isNull(authSession.RevokedAt),
            ),
          );
      }
      set.status = 204;
    },
    { body: RefreshBody, detail: { summary: "Sign out (ends the session)" } },
  )
  .use(authGuard)
  .get(
    "/me",
    async ({ user, status }) => {
      const [account] = await selectAccount(db)
        .where(and(eq(login.LoginId, user.loginId), accountsOfSite(user.site)))
        .limit(1);
      if (!account || account.AccountStatus !== "1")
        return status(401, { message: SESSION_ENDED });
      return publicUser(toAuthUser(account, user.sessionId, user.site));
    },
    {
      response: { 200: UserSchema, 401: Message },
      detail: { summary: "The signed-in user" },
    },
  );
