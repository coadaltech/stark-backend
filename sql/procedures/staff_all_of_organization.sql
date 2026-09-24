-- Converted from MySQL procedure `staff_all_of_organization`.
-- NOTE: MySQL returned raw lg.AddedDate/lg.UpdatedDate AND formatted AddedDate/UpdatedDate (duplicate labels;
-- name-keyed clients saw the later, formatted one). PG cannot return duplicate names, so "AddedDate"/"UpdatedDate"
-- are returned once, as the formatted text, in the raw columns' position.
-- Non-grouped role/ledger columns (MySQL GROUP BY lg.LoginId) wrapped in any_value().
DROP ROUTINE IF EXISTS "staff_all_of_organization";
CREATE OR REPLACE FUNCTION "staff_all_of_organization"(
    varOrganizationId integer,
    varLedgerName varchar,
    varLedgerId integer,
    varUserName varchar,
    varRoleId integer,
    varRoleType varchar
)
RETURNS TABLE(
    "LoginId" bigint,
    "OrganizationId" bigint,
    "LedgerId" bigint,
    "LoginName" text,
    "UserName" text,
    "LoginType" smallint,
    "Mobile" text,
    "Address" text,
    "StaffWorkMode" integer,
    "AccountStatus" text,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" text,
    "UpdatedBy" text,
    "UpdatedDate" text,
    "RoleName" text,
    "GroupId" integer,
    "AgentLedgerId" bigint,
    "AgentLedgerName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    -- RoleId = 2 super admin, 3 distributer,4 ressaler ,5 panter
    CASE varRoleId
    WHEN 3 THEN
        RETURN QUERY
        SELECT
            lg."LoginId",
            lg."OrganizationId",
            lg."LedgerId",
            lg."LoginName"::text,
            lg."UserName"::text,
            lg."LoginType",
            lg."Mobile"::text,
            lg."Address"::text,
            lg."StaffWorkMode",
            lg."AccountStatus"::text,
            lg."RecordStatus"::text,
            lg."AddedBy"::text,
            to_char(lg."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
            lg."UpdatedBy"::text,
            to_char(lg."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
            any_value(r."RoleName")::text AS "RoleName", any_value(l."GroupId") AS "GroupId",
            any_value(l."AgentLedgerId") AS "AgentLedgerId", any_value(agent."LedgerName")::text AS "AgentLedgerName"
        FROM "login" lg
        JOIN "role" r ON lg."LoginType" = r."RoleId"
        JOIN "ledger" l ON lg."LedgerId" = l."LedgerId" AND l."GroupId" = 7 AND l."IsHide" = '0'
        LEFT JOIN "ledger" AS agent ON agent."LedgerId" = l."AgentLedgerId"
        WHERE l."OrganizationId" = varOrganizationId
          AND lg."RecordStatus" != 'D'
          AND (varLedgerName IS NULL OR l."LedgerName" ILIKE ('%' || varLedgerName::text || '%'))
          AND (l."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId
               OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
          AND (varRoleType = 'ALL'
               OR l."UpdatedBy" = varUserName)
        GROUP BY lg."LoginId"
        ORDER BY lg."AddedDate" ASC;
    WHEN 4 THEN
        RETURN QUERY
        SELECT
            lg."LoginId",
            lg."OrganizationId",
            lg."LedgerId",
            lg."LoginName"::text,
            lg."UserName"::text,
            lg."LoginType",
            lg."Mobile"::text,
            lg."Address"::text,
            lg."StaffWorkMode",
            lg."AccountStatus"::text,
            lg."RecordStatus"::text,
            lg."AddedBy"::text,
            to_char(lg."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
            lg."UpdatedBy"::text,
            to_char(lg."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
            any_value(r."RoleName")::text AS "RoleName", any_value(l."GroupId") AS "GroupId",
            any_value(l."AgentLedgerId") AS "AgentLedgerId", any_value(agent."LedgerName")::text AS "AgentLedgerName"
        FROM "login" lg
        JOIN "role" r ON lg."LoginType" = r."RoleId"
        JOIN "ledger" l ON lg."LedgerId" = l."LedgerId" AND l."GroupId" = 7 AND l."IsHide" = '0'
        LEFT JOIN "ledger" AS agent ON agent."LedgerId" = l."AgentLedgerId"
        WHERE l."OrganizationId" = varOrganizationId
          AND lg."RecordStatus" != 'D'
          AND (varLedgerName IS NULL OR l."LedgerName" ILIKE ('%' || varLedgerName::text || '%'))
          AND (l."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId)
          AND (varRoleType = 'ALL'
               OR l."UpdatedBy" = varUserName)
        GROUP BY lg."LoginId"
        ORDER BY lg."AddedDate" ASC;
    WHEN 5 THEN
        RETURN QUERY
        SELECT
            lg."LoginId",
            lg."OrganizationId",
            lg."LedgerId",
            lg."LoginName"::text,
            lg."UserName"::text,
            lg."LoginType",
            lg."Mobile"::text,
            lg."Address"::text,
            lg."StaffWorkMode",
            lg."AccountStatus"::text,
            lg."RecordStatus"::text,
            lg."AddedBy"::text,
            to_char(lg."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
            lg."UpdatedBy"::text,
            to_char(lg."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
            any_value(r."RoleName")::text AS "RoleName", any_value(l."GroupId") AS "GroupId",
            any_value(l."AgentLedgerId") AS "AgentLedgerId", any_value(agent."LedgerName")::text AS "AgentLedgerName"
        FROM "login" lg
        JOIN "role" r ON lg."LoginType" = r."RoleId"
        JOIN "ledger" l ON lg."LedgerId" = l."LedgerId" AND l."GroupId" = 7 AND l."IsHide" = '0'
        LEFT JOIN "ledger" AS agent ON agent."LedgerId" = l."AgentLedgerId"
        WHERE l."OrganizationId" = varOrganizationId
          AND lg."RecordStatus" != 'D'
          AND (varLedgerName IS NULL OR l."LedgerName" ILIKE ('%' || varLedgerName::text || '%'))
          AND (l."LedgerId" = varLedgerId)
          AND (varRoleType = 'ALL'
               OR l."UpdatedBy" = varUserName)
        GROUP BY lg."LoginId"
        ORDER BY lg."AddedDate" ASC;
    ELSE
        RETURN QUERY
        SELECT
            lg."LoginId",
            lg."OrganizationId",
            lg."LedgerId",
            lg."LoginName"::text,
            lg."UserName"::text,
            lg."LoginType",
            lg."Mobile"::text,
            lg."Address"::text,
            lg."StaffWorkMode",
            lg."AccountStatus"::text,
            lg."RecordStatus"::text,
            lg."AddedBy"::text,
            to_char(lg."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
            lg."UpdatedBy"::text,
            to_char(lg."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
            any_value(r."RoleName")::text AS "RoleName", any_value(l."GroupId") AS "GroupId",
            any_value(l."AgentLedgerId") AS "AgentLedgerId", any_value(agent."LedgerName")::text AS "AgentLedgerName"
        FROM "login" lg
        JOIN "role" r ON lg."LoginType" = r."RoleId"
        JOIN "ledger" l ON lg."LedgerId" = l."LedgerId" AND l."GroupId" = 7 AND l."IsHide" = '0'
        LEFT JOIN "ledger" AS agent ON agent."LedgerId" = l."AgentLedgerId"
        WHERE l."OrganizationId" = varOrganizationId
          AND lg."RecordStatus" != 'D'
          AND (varLedgerName IS NULL OR l."LedgerName" ILIKE ('%' || varLedgerName::text || '%'))
          AND (varRoleType = 'ALL'
               OR l."UpdatedBy" = varUserName)
        GROUP BY lg."LoginId"
        ORDER BY lg."AddedDate" DESC;
    END CASE;
END;
$$;
