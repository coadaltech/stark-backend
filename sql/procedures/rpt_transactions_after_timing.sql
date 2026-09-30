-- Converted from MySQL procedure `rpt_transactions_after_timing`.
-- NOTE: shift_timing.EndTime (varchar) is assumed to hold a time string like 'HH:MM[:SS]';
-- MySQL compared UpdatedDate against the string "<date> <EndTime>", PG casts it to timestamp.
DROP ROUTINE IF EXISTS "rpt_transactions_after_timing";
CREATE OR REPLACE FUNCTION "rpt_transactions_after_timing"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date
)
RETURNS TABLE(
    "TransactionId" bigint,
    "OrganizationId" bigint,
    "ShiftId" bigint,
    "LedgerId" bigint,
    "TransactionDate" date,
    "TransactionMode" smallint,
    "TransactionType" varchar,
    "KFlag" varchar,
    "EntryType" varchar,
    "ClientRemarks" varchar,
    "IsHissa" varchar,
    "SelfHissa" double precision,
    "OtherHissa" double precision,
    "DaraRate" double precision,
    "DaraCommission" double precision,
    "AkharRate" double precision,
    "AkharCommission" double precision,
    "Tax" double precision,
    "TotalAmount" double precision,
    "TotalCommission" double precision,
    "TotalTax" double precision,
    "FinalAmount" double precision,
    "TransactionStartTime" timestamp,
    "DeviceType" varchar,
    "RecordStatus" char(1),
    "AddedBy" varchar,
    "AddedDate" timestamp,
    "UpdatedBy" varchar,
    "UpdatedDate" timestamp,
    "EndTime" text,
    "ShiftName" text,
    "LoginName" text,
    "AllowTime" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT t.*, st."EndTime"::text, s."ShiftName"::text, lg."LoginName"::text
        , (CASE WHEN s."ShiftNextDay" = 'Yes' THEN
                to_char((to_char(t."TransactionDate", 'YYYY-MM-DD') || ' ' || st."EndTime")::timestamp + interval '1 day', 'YYYY-MM-DD HH24:MI:SS')
           ELSE
                to_char(t."TransactionDate", 'YYYY-MM-DD') || ' ' || st."EndTime"
           END) AS "AllowTime"
    FROM "transaction_declare" AS t
    INNER JOIN "login" lg ON t."UpdatedBy" = lg."UserName" AND lg."OrganizationId" = t."OrganizationId" AND lg."LoginType" = 5
    INNER JOIN "shift_timing" st ON st."ShiftId" = t."ShiftId" AND st."RoleId" = 5
    INNER JOIN "shift" s ON t."ShiftId" = s."ShiftId"
    WHERE t."TransactionDate" BETWEEN varFromDate AND varToDate
      AND t."OrganizationId" = varOrganizationId
      AND (CASE WHEN s."ShiftNextDay" = 'Yes' THEN
                t."UpdatedDate" > (to_char(t."TransactionDate", 'YYYY-MM-DD') || ' ' || st."EndTime")::timestamp + interval '1 day'
           ELSE
                t."UpdatedDate" > (to_char(t."TransactionDate", 'YYYY-MM-DD') || ' ' || st."EndTime")::timestamp
           END)

    UNION ALL

    SELECT t.*, st."EndTime"::text, s."ShiftName"::text, lg."LoginName"::text
        , (CASE WHEN s."ShiftNextDay" = 'Yes' THEN
                to_char((to_char(t."TransactionDate", 'YYYY-MM-DD') || ' ' || st."EndTime")::timestamp + interval '1 day', 'YYYY-MM-DD HH24:MI:SS')
           ELSE
                to_char(t."TransactionDate", 'YYYY-MM-DD') || ' ' || st."EndTime"
           END) AS "AllowTime"
    FROM "transaction" AS t
    INNER JOIN "login" lg ON t."UpdatedBy" = lg."UserName" AND lg."OrganizationId" = t."OrganizationId" AND lg."LoginType" = 5
    INNER JOIN "shift_timing" st ON st."ShiftId" = t."ShiftId" AND st."RoleId" = 5
    INNER JOIN "shift" s ON t."ShiftId" = s."ShiftId"
    WHERE t."TransactionDate" BETWEEN varFromDate AND varToDate
      AND t."OrganizationId" = varOrganizationId
      AND (CASE WHEN s."ShiftNextDay" = 'Yes' THEN
                t."UpdatedDate" > (to_char(t."TransactionDate", 'YYYY-MM-DD') || ' ' || st."EndTime")::timestamp + interval '1 day'
           ELSE
                t."UpdatedDate" > (to_char(t."TransactionDate", 'YYYY-MM-DD') || ' ' || st."EndTime")::timestamp
           END);
END;
$$;
