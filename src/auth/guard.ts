import { Elysia } from "elysia";
import { and, eq, gt, isNull, sql } from "drizzle-orm";
import { db } from "../db";
import { authSession, login } from "../db/legacy";
import { accountsOfSite, denial, selectAccount, siteStillValid } from "./access";
import { MAIN_SITE, verifyAccessToken, type AuthUser } from "./tokens";
import { allows, effectivePermissions, type Action, type PermissionMap } from "../permissions/effective";

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
 * Signed in on an organization site, the site still exists for that organization, and the account is
 * still allowed there (spec §5.2) — checked on every call, so deactivating an organization or turning
 * its Domain off takes effect at once, not after the access token expires.
 */
async function authenticateOrganizationSite(
  authorization: string | undefined,
): Promise<{ error: 401 | 403 } | { error?: undefined; user: AuthUser; organizationId: number }> {
  const user = await authenticate(authorization);
  if (!user) return { error: 401 };
  const organizationId = user.siteOrganizationId;
  if (organizationId === null) return { error: 403 };
  const site = { site: user.site, siteOrganizationId: organizationId };
  if (!(await siteStillValid(site))) return { error: 401 };
  const [account] = await selectAccount(db)
    .where(and(eq(login.LoginId, user.loginId), accountsOfSite(site)))
    .limit(1);
  if (!account || denial(account)) return { error: 401 };
  return { user, organizationId };
}

/**
 * Organization-site work. Handlers get `user`, `organizationId` (the site's organization) and the
 * user's effective `permissions` (specs/build/permissions/permission_spec.md §3.1).
 */
export const organizationSiteGuard = new Elysia({ name: "organization-site-guard" }).derive(
  { as: "scoped" },
  async ({ headers, status }) => {
    const result = await authenticateOrganizationSite(headers.authorization);
    if (result.error) return status(result.error, result.error === 401 ? unauthorized : forbidden);
    const permissions = await effectivePermissions(result.user, result.organizationId);
    return { user: result.user, organizationId: result.organizationId, permissions };
  },
);

/**
 * Route hook for routes behind `organizationSiteGuard`: 403 "You don't have access to this." unless
 * the user may take `action` on page `pageKey`. Use as the route's `transform` hook — it runs before
 * body validation, so a forbidden caller never sees validation details.
 *   .post("/", handler, { transform: requirePermission("staff-list", "add"), body })
 */
export const requirePermission =
  (pageKey: string, ...anyOf: [Action, ...Action[]]) =>
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  ({ permissions, status }: { permissions: PermissionMap; status: (code: 403, body: typeof forbidden) => any }) => {
    if (!anyOf.some((action) => allows(permissions, pageKey, action))) return status(403, forbidden);
  };

/** Roles that manage permissions (permission_spec.md §3.3): DEVELOPER, SUPERADMIN, ADMIN. */
export const PERMISSION_MANAGER_ROLE_IDS: readonly number[] = [DEVELOPER_ROLE_ID, 2, 7];

/**
 * Route hook (as `transform`, before validation) for the Permissions section: only DEVELOPER,
 * SUPERADMIN and ADMIN; it is not itself controlled by permissions, so nobody can lock themselves out.
 */
export const requirePermissionManager =
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  ({ user, status }: { user: AuthUser; status: (code: 403, body: typeof forbidden) => any }) => {
    if (!PERMISSION_MANAGER_ROLE_IDS.includes(user.roleId)) return status(403, forbidden);
  };
