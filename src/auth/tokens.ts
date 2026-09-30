import { env } from "../env";
import { sha256Hex, signJwt, verifyJwt, type JwtPayload } from "./jwt";

export const ISSUER = "stark";
export const ACCESS_TTL_SECONDS = 15 * 60; // 15 minutes
export const REFRESH_TTL_SECONDS = 7 * 24 * 60 * 60; // 7 days (sliding: extended on every refresh)

/** The main app. Organization sites (layer 08) will use their host. */
export const MAIN_SITE = "main";

/** Who is signed in, and on which site — carried in the access token. */
export type AuthUser = {
  loginId: number;
  userName: string;
  name: string;
  roleId: number;
  roleName: string;
  /** Null for developers (platform accounts). */
  organizationId: number | null;
  sessionId: string;
  site: string;
};

type AccessPayload = JwtPayload & {
  typ: "access";
  sub: string;
  sid: string;
  site: string;
  org: number | null;
  usr: string;
  name: string;
  role: number;
  roleName: string;
};

type RefreshPayload = JwtPayload & {
  typ: "refresh";
  sub: string;
  sid: string;
  site: string;
  jti: string;
};

export async function issueAccessToken(user: AuthUser) {
  const { token, payload } = await signJwt(
    {
      typ: "access",
      sub: String(user.loginId),
      sid: user.sessionId,
      site: user.site,
      org: user.organizationId,
      usr: user.userName,
      name: user.name,
      role: user.roleId,
      roleName: user.roleName,
    },
    env.JWT_ACCESS_SECRET,
    ACCESS_TTL_SECONDS,
    ISSUER,
  );
  return { token, expiresAt: payload.exp };
}

/** A JWT naming its session and site; a random jti makes every rotation unique. */
export async function issueRefreshToken(
  loginId: number,
  sessionId: string,
  site: string,
) {
  const { token, payload } = await signJwt(
    {
      typ: "refresh",
      sub: String(loginId),
      sid: sessionId,
      site,
      jti: crypto.randomUUID(),
    },
    env.JWT_REFRESH_SECRET,
    REFRESH_TTL_SECONDS,
    ISSUER,
  );
  return { token, expiresAt: payload.exp, hash: await sha256Hex(token) };
}

export async function verifyAccessToken(
  token: string,
): Promise<AuthUser | null> {
  const result = await verifyJwt<AccessPayload>(
    token,
    env.JWT_ACCESS_SECRET,
    ISSUER,
  );
  if (!result.ok || result.payload.typ !== "access") return null;
  const p = result.payload;
  return {
    loginId: Number(p.sub),
    userName: p.usr,
    name: p.name,
    roleId: p.role,
    roleName: p.roleName,
    organizationId: p.org,
    sessionId: p.sid,
    site: p.site,
  };
}

export async function verifyRefreshToken(token: string) {
  const result = await verifyJwt<RefreshPayload>(
    token,
    env.JWT_REFRESH_SECRET,
    ISSUER,
  );
  if (!result.ok || result.payload.typ !== "refresh") return null;
  const p = result.payload;
  return {
    loginId: Number(p.sub),
    sessionId: p.sid,
    site: p.site,
    hash: await sha256Hex(token),
  };
}
