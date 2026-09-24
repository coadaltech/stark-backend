function required(name: string): string {
  const value = process.env[name];
  if (!value) throw new Error(`Missing required env var: ${name}`);
  return value;
}

export const env = {
  PORT: Number(process.env.PORT ?? 8000),
  DATABASE_URL: required("DATABASE_URL"),
  CORS_ORIGIN: process.env.CORS_ORIGIN ?? "http://localhost:3000",
  // Session time zone for DB connections, so localtimestamp/current_date (used by the
  // legacy routines) follow local business time rather than the container clock.
  DB_TIMEZONE: process.env.DB_TIMEZONE ?? Intl.DateTimeFormat().resolvedOptions().timeZone,
};
