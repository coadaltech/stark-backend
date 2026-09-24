-- Converted from MySQL procedure `payroll_rpt_staff_attendance_detail`.
DROP ROUTINE IF EXISTS "payroll_rpt_staff_attendance_detail";
CREATE OR REPLACE FUNCTION "payroll_rpt_staff_attendance_detail"(
    varOrganizationId integer,
    varMonth integer,
    varYear integer,
    varLedgerId bigint,
    varAddedBy varchar,
    varLoginType integer
)
RETURNS TABLE(
    "EntryDates" date,
    "UnpaidLeave" integer,
    "PaidLeave" integer,
    "Present" integer,
    "EntryCount" bigint
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varFromDate timestamp;
    varToDate timestamp;
    varTempDate date;
BEGIN
    varFromDate := make_date(varYear, varMonth, 1)::timestamp;
    IF varMonth <> 12 THEN
        varToDate := make_date(varYear, varMonth + 1, 1)::timestamp;
    ELSE
        varToDate := make_date(varYear + 1, 1, 1)::timestamp;
    END IF;
    varToDate := varToDate + interval '-1 day';
    varTempDate := varFromDate::date;

    DROP TABLE IF EXISTS "MonthDates";
    CREATE TEMP TABLE "MonthDates"("EntryDates" date) ON COMMIT DROP;
    PERFORM plpgsql_check_pragma('table: "MonthDates"("EntryDates" date)');

    WHILE varTempDate <= varToDate LOOP
        INSERT INTO "MonthDates"("EntryDates") VALUES (varTempDate);
        varTempDate := varTempDate + 1;
    END LOOP;

    RETURN QUERY
    SELECT md."EntryDates"
        , (CASE WHEN pl."IsPaid" = 0 THEN 1 ELSE 0 END)::integer AS "UnpaidLeave"
        , (CASE WHEN pl."IsPaid" = 1 THEN 1 ELSE 0 END)::integer AS "PaidLeave"
        , (CASE WHEN varLoginType IN (11) THEN
                    (CASE WHEN COALESCE(atten."EntryCount", 0) < 1000 THEN 0 ELSE 1 END)
                WHEN varLoginType IN (12) THEN
                    (CASE WHEN COALESCE(atten."EntryCount", 0) < 10 THEN 0 ELSE 1 END)
                ELSE
                    (CASE WHEN pl."IsPaid" IS NULL THEN 1 ELSE 0 END)
           END)::integer AS "Present"
        , COALESCE((atten."EntryCount"), 0)::bigint AS "EntryCount"
    FROM "MonthDates" md
    LEFT JOIN "payroll_leave" pl ON pl."LeaveDate" = md."EntryDates"
            AND pl."RecordStatus" != 'D'
            AND pl."LedgerId" = varLedgerId
    LEFT JOIN
        (
            SELECT td."TransactionDate"::date AS "TransactionDate"
                , sum(td."EntryCount") AS "EntryCount"
            FROM
                (SELECT any_value(tdc."OrganizationId") AS "OrganizationId", tdc."TransactionDate"::date AS "TransactionDate"
                    , count(1) AS "EntryCount"
                 FROM "transaction_detail_declare" tdd
                 JOIN "transaction_declare" tdc ON tdd."TransactionId" = tdc."TransactionId"
                 WHERE tdd."RecordStatus" != 'D'
                   AND tdc."RecordStatus" != 'D'
                   AND tdc."TransactionDate"::date BETWEEN varFromDate AND varToDate
                   AND tdc."AddedBy" = varAddedBy
                 GROUP BY tdc."TransactionDate"::date
                 UNION ALL
                 SELECT any_value(ta."OrganizationId"), ta."ShiftDate"
                    , count(1) AS "EntryCount"
                 FROM "transaction_audit" ta
                 WHERE (ta."RecordStatus" != 'D')
                   AND (ta."ShiftDate" BETWEEN varFromDate AND varToDate)
                   AND ta."AddedBy" = varAddedBy
                 GROUP BY ta."ShiftDate"
                ) AS td
            GROUP BY td."TransactionDate"
        ) AS atten ON atten."TransactionDate" = md."EntryDates"
    ORDER BY md."EntryDates";

    DROP TABLE IF EXISTS "MonthDates";
END;
$$;
