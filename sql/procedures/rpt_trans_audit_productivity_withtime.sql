-- Converted from MySQL procedure `rpt_trans_audit_productivity_withtime`.
-- MySQL used a session variable (@varEndDate) as a running "previous row AddedDate" while
-- scanning rows ordered by AddedDate. Converted to lag() over AddedDate. The first row has no
-- previous AddedDate -> StartDiffrence 'START' (MySQL: timediff(datetime, date-string) is NULL).
-- Output labels "@varEndDate" (previous value, first row = varFromDate) and
-- "@varEndDate:=AA.AddedDate" (the row's AddedDate) mirror the MySQL column labels.
DROP ROUTINE IF EXISTS "rpt_trans_audit_productivity_withtime";
CREATE OR REPLACE FUNCTION "rpt_trans_audit_productivity_withtime"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date,
    varShiftId integer,
    varAddedBy varchar)
RETURNS TABLE(
    "TransactionId" bigint, "ShiftDate" date, "ShiftId" bigint, "LedgerId" bigint, "Amount" double precision,
    "AddedDate" timestamp, "RecordStatus" text, "AddedBy" text, "UpdatedBy" text, "UpdatedDate" timestamp,
    "Timetaken" interval, "LedgerName" text, "NoofTrans" bigint, "MistakeStatus" integer, "Remark" text,
    "ShiftName" text, "@varEndDate" text, "StartDiffrence" text, "@varEndDate:=AA.AddedDate" timestamp)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT AA."TransactionId", AA."ShiftDate", AA."ShiftId", AA."LedgerId", AA."Amount",
           AA."AddedDate", AA."RecordStatus", AA."AddedBy", AA."UpdatedBy", AA."UpdatedDate",
           AA."Timetaken", AA."LedgerName", AA."NoofTrans", AA."MistakeStatus", AA."Remark",
           s."ShiftName"::text,
           COALESCE(to_char(lag(AA."AddedDate") OVER w, 'YYYY-MM-DD HH24:MI:SS'), varFromDate::text) AS "@varEndDate",
           COALESCE(to_char(AA."AddedDate" - lag(AA."AddedDate") OVER w, 'HH24:MI:SS'), 'START') AS "StartDiffrence",
           /*,TIMESTAMPDIFF(minute,AA.TransactionStartTime,AA.AddedDate) as TimeTakenInMin
             ,TIMESTAMPDIFF(minute,@varEndDate,AA.TransactionStartTime) as StartDiffrenceInMin */
           AA."AddedDate" AS "@varEndDate:=AA.AddedDate"
    FROM (
        SELECT t."TransactionId",
               t."ShiftDate",
               t."ShiftId",
               t."LedgerId",
               t."Amount",
               t."AddedDate",
               t."RecordStatus"::text AS "RecordStatus",
               t."AddedBy"::text AS "AddedBy",
               t."UpdatedBy"::text AS "UpdatedBy",
               t."UpdatedDate",
               (t."AddedDate" - t."AddedDate") AS "Timetaken",
               l."LedgerName"::text AS "LedgerName",
               count(t."TransactionId") AS "NoofTrans",
               (CASE WHEN COALESCE(t."MistakeStatus", 0) = 0 OR COALESCE(t."MistakeStatus", 0) = 2 THEN 0 ELSE 1 END) AS "MistakeStatus",
               t."Remark"
        FROM "transaction_audit" AS t
        JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
        WHERE (t."RecordStatus" != 'D')
          AND (t."ShiftDate" BETWEEN varFromDate AND varToDate)
          AND (COALESCE(varShiftId, 0) = 0 OR t."ShiftId" = varShiftId)
          AND t."OrganizationId" = varOrganizationId
          AND t."AddedBy" = varAddedBy
        GROUP BY t."TransactionId", t."ShiftDate", t."ShiftId", t."LedgerId", t."Amount", t."RecordStatus",
                 t."AddedBy", t."AddedDate", t."UpdatedBy", t."UpdatedDate",
                 l."LedgerName", t."MistakeStatus", t."Remark"
    ) AS AA
    JOIN "shift" s ON s."ShiftId" = AA."ShiftId"
    WINDOW w AS (ORDER BY AA."AddedDate" ASC)
    ORDER BY AA."AddedDate" ASC;
END;
$$;
