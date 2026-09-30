-- Usernames (see stark-frontend/specs/001_Auth_Org_Sites_Staff.md §4.1).
-- 1. Unique per organization, ignoring case, among non-deleted logins. NULLS NOT DISTINCT makes
--    developers (OrganizationId NULL) unique among themselves too.
-- 2. Developer usernames are reserved platform-wide: no staff member in any organization may use a
--    developer's username, and a developer can't take an existing staff username. Developers can sign
--    in at every organization site, so this keeps sign-in unambiguous.
-- Usernames are stored as typed (legacy reports match login."UserName" to transaction."AddedBy",
-- together with the organization).

-- Replaces the earlier platform-wide rule.
DROP INDEX IF EXISTS "login_username_key";

CREATE UNIQUE INDEX IF NOT EXISTS "login_org_username_key"
  ON "login" ("OrganizationId", lower("UserName")) NULLS NOT DISTINCT
  WHERE "RecordStatus" <> 'D';

CREATE OR REPLACE FUNCTION "login_reserve_developer_username"() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
    IF NEW."RecordStatus" = 'D' THEN
        RETURN NEW;
    END IF;
    -- Serialize concurrent saves of the same username so two transactions can't both pass the check.
    PERFORM pg_advisory_xact_lock(hashtext('login_username:' || lower(NEW."UserName")));

    IF NEW."OrganizationId" IS NULL THEN
        -- A developer (platform account) may not take a username used by staff anywhere.
        IF EXISTS (
            SELECT 1 FROM "login" l
            WHERE lower(l."UserName") = lower(NEW."UserName")
              AND l."OrganizationId" IS NOT NULL
              AND l."RecordStatus" <> 'D'
              AND l."LoginId" <> NEW."LoginId"
        ) THEN
            RAISE EXCEPTION 'Username "%" is already used by staff', NEW."UserName"
                USING ERRCODE = 'unique_violation', CONSTRAINT = 'login_developer_username_reserved';
        END IF;
    ELSIF EXISTS (
        SELECT 1 FROM "login" l
        WHERE lower(l."UserName") = lower(NEW."UserName")
          AND l."OrganizationId" IS NULL
          AND l."RecordStatus" <> 'D'
          AND l."LoginId" <> NEW."LoginId"
    ) THEN
        -- Staff may not use a developer's username.
        RAISE EXCEPTION 'Username "%" is reserved', NEW."UserName"
            USING ERRCODE = 'unique_violation', CONSTRAINT = 'login_developer_username_reserved';
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS "login_reserve_developer_username" ON "login";
CREATE TRIGGER "login_reserve_developer_username"
    BEFORE INSERT OR UPDATE OF "UserName", "OrganizationId", "RecordStatus" ON "login"
    FOR EACH ROW EXECUTE FUNCTION "login_reserve_developer_username"();
