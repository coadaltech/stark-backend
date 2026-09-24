-- Converted from MySQL procedure `payroll_rpt_stock_issue_return`.
DROP ROUTINE IF EXISTS "payroll_rpt_stock_issue_return";
CREATE OR REPLACE FUNCTION "payroll_rpt_stock_issue_return"(varOrganizationId bigint, varStaffStockId bigint)
RETURNS TABLE(
    "CommanName" text,
    "IssueReturnStockId" bigint,
    "StaffStockId" bigint,
    "LedgerId" bigint,
    "OrganizationId" bigint,
    "CommanMasterId" bigint,
    "IssueDate" date,
    "Amount" double precision,
    "Quantity" integer,
    "Brand" text,
    "BillPartNo" text,
    "IsReturn" integer,
    "Remark" text,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT pcm."CommanName"::text,
           s."IssueReturnStockId",
           s."StaffStockId",
           s."LedgerId",
           s."OrganizationId",
           s."CommanMasterId",
           s."IssueDate",
           s."Amount",
           s."Quantity",
           s."Brand"::text,
           s."BillPartNo"::text,
           s."IsReturn",
           s."Remark"::text,
           s."RecordStatus"::text,
           s."AddedBy"::text,
           s."AddedDate",
           s."UpdatedBy"::text,
           s."UpdatedDate"
    FROM "payroll_issue_return_stock" s
    JOIN "payroll_comman_master" pcm ON s."CommanMasterId" = pcm."CommanMasterId"
    WHERE s."StaffStockId" = varStaffStockId
      AND (COALESCE(s."OrganizationId", 0) = varOrganizationId)
      AND s."RecordStatus" != 'D'
    ORDER BY s."IssueDate" DESC, s."AddedDate" DESC;
END;
$$;
