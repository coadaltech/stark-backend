-- Converted from MySQL procedure `rpt_new_ledger_list_for_deshboard`.
DROP ROUTINE IF EXISTS "rpt_new_ledger_list_for_deshboard";
CREATE OR REPLACE FUNCTION "rpt_new_ledger_list_for_deshboard"(
    varOrganizationId integer,
    varNoOfRecords integer,
    varLoginId integer,
    varRoleId integer
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp,
    "GroupId" integer,
    "UserName" text,
    "Mobile" text,
    "LoginType" smallint,
    "GroupName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT
        ledger."LedgerId"
        , ledger."LedgerName"::text
        , ledger."AddedBy"::text
        , ledger."AddedDate"
        , ledger."UpdatedBy"::text
        , ledger."UpdatedDate"
        , ledger."GroupId"
        -- (many other ledger/login columns and sub-selects were commented out in the MySQL source)
        , login."UserName"::text
        , login."Mobile"::text
        , login."LoginType"
        , ledger_group."GroupName"::text
    FROM "ledger"
    LEFT JOIN "login" ON ledger."LedgerId" = login."LedgerId"
    JOIN "ledger_group" ON ledger."GroupId" = ledger_group."GroupId"
    WHERE (ledger."OrganizationId" = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
      AND ledger."RecordStatus" != 'D'
      AND ledger_group."GroupId" != 7
      AND EXISTS (
            SELECT rp."RolePermissionId" FROM "role_permission" rp
            WHERE rp."Page" = 'ledgers'
              AND rp."RoleId" = varRoleId
              AND rp."IsPageAllow" = '1'
              AND rp."RecordStatus" != 'D'
              AND rp."OrganizationId" = varOrganizationId
          )
      AND NOT EXISTS (
            SELECT rpd."RolePermissionDeniedId" FROM "role_permission_denied" rpd
            JOIN "role_permission" rp ON rp."RolePermissionId" = rpd."RolePermissionId" AND rp."RecordStatus" != 'D'
            WHERE rp."Page" = 'ledgers'
              AND rpd."RecordStatus" != 'D'
              AND rp."RoleId" = varRoleId
              AND rpd."LoginId" = varLoginId
              AND rpd."OrganizationId" = varOrganizationId
          )
    ORDER BY ledger."AddedDate" DESC
    LIMIT varNoOfRecords;
END;
$$;
