-- Shifts (specs/build/shifts/shift_spec.md §2, §5). Idempotent.

-- 1. The Shift page: a sub-menu of the Staff menu (Staff ▾ → Staff, Shift), key "shift-list".
INSERT INTO "sys_sub_menu" ("MenuId", "SubMenuKey", "Label", "Order", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
SELECT m."MenuId", 'shift-list', 'Shift', 2, 'A', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp
FROM "sys_menu" m
WHERE m."MenuKey" = 'staff'
  AND NOT EXISTS (SELECT 1 FROM "sys_sub_menu" WHERE "SubMenuKey" = 'shift-list');

-- Existing organizations get the sub-menu and the default permissions ("Superadmin – Shift",
-- "Admin – Shift"); the procedures only add what an organization never had (sql/007).
DO $$
DECLARE
    org record;
BEGIN
    FOR org IN SELECT "OrganizationId" FROM "organization" WHERE "RecordStatus" <> 'D' LOOP
        CALL "assign_default_sub_menus"(org."OrganizationId");
        CALL "assign_default_permissions"(org."OrganizationId");
    END LOOP;
END $$;

-- 2. Shift names are unique per organization, ignoring case (stored UPPERCASE by the API).
CREATE UNIQUE INDEX IF NOT EXISTS "shift_org_name_key"
    ON "shift" ("OrganizationId", lower("ShiftName")) WHERE "RecordStatus" <> 'D';

-- 3. At most one end time per role and shift.
CREATE UNIQUE INDEX IF NOT EXISTS "shift_timing_shift_role_key"
    ON "shift_timing" ("ShiftId", "RoleId") WHERE "RecordStatus" <> 'D';
