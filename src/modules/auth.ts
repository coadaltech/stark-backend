import { Elysia, t } from "elysia";
import { and, eq, isNull, sql } from "drizzle-orm";
import { db } from "../db";
import { authSession, login } from "../db/legacy";
import {
  accountsOfSite,
  denial,
  selectAccount,
  siteOfHost,
  siteStillValid,
  type Account,
  type SessionSite,
} from "../auth/access";
import { authGuard } from "../auth/guard";
import {
  issueAccessToken,
  issueRefreshToken,
  MAIN_SITE,
  REFRESH_TTL_SECONDS,
  verifyRefreshToken,
  type AuthUser,
} from "../auth/tokens";

/** A refresh token replaced less than this long ago is still accepted (parallel refreshes). */
const ROTATION_GRACE_MS = 30_000;
const INVALID_CREDENTIALS = "Invalid username or password.";
const SESSION_ENDED = "Your session has ended. Please sign in again.";

// Checked when the username isn't found, so response time doesn't reveal which usernames exist.
const DUMMY_HASH = await Bun.password.hash(crypto.randomUUID(), {
  algorithm: "bcrypt",
  cost: 10,
});

const toAuthUser = (
  account: Account,
  sessionId: string,
  { site, siteOrganizationId }: SessionSite,
): AuthUser => ({
  loginId: account.LoginId,
  userName: account.UserName,
  name: account.LoginName,
  roleId: account.LoginType,
  roleName: account.RoleName,
  organizationId: account.OrganizationId,
  sessionId,
  site,
  siteOrganizationId,
});

const publicUser = (user: AuthUser) => ({
  loginId: user.loginId,
  userName: user.userName,
  name: user.name,
  roleId: user.roleId,
  roleName: user.roleName,
  organizationId: user.organizationId,
  site: user.site,
  siteOrganizationId: user.siteOrganizationId,
});

const UserSchema = t.Object({
  loginId: t.Number(),
  userName: t.String(),
  name: t.String(),
  roleId: t.Number(),
  roleName: t.String(),
  organizationId: t.Nullable(t.Number()),
  site: t.String(),
  siteOrganizationId: t.Nullable(t.Number()),
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
const RefreshAtSiteBody = t.Object({
  refreshToken: t.String({ minLength: 1, maxLength: 2000 }),
  // The address the refresh comes from; a token is only refreshed at its own site.
  Host: t.String({ minLength: 1, maxLength: 300, error: "Host is required" }),
});

async function tokenPair(
  account: Account,
  sessionId: string,
  site: SessionSite,
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
      const site = await siteOfHost(body.Host);
      if (!site) return status(404, { message: "Site not found" });
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
      const denied = denial(account);
      if (denied) return status(403, { message: denied.message });

      const sessionId = crypto.randomUUID();
      const refresh = await issueRefreshToken(account.LoginId, sessionId, site.site, 0);
      await db.insert(authSession).values({
        SessionId: sessionId,
        LoginId: account.LoginId,
        Site: site.site,
        SiteOrganizationId: site.siteOrganizationId,
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
        // The address the user is signing in at; decides the site (main app or an organization).
        Host: t.String({ minLength: 1, maxLength: 300, error: "Host is required" }),
      }),
      response: { 200: TokenPair, 401: Message, 403: Message, 404: Message },
      detail: {
        summary:
          "Sign in at a site (main app: developers only; organization site: developers and its staff)",
      },
    },
  )
  .post(
    "/refresh",
    async ({ body, status }) => {
      const presented = await verifyRefreshToken(body.refreshToken);
      if (!presented) return status(401, { message: SESSION_ENDED });
      const hostSite = await siteOfHost(body.Host);

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

        const site: SessionSite = {
          site: session.Site,
          siteOrganizationId: session.SiteOrganizationId,
        };
        if (
          hostSite?.site !== site.site ||
          hostSite.siteOrganizationId !== site.siteOrganizationId
        ) {
          // Presented at another address. End the session only if its own site no longer exists for the
          // same organization (Domain OFF, deleted, or moved); a token carried to another site is
          // refused without touching its session.
          if (!(await siteStillValid(site))) await revoke("site");
          return { kind: "ended" } as const;
        }

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

        // The account must still be allowed on this site (spec §5.2).
        const [account] = await selectAccount(tx)
          .where(and(eq(login.LoginId, session.LoginId), accountsOfSite(site)))
          .limit(1);
        if (!account) {
          await revoke("account");
          return { kind: "ended" } as const;
        }
        const denied = denial(account);
        if (denied) {
          await revoke(denied.reason);
          return { kind: "forbidden", message: denied.message } as const;
        }

        if (inGrace) {
          // A parallel refresh that raced the latest rotation: hand out the current refresh token
          // again (rebuilt identically) instead of rotating once more, so every racing request ends
          // up with the same cookie.
          const current = await issueRefreshToken(
            account.LoginId,
            session.SessionId,
            session.Site,
            session.Rotation,
            Math.floor(session.ExpiresAt.getTime() / 1000) - REFRESH_TTL_SECONDS,
          );
          // Sessions from before this scheme can't be rebuilt; treat like an ended session.
          if (current.hash !== session.RefreshTokenHash) return { kind: "ended" } as const;
          return {
            kind: "ok",
            pair: await tokenPair(account, session.SessionId, site, current),
          } as const;
        }

        const rotation = session.Rotation + 1;
        const refresh = await issueRefreshToken(
          account.LoginId,
          session.SessionId,
          session.Site,
          rotation,
        );
        await tx
          .update(authSession)
          .set({
            RefreshTokenHash: refresh.hash,
            PreviousRefreshTokenHash: session.RefreshTokenHash,
            RotatedAt: new Date(),
            ExpiresAt: new Date(refresh.expiresAt * 1000),
            Rotation: rotation,
          })
          .where(eq(authSession.SessionId, session.SessionId));
        return {
          kind: "ok",
          pair: await tokenPair(account, session.SessionId, site, refresh),
        } as const;
      });

      if (result.kind === "ended")
        return status(401, { message: SESSION_ENDED });
      if (result.kind === "forbidden")
        return status(403, { message: result.message });
      return result.pair;
    },
    {
      body: RefreshAtSiteBody,
      response: { 200: TokenPair, 401: Message, 403: Message },
      detail: {
        summary:
          "Exchange a refresh token for a new pair at its own site (rotates the refresh token)",
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
      // Same checks as a refresh: the site still exists for the same organization and the account is
      // still allowed on it. (The session itself was checked by the guard.)
      const site: SessionSite = { site: user.site, siteOrganizationId: user.siteOrganizationId };
      if (!(await siteStillValid(site))) return status(401, { message: SESSION_ENDED });
      const [account] = await selectAccount(db)
        .where(and(eq(login.LoginId, user.loginId), accountsOfSite(site)))
        .limit(1);
      if (!account || denial(account)) return status(401, { message: SESSION_ENDED });
      return publicUser(toAuthUser(account, user.sessionId, site));
    },
    {
      response: { 200: UserSchema, 401: Message },
      detail: { summary: "The signed-in user" },
    },
  );
