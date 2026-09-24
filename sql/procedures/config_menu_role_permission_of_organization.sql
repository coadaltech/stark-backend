-- Converted from MySQL procedure `config_menu_role_permission_of_organization`.
DROP ROUTINE IF EXISTS "config_menu_role_permission_of_organization";
CREATE OR REPLACE FUNCTION "config_menu_role_permission_of_organization"(
    varOrganizationId integer,
    varRoleId integer,
    varMenuId integer,
    varLoginId integer,
    varIsCheckRolePermissionDenied integer
)
RETURNS TABLE(
    "RolePermissionId" bigint,
    "OrganizationId" bigint,
    "RoleId" bigint,
    "MenuId" bigint,
    "Title" text,
    "Page" text,
    "IsPageAllow" text,
    "IsOption" text,
    "Add" text,
    "Edit" text,
    "Delete" text,
    "Export" text,
    "ViewType" text,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT rp."RolePermissionId",
           rp."OrganizationId",
           rp."RoleId",
           rp."MenuId",
           rp."Title"::text,
           rp."Page"::text,
           (CASE WHEN COALESCE(rpd."RolePermissionId", 0) = 0 OR COALESCE(varIsCheckRolePermissionDenied, 0) = 0 THEN rp."IsPageAllow"::text ELSE '0' END) AS "IsPageAllow",
           (CASE WHEN COALESCE(rpd."RolePermissionId", 0) = 0 OR COALESCE(varIsCheckRolePermissionDenied, 0) = 0 THEN rp."IsOption"::text ELSE '0' END) AS "IsOption",
           (CASE WHEN COALESCE(rpd."RolePermissionId", 0) = 0 OR COALESCE(varIsCheckRolePermissionDenied, 0) = 0 THEN rp."Add"::text ELSE '0' END) AS "Add",
           (CASE WHEN COALESCE(rpd."RolePermissionId", 0) = 0 OR COALESCE(varIsCheckRolePermissionDenied, 0) = 0 THEN rp."Edit"::text ELSE '0' END) AS "Edit",
           (CASE WHEN COALESCE(rpd."RolePermissionId", 0) = 0 OR COALESCE(varIsCheckRolePermissionDenied, 0) = 0 THEN rp."Delete"::text ELSE '0' END) AS "Delete",
           (CASE WHEN COALESCE(rpd."RolePermissionId", 0) = 0 OR COALESCE(varIsCheckRolePermissionDenied, 0) = 0 THEN rp."Export"::text ELSE '0' END) AS "Export",
           rp."ViewType"::text,
           rp."RecordStatus"::text,
           rp."AddedBy"::text,
           rp."AddedDate",
           rp."UpdatedBy"::text,
           rp."UpdatedDate"
    FROM "role_permission" rp
    LEFT JOIN "role_permission_denied" rpd ON rpd."RolePermissionId" = rp."RolePermissionId" AND rpd."RecordStatus" != 'D'
              AND rpd."LoginId" = varLoginId
    LEFT JOIN (SELECT count(1) AS "ShiftCount", max(rpt."ExpiryDateTime") AS "ExpiryDateTime", rpt."Page"
               FROM "role_permission_transaction" rpt
               WHERE rpt."RecordStatus" != 'D' AND COALESCE(rpt."IsPageAllow", '0') = '1'
                 AND rpt."LoginId" = varLoginId
               GROUP BY rpt."Page"
              ) AS role_permission_transaction ON rp."Page" = role_permission_transaction."Page"
    WHERE rp."OrganizationId" = varOrganizationId
      AND rp."RoleId" = varRoleId
      AND rp."MenuId" = varMenuId
      AND rp."RecordStatus" != 'D'
      AND
        (CASE WHEN COALESCE(varIsCheckRolePermissionDenied, 0) = 1
                   AND (SELECT COALESCE(r."IsDeclareTransactionConfig", 0) FROM "role" r
                        WHERE r."OrganizationId" = varOrganizationId AND r."RoleId" = varRoleId) = 1 THEN
              (CASE WHEN COALESCE(role_permission_transaction."ExpiryDateTime", localtimestamp) >= localtimestamp
                    THEN true ELSE false END)
         ELSE
              true
         END)
    ORDER BY rp."RolePermissionId" ASC;
END;
$$;
