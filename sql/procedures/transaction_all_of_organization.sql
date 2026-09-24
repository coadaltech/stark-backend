-- Converted from MySQL procedure `transaction_all_of_organization`.
-- LIKE -> ILIKE to keep MySQL's case-insensitive collation behaviour.
DROP ROUTINE IF EXISTS "transaction_all_of_organization";
CREATE OR REPLACE FUNCTION "transaction_all_of_organization"(
    varOrganizationId integer,
    varShiftId integer,
    varShiftDate date,
    varLedgerId integer,
    varUserName varchar,
    varRoleId integer,
    varRoleType varchar,
    varLedgerName varchar,
    varIsDeleted integer)
RETURNS TABLE(
    "TransactionId" text, "OrganizationId" bigint, "LedgerId" bigint, "LedgerName" text, "ShiftId" bigint,
    "TotalAmount" double precision, "UpdatedBy" text, "TransactionDateDB" date, "TransactionType" text,
    "KFlag" text, "IsHissa" text, "DaraRate" double precision, "DaraCommission" double precision,
    "AkharRate" double precision, "AkharCommission" double precision, "DeviceType" text,
    "TransactionDate" text, "AddedDate" text, "UpdatedDate" text, "AddedBy" text, "IsUpdated" text,
    "DeclareNumber" text, "UpdateDiff" interval, "IsDada" integer, "IsBAkar" integer, "IsAAkar" integer,
    "AddedDayTime" text, "UpdatedDayTime" text, "RecordStatus" text, "OrderAddeddate" timestamp,
    "ClientRemarks" text, "MistakeStatus" integer, "ModifyStatus" integer, "LastStatus" integer, "Remark" text)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    -- RoleId = 2 super admin, 3 distributer,4 ressaler ,5 panter
    -- RoleId = 11 dataentry oprater
    CASE varRoleId
    WHEN 3 THEN
        RETURN QUERY
        SELECT t."TransactionId", t."OrganizationId", t."LedgerId",
               t."LedgerName" AS "LedgerName",
               t."ShiftId", t."TotalAmount",
               t."UpdatedBy", t."TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
               t."TransactionDate",
               t."AddedDate",
               t."UpdatedDate",
               t."AddedBy",
               t."IsUpdated",
               t."DeclareNumber",
               t."UpdateDiff",
               t."IsDada",
               t."IsBAkar",
               t."IsAAkar",
               t."AddedDayTime",
               t."UpdatedDayTime",
               t."RecordStatus",
               t."OrderAddeddate",
               t."ClientRemarks",
               (COALESCE(ta."MistakeStatus", 0) % 2)::integer AS "MistakeStatus",
               COALESCE(ta."ModifyStatus", 0)::integer AS "ModifyStatus",
               COALESCE(ta."LastStatus", 0)::integer AS "LastStatus",
               COALESCE(ta."Remark", '') AS "Remark"
        FROM (
            SELECT tr."TransactionId"::text AS "TransactionId", tr."OrganizationId", tr."LedgerId",
                   (CASE WHEN varRoleId = 11 THEN COALESCE(lg."UserName"::text, '') ELSE l."LedgerName"::text END) AS "LedgerName",
                   tr."ShiftId", tr."TotalAmount", tr."UpdatedBy"::text AS "UpdatedBy", tr."TransactionDate" AS "TransactionDateDB",
                   tr."TransactionType"::text AS "TransactionType", tr."KFlag"::text AS "KFlag", tr."IsHissa"::text AS "IsHissa",
                   tr."DaraRate", tr."DaraCommission", tr."AkharRate", tr."AkharCommission", tr."DeviceType"::text AS "DeviceType",
                   to_char(tr."TransactionDate", 'DD-MM-YYYY') AS "TransactionDate",
                   to_char(tr."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
                   to_char(tr."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
                   tr."AddedBy"::text AS "AddedBy",
                   (CASE WHEN tr."UpdatedDate" = tr."AddedDate" THEN 'No' ELSE 'Yes' END) AS "IsUpdated",
                   ''::text AS "DeclareNumber",
                   (tr."UpdatedDate" - tr."AddedDate") AS "UpdateDiff",
                   0 AS "IsDada",
                   0 AS "IsBAkar",
                   0 AS "IsAAkar",
                   to_char(tr."AddedDate", 'DD - HH12:MI AM') AS "AddedDayTime",
                   to_char(tr."UpdatedDate", 'DD - HH12:MI AM') AS "UpdatedDayTime",
                   tr."RecordStatus"::text AS "RecordStatus",
                   tr."AddedDate" AS "OrderAddeddate",
                   tr."ClientRemarks"::text AS "ClientRemarks"
            FROM "transaction" tr
            JOIN "ledger" l ON tr."LedgerId" = l."LedgerId"
            JOIN "login" lg ON lg."LedgerId" = l."LedgerId"
            WHERE tr."OrganizationId" = varOrganizationId
              AND tr."ShiftId" = varShiftId
              AND tr."TransactionDate" = varShiftDate
              AND (CASE WHEN varIsDeleted = 1 THEN tr."RecordStatus" = 'D' ELSE tr."RecordStatus" != 'D' END)
              AND (tr."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
              AND (varRoleType = 'ALL'
                   OR tr."UpdatedBy" = varUserName)
              AND l."LedgerName" ILIKE (COALESCE(varLedgerName::text, '') || '%')
        ) AS t
        LEFT JOIN "transaction_audit" ta ON ta."TransactionId" = t."TransactionId"::bigint AND ta."RecordStatus" != 'D'
        ORDER BY t."OrderAddeddate" DESC;
    WHEN 4 THEN
        RETURN QUERY
        SELECT t."TransactionId", t."OrganizationId", t."LedgerId",
               t."LedgerName" AS "LedgerName",
               t."ShiftId", t."TotalAmount",
               t."UpdatedBy", t."TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
               t."TransactionDate",
               t."AddedDate",
               t."UpdatedDate",
               t."AddedBy",
               t."IsUpdated",
               t."DeclareNumber",
               t."UpdateDiff",
               t."IsDada",
               t."IsBAkar",
               t."IsAAkar",
               t."AddedDayTime",
               t."UpdatedDayTime",
               t."RecordStatus",
               t."OrderAddeddate",
               t."ClientRemarks",
               (COALESCE(ta."MistakeStatus", 0) % 2)::integer AS "MistakeStatus",
               COALESCE(ta."ModifyStatus", 0)::integer AS "ModifyStatus",
               COALESCE(ta."LastStatus", 0)::integer AS "LastStatus",
               COALESCE(ta."Remark", '') AS "Remark"
        FROM (
            SELECT tr."TransactionId"::text AS "TransactionId", tr."OrganizationId", tr."LedgerId",
                   l."LedgerName"::text AS "LedgerName",
                   tr."ShiftId", tr."TotalAmount", tr."UpdatedBy"::text AS "UpdatedBy", tr."TransactionDate" AS "TransactionDateDB",
                   tr."TransactionType"::text AS "TransactionType", tr."KFlag"::text AS "KFlag", tr."IsHissa"::text AS "IsHissa",
                   tr."DaraRate", tr."DaraCommission", tr."AkharRate", tr."AkharCommission", tr."DeviceType"::text AS "DeviceType",
                   to_char(tr."TransactionDate", 'DD-MM-YYYY') AS "TransactionDate",
                   to_char(tr."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
                   to_char(tr."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
                   tr."AddedBy"::text AS "AddedBy",
                   (CASE WHEN tr."UpdatedDate" = tr."AddedDate" THEN 'No' ELSE 'Yes' END) AS "IsUpdated",
                   ''::text AS "DeclareNumber",
                   (tr."UpdatedDate" - tr."AddedDate") AS "UpdateDiff",
                   0 AS "IsDada",
                   0 AS "IsBAkar",
                   0 AS "IsAAkar",
                   to_char(tr."AddedDate", 'DD - HH12:MI AM') AS "AddedDayTime",
                   to_char(tr."UpdatedDate", 'DD - HH12:MI AM') AS "UpdatedDayTime",
                   tr."RecordStatus"::text AS "RecordStatus",
                   tr."AddedDate" AS "OrderAddeddate",
                   tr."ClientRemarks"::text AS "ClientRemarks"
            FROM "transaction" tr
            JOIN "ledger" l ON tr."LedgerId" = l."LedgerId"
            WHERE tr."OrganizationId" = varOrganizationId
              AND tr."ShiftId" = varShiftId
              AND tr."TransactionDate" = varShiftDate
              AND (CASE WHEN varIsDeleted = 1 THEN tr."RecordStatus" = 'D' ELSE tr."RecordStatus" != 'D' END)
              AND (tr."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId)
              AND (varRoleType = 'ALL'
                   OR tr."UpdatedBy" = varUserName)
              AND l."LedgerName" ILIKE (COALESCE(varLedgerName::text, '') || '%')
        ) AS t
        LEFT JOIN "transaction_audit" ta ON ta."TransactionId" = t."TransactionId"::bigint AND ta."RecordStatus" != 'D'
        ORDER BY t."OrderAddeddate" DESC;
    WHEN 5 THEN
        RETURN QUERY
        SELECT t."TransactionId", t."OrganizationId", t."LedgerId",
               t."LedgerName" AS "LedgerName",
               t."ShiftId", t."TotalAmount",
               t."UpdatedBy", t."TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
               t."TransactionDate",
               t."AddedDate",
               t."UpdatedDate",
               t."AddedBy",
               t."IsUpdated",
               t."DeclareNumber",
               t."UpdateDiff",
               t."IsDada",
               t."IsBAkar",
               t."IsAAkar",
               t."AddedDayTime",
               t."UpdatedDayTime",
               t."RecordStatus",
               t."OrderAddeddate",
               t."ClientRemarks",
               (COALESCE(ta."MistakeStatus", 0) % 2)::integer AS "MistakeStatus",
               COALESCE(ta."ModifyStatus", 0)::integer AS "ModifyStatus",
               COALESCE(ta."LastStatus", 0)::integer AS "LastStatus",
               COALESCE(ta."Remark", '') AS "Remark"
        FROM (
            SELECT tr."TransactionId"::text AS "TransactionId", tr."OrganizationId", tr."LedgerId",
                   l."LedgerName"::text AS "LedgerName",
                   tr."ShiftId", tr."TotalAmount", tr."UpdatedBy"::text AS "UpdatedBy", tr."TransactionDate" AS "TransactionDateDB",
                   tr."TransactionType"::text AS "TransactionType", tr."KFlag"::text AS "KFlag", tr."IsHissa"::text AS "IsHissa",
                   tr."DaraRate", tr."DaraCommission", tr."AkharRate", tr."AkharCommission", tr."DeviceType"::text AS "DeviceType",
                   to_char(tr."TransactionDate", 'DD-MM-YYYY') AS "TransactionDate",
                   to_char(tr."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
                   to_char(tr."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
                   tr."AddedBy"::text AS "AddedBy",
                   (CASE WHEN tr."UpdatedDate" = tr."AddedDate" THEN 'No' ELSE 'Yes' END) AS "IsUpdated",
                   ''::text AS "DeclareNumber",
                   (tr."UpdatedDate" - tr."AddedDate") AS "UpdateDiff",
                   0 AS "IsDada",
                   0 AS "IsBAkar",
                   0 AS "IsAAkar",
                   to_char(tr."AddedDate", 'DD - HH12:MI AM') AS "AddedDayTime",
                   to_char(tr."UpdatedDate", 'DD - HH12:MI AM') AS "UpdatedDayTime",
                   tr."RecordStatus"::text AS "RecordStatus",
                   tr."AddedDate" AS "OrderAddeddate",
                   tr."ClientRemarks"::text AS "ClientRemarks"
            FROM "transaction" tr
            JOIN "ledger" l ON tr."LedgerId" = l."LedgerId"
            WHERE tr."OrganizationId" = varOrganizationId
              AND tr."ShiftId" = varShiftId
              AND tr."TransactionDate" = varShiftDate
              AND (CASE WHEN varIsDeleted = 1 THEN tr."RecordStatus" = 'D' ELSE tr."RecordStatus" != 'D' END)
              AND tr."LedgerId" = varLedgerId
              AND (varRoleType = 'ALL'
                   OR tr."UpdatedBy" = varUserName)
              AND l."LedgerName" ILIKE (COALESCE(varLedgerName::text, '') || '%')
        ) AS t
        LEFT JOIN "transaction_audit" ta ON ta."TransactionId" = t."TransactionId"::bigint AND ta."RecordStatus" != 'D'
        ORDER BY t."OrderAddeddate" DESC;
    ELSE
        RETURN QUERY
        SELECT t."TransactionId", t."OrganizationId", t."LedgerId",
               t."LedgerName" AS "LedgerName",
               t."ShiftId", t."TotalAmount",
               t."UpdatedBy", t."TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
               t."TransactionDate",
               t."AddedDate",
               t."UpdatedDate",
               t."AddedBy",
               t."IsUpdated",
               t."DeclareNumber",
               t."UpdateDiff",
               t."IsDada",
               t."IsBAkar",
               t."IsAAkar",
               t."AddedDayTime",
               t."UpdatedDayTime",
               t."RecordStatus",
               t."OrderAddeddate",
               t."ClientRemarks",
               (COALESCE(ta."MistakeStatus", 0) % 2)::integer AS "MistakeStatus",
               COALESCE(ta."ModifyStatus", 0)::integer AS "ModifyStatus",
               COALESCE(ta."LastStatus", 0)::integer AS "LastStatus",
               COALESCE(ta."Remark", '') AS "Remark"
        FROM (
            SELECT tr."TransactionId"::text AS "TransactionId", tr."OrganizationId", tr."LedgerId",
                   l."LedgerName"::text AS "LedgerName",
                   tr."ShiftId", tr."TotalAmount", tr."UpdatedBy"::text AS "UpdatedBy", tr."TransactionDate" AS "TransactionDateDB",
                   tr."TransactionType"::text AS "TransactionType", tr."KFlag"::text AS "KFlag", tr."IsHissa"::text AS "IsHissa",
                   tr."DaraRate", tr."DaraCommission", tr."AkharRate", tr."AkharCommission", tr."DeviceType"::text AS "DeviceType",
                   to_char(tr."TransactionDate", 'DD-MM-YYYY') AS "TransactionDate",
                   to_char(tr."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
                   to_char(tr."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
                   tr."AddedBy"::text AS "AddedBy",
                   (CASE WHEN tr."UpdatedDate" = tr."AddedDate" THEN 'No' ELSE 'Yes' END) AS "IsUpdated",
                   ''::text AS "DeclareNumber",
                   (tr."UpdatedDate" - tr."AddedDate") AS "UpdateDiff",
                   0 AS "IsDada",
                   0 AS "IsBAkar",
                   0 AS "IsAAkar",
                   to_char(tr."AddedDate", 'DD - HH12:MI AM') AS "AddedDayTime",
                   to_char(tr."UpdatedDate", 'DD - HH12:MI AM') AS "UpdatedDayTime",
                   tr."RecordStatus"::text AS "RecordStatus",
                   tr."AddedDate" AS "OrderAddeddate",
                   tr."ClientRemarks"::text AS "ClientRemarks"
            FROM "transaction" tr
            JOIN "ledger" l ON tr."LedgerId" = l."LedgerId"
            WHERE tr."OrganizationId" = varOrganizationId
              AND tr."ShiftId" = varShiftId
              AND tr."TransactionDate" = varShiftDate
              AND (CASE WHEN varIsDeleted = 1 THEN tr."RecordStatus" = 'D' ELSE tr."RecordStatus" != 'D' END)
              AND (varRoleType = 'ALL'
                   OR tr."UpdatedBy" = varUserName)
              AND l."LedgerName" ILIKE (COALESCE(varLedgerName::text, '') || '%')
        ) AS t
        LEFT JOIN "transaction_audit" ta ON ta."TransactionId" = t."TransactionId"::bigint AND ta."RecordStatus" != 'D'
        ORDER BY t."OrderAddeddate" DESC;
    END CASE;
END;
$$;
