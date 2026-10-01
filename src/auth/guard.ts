import { Elysia } from "elysia";
import { and, eq, gt, isNull, sql } from "drizzle-orm";
import { db } from "../db";
import { authSession, login } from "../db/legacy";
import { accountsOfSite, denial, selectAccount, siteStillValid } from "./access";
import { MAIN_SITE, verifyAccessToken, type AuthUser } from "./tokens";

const DEVELOPER_ROLE_ID = 1;
const unauthorized = { message: "Please sign in again." };
const forbidden = { message: "You don't have access to this." };

/**
 * The signed-in user from `Authorization: Bearer <access token>`, or null. The token must be valid and
 * its session still active on the same site (so logout takes effect immediately). Whether the site
 * still exists and the account may still use it is checked by /auth/me and on refresh.
 */
export async function authenticate(
  authorization: string | undefined,
): Promise<AuthUser | null> {
  const match = /^Bearer (.+)$/.exec(authorization ?? "");
  const user = match ? await verifyAccessToken(match[1]!) : null;
  if (!user) return null;
  const [session] = await db
    .select({ SessionId: authSession.SessionId })
    .from(authSession)
    .where(
      and(
        eq(authSession.SessionId, user.sessionId),
        eq(authSession.Site, user.site),
        sql`${authSession.SiteOrganizationId} is not distinct from ${user.siteOrganizationId}`,
        isNull(authSession.RevokedAt),
        gt(authSession.ExpiresAt, new Date()),
      ),
    );
  return session ? user : null;
}

const isPlatformDeveloper = (user: AuthUser) =>
  user.roleId === DEVELOPER_ROLE_ID &&
  user.organizationId === null &&
  user.site === MAIN_SITE;

// Each guard does its whole check in one hook: Elysia "scoped" hooks only reach the module that uses
// the guard, so guards must not be stacked on top of each other.

/** Any signed-in user (401 otherwise). Handlers get a typed `user`. */
export const authGuard = new Elysia({ name: "auth-guard" }).derive(
  { as: "scoped" },
  async ({ headers, status }) => {
    const user = await authenticate(headers.authorization);
    if (!user) return status(401, unauthorized);
    return { user };
  },
);

/** Platform administration: a DEVELOPER signed in on the main app (401 not signed in, 403 anyone else). */
export const developerGuard = new Elysia({ name: "developer-guard" }).derive(
  { as: "scoped" },
  async ({ headers, status }) => {
    const user = await authenticate(headers.authorization);
    if (!user) return status(401, unauthorized);
    if (!isPlatformDeveloper(user)) return status(403, forbidden);
    return { user };
  },
);

/**
 * Organization-site work: signed in on an organization site, the site still exists for that
 * organization, and the account is still allowed there (spec §5.2) — checked on every call, so
 * deactivating an organization or turning its Domain off takes effect at once, not after the access
 * token expires. Handlers get `user` and `organizationId` (the site's organization).
 */
export const organizationSiteGuard = new Elysia({ name: "organization-site-guard" }).derive(
  { as: "scoped" },
  async ({ headers, status }) => {
    const user = await authenticate(headers.authorization);
    if (!user) return status(401, unauthorized);
    const organizationId = user.siteOrganizationId;
    if (organizationId === null) return status(403, forbidden);
    const site = { site: user.site, siteOrganizationId: organizationId };
    if (!(await siteStillValid(site))) return status(401, unauthorized);
    const [account] = await selectAccount(db)
      .where(and(eq(login.LoginId, user.loginId), accountsOfSite(site)))
      .limit(1);
    if (!account || denial(account)) return status(401, unauthorized);
    return { user, organizationId };
  },
);
