function required(name: string): string {
  const value = process.env[name];
  if (!value) throw new Error(`Missing required env var: ${name}`);
  return value;
}

/** HMAC secrets must be long random strings (e.g. openssl rand -base64 48). */
function secret(name: string): string {
  const value = required(name);
  if (value.length < 32) throw new Error(`${name} must be at least 32 characters`);
  return value;
}

export const env = {
  PORT: Number(process.env.PORT ?? 8000),
  DATABASE_URL: required("DATABASE_URL"),
  CORS_ORIGIN: process.env.CORS_ORIGIN ?? "http://localhost:3000",
  // Session time zone for DB connections, so localtimestamp/current_date (used by the
  // legacy routines) follow local business time rather than the container clock.
  DB_TIMEZONE: process.env.DB_TIMEZONE ?? Intl.DateTimeFormat().resolvedOptions().timeZone,
  // Separate secrets so a refresh token can never pass as an access token (and vice versa).
  // The frontend needs the same JWT_ACCESS_SECRET to verify sessions (layer 05).
  JWT_ACCESS_SECRET: secret("JWT_ACCESS_SECRET"),
  JWT_REFRESH_SECRET: secret("JWT_REFRESH_SECRET"),
};
