-- Converted from MySQL procedure `payroll_rpt_staff_attendance`.
DROP ROUTINE IF EXISTS "payroll_rpt_staff_attendance";
CREATE OR REPLACE FUNCTION "payroll_rpt_staff_attendance"(varOrganizationId integer, varMonth integer, varYear integer, varLedgerId bigint)
RETURNS TABLE(
    "LedgerName" text,
    "LedgerId" bigint,
    "AttendanceDate" date,
    "AttendanceMonth" integer,
    "AttendanceYear" integer,
    "WorkingDays" integer,
    "TotalDays" integer,
    "Absent" integer,
    "PaidLeave" integer,
    "Present" integer,
    "MonthEndLeaveApplicable" integer,
    "TotalEntryCount" integer,
    "Remark" text,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp,
    "UserName" text,
    "LoginType" smallint,
    "Mobile" text,
    "Address" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT l."LedgerName"::text,
           pa."LedgerId",
           pa."AttendanceDate",
           pa."AttendanceMonth",
           pa."AttendanceYear",
           pa."WorkingDays",
           pa."TotalDays",
           pa."Absent",
           pa."PaidLeave",
           pa."Present",
           pa."MonthEndLeaveApplicable",
           pa."TotalEntryCount",
           pa."Remark"::text,
           pa."RecordStatus"::text,
           pa."AddedBy"::text,
           pa."AddedDate",
           pa."UpdatedBy"::text,
           pa."UpdatedDate",
           lg."UserName"::text,
           lg."LoginType",
           lg."Mobile"::text,
           lg."Address"::text
    FROM "payroll_attendance" pa
    JOIN "ledger" l ON l."LedgerId" = pa."LedgerId"
    LEFT JOIN "login" lg ON lg."LedgerId" = l."LedgerId"
    WHERE (pa."OrganizationId" = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
      AND pa."AttendanceMonth" = varMonth
      AND pa."AttendanceYear" = varYear
      AND (pa."LedgerId" = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
    ORDER BY l."LedgerName", lg."UserName";
END;
$$;
