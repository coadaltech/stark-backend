import { isValidHost, normalizeHost } from "./sites/host";

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

function host(name: string, fallback: string): string {
  const value = normalizeHost(process.env[name] || fallback);
  if (!isValidHost(value)) throw new Error(`${name} must be a host name with an optional port, e.g. localhost:3000`);
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
  // Only the API holds them; the frontend confirms sessions with GET /auth/me.
  JWT_ACCESS_SECRET: secret("JWT_ACCESS_SECRET"),
  JWT_REFRESH_SECRET: secret("JWT_REFRESH_SECRET"),
  // Host (with port in development) the main app is served at; every other host is an organization
  // site or "Site not found".
  MAIN_APP_HOST: host("MAIN_APP_HOST", "localhost:3000"),
};
