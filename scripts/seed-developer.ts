// Creates the DEVELOPER (platform) account from DEVELOPER_USERNAME / DEVELOPER_PASSWORD in .env, if it
// doesn't exist yet. Idempotent: an existing developer with that username is never changed.
// Run: bun run db:seed:developer   (see stark-frontend/specs/001_Auth_Org_Sites_Staff.md §5.4)
import postgres from "postgres";

const DEVELOPER_ROLE_ID = 1;
const PLACEHOLDER_PASSWORD = "change-me"; // the value shown in .env.example

function fail(message: string): never {
  console.error(`Developer seed: ${message}`);
  process.exit(1);
}

const url = process.env.DATABASE_URL?.trim() || fail("DATABASE_URL is not set");
const userName = process.env.DEVELOPER_USERNAME?.trim() || fail("set DEVELOPER_USERNAME in .env");
const password = process.env.DEVELOPER_PASSWORD ?? "";
if (!password) fail("set DEVELOPER_PASSWORD in .env");
if (/\s/.test(userName) || userName.length > 30) fail("DEVELOPER_USERNAME must have no spaces and at most 30 characters");
if (password.length < 8 || password.length > 72) fail("DEVELOPER_PASSWORD must be 8–72 characters");
if (password === PLACEHOLDER_PASSWORD) fail("DEVELOPER_PASSWORD is still the placeholder from .env.example");

const sql = postgres(url, { onnotice: () => {} });
try {
  const created = await sql.begin(async (tx) => {
    const [existing] = await tx`
      select "LoginId" from "login"
      where "OrganizationId" is null and lower("UserName") = lower(${userName}) and "RecordStatus" <> 'D'`;
    if (existing) return { loginId: existing.LoginId as number, isNew: false };

    const hash = await Bun.password.hash(password, { algorithm: "bcrypt", cost: 10 });
    // The login_reserve_developer_username trigger rejects a username already used by staff.
    const [row] = await tx`
      insert into "login" ("OrganizationId", "LedgerId", "LoginName", "UserName", "Password", "LoginType",
                           "Mobile", "Address", "StaffWorkMode", "AccountStatus", "RecordStatus",
                           "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
      values (null, 0, 'DEVELOPER', ${userName}, ${hash}, ${DEVELOPER_ROLE_ID},
              '0000000000', '', 0, '1', 'A', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp)
      returning "LoginId"`;
    return { loginId: row!.LoginId as number, isNew: true };
  });
  console.log(
    created.isNew
      ? `Created developer "${userName}" (LoginId ${created.loginId}).`
      : `Developer "${userName}" already exists (LoginId ${created.loginId}); nothing changed.`,
  );
} catch (error) {
  const pg = error as { code?: string; constraint_name?: string };
  if (pg.code === "23505") {
    fail(
      pg.constraint_name === "login_developer_username_reserved"
        ? `username "${userName}" is already used by staff; choose another DEVELOPER_USERNAME`
        : `username "${userName}" is already taken`,
    );
  }
  throw error;
} finally {
  await sql.end();
}
