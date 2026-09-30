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
