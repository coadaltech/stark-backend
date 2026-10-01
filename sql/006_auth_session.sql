-- Sign-in sessions for the hand-written JWT auth (spec §5).
-- One row per signed-in device. Only hashes of refresh tokens are stored. Each refresh rotates the
-- token; the previous hash is kept so a request that raced the rotation (parallel refreshes) is
-- accepted for a few seconds instead of being treated as token theft.
CREATE TABLE IF NOT EXISTS "auth_session" (
  "SessionId" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "LoginId" bigint NOT NULL,
  "RefreshTokenHash" char(64) NOT NULL,
  "PreviousRefreshTokenHash" char(64),
  "ExpiresAt" timestamptz NOT NULL,
  "CreatedAt" timestamptz NOT NULL DEFAULT now(),
  "RotatedAt" timestamptz,
  "RevokedAt" timestamptz,
  "RevokedReason" varchar(30),
  "UserAgent" varchar(300),
  "Ip" varchar(64)
);

CREATE INDEX IF NOT EXISTS "auth_session_login_idx" ON "auth_session" ("LoginId");

-- The site a session belongs to: "main" for the main app (layer 03); organization sites in layer 08.
-- A refresh keeps the session's site; tokens carry the same value.
ALTER TABLE "auth_session" ADD COLUMN IF NOT EXISTS "Site" varchar(255) NOT NULL DEFAULT 'main';

-- The organization of the site a session belongs to (layer 08): NULL for the main app. Organization
-- sessions also keep the site's host in "Site"; the host must still resolve to this organization on
-- every refresh / session check, so a domain moved to another organization can't carry sessions over.
ALTER TABLE "auth_session" ADD COLUMN IF NOT EXISTS "SiteOrganizationId" bigint;

-- How many times the refresh token was rotated (layer 08 fix). With ExpiresAt it rebuilds the current
-- refresh token exactly, so parallel refreshes inside the grace window all receive the same token
-- instead of rotating again (which made a third parallel refresh look like token theft).
ALTER TABLE "auth_session" ADD COLUMN IF NOT EXISTS "Rotation" integer NOT NULL DEFAULT 0;
