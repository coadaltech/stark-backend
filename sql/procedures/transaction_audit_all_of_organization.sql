-- Converted from MySQL procedure `transaction_audit_all_of_organization`.
-- LIKE -> ILIKE to keep MySQL's case-insensitive collation behaviour.
DROP ROUTINE IF EXISTS "transaction_audit_all_of_organization";
CREATE OR REPLACE FUNCTION "transaction_audit_all_of_organization"(
    varOrganizationId integer,
    varShiftId integer,
    varShiftDate date,
    varIsAudit integer,
    varMistakeStatus integer,
    varModifyStatus integer,
    varLedgerName varchar)
RETURNS TABLE(
    "TransactionId" text, "OrganizationId" bigint, "LedgerId" bigint, "LedgerName" text, "ShiftId" bigint,
    "TotalAmount" double precision, "UpdatedBy" text, "TransactionDateDB" date, "TransactionType" text,
    "KFlag" text, "IsHissa" text, "DaraRate" double precision, "DaraCommission" double precision,
    "AkharRate" double precision, "AkharCommission" double precision, "DeviceType" text,
    "TransactionDate" text, "AddedDate" text, "UpdatedDate" text, "AddedBy" text, "IsUpdated" text,
    "DeclareNumber" text, "UpdateDiff" interval, "IsDada" integer, "IsBAkar" integer, "IsAAkar" integer,
    "AddedDayTime" text, "UpdatedDayTime" text, "ShiftName" text, "OrderAddeddate" timestamp,
    "TransactionAuditId" bigint, "Amount" double precision, "AmountUpdated" double precision,
    "MistakeStatus" integer, "ModifyStatus" integer, "LastStatus" integer, "Remark" text,
    "AddedByAudit" text, "AddedDateAudit" timestamp, "UpdatedByAudit" text, "UpdatedDateAudit" timestamp,
    "ReAudit" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
/*
IsAudit 0 All,1 Not Audit ,2 Audit
varMistakeStatus -1 All 0 & 1 by MistakeStatus
varModifyStatus -1 All 0 & 1 by ModifyStatus
*/
    RETURN QUERY
    SELECT t.*,
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
        SELECT tr."TransactionId"::text AS "TransactionId", tr."OrganizationId", tr."LedgerId", l."LedgerName"::text AS "LedgerName",
               tr."ShiftId", tr."TotalAmount", tr."UpdatedBy"::text AS "UpdatedBy",
               tr."TransactionDate" AS "TransactionDateDB", tr."TransactionType"::text AS "TransactionType",
               tr."KFlag"::text AS "KFlag", tr."IsHissa"::text AS "IsHissa", tr."DaraRate", tr."DaraCommission",
               tr."AkharRate", tr."AkharCommission", tr."DeviceType"::text AS "DeviceType",
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
               s."ShiftName"::text AS "ShiftName",
               tr."AddedDate" AS "OrderAddeddate"
        FROM "transaction" tr
        JOIN "ledger" l ON tr."LedgerId" = l."LedgerId" AND COALESCE(l."ParentLedgerId", 0) = 0
        JOIN "shift" s ON s."ShiftId" = tr."ShiftId"
        WHERE tr."OrganizationId" = varOrganizationId
          AND (CASE WHEN COALESCE(varShiftId, 0) = 0 THEN
                        tr."TransactionDate" = s."ShiftDate"
                        AND s."OrganizationId" = varOrganizationId
                        AND s."IsActive" = '1'
                        AND s."RecordStatus" != 'D'
                    ELSE
                        tr."ShiftId" = varShiftId
                        AND tr."TransactionDate" = varShiftDate
               END)
          AND l."LedgerName" ILIKE (COALESCE(varLedgerName::text, '') || '%')
          AND tr."RecordStatus" != 'D'
    ) AS t
    LEFT JOIN "transaction_audit" ta ON ta."TransactionId" = t."TransactionId"::bigint AND ta."RecordStatus" != 'D'
    INNER JOIN "login" lg ON lg."UserName" = t."AddedBy" AND lg."OrganizationId" = varOrganizationId
    WHERE (CASE WHEN varIsAudit = 1 THEN (ta."TransactionAuditId" IS NULL OR COALESCE(ta."MistakeStatus", 0) = 2)
                WHEN varIsAudit = 2 THEN ta."TransactionAuditId" IS NOT NULL
                ELSE true END)
      AND (COALESCE(ta."MistakeStatus", 0) % 2 = COALESCE(varMistakeStatus, 0) OR COALESCE(varMistakeStatus, 0) = -1)
      AND (ta."ModifyStatus" = COALESCE(varModifyStatus, 0) OR COALESCE(varModifyStatus, 0) = -1)
      AND lg."LoginType" NOT IN (3,4,5)
    ORDER BY t."OrderAddeddate";
END;
$$;
