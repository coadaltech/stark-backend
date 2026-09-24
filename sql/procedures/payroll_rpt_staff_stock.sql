-- Converted from MySQL procedure `payroll_rpt_staff_stock`.
DROP ROUTINE IF EXISTS "payroll_rpt_staff_stock";
CREATE OR REPLACE FUNCTION "payroll_rpt_staff_stock"(
	varOrganizationId bigint
	, varLedgerId bigint
)
RETURNS TABLE(
	"CommanName" text
	,"StaffStockId" bigint
	,"LedgerId" bigint
	,"OrganizationId" bigint
	,"CommanMasterId" bigint
	,"Amount" double precision
	,"Quantity" integer
	,"Brand" text
	,"BillPartNo" text
	,"Remark" text
	,"RecordStatus" text
	,"AddedBy" text
	,"AddedDate" timestamp
	,"UpdatedBy" text
	,"UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT pcm."CommanName"::text
	,s."StaffStockId"
	,s."LedgerId"
	,s."OrganizationId"
	,s."CommanMasterId"
	,s."Amount"
	,s."Quantity"
	,s."Brand"::text
	,s."BillPartNo"::text
	,s."Remark"::text
	,s."RecordStatus"::text
	,s."AddedBy"::text
	,s."AddedDate"
	,s."UpdatedBy"::text
	,s."UpdatedDate"
	FROM "payroll_staff_stock" s
	JOIN "payroll_comman_master" pcm ON s."CommanMasterId" = pcm."CommanMasterId"
	WHERE s."LedgerId" = varLedgerId
	AND (coalesce(s."OrganizationId", 0) = varOrganizationId)
	AND s."RecordStatus" <> 'D'
	ORDER BY pcm."CommanOrder";
END;
$$;
