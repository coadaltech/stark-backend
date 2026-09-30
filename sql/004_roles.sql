-- Roles (see stark-frontend/specs/001_Auth_Org_Sites_Staff.md §3).
-- sys_role is the global template; role holds a copy per organization; login."LoginType" = RoleId.
-- Idempotent: rows are only inserted when missing and priorities only set the first time, so later
-- changes made in the database are never overwritten.

-- 1. Global role rules: priority (1 = highest) and whether the role can be given to new staff.
ALTER TABLE "sys_role" ADD COLUMN IF NOT EXISTS "RolePriority" integer;
ALTER TABLE "sys_role" ADD COLUMN IF NOT EXISTS "IsStaffCreatable" smallint NOT NULL DEFAULT 0;
CREATE UNIQUE INDEX IF NOT EXISTS "sys_role_priority_key" ON "sys_role" ("RolePriority");

-- 2. The 14 roles at fixed RoleIds (legacy procedures rely on these ids).
INSERT INTO "sys_role" ("RoleId", "RoleName", "IsTransaction", "IsAllow", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
SELECT v.id, v.name, '0', '1', 'S', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp
FROM (VALUES
  (1, 'DEVELOPER'),
  (2, 'SUPERADMIN'),
  (3, 'DISTRIBUTOR'),
  (4, 'RETAILOR'),
  (5, 'FANTER'),
  (6, 'CASH AGENT'),
  (7, 'ADMIN'),
  (8, 'MANAGER'),
  (9, 'MARKETER'),
  (10, 'AUDITOR'),
  (11, 'ADMIN DATA ENTRY OPERATOR'),
  (12, 'DATA ENTRY OPERATOR'),
  (13, 'ADMIN TALLY OPERATOR'),
  (14, 'TALLY OPERATOR')
) AS v(id, name)
WHERE NOT EXISTS (SELECT 1 FROM "sys_role" sr WHERE sr."RoleId" = v.id);

-- Explicit ids don't advance the identity sequence; move it past the highest id.
SELECT setval(pg_get_serial_sequence('"sys_role"', 'RoleId'), (SELECT max("RoleId") FROM "sys_role"));

-- 3. Priority order: DEVELOPER > SUPERADMIN > ADMIN > DISTRIBUTOR > RETAILOR > FANTER > CASH AGENT >
--    MANAGER > MARKETER > AUDITOR > ADMIN DATA ENTRY OPERATOR > DATA ENTRY OPERATOR >
--    ADMIN TALLY OPERATOR > TALLY OPERATOR.
--    Not creatable as staff: DEVELOPER (seed only) and DISTRIBUTOR, RETAILOR, FANTER, CASH AGENT.
UPDATE "sys_role" sr
SET "RolePriority" = v.priority, "IsStaffCreatable" = v.creatable
FROM (VALUES
  (1, 1, 0),   -- DEVELOPER
  (2, 2, 1),   -- SUPERADMIN
  (7, 3, 1),   -- ADMIN
  (3, 4, 0),   -- DISTRIBUTOR
  (4, 5, 0),   -- RETAILOR
  (5, 6, 0),   -- FANTER
  (6, 7, 0),   -- CASH AGENT
  (8, 8, 1),   -- MANAGER
  (9, 9, 1),   -- MARKETER
  (10, 10, 1), -- AUDITOR
  (11, 11, 1), -- ADMIN DATA ENTRY OPERATOR
  (12, 12, 1), -- DATA ENTRY OPERATOR
  (13, 13, 1), -- ADMIN TALLY OPERATOR
  (14, 14, 1)  -- TALLY OPERATOR
) AS v(role_id, priority, creatable)
WHERE sr."RoleId" = v.role_id AND sr."RolePriority" IS NULL;

-- 4. One role row per (organization, RoleId).
CREATE UNIQUE INDEX IF NOT EXISTS "role_organization_role_key" ON "role" ("OrganizationId", "RoleId");

-- 5. Copy the template roles an organization is missing, with the legacy login flags
--    (web login: 1, 2, 7, 11; app login + dashboard re-declare: 1, 2). Safe to call repeatedly,
--    unlike the legacy sys_default_role_asign which inserts blindly.
DROP ROUTINE IF EXISTS "assign_default_roles";
CREATE OR REPLACE PROCEDURE "assign_default_roles"(varOrganizationId bigint)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO "role" ("RoleId", "OrganizationId", "RoleName", "IsTransaction", "IsAllow",
                        "IsWebLogin", "IsAppLogin", "IsDashboardReDeclare",
                        "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT sr."RoleId", varOrganizationId, sr."RoleName", sr."IsTransaction", sr."IsAllow",
           CASE WHEN sr."RoleId" IN (1, 2, 7, 11) THEN 1 ELSE 0 END,
           CASE WHEN sr."RoleId" IN (1, 2) THEN 1 ELSE 0 END,
           CASE WHEN sr."RoleId" IN (1, 2) THEN 1 ELSE 0 END,
           'S', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp
    FROM "sys_role" sr
    WHERE sr."RecordStatus" <> 'D'
    ON CONFLICT ("OrganizationId", "RoleId") DO NOTHING;
END;
$$;

-- 6. Existing organizations.
DO $$
DECLARE
    org record;
BEGIN
    FOR org IN SELECT "OrganizationId" FROM "organization" WHERE "RecordStatus" <> 'D' LOOP
        CALL "assign_default_roles"(org."OrganizationId");
    END LOOP;
END $$;
