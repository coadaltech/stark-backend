-- Converted from MySQL procedure `transaction_check_after_before_declare`.
-- NOTES:
--  * MySQL's middle query aliased `t.TransactionDate as TransactionDateDB`, where t.TransactionDate is already the
--    formatted 'DD-MM-YYYY' string, so TransactionDateDB is text here as well.
--  * timediff(UpdatedDate, AddedDate) (MySQL TIME, rendered 'HH:MM:SS' with hours > 24 allowed) is emulated as text.
--  * td.Number = d.DeclareNumber was a numeric (varchar vs int) comparison in MySQL; emulated with a guarded cast.
--  * ORDER BY t.AddedDate sorts the formatted 'DD-MM-YYYY HH12:MI AM' string, as in MySQL.
DROP ROUTINE IF EXISTS "transaction_check_after_before_declare";
CREATE OR REPLACE FUNCTION "transaction_check_after_before_declare"(
    varOrganizationId integer,
    varShiftId integer,
    varShiftDate date,
    varLedgerId integer,
    varLedgerName varchar,
    varIsAfterDeclare integer
)
RETURNS TABLE(
    "TransactionId" text,
    "OrganizationId" bigint,
    "LedgerId" bigint,
    "LedgerName" text,
    "ShiftId" bigint,
    "TotalAmount" double precision,
    "UpdatedBy" text,
    "TransactionDateDB" text,
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
    "IsAfterDeclare" integer,
    "DeclareDateAdded" timestamp,
    "MistakeStatus" integer,
    "ModifyStatus" integer,
    "LastStatus" integer,
    "Remark" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount"
        , t."UpdatedBy", t."TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa"
        , t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType"
        , t."TransactionDate", t."AddedDate", t."UpdatedDate"
        , t."AddedBy", t."IsUpdated", t."DeclareNumber", t."UpdateDiff"
        , t."IsDada", t."IsBAkar", t."IsAAkar"
        , t."AddedDayTime", t."UpdatedDayTime", t."RecordStatus", t."IsAfterDeclare", t."DeclareDateAdded"
        , (COALESCE(transaction_audit."MistakeStatus", 0) % 2)::integer AS "MistakeStatus"
        , COALESCE(transaction_audit."ModifyStatus", 0)::integer AS "ModifyStatus"
        , COALESCE(transaction_audit."LastStatus", 0)::integer AS "LastStatus"
        , COALESCE(transaction_audit."Remark", '')::text AS "Remark"
    FROM
        (
        SELECT t."TransactionId"::text AS "TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName"::text AS "LedgerName", t."ShiftId", t."TotalAmount"
            , t."UpdatedBy"::text AS "UpdatedBy", t."TransactionDate" AS "TransactionDateDB", t."TransactionType"::text AS "TransactionType", t."KFlag"::text AS "KFlag", t."IsHissa"::text AS "IsHissa"
            , t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType"::text AS "DeviceType",
              t."TransactionDate",
              t."AddedDate",
              t."UpdatedDate"
            , t."AddedBy"::text AS "AddedBy"
            , t."IsUpdated"
            , t."DeclareNumber"
            , t."UpdateDiff"
            , max(t."IsDada") AS "IsDada"
            , max(t."IsBAkar") AS "IsBAkar"
            , max(t."IsAAkar") AS "IsAAkar"
            , t."AddedDayTime"
            , t."UpdatedDayTime"
            , t."RecordStatus"::text AS "RecordStatus"
            , t."IsAfterDeclare"
            , t."DeclareDateAdded"
        FROM (
            SELECT t."TransactionId", t."OrganizationId", t."LedgerId", l."LedgerName", t."ShiftId", t."TotalAmount"
                , t."UpdatedBy", t."TransactionDate" AS "TransactionDateDB", t."TransactionType", t."KFlag", t."IsHissa"
                , t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
                  to_char(t."TransactionDate", 'DD-MM-YYYY') AS "TransactionDate",
                  to_char(t."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
                  to_char(t."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate"
                , t."AddedBy"
                , (CASE WHEN t."UpdatedDate" = t."AddedDate" THEN 'No' ELSE 'Yes' END) AS "IsUpdated"
                , d."DeclareNumber"
                -- timediff(t.UpdatedDate, t.AddedDate)
                , (CASE WHEN t."UpdatedDate" < t."AddedDate"
                        THEN '-' || to_char(make_interval(secs => extract(epoch FROM (t."AddedDate" - t."UpdatedDate"))), 'HH24:MI:SS')
                        ELSE to_char(make_interval(secs => extract(epoch FROM (t."UpdatedDate" - t."AddedDate"))), 'HH24:MI:SS')
                   END) AS "UpdateDiff"
                , (CASE WHEN (CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END) = d."DeclareNumber" THEN 1 ELSE 0 END) AS "IsDada"
                , (CASE WHEN td."Number" = right(lpad(((d."DeclareNumber" % 10) * 111)::text, 3, '0'), 3) THEN 1 ELSE 0 END) AS "IsBAkar"
                , (CASE WHEN td."Number" = right(lpad(((floor(d."DeclareNumber"::numeric / 10)::bigint % 10) * 1111)::text, 4, '0'), 4) THEN 1 ELSE 0 END) AS "IsAAkar"
                , to_char(t."AddedDate", 'DD - HH12:MI AM') AS "AddedDayTime"
                , to_char(t."UpdatedDate", 'DD - HH12:MI AM') AS "UpdatedDayTime"
                , t."RecordStatus" AS "RecordStatus"
                , (CASE WHEN t."UpdatedDate" > d."AddedDate" THEN 1 ELSE 0 END) AS "IsAfterDeclare"
                , d."AddedDate" AS "DeclareDateAdded"
            FROM "transaction_declare" t
            INNER JOIN "transaction_detail_declare" td ON td."TransactionId" = t."TransactionId"
            INNER JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
            INNER JOIN "declare_result" AS d ON d."RecordStatus" != 'D' AND d."DeclareDate" = t."TransactionDate" AND d."ShiftId" = t."ShiftId" AND d."OrganizationId" = varOrganizationId
            WHERE t."OrganizationId" = varOrganizationId
              AND t."ShiftId" = varShiftId
              AND t."TransactionDate" = varShiftDate
              AND t."RecordStatus" != 'D'
              AND (t."LedgerId" = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
              AND l."LedgerName" ILIKE (COALESCE(varLedgerName, '')::text || '%')
            ) AS t
        WHERE 1 = 1
          AND (CASE varIsAfterDeclare WHEN 0 THEN t."IsAfterDeclare" = 0 WHEN 1 THEN t."IsAfterDeclare" = 1 ELSE true END)
        -- AddedDayTime / UpdatedDayTime (not grouped in MySQL) are derived from the grouped transaction row, so adding them is equivalent.
        GROUP BY t."TransactionId", t."OrganizationId", t."LedgerId", t."LedgerName", t."ShiftId", t."TotalAmount"
            , t."UpdatedBy", t."TransactionDate", t."TransactionType", t."KFlag", t."IsHissa"
            , t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType",
              t."TransactionDate",
              t."AddedDate",
              t."UpdatedDate"
            , t."AddedBy"
            , t."DeclareNumber"
            , t."IsUpdated"
            , t."UpdateDiff"
            , t."RecordStatus"
            , t."IsAfterDeclare"
            , t."DeclareDateAdded"
            , t."AddedDayTime", t."UpdatedDayTime"
        ) AS t
    LEFT JOIN "transaction_audit" ON transaction_audit."TransactionId" = t."TransactionId"::bigint AND transaction_audit."RecordStatus" != 'D'
    ORDER BY t."AddedDate" DESC;
END;
$$;
