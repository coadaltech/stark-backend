-- Converted from MySQL procedure `sys_default_role_asign`.
DROP ROUTINE IF EXISTS "sys_default_role_asign";
CREATE OR REPLACE PROCEDURE "sys_default_role_asign"(
    varOrganization integer
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO "role"("RoleId", "OrganizationId", "RoleName", "IsTransaction", "IsAllow", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT sr."RoleId", varOrganization, sr."RoleName", sr."IsTransaction", sr."IsAllow", 'S', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp
    FROM "sys_role" sr;

    UPDATE "role" SET "IsAppLogin" = 1
        , "IsWebLogin" = 1
        , "IsDashboardReDeclare" = 1
    WHERE "role"."RoleId" IN (1, 2)
      AND "role"."OrganizationId" = varOrganization;

    UPDATE "role" SET "IsWebLogin" = 1
    WHERE "role"."RoleId" IN (7, 11)
      AND "role"."OrganizationId" = varOrganization;
END;
$$;
