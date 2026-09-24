-- Converted from MySQL procedure `payroll_sys_staff_attendance_create`.
DROP ROUTINE IF EXISTS "payroll_sys_staff_attendance_create";
CREATE OR REPLACE FUNCTION "payroll_sys_staff_attendance_create"(varOrganizationId integer, varMonth integer, varYear integer, varLedgerId bigint)
RETURNS TABLE("UpdateTable" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varFromDate timestamp;
    varToDate timestamp;
BEGIN
    varFromDate := make_date(varYear, varMonth, 1)::timestamp;
    IF varMonth <> 12 THEN
        varToDate := make_date(varYear, varMonth + 1, 1)::timestamp;
    ELSE
        varToDate := make_date(varYear + 1, 1, 1)::timestamp;
    END IF;
    varToDate := varToDate - interval '1 day';

    IF EXISTS (SELECT ps."LedgerId" FROM "payroll_salary" ps
               WHERE (ps."OrganizationId" = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
                 AND ps."SalaryMonth" = varMonth
                 AND ps."SalaryYear" = varYear AND ps."VoucherId" != 0 AND ps."RecordStatus" != 'D') THEN
        RETURN QUERY SELECT 0 AS "UpdateTable";
    ELSE
        DELETE FROM "payroll_attendance" pa
        WHERE (pa."OrganizationId" = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
          AND pa."AttendanceMonth" = varMonth
          AND pa."AttendanceYear" = varYear;

        INSERT INTO "payroll_attendance"(
            "OrganizationId",
            "LedgerId",
            "AttendanceDate", "AttendanceMonth", "AttendanceYear",
            "WorkingDays",
            "TotalDays",
            "Absent",
            "PaidLeave",
            "Present",
            "MonthEndLeaveApplicable",
            "TotalEntryCount",
            "Remark",
            "RecordStatus",
            "AddedBy",
            "AddedDate",
            "UpdatedBy",
            "UpdatedDate"
        )
        SELECT atten."OrganizationId",
               atten."LedgerId",
               current_date, varMonth, varYear,
               (varToDate::date - varFromDate::date) AS "WorkingDays",
               (varToDate::date - varFromDate::date) + 1 AS "TotalDays",
               COALESCE((SELECT count(1) FROM "payroll_leave" pl WHERE pl."RecordStatus" != 'D'
                           AND extract(month FROM pl."LeaveDate")::int = varMonth AND extract(year FROM pl."LeaveDate")::int = varYear
                           AND pl."LedgerId" = atten."LedgerId" AND COALESCE(pl."IsPaid", 0) = 0), 0),
               COALESCE((SELECT count(1) FROM "payroll_leave" pl WHERE pl."RecordStatus" != 'D'
                           AND extract(month FROM pl."LeaveDate")::int = varMonth AND extract(year FROM pl."LeaveDate")::int = varYear
                           AND pl."LedgerId" = atten."LedgerId" AND COALESCE(pl."IsPaid", 0) = 1), 0),
               (CASE WHEN atten."LoginType" IN (11) THEN
                         sum(CASE WHEN COALESCE(atten."EntryCount", 0) < 1000 THEN 0 ELSE 1 END)
                     WHEN atten."LoginType" IN (12) THEN
                         sum(CASE WHEN COALESCE(atten."EntryCount", 0) < 10 THEN 0 ELSE 1 END)
                     ELSE
                         (varToDate::date - varFromDate::date)
                         - COALESCE((SELECT count(1) FROM "payroll_leave" pl WHERE pl."RecordStatus" != 'D'
                                       AND extract(month FROM pl."LeaveDate")::int = varMonth AND extract(year FROM pl."LeaveDate")::int = varYear
                                       AND pl."LedgerId" = atten."LedgerId"), 0)
                END) AS "Present",
               (CASE WHEN atten."LoginType" IN (11) THEN
                         COALESCE((CASE WHEN sum(CASE WHEN COALESCE(atten."EntryCount", 0) < 500 THEN 0 ELSE 1 END) >= (varToDate::date - varFromDate::date) THEN 1 ELSE 0 END), 0)
                     ELSE
                         0
                END) AS "MonthEndLeaveApplicable",
               /*,(case when Atten.LoginType in (11,12) then
                    sum(case when ifnull(Atten.EntryCount,0) < 500 then 0 else 1 end)
                    + (case when sum(case when ifnull(Atten.EntryCount,0) < 500 then 0 else 1 end) >= 15 then 1 else 0 end)
                else
                    (datediff(varToDate,varFromDate) + 1)
                end )as Attendance
               */
               COALESCE(sum(atten."EntryCount"), 0) AS "EntryCount",
               '' AS "Remark",
               'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
        FROM (
            SELECT ledger."OrganizationId", ledger."LedgerId", ledger."LedgerName", lg."UserName", day_transaction."TransactionDate", day_transaction."EntryCount",
                   lg."Mobile",
                   lg."Address",
                   lg."LoginType"
            FROM (SELECT l."OrganizationId", l."LedgerId", l."LedgerName" FROM "ledger" l
                  WHERE (l."OrganizationId" = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
                    AND (COALESCE(l."LedgerId", 0) = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
                    AND l."GroupId" IN (2, 3, 5, 6, 7)
                    AND l."RecordStatus" != 'D') AS ledger
            INNER JOIN (SELECT pss."LedgerId" FROM "payroll_staff_structure" pss WHERE pss."RecordStatus" != 'D' GROUP BY pss."LedgerId")
                AS pss ON ledger."LedgerId" = pss."LedgerId"
            LEFT JOIN "login" lg ON lg."LedgerId" = ledger."LedgerId" AND lg."LoginType" NOT IN (2, 7)
            LEFT JOIN (
                SELECT x."OrganizationId", x."TransactionDate"::date AS "TransactionDate",
                       x."AddedBy", sum(x."EntryCount") AS "EntryCount"
                FROM (SELECT td."OrganizationId", td."TransactionDate"::date AS "TransactionDate",
                             td."AddedBy", count(1) AS "EntryCount"
                      FROM "transaction_detail_declare" tdd
                      JOIN "transaction_declare" td ON tdd."TransactionId" = td."TransactionId"
                      WHERE td."OrganizationId" = varOrganizationId
                        AND tdd."RecordStatus" != 'D'
                        AND td."RecordStatus" != 'D'
                        AND td."TransactionDate"::date BETWEEN varFromDate AND varToDate
                      GROUP BY td."TransactionDate"::date, td."AddedBy", td."OrganizationId"
                      UNION ALL
                      SELECT t."OrganizationId", t."ShiftDate",
                             t."AddedBy", count(1) AS "EntryCount"
                      FROM "transaction_audit" t
                      WHERE (t."RecordStatus" != 'D')
                        AND (t."ShiftDate" BETWEEN varFromDate AND varToDate)
                        AND t."OrganizationId" = varOrganizationId
                      GROUP BY t."ShiftDate", t."AddedBy", t."OrganizationId"
                     ) AS x
                GROUP BY x."TransactionDate", x."OrganizationId", x."AddedBy"
            ) AS day_transaction ON lg."UserName" = day_transaction."AddedBy"
            ORDER BY ledger."LedgerName", day_transaction."TransactionDate"
        ) AS atten
        GROUP BY atten."OrganizationId", atten."LedgerId", atten."LoginType", atten."LedgerName", atten."UserName",
                 atten."Mobile",
                 atten."Address";

        RETURN QUERY SELECT 1 AS "UpdateTable";
    END IF;
END;
$$;
