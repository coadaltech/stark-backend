-- Converted from MySQL procedure `payroll_rpt_staff_structure_default`.
DROP ROUTINE IF EXISTS "payroll_rpt_staff_structure_default";
CREATE OR REPLACE FUNCTION "payroll_rpt_staff_structure_default"(
	varOrganizationId bigint
	, varCommanMasterType integer
	, varCommanMasterId bigint
)
RETURNS TABLE(
	"CommanName" text
	,"CommanType" integer
	,"DefaultStructureId" bigint
	,"OrganizationId" bigint
	,"RoleId" bigint
	,"CommanMasterId" bigint
	,"Amount" double precision
	,"AmountType" double precision
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
	,pcm."CommanType"
	,d."DefaultStructureId"
	,d."OrganizationId"
	,d."RoleId"
	,d."CommanMasterId"
	,d."Amount"
	,d."AmountType"
	,d."Remark"::text
	,d."RecordStatus"::text
	,d."AddedBy"::text
	,d."AddedDate"
	,d."UpdatedBy"::text
	,d."UpdatedDate"
	FROM "payroll_staff_structure_default" d
	JOIN "payroll_comman_master" pcm ON d."CommanMasterId" = pcm."CommanMasterId"
	WHERE pcm."CommanType" = varCommanMasterType
	AND (coalesce(d."CommanMasterId", 0) = varCommanMasterId OR varCommanMasterId = 0)
	AND (coalesce(d."OrganizationId", 0) = varOrganizationId)
	AND d."RecordStatus" <> 'D'
	ORDER BY pcm."CommanOrder";
END;
$$;
