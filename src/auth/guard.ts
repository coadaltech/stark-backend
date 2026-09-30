import { Elysia } from "elysia";
import { and, eq, gt, isNull } from "drizzle-orm";
import { db } from "../db";
import { authSession } from "../db/legacy";
import { verifyAccessToken, type AuthUser } from "./tokens";

const unauthorized = { message: "Please sign in again." };

/**
 * Requires `Authorization: Bearer <access token>` on every route of the module that uses it, and that
 * the token's session is still active (so logout takes effect immediately). Handlers get a typed
 * `user`. Role/site rules are applied by each module (e.g. layer 04: developer on the main app).
 */
export const authGuard = new Elysia({ name: "auth-guard" }).resolve(
  { as: "scoped" },
  async ({ headers, status }) => {
    const match = /^Bearer (.+)$/.exec(headers.authorization ?? "");
    const user: AuthUser | null = match
      ? await verifyAccessToken(match[1]!)
      : null;
    if (!user) return status(401, unauthorized);

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
    if (!session) return status(401, unauthorized);
    return { user };
  },
);
