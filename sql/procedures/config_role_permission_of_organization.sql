-- Converted from MySQL procedure `config_role_permission_of_organization`.
DROP ROUTINE IF EXISTS "config_role_permission_of_organization";
CREATE OR REPLACE FUNCTION "config_role_permission_of_organization"(
    varOrganizationId integer,
    varRoleId integer
) RETURNS TABLE(
    "RolePermissionId" bigint,
    "OrganizationId" bigint,
    "RoleId" bigint,
    "MenuId" bigint,
    "Title" varchar,
    "Page" varchar,
    "IsPageAllow" varchar,
    "IsOption" varchar,
    "Add" varchar,
    "Edit" varchar,
    "Delete" varchar,
    "Export" varchar,
    "ViewType" varchar,
    "RecordStatus" char,
    "AddedBy" varchar,
    "AddedDate" timestamp,
    "UpdatedBy" varchar,
    "UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT rp."RolePermissionId", rp."OrganizationId", rp."RoleId", rp."MenuId",
           rp."Title"::varchar, rp."Page"::varchar, rp."IsPageAllow"::varchar, rp."IsOption"::varchar,
           rp."Add"::varchar, rp."Edit"::varchar, rp."Delete"::varchar, rp."Export"::varchar,
           rp."ViewType"::varchar, rp."RecordStatus"::char, rp."AddedBy"::varchar, rp."AddedDate",
           rp."UpdatedBy"::varchar, rp."UpdatedDate"
    FROM "role_permission" rp
    WHERE rp."OrganizationId" = varOrganizationId
      AND rp."RoleId" = varRoleId
      AND rp."RecordStatus" != 'D'
    ORDER BY rp."RolePermissionId" ASC;
END
$$;
