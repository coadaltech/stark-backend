import { Elysia } from "elysia";
import { and, eq, gt, isNull } from "drizzle-orm";
import { db } from "../db";
import { authSession } from "../db/legacy";
import { MAIN_SITE, verifyAccessToken, type AuthUser } from "./tokens";

const DEVELOPER_ROLE_ID = 1;
const unauthorized = { message: "Please sign in again." };
const forbidden = { message: "You don't have access to this." };

/**
 * The signed-in user from `Authorization: Bearer <access token>`, or null. The token must be valid and
 * its session still active on the same site (so logout takes effect immediately).
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
