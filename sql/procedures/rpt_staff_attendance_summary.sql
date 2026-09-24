-- Converted from MySQL procedure `rpt_staff_attendance_summary`.
DROP ROUTINE IF EXISTS "rpt_staff_attendance_summary";
CREATE OR REPLACE FUNCTION "rpt_staff_attendance_summary"(varOrganizationId integer, varFromDate date, varToDate date, varUserName varchar, varLedgerId integer)
RETURNS TABLE(
    "UserName" text,
    "LedgerName" text,
    "Attendance" bigint,
    "Absent" bigint,
    "TotalDays" bigint,
    "EntryCount" numeric,
    "LedgerId" bigint,
    "Mobile" text,
    "Address" text,
    "PaidLeave" bigint,
    "UnPaidLeave" bigint
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT atten."UserName"::text, atten."LedgerName"::text,
           (sum(CASE WHEN atten."AddedDate" IS NULL THEN 0 ELSE 1 END) + COALESCE(pl."PaidLeave", 0))::bigint AS "Attendance",
           ((varToDate - varFromDate) + 1 - sum(CASE WHEN atten."AddedDate" IS NULL THEN 0 ELSE 1 END) - COALESCE(pl."PaidLeave", 0))::bigint AS "Absent",
           ((varToDate - varFromDate) + 1)::bigint AS "TotalDays",
           COALESCE(sum(atten."EntryCount"), 0)::numeric AS "EntryCount", atten."LedgerId",
           atten."Mobile"::text,
           atten."Address"::text,
           pl."PaidLeave"::bigint,
           pl."UnPaidLeave"::bigint
    FROM (
        SELECT ledger."LedgerId", ledger."LedgerName", lg."UserName", day_transaction."AddedDate", day_transaction."EntryCount",
               lg."Mobile",
               lg."Address"
        FROM (SELECT l."LedgerId", l."LedgerName" FROM "ledger" l
              WHERE l."OrganizationId" = varOrganizationId
                AND (COALESCE(l."LedgerId", 0) = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
                AND l."GroupId" = 7
                AND l."RecordStatus" = 'A') AS ledger
        INNER JOIN "login" lg ON lg."LedgerId" = ledger."LedgerId" AND lg."LoginType" NOT IN (2, 7)
            AND (COALESCE(lg."UserName"::text, '0') = varUserName OR COALESCE(varUserName, '') = '')
        LEFT JOIN (
            SELECT any_value(td."OrganizationId") AS "OrganizationId", td."AddedDate"::date AS "AddedDate",
                   td."AddedBy", count(1) AS "EntryCount"
            FROM "transaction_declare" td
            WHERE td."OrganizationId" = varOrganizationId
              AND td."AddedDate"::date BETWEEN varFromDate AND varToDate
              AND (COALESCE(td."AddedBy"::text, '0') = varUserName OR COALESCE(varUserName, '') = '')
            GROUP BY td."AddedDate"::date, td."AddedBy"
        ) AS day_transaction ON lg."UserName" = day_transaction."AddedBy"
        ORDER BY ledger."LedgerName", day_transaction."AddedDate"
    ) AS atten
    LEFT JOIN (SELECT sum(CASE WHEN COALESCE(p."IsPaid", 0) = 1 THEN 1 ELSE 0 END) AS "PaidLeave",
                      sum(CASE WHEN COALESCE(p."IsPaid", 0) = 1 THEN 0 ELSE 1 END) AS "UnPaidLeave",
                      p."LedgerId"
               FROM "payroll_leave" p
               WHERE p."RecordStatus" != 'D'
                 AND p."LeaveDate" BETWEEN varFromDate AND varToDate
               GROUP BY p."LedgerId"
    ) AS pl ON pl."LedgerId" = atten."LedgerId"
    GROUP BY atten."LedgerId", atten."LedgerName", atten."UserName",
             atten."Mobile",
             atten."Address",
             pl."PaidLeave",
             pl."UnPaidLeave"
    ORDER BY atten."LedgerName", atten."UserName";
END;
$$;
