-- Converted from MySQL procedure `declare_transaction_all_of_organization`.
-- NOTE: MySQL compared varchar td.Number with integer DeclareNumber numerically; emulated with
-- (Number ~ '^[0-9]+$' AND Number::integer = DeclareNumber). timediff() emulated as signed 'HH:MM:SS' text.
DROP ROUTINE IF EXISTS "declare_transaction_all_of_organization";
CREATE OR REPLACE FUNCTION "declare_transaction_all_of_organization"(
    varOrganizationId integer,
    varShiftId integer,
    varShiftDate date,
    varLedgerId integer,
    varUserName varchar,
    varRoleId integer,
    varRoleType varchar,
    varLedgerName varchar,
    varIsDeleted integer
)
RETURNS TABLE(
    "TransactionId" text,
    "OrganizationId" bigint,
    "LedgerId" bigint,
    "LedgerName" text,
    "ShiftId" bigint,
    "TotalAmount" double precision,
    "UpdatedBy" text,
    "TransactionDateDB" date,
    "TransactionType" text,
    "KFlag" text,
    "IsHissa" text,
    "DaraRate" double precision,
    "DaraCommission" double precision,
    "AkharRate" double precision,
    "AkharCommission" double precision,
    "DeviceType" text,
    "TransactionDate" text,
    "AddedDate" text,
    "UpdatedDate" text,
    "AddedBy" text,
    "IsUpdated" text,
    "DeclareNumber" integer,
    "UpdateDiff" text,
    "IsDada" integer,
    "IsBAkar" integer,
    "IsAAkar" integer,
    "AddedDayTime" text,
    "UpdatedDayTime" text,
    "RecordStatus" text,
    "OrderAddeddate" timestamp,
    "ClientRemarks" text,
    "MistakeStatus" integer,
    "ModifyStatus" integer,
    "LastStatus" integer,
    "Remark" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    -- RoleId = 2 super admin, 3 distributer,4 ressaler ,5 panter
    CASE varRoleId
    WHEN 3 THEN
        RETURN QUERY
        SELECT t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount",
               t."UpdatedBy", t."TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa",
               t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
               t."TransactionDate", t."AddedDate", t."UpdatedDate", t."AddedBy", t."IsUpdated",
               t."DeclareNumber", t."UpdateDiff", t."IsDada", t."IsBAkar", t."IsAAkar",
               t."AddedDayTime", t."UpdatedDayTime", t."RecordStatus", t."OrderAddeddate", t."ClientRemarks",
               (COALESCE(ta."MistakeStatus", 0) % 2)::integer AS "MistakeStatus",
               COALESCE(ta."ModifyStatus", 0)::integer AS "ModifyStatus",
               COALESCE(ta."LastStatus", 0)::integer AS "LastStatus",
               COALESCE(ta."Remark", '') AS "Remark"
        FROM (
            SELECT t."TransactionId"::text AS "TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName"::text AS "LedgerName", t."ShiftId", t."TotalAmount",
                   t."UpdatedBy"::text AS "UpdatedBy", t."TransactionDateDB", t."TransactionType"::text AS "TransactionType",
                   t."KFlag"::text AS "KFlag", t."IsHissa"::text AS "IsHissa",
                   t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType"::text AS "DeviceType",
                   t."TransactionDate",
                   t."AddedDate",
                   t."UpdatedDate",
                   t."AddedBy"::text AS "AddedBy",
                   t."IsUpdated",
                   t."DeclareNumber",
                   t."UpdateDiff",
                   max(t."IsDada") AS "IsDada",
                   max(t."IsBAkar") AS "IsBAkar",
                   max(t."IsAAkar") AS "IsAAkar",
                   t."AddedDayTime",
                   t."UpdatedDayTime",
                   t."RecordStatus"::text AS "RecordStatus",
                   t."OrderAddeddate",
                   t."ClientRemarks"::text AS "ClientRemarks"
            FROM (
                SELECT t."TransactionId", t."OrganizationId", t."LedgerId", l."LedgerName", t."ShiftId", t."TotalAmount",
                       t."UpdatedBy", t."TransactionDate" AS "TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa",
                       t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                       to_char(t."TransactionDate", 'DD-MM-YYYY') AS "TransactionDate",
                       to_char(t."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
                       to_char(t."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
                       t."AddedBy",
                       (CASE WHEN t."UpdatedDate" = t."AddedDate" THEN 'No' ELSE 'Yes' END) AS "IsUpdated",
                       d."DeclareNumber",
                       ((CASE WHEN t."UpdatedDate" < t."AddedDate" THEN '-' ELSE '' END)
                         || lpad(trunc(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))) / 3600)::text, 2, '0')
                         || ':' || lpad(trunc(mod(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))), 3600) / 60)::text, 2, '0')
                         || ':' || lpad(trunc(mod(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))), 60))::text, 2, '0')
                       ) AS "UpdateDiff",
                       (CASE WHEN (td."Number" ~ '^[0-9]+$' AND td."Number"::integer = d."DeclareNumber") THEN 1 ELSE 0 END) AS "IsDada",
                       (CASE WHEN td."Number" = right(lpad(((d."DeclareNumber" % 10) * 111)::text, 3, '0'), 3) THEN 1 ELSE 0 END) AS "IsBAkar",
                       (CASE WHEN td."Number" = right(lpad(((floor(d."DeclareNumber"::numeric / 10) % 10) * 1111)::text, 4, '0'), 4) THEN 1 ELSE 0 END) AS "IsAAkar",
                       to_char(t."AddedDate", 'DD - HH12:MI AM') AS "AddedDayTime",
                       to_char(t."UpdatedDate", 'DD - HH12:MI AM') AS "UpdatedDayTime",
                       t."RecordStatus" AS "RecordStatus",
                       t."AddedDate" AS "OrderAddeddate",
                       t."ClientRemarks"
                FROM "transaction_declare" t
                INNER JOIN "transaction_detail_declare" td ON td."TransactionId" = t."TransactionId"
                INNER JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
                INNER JOIN "declare_result" AS d ON d."RecordStatus" != 'D' AND d."DeclareDate" = t."TransactionDate" AND d."ShiftId" = t."ShiftId" AND d."OrganizationId" = varOrganizationId
                WHERE t."OrganizationId" = varOrganizationId
                  AND t."ShiftId" = varShiftId
                  AND t."TransactionDate" = varShiftDate
                  AND (CASE WHEN varIsDeleted = 1 THEN t."RecordStatus" = 'D' ELSE t."RecordStatus" != 'D' END)
                  AND (t."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
                  AND (varRoleType = 'ALL'
                       OR t."UpdatedBy" = varUserName)
                  AND l."LedgerName" ILIKE (COALESCE(varLedgerName, '')::text || '%')
            ) AS t
            -- TransactionDateDB / AddedDayTime / UpdatedDayTime added to GROUP BY (functionally dependent on the transaction row)
            GROUP BY t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount",
                     t."UpdatedBy", t."TransactionDate", t."TransactionType", t."KFlag", t."IsHissa",
                     t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                     t."AddedDate",
                     t."UpdatedDate",
                     t."AddedBy",
                     t."DeclareNumber",
                     t."IsUpdated",
                     t."UpdateDiff",
                     t."RecordStatus",
                     t."OrderAddeddate",
                     t."ClientRemarks",
                     t."TransactionDateDB", t."AddedDayTime", t."UpdatedDayTime"
        ) AS t
        LEFT JOIN "transaction_audit" ta ON ta."TransactionId" = t."TransactionId"::bigint AND ta."RecordStatus" != 'D'
        ORDER BY t."OrderAddeddate" DESC;

    WHEN 4 THEN
        RETURN QUERY
        SELECT t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount",
               t."UpdatedBy", t."TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa",
               t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
               t."TransactionDate", t."AddedDate", t."UpdatedDate", t."AddedBy", t."IsUpdated",
               t."DeclareNumber", t."UpdateDiff", t."IsDada", t."IsBAkar", t."IsAAkar",
               t."AddedDayTime", t."UpdatedDayTime", t."RecordStatus", t."OrderAddeddate", t."ClientRemarks",
               (COALESCE(ta."MistakeStatus", 0) % 2)::integer AS "MistakeStatus",
               COALESCE(ta."ModifyStatus", 0)::integer AS "ModifyStatus",
               COALESCE(ta."LastStatus", 0)::integer AS "LastStatus",
               COALESCE(ta."Remark", '') AS "Remark"
        FROM (
            SELECT t."TransactionId"::text AS "TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName"::text AS "LedgerName", t."ShiftId", t."TotalAmount",
                   t."UpdatedBy"::text AS "UpdatedBy", t."TransactionDateDB", t."TransactionType"::text AS "TransactionType",
                   t."KFlag"::text AS "KFlag", t."IsHissa"::text AS "IsHissa",
                   t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType"::text AS "DeviceType",
                   t."TransactionDate",
                   t."AddedDate",
                   t."UpdatedDate",
                   t."AddedBy"::text AS "AddedBy",
                   t."IsUpdated",
                   t."DeclareNumber",
                   t."UpdateDiff",
                   max(t."IsDada") AS "IsDada",
                   max(t."IsBAkar") AS "IsBAkar",
                   max(t."IsAAkar") AS "IsAAkar",
                   t."AddedDayTime",
                   t."UpdatedDayTime",
                   t."RecordStatus"::text AS "RecordStatus",
                   t."OrderAddeddate",
                   t."ClientRemarks"::text AS "ClientRemarks"
            FROM (
                SELECT t."TransactionId", t."OrganizationId", t."LedgerId", l."LedgerName", t."ShiftId", t."TotalAmount",
                       t."UpdatedBy", t."TransactionDate" AS "TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa",
                       t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                       to_char(t."TransactionDate", 'DD-MM-YYYY') AS "TransactionDate",
                       to_char(t."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
                       to_char(t."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
                       t."AddedBy",
                       (CASE WHEN t."UpdatedDate" = t."AddedDate" THEN 'No' ELSE 'Yes' END) AS "IsUpdated",
                       d."DeclareNumber",
                       ((CASE WHEN t."UpdatedDate" < t."AddedDate" THEN '-' ELSE '' END)
                         || lpad(trunc(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))) / 3600)::text, 2, '0')
                         || ':' || lpad(trunc(mod(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))), 3600) / 60)::text, 2, '0')
                         || ':' || lpad(trunc(mod(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))), 60))::text, 2, '0')
                       ) AS "UpdateDiff",
                       (CASE WHEN (td."Number" ~ '^[0-9]+$' AND td."Number"::integer = d."DeclareNumber") THEN 1 ELSE 0 END) AS "IsDada",
                       (CASE WHEN td."Number" = right(lpad(((d."DeclareNumber" % 10) * 111)::text, 3, '0'), 3) THEN 1 ELSE 0 END) AS "IsBAkar",
                       (CASE WHEN td."Number" = right(lpad(((floor(d."DeclareNumber"::numeric / 10) % 10) * 1111)::text, 4, '0'), 4) THEN 1 ELSE 0 END) AS "IsAAkar",
                       to_char(t."AddedDate", 'DD - HH12:MI AM') AS "AddedDayTime",
                       to_char(t."UpdatedDate", 'DD - HH12:MI AM') AS "UpdatedDayTime",
                       t."RecordStatus" AS "RecordStatus",
                       t."AddedDate" AS "OrderAddeddate",
                       t."ClientRemarks"
                FROM "transaction_declare" t
                INNER JOIN "transaction_detail_declare" td ON td."TransactionId" = t."TransactionId"
                INNER JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
                INNER JOIN "declare_result" AS d ON d."DeclareDate" = t."TransactionDate" AND d."ShiftId" = t."ShiftId" AND d."OrganizationId" = varOrganizationId
                WHERE t."OrganizationId" = varOrganizationId
                  AND t."ShiftId" = varShiftId
                  AND t."TransactionDate" = varShiftDate
                  AND (CASE WHEN varIsDeleted = 1 THEN t."RecordStatus" = 'D' ELSE t."RecordStatus" != 'D' END)
                  AND (t."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId)
                  AND (varRoleType = 'ALL'
                       OR t."UpdatedBy" = varUserName)
                  AND l."LedgerName" ILIKE (COALESCE(varLedgerName, '')::text || '%')
            ) AS t
            -- TransactionDateDB / AddedDayTime / UpdatedDayTime added to GROUP BY (functionally dependent on the transaction row)
            GROUP BY t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount",
                     t."UpdatedBy", t."TransactionDate", t."TransactionType", t."KFlag", t."IsHissa",
                     t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                     t."AddedDate",
                     t."UpdatedDate",
                     t."AddedBy",
                     t."DeclareNumber",
                     t."IsUpdated",
                     t."UpdateDiff",
                     t."RecordStatus",
                     t."OrderAddeddate",
                     t."ClientRemarks",
                     t."TransactionDateDB", t."AddedDayTime", t."UpdatedDayTime"
        ) AS t
        LEFT JOIN "transaction_audit" ta ON ta."TransactionId" = t."TransactionId"::bigint AND ta."RecordStatus" != 'D'
        ORDER BY t."OrderAddeddate" DESC;

    WHEN 5 THEN
        RETURN QUERY
        SELECT t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount",
               t."UpdatedBy", t."TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa",
               t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
               t."TransactionDate", t."AddedDate", t."UpdatedDate", t."AddedBy", t."IsUpdated",
               t."DeclareNumber", t."UpdateDiff", t."IsDada", t."IsBAkar", t."IsAAkar",
               t."AddedDayTime", t."UpdatedDayTime", t."RecordStatus", t."OrderAddeddate", t."ClientRemarks",
               (COALESCE(ta."MistakeStatus", 0) % 2)::integer AS "MistakeStatus",
               COALESCE(ta."ModifyStatus", 0)::integer AS "ModifyStatus",
               COALESCE(ta."LastStatus", 0)::integer AS "LastStatus",
               COALESCE(ta."Remark", '') AS "Remark"
        FROM (
            SELECT t."TransactionId"::text AS "TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName"::text AS "LedgerName", t."ShiftId", t."TotalAmount",
                   t."UpdatedBy"::text AS "UpdatedBy", t."TransactionDateDB", t."TransactionType"::text AS "TransactionType",
                   t."KFlag"::text AS "KFlag", t."IsHissa"::text AS "IsHissa",
                   t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType"::text AS "DeviceType",
                   t."TransactionDate",
                   t."AddedDate",
                   t."UpdatedDate",
                   t."AddedBy"::text AS "AddedBy",
                   t."IsUpdated",
                   t."DeclareNumber",
                   t."UpdateDiff",
                   max(t."IsDada") AS "IsDada",
                   max(t."IsBAkar") AS "IsBAkar",
                   max(t."IsAAkar") AS "IsAAkar",
                   t."AddedDayTime",
                   t."UpdatedDayTime",
                   t."RecordStatus"::text AS "RecordStatus",
                   t."OrderAddeddate",
                   t."ClientRemarks"::text AS "ClientRemarks"
            FROM (
                SELECT t."TransactionId", t."OrganizationId", t."LedgerId", l."LedgerName", t."ShiftId", t."TotalAmount",
                       t."UpdatedBy", t."TransactionDate" AS "TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa",
                       t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                       to_char(t."TransactionDate", 'DD-MM-YYYY') AS "TransactionDate",
                       to_char(t."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
                       to_char(t."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
                       t."AddedBy",
                       (CASE WHEN t."UpdatedDate" = t."AddedDate" THEN 'No' ELSE 'Yes' END) AS "IsUpdated",
                       d."DeclareNumber",
                       ((CASE WHEN t."UpdatedDate" < t."AddedDate" THEN '-' ELSE '' END)
                         || lpad(trunc(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))) / 3600)::text, 2, '0')
                         || ':' || lpad(trunc(mod(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))), 3600) / 60)::text, 2, '0')
                         || ':' || lpad(trunc(mod(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))), 60))::text, 2, '0')
                       ) AS "UpdateDiff",
                       (CASE WHEN (td."Number" ~ '^[0-9]+$' AND td."Number"::integer = d."DeclareNumber") THEN 1 ELSE 0 END) AS "IsDada",
                       (CASE WHEN td."Number" = right(lpad(((d."DeclareNumber" % 10) * 111)::text, 3, '0'), 3) THEN 1 ELSE 0 END) AS "IsBAkar",
                       (CASE WHEN td."Number" = right(lpad(((floor(d."DeclareNumber"::numeric / 10) % 10) * 1111)::text, 4, '0'), 4) THEN 1 ELSE 0 END) AS "IsAAkar",
                       to_char(t."AddedDate", 'DD - HH12:MI AM') AS "AddedDayTime",
                       to_char(t."UpdatedDate", 'DD - HH12:MI AM') AS "UpdatedDayTime",
                       t."RecordStatus" AS "RecordStatus",
                       t."AddedDate" AS "OrderAddeddate",
                       t."ClientRemarks"
                FROM "transaction_declare" t
                INNER JOIN "transaction_detail_declare" td ON td."TransactionId" = t."TransactionId"
                INNER JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
                INNER JOIN "declare_result" AS d ON d."DeclareDate" = t."TransactionDate" AND d."ShiftId" = t."ShiftId" AND d."OrganizationId" = varOrganizationId
                WHERE t."OrganizationId" = varOrganizationId
                  AND t."ShiftId" = varShiftId
                  AND t."TransactionDate" = varShiftDate
                  AND (CASE WHEN varIsDeleted = 1 THEN t."RecordStatus" = 'D' ELSE t."RecordStatus" != 'D' END)
                  AND t."LedgerId" = varLedgerId
                  AND (varRoleType = 'ALL'
                       OR t."UpdatedBy" = varUserName)
                  AND l."LedgerName" ILIKE (COALESCE(varLedgerName, '')::text || '%')
            ) AS t
            -- TransactionDateDB / AddedDayTime / UpdatedDayTime added to GROUP BY (functionally dependent on the transaction row)
            GROUP BY t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount",
                     t."UpdatedBy", t."TransactionDate", t."TransactionType", t."KFlag", t."IsHissa",
                     t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                     t."AddedDate",
                     t."UpdatedDate",
                     t."AddedBy",
                     t."DeclareNumber",
                     t."IsUpdated",
                     t."UpdateDiff",
                     t."RecordStatus",
                     t."OrderAddeddate",
                     t."ClientRemarks",
                     t."TransactionDateDB", t."AddedDayTime", t."UpdatedDayTime"
        ) AS t
        LEFT JOIN "transaction_audit" ta ON ta."TransactionId" = t."TransactionId"::bigint AND ta."RecordStatus" != 'D'
        ORDER BY t."OrderAddeddate" DESC;

    ELSE
        IF (SELECT COALESCE(r."IsDeclareTransactionConfig", 0) FROM "role" r WHERE r."OrganizationId" = varOrganizationId AND r."RoleId" = varRoleId) = 1 THEN
            RETURN QUERY
            SELECT t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount",
                   t."UpdatedBy", t."TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa",
                   t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                   t."TransactionDate", t."AddedDate", t."UpdatedDate", t."AddedBy", t."IsUpdated",
                   t."DeclareNumber", t."UpdateDiff", t."IsDada", t."IsBAkar", t."IsAAkar",
                   t."AddedDayTime", t."UpdatedDayTime", t."RecordStatus", t."OrderAddeddate", t."ClientRemarks",
                   (COALESCE(ta."MistakeStatus", 0) % 2)::integer AS "MistakeStatus",
                   COALESCE(ta."ModifyStatus", 0)::integer AS "ModifyStatus",
                   COALESCE(ta."LastStatus", 0)::integer AS "LastStatus",
                   COALESCE(ta."Remark", '') AS "Remark"
            FROM (
                SELECT t."TransactionId"::text AS "TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName"::text AS "LedgerName", t."ShiftId", t."TotalAmount",
                       t."UpdatedBy"::text AS "UpdatedBy", t."TransactionDateDB", t."TransactionType"::text AS "TransactionType",
                       t."KFlag"::text AS "KFlag", t."IsHissa"::text AS "IsHissa",
                       t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType"::text AS "DeviceType",
                       t."TransactionDate",
                       t."AddedDate",
                       t."UpdatedDate",
                       t."AddedBy"::text AS "AddedBy",
                       t."IsUpdated",
                       t."DeclareNumber",
                       t."UpdateDiff",
                       max(t."IsDada") AS "IsDada",
                       max(t."IsBAkar") AS "IsBAkar",
                       max(t."IsAAkar") AS "IsAAkar",
                       t."AddedDayTime",
                       t."UpdatedDayTime",
                       t."RecordStatus"::text AS "RecordStatus",
                       t."OrderAddeddate",
                       t."ClientRemarks"::text AS "ClientRemarks"
                FROM (
                    SELECT t."TransactionId", t."OrganizationId", t."LedgerId", l."LedgerName", t."ShiftId", t."TotalAmount",
                           t."UpdatedBy", t."TransactionDate" AS "TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa",
                           t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                           to_char(t."TransactionDate", 'DD-MM-YYYY') AS "TransactionDate",
                           to_char(t."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
                           to_char(t."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
                           t."AddedBy",
                           (CASE WHEN t."UpdatedDate" = t."AddedDate" THEN 'No' ELSE 'Yes' END) AS "IsUpdated",
                           d."DeclareNumber",
                           ((CASE WHEN t."UpdatedDate" < t."AddedDate" THEN '-' ELSE '' END)
                             || lpad(trunc(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))) / 3600)::text, 2, '0')
                             || ':' || lpad(trunc(mod(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))), 3600) / 60)::text, 2, '0')
                             || ':' || lpad(trunc(mod(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))), 60))::text, 2, '0')
                           ) AS "UpdateDiff",
                           (CASE WHEN (td."Number" ~ '^[0-9]+$' AND td."Number"::integer = d."DeclareNumber") THEN 1 ELSE 0 END) AS "IsDada",
                           (CASE WHEN td."Number" = right(lpad(((d."DeclareNumber" % 10) * 111)::text, 3, '0'), 3) THEN 1 ELSE 0 END) AS "IsBAkar",
                           (CASE WHEN td."Number" = right(lpad(((floor(d."DeclareNumber"::numeric / 10) % 10) * 1111)::text, 4, '0'), 4) THEN 1 ELSE 0 END) AS "IsAAkar",
                           to_char(t."AddedDate", 'DD - HH12:MI AM') AS "AddedDayTime",
                           to_char(t."UpdatedDate", 'DD - HH12:MI AM') AS "UpdatedDayTime",
                           t."RecordStatus" AS "RecordStatus",
                           t."AddedDate" AS "OrderAddeddate",
                           t."ClientRemarks"
                    FROM "transaction_declare" t
                    INNER JOIN "transaction_detail_declare" td ON td."TransactionId" = t."TransactionId"
                    INNER JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
                    INNER JOIN "declare_result" AS d ON d."DeclareDate" = t."TransactionDate" AND d."ShiftId" = t."ShiftId" AND d."OrganizationId" = varOrganizationId
                    INNER JOIN (
                        SELECT rpt."ExpiryDateTime", rpt."DataViewMode", rpt."ViewType", rpt."ShiftId", rpt."ShiftDate", lg."UserName"
                        FROM "role_permission_transaction" rpt
                        JOIN "login" lg ON lg."LoginId" = rpt."LoginId"
                        WHERE lg."UserName" = varUserName
                          AND rpt."OrganizationId" = varOrganizationId
                          AND rpt."ShiftId" = varShiftId
                          AND rpt."RecordStatus" != 'D'
                          AND COALESCE(rpt."IsPageAllow", '0') = '1'
                    ) AS r_p_t ON r_p_t."ShiftId" = t."ShiftId"
                        AND r_p_t."ShiftDate" = t."TransactionDate"
                        AND (CASE WHEN r_p_t."DataViewMode" = 1 THEN t."AddedDate" < d."AddedDate" WHEN r_p_t."DataViewMode" = 2 THEN t."AddedDate" >= d."AddedDate" ELSE true END)
                        AND (CASE WHEN r_p_t."ViewType" = '1' THEN r_p_t."UserName" = t."UpdatedBy" ELSE true END)
                    WHERE t."OrganizationId" = varOrganizationId
                      AND t."ShiftId" = varShiftId
                      AND t."TransactionDate" = varShiftDate
                      AND (CASE WHEN varIsDeleted = 1 THEN t."RecordStatus" = 'D' ELSE t."RecordStatus" != 'D' END)
                      AND (varRoleType = 'ALL'
                           OR t."UpdatedBy" = varUserName)
                      AND l."LedgerName" ILIKE (COALESCE(varLedgerName, '')::text || '%')
                ) AS t
                -- TransactionDateDB / AddedDayTime / UpdatedDayTime added to GROUP BY (functionally dependent on the transaction row)
                GROUP BY t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount",
                         t."UpdatedBy", t."TransactionDate", t."TransactionType", t."KFlag", t."IsHissa",
                         t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                         t."AddedDate",
                         t."UpdatedDate",
                         t."AddedBy",
                         t."DeclareNumber",
                         t."IsUpdated",
                         t."UpdateDiff",
                         t."RecordStatus",
                         t."OrderAddeddate",
                         t."ClientRemarks",
                         t."TransactionDateDB", t."AddedDayTime", t."UpdatedDayTime"
            ) AS t
            LEFT JOIN "transaction_audit" ta ON ta."TransactionId" = t."TransactionId"::bigint AND ta."RecordStatus" != 'D'
            ORDER BY t."OrderAddeddate" DESC;
        ELSE
            RETURN QUERY
            SELECT t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount",
                   t."UpdatedBy", t."TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa",
                   t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                   t."TransactionDate", t."AddedDate", t."UpdatedDate", t."AddedBy", t."IsUpdated",
                   t."DeclareNumber", t."UpdateDiff", t."IsDada", t."IsBAkar", t."IsAAkar",
                   t."AddedDayTime", t."UpdatedDayTime", t."RecordStatus", t."OrderAddeddate", t."ClientRemarks",
                   (COALESCE(ta."MistakeStatus", 0) % 2)::integer AS "MistakeStatus",
                   COALESCE(ta."ModifyStatus", 0)::integer AS "ModifyStatus",
                   COALESCE(ta."LastStatus", 0)::integer AS "LastStatus",
                   COALESCE(ta."Remark", '') AS "Remark"
            FROM (
                SELECT t."TransactionId"::text AS "TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName"::text AS "LedgerName", t."ShiftId", t."TotalAmount",
                       t."UpdatedBy"::text AS "UpdatedBy", t."TransactionDateDB", t."TransactionType"::text AS "TransactionType",
                       t."KFlag"::text AS "KFlag", t."IsHissa"::text AS "IsHissa",
                       t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType"::text AS "DeviceType",
                       t."TransactionDate",
                       t."AddedDate",
                       t."UpdatedDate",
                       t."AddedBy"::text AS "AddedBy",
                       t."IsUpdated",
                       t."DeclareNumber",
                       t."UpdateDiff",
                       max(t."IsDada") AS "IsDada",
                       max(t."IsBAkar") AS "IsBAkar",
                       max(t."IsAAkar") AS "IsAAkar",
                       t."AddedDayTime",
                       t."UpdatedDayTime",
                       t."RecordStatus"::text AS "RecordStatus",
                       t."OrderAddeddate",
                       t."ClientRemarks"::text AS "ClientRemarks"
                FROM (
                    SELECT t."TransactionId", t."OrganizationId", t."LedgerId", l."LedgerName", t."ShiftId", t."TotalAmount",
                           t."UpdatedBy", t."TransactionDate" AS "TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa",
                           t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                           to_char(t."TransactionDate", 'DD-MM-YYYY') AS "TransactionDate",
                           to_char(t."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
                           to_char(t."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
                           t."AddedBy",
                           (CASE WHEN t."UpdatedDate" = t."AddedDate" THEN 'No' ELSE 'Yes' END) AS "IsUpdated",
                           d."DeclareNumber",
                           ((CASE WHEN t."UpdatedDate" < t."AddedDate" THEN '-' ELSE '' END)
                             || lpad(trunc(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))) / 3600)::text, 2, '0')
                             || ':' || lpad(trunc(mod(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))), 3600) / 60)::text, 2, '0')
                             || ':' || lpad(trunc(mod(abs(extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))), 60))::text, 2, '0')
                           ) AS "UpdateDiff",
                           (CASE WHEN (td."Number" ~ '^[0-9]+$' AND td."Number"::integer = d."DeclareNumber") THEN 1 ELSE 0 END) AS "IsDada",
                           (CASE WHEN td."Number" = right(lpad(((d."DeclareNumber" % 10) * 111)::text, 3, '0'), 3) THEN 1 ELSE 0 END) AS "IsBAkar",
                           (CASE WHEN td."Number" = right(lpad(((floor(d."DeclareNumber"::numeric / 10) % 10) * 1111)::text, 4, '0'), 4) THEN 1 ELSE 0 END) AS "IsAAkar",
                           to_char(t."AddedDate", 'DD - HH12:MI AM') AS "AddedDayTime",
                           to_char(t."UpdatedDate", 'DD - HH12:MI AM') AS "UpdatedDayTime",
                           t."RecordStatus" AS "RecordStatus",
                           t."AddedDate" AS "OrderAddeddate",
                           t."ClientRemarks"
                    FROM "transaction_declare" t
                    INNER JOIN "transaction_detail_declare" td ON td."TransactionId" = t."TransactionId"
                    INNER JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
                    INNER JOIN "declare_result" AS d ON d."DeclareDate" = t."TransactionDate" AND d."ShiftId" = t."ShiftId" AND d."OrganizationId" = varOrganizationId
                    WHERE t."OrganizationId" = varOrganizationId
                      AND t."ShiftId" = varShiftId
                      AND t."TransactionDate" = varShiftDate
                      AND (CASE WHEN varIsDeleted = 1 THEN t."RecordStatus" = 'D' ELSE t."RecordStatus" != 'D' END)
                      AND (varRoleType = 'ALL'
                           OR t."UpdatedBy" = varUserName)
                      AND l."LedgerName" ILIKE (COALESCE(varLedgerName, '')::text || '%')
                ) AS t
                -- TransactionDateDB / AddedDayTime / UpdatedDayTime added to GROUP BY (functionally dependent on the transaction row)
                GROUP BY t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount",
                         t."UpdatedBy", t."TransactionDate", t."TransactionType", t."KFlag", t."IsHissa",
                         t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                         t."AddedDate",
                         t."UpdatedDate",
                         t."AddedBy",
                         t."DeclareNumber",
                         t."IsUpdated",
                         t."UpdateDiff",
                         t."RecordStatus",
                         t."OrderAddeddate",
                         t."ClientRemarks",
                         t."TransactionDateDB", t."AddedDayTime", t."UpdatedDayTime"
            ) AS t
            LEFT JOIN "transaction_audit" ta ON ta."TransactionId" = t."TransactionId"::bigint AND ta."RecordStatus" != 'D'
            ORDER BY t."OrderAddeddate" DESC;
        END IF;
    END CASE;
END;
$$;
