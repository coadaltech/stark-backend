-- Converted from MySQL procedure `ledger_List`.
-- NOTE: MySQL LIKE was case-insensitive (ci collation); ILIKE is used to keep that behaviour.
DROP ROUTINE IF EXISTS "ledger_List";
CREATE OR REPLACE FUNCTION "ledger_List"(
	varLedgerId integer,
	varListType integer, -- 0 for self, 1 for only ressaler, 2 only panter, 3 for ressaler and panter
	varLedgerName varchar
)
RETURNS TABLE(
	"LedgerId" bigint
	,"OrganizationId" bigint
	,"ParentLedgerId" bigint
	,"LedgerName" text
	,"GroupId" integer
	,"RecordStatus" text
	,"AddedBy" text
	,"Mobile" text
	,"UserName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
CASE varListType
	WHEN 3 THEN
		RETURN QUERY
		SELECT ledger."LedgerId",
			ledger."OrganizationId",
			ledger."ParentLedgerId",
			ledger."LedgerName"::text,
			ledger."GroupId",
			ledger."RecordStatus"::text
			,ledger."AddedBy"::text
			,coalesce(login."Mobile"::text, 'NA') AS "Mobile"
			,coalesce(login."UserName"::text, 'NA') AS "UserName"
			FROM "ledger" ledger
			LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
			WHERE (ledger."LedgerId" = varLedgerId OR ledger."ParentLedgerId" = varLedgerId
				OR ledger."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
			AND ledger."LedgerName" ILIKE ('' || varLedgerName || '%')
			AND ledger."RecordStatus" <> 'D'
			AND ledger."IsHide" = '0'
			ORDER BY ledger."LedgerName" ASC;
	WHEN 2 THEN
		RETURN QUERY
		SELECT ledger."LedgerId",
			ledger."OrganizationId",
			ledger."ParentLedgerId",
			ledger."LedgerName"::text,
			ledger."GroupId",
			ledger."RecordStatus"::text
			,ledger."AddedBy"::text
			,coalesce(login."Mobile"::text, 'NA') AS "Mobile"
			,coalesce(login."UserName"::text, 'NA') AS "UserName"
			FROM "ledger" ledger
			LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
			WHERE (ledger."LedgerId" = varLedgerId OR ((ledger."ParentLedgerId" = varLedgerId
				OR ledger."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId)
				)
				AND ledger."GroupId" IN (5))
					)
			AND ledger."LedgerName" ILIKE ('' || varLedgerName || '%')
			AND ledger."RecordStatus" <> 'D'
			AND ledger."IsHide" = '0'
			ORDER BY ledger."LedgerName" ASC;
	WHEN 1 THEN
		RETURN QUERY
		SELECT ledger."LedgerId",
			ledger."OrganizationId",
			ledger."ParentLedgerId",
			ledger."LedgerName"::text,
			ledger."GroupId",
			ledger."RecordStatus"::text
			,ledger."AddedBy"::text
			,coalesce(login."Mobile"::text, 'NA') AS "Mobile"
			,coalesce(login."UserName"::text, 'NA') AS "UserName"
			FROM "ledger" ledger
			LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
			WHERE (ledger."LedgerId" = varLedgerId OR ((ledger."ParentLedgerId" = varLedgerId
				OR ledger."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId)
				)
				AND ledger."GroupId" IN (4))
					)
			AND ledger."LedgerName" ILIKE ('' || varLedgerName || '%')
			AND ledger."RecordStatus" <> 'D'
			AND ledger."IsHide" = '0'
			ORDER BY ledger."LedgerName" ASC;
	WHEN 0 THEN
		RETURN QUERY
		SELECT ledger."LedgerId",
			ledger."OrganizationId",
			ledger."ParentLedgerId",
			ledger."LedgerName"::text,
			ledger."GroupId",
			ledger."RecordStatus"::text
			,ledger."AddedBy"::text
			,coalesce(login."Mobile"::text, 'NA') AS "Mobile"
			,coalesce(login."UserName"::text, 'NA') AS "UserName"
			FROM "ledger" ledger
			LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
			WHERE ledger."LedgerId" = varLedgerId
			AND ledger."LedgerName" ILIKE ('' || varLedgerName || '%')
			AND ledger."RecordStatus" <> 'D'
			AND ledger."IsHide" = '0'
			ORDER BY ledger."LedgerName" ASC;
	ELSE
		RETURN QUERY
		SELECT ledger."LedgerId",
			ledger."OrganizationId",
			ledger."ParentLedgerId",
			ledger."LedgerName"::text,
			ledger."GroupId",
			ledger."RecordStatus"::text
			,ledger."AddedBy"::text
			,coalesce(login."Mobile"::text, 'NA') AS "Mobile"
			,coalesce(login."UserName"::text, 'NA') AS "UserName"
			FROM "ledger" ledger
			LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
			WHERE (ledger."OrganizationId" = varLedgerId OR ledger."OrganizationId" = 0)
			AND ledger."LedgerName" ILIKE ('' || varLedgerName || '%')
			AND ledger."RecordStatus" <> 'D'
			AND ledger."IsHide" = '0'
			AND ledger."GroupId" NOT IN (7)
			ORDER BY ledger."LedgerName" ASC;
END CASE;
END;
$$;
