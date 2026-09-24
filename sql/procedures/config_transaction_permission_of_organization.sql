-- Converted from MySQL procedure `config_transaction_permission_of_organization`.
DROP ROUTINE IF EXISTS "config_transaction_permission_of_organization";
CREATE OR REPLACE FUNCTION "config_transaction_permission_of_organization"(
	varOrganizationId integer
	, varLoginId integer
	, varShiftId integer
	, varShiftDate date
)
RETURNS TABLE(
	"RolePermissionTransactionId" bigint
	,"OrganizationId" bigint
	,"LoginId" bigint
	,"ShiftId" bigint
	,"ShiftDate" date
	,"ExpiryDateTime" timestamp
	,"ExpiryDateTimeNew" text
	,"DataViewMode" smallint
	,"Page" text
	,"IsPageAllow" text
	,"Add" text
	,"Edit" text
	,"Delete" text
	,"Export" text
	,"ViewType" text
	,"RecordStatus" text
	,"AddedBy" text
	,"AddedDate" timestamp
	,"UpdatedBy" text
	,"UpdatedDate" timestamp
	,"IsExpiry" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT rpt."RolePermissionTransactionId",
		rpt."OrganizationId",
		rpt."LoginId",
		rpt."ShiftId",
		rpt."ShiftDate",
		rpt."ExpiryDateTime",
		/*Y-m-d\TH:i:s*/
		to_char(rpt."ExpiryDateTime", 'YYYY-MM-DD"T"HH24:MI:SS') AS "ExpiryDateTimeNew",
		rpt."DataViewMode",
		rpt."Page"::text,
		rpt."IsPageAllow"::text,
		rpt."Add"::text,
		rpt."Edit"::text,
		rpt."Delete"::text,
		rpt."Export"::text,
		rpt."ViewType"::text,
		rpt."RecordStatus"::text,
		rpt."AddedBy"::text,
		rpt."AddedDate",
		rpt."UpdatedBy"::text,
		rpt."UpdatedDate",
		(CASE WHEN localtimestamp >= coalesce(rpt."ExpiryDateTime", localtimestamp) THEN 1 ELSE 0 END) AS "IsExpiry"
	FROM "role_permission_transaction" rpt
	WHERE rpt."OrganizationId" = varOrganizationId
	AND rpt."RecordStatus" <> 'D'
	AND (rpt."LoginId" = varLoginId OR coalesce(varLoginId, 0) = 0)
	AND (rpt."ShiftId" = varShiftId OR coalesce(varShiftId, 0) = 0)
	AND (rpt."ShiftDate" = varShiftDate OR varShiftDate IS NULL)
	ORDER BY rpt."AddedDate" DESC;
END;
$$;
