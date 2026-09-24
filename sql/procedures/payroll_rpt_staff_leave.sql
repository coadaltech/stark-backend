-- Converted from MySQL procedure `payroll_rpt_staff_leave`.
DROP ROUTINE IF EXISTS "payroll_rpt_staff_leave";
CREATE OR REPLACE FUNCTION "payroll_rpt_staff_leave"(varOrganizationId integer, varLedgerId bigint, varFromDate date, varToDate date)
RETURNS TABLE("LeaveId" bigint, "OrganizationId" bigint, "LedgerId" bigint, "LedgerName" text,
              "LeaveDate" date, "IsPaid" integer, "Remark" text, "RecordStatus" text,
              "AddedBy" text, "AddedDate" timestamp, "UpdatedBy" text, "UpdatedDate" timestamp)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT pl."LeaveId",
           pl."OrganizationId",
           pl."LedgerId",
           l."LedgerName"::text,
           pl."LeaveDate",
           pl."IsPaid",
           pl."Remark"::text,
           pl."RecordStatus"::text,
           pl."AddedBy"::text,
           pl."AddedDate",
           pl."UpdatedBy"::text,
           pl."UpdatedDate"
    FROM "payroll_leave" pl
    INNER JOIN "ledger" l ON pl."LedgerId" = l."LedgerId"
    WHERE pl."RecordStatus" != 'D'
      AND pl."OrganizationId" = varOrganizationId
      AND pl."LeaveDate" BETWEEN varFromDate AND varToDate
      AND (COALESCE(pl."LedgerId", 0) = varLedgerId OR COALESCE(varLedgerId, 0) = 0);
END;
$$;
