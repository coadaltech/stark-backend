-- Converted from MySQL procedure `declare_transaction_audit_all_of_organization`.
DROP ROUTINE IF EXISTS "declare_transaction_audit_all_of_organization";
CREATE OR REPLACE FUNCTION "declare_transaction_audit_all_of_organization"(
    varOrganizationId integer,
    varShiftId integer,
    varShiftDate date,
    varIsAudit integer,
    varMistakeStatus integer,
    varModifyStatus integer,
    varLedgerName varchar
)
RETURNS TABLE(
    "TransactionId" text,
    "OrganizationId" bigint,
    "LedgerId" bigint,
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
    "OrderAddeddate" timestamp,
    "LedgerName" text,
    "ShiftName" text,
    "TransactionAuditId" bigint,
    "Amount" double precision,
    "AmountUpdated" double precision,
    "MistakeStatus" integer,
    "ModifyStatus" integer,
    "LastStatus" integer,
    "Remark" text,
    "AddedByAudit" text,
    "AddedDateAudit" timestamp,
    "UpdatedByAudit" text,
    "UpdatedDateAudit" timestamp,
    "ReAudit" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    -- NOTE: MySQL compared varchar td.Number with integer DeclareNumber numerically; emulated with
    -- (Number ~ '^[0-9]+$' AND Number::integer = DeclareNumber).
    -- timediff() emulated as a signed 'HH:MM:SS' text.
    RETURN QUERY
    SELECT t."TransactionId", t."OrganizationId", t."LedgerId", t."ShiftId", t."TotalAmount",
           t."UpdatedBy", t."TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa",
           t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
           t."TransactionDate", t."AddedDate", t."UpdatedDate", t."AddedBy", t."IsUpdated",
           t."DeclareNumber", t."UpdateDiff", t."IsDada", t."IsBAkar", t."IsAAkar",
           t."AddedDayTime", t."UpdatedDayTime", t."OrderAddeddate",
           l."LedgerName"::text, s."ShiftName"::text,
           COALESCE(ta."TransactionAuditId", 0) AS "TransactionAuditId",
           COALESCE(ta."Amount", 0) AS "Amount",
           COALESCE(ta."AmountUpdated", 0) AS "AmountUpdated",
           (COALESCE(ta."MistakeStatus", 0) % 2)::integer AS "MistakeStatus",
           COALESCE(ta."ModifyStatus", 0)::integer AS "ModifyStatus",
           COALESCE(ta."LastStatus", 0)::integer AS "LastStatus",
           COALESCE(ta."Remark", '') AS "Remark",
           COALESCE(ta."AddedBy"::text, '') AS "AddedByAudit",
           COALESCE(ta."AddedDate", '1970-01-01 00:00:00'::timestamp) AS "AddedDateAudit",
           COALESCE(ta."UpdatedBy"::text, '') AS "UpdatedByAudit",
           COALESCE(ta."UpdatedDate", '1970-01-01 00:00:00'::timestamp) AS "UpdatedDateAudit",
           (CASE WHEN COALESCE(ta."MistakeStatus", 0) = 2 THEN 1 ELSE 0 END) AS "ReAudit"
    FROM (
        SELECT t."TransactionId"::text AS "TransactionId", t."OrganizationId", t."LedgerId", t."ShiftId", t."TotalAmount",
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
               t."OrderAddeddate"
        FROM (
            SELECT t."TransactionId", t."OrganizationId", t."LedgerId", t."ShiftId", t."TotalAmount",
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
                   t."AddedDate" AS "OrderAddeddate"
            FROM "transaction_declare" t
            INNER JOIN "transaction_detail_declare" td ON td."TransactionId" = t."TransactionId"
            INNER JOIN "declare_result" AS d ON d."RecordStatus" != 'D' AND d."DeclareDate" = t."TransactionDate" AND d."ShiftId" = t."ShiftId" AND d."OrganizationId" = varOrganizationId
            WHERE t."OrganizationId" = varOrganizationId
              AND t."TransactionDate" = varShiftDate
              AND (COALESCE(varShiftId, 0) = 0 OR t."ShiftId" = varShiftId)
              AND t."TransactionDate" = varShiftDate
              AND t."RecordStatus" != 'D'
        ) AS t
        -- TransactionDateDB / AddedDayTime / UpdatedDayTime added to GROUP BY (functionally dependent on the transaction row)
        GROUP BY t."TransactionId", t."OrganizationId", t."LedgerId", t."ShiftId", t."TotalAmount",
                 t."UpdatedBy", t."TransactionDate", t."TransactionType", t."KFlag", t."IsHissa",
                 t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                 t."TransactionDate",
                 t."AddedDate",
                 t."UpdatedDate",
                 t."AddedBy",
                 t."DeclareNumber",
                 t."IsUpdated",
                 t."UpdateDiff",
                 t."OrderAddeddate",
                 t."TransactionDateDB", t."AddedDayTime", t."UpdatedDayTime"
    ) AS t
    LEFT JOIN "transaction_audit" ta ON ta."TransactionId" = t."TransactionId"::bigint AND ta."RecordStatus" != 'D'
    INNER JOIN "ledger" l ON t."LedgerId" = l."LedgerId" AND COALESCE(l."ParentLedgerId", 0) = 0
    INNER JOIN "shift" s ON s."ShiftId" = t."ShiftId"
    INNER JOIN "login" lg ON lg."UserName" = t."AddedBy"
    WHERE (CASE WHEN varIsAudit = 1 THEN (ta."TransactionAuditId" IS NULL OR COALESCE(ta."MistakeStatus", 0) = 2)
                WHEN varIsAudit = 2 THEN ta."TransactionAuditId" IS NOT NULL
                ELSE true END)
      AND (COALESCE(ta."MistakeStatus", 0) % 2 = COALESCE(varMistakeStatus, 0) OR COALESCE(varMistakeStatus, 0) = -1)
      AND (ta."ModifyStatus" = COALESCE(varModifyStatus, 0) OR COALESCE(varModifyStatus, 0) = -1)
      AND l."LedgerName" ILIKE (COALESCE(varLedgerName, '')::text || '%')
      AND lg."LoginType" NOT IN (3, 4, 5)
    ORDER BY t."OrderAddeddate";
END;
$$;
