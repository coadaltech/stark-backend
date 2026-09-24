-- Converted from MySQL procedure `rpt_agent_linked_ledgers`.
-- NOTE: the MySQL result set listed ledger.AddedBy twice (same value); PG RETURNS TABLE cannot have
-- duplicate column names, so the second "AddedBy" column is omitted.
DROP ROUTINE IF EXISTS "rpt_agent_linked_ledgers";
CREATE OR REPLACE FUNCTION "rpt_agent_linked_ledgers"(
	varOrganizationId bigint
	,varLedgerId bigint
	,varToDate date
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
	,"LedgerBalance" double precision
	,"Amount" numeric
	,"AmountType" text
	,"OppositeLedgerId" integer
	,"Remark" text
	,"AddedDate" timestamp
	,"UpdatedBy" text
	,"UpdatedDate" timestamp
	,"IsSettDone" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
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
		,ledger_limit."LedgerBalance"
		,vd."Closing"::numeric AS "Amount"
		,'Cr'::text AS "AmountType"
		,0 AS "OppositeLedgerId"
		,''::text AS "Remark"
		,ledger."AddedDate"
		,ledger."UpdatedBy"::text
		,ledger."UpdatedDate"
		,(CASE WHEN coalesce(sett."SettLedgerId", 0) <> 0 THEN 1 ELSE 0 END) AS "IsSettDone"
	FROM "ledger" ledger
	LEFT JOIN (SELECT (sum(CASE WHEN v."AmountType" = 'Cr' THEN v."Amount" ELSE - v."Amount" END))::numeric(16,2) AS "Closing", v."LedgerId"
		FROM "voucher_detail" v
		WHERE v."OrganizationId" = varOrganizationId
		AND v."RecordStatus" <> 'D'
		AND v."VoucherType" <> 2
		AND v."VoucherDate" <= varToDate
		GROUP BY v."LedgerId") AS vd ON vd."LedgerId" = ledger."LedgerId"
	LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
	JOIN "ledger_limit" ledger_limit ON ledger."LedgerId" = ledger_limit."LedgerId"
	LEFT JOIN (SELECT hs."LedgerId" AS "SettLedgerId" FROM "hp_settelment" hs WHERE hs."SettelmentToDate" >= varToDate
		AND hs."RecordStatus" <> 'D'
		GROUP BY hs."LedgerId")
			AS sett ON sett."SettLedgerId" = ledger."LedgerId"
	WHERE ledger."OrganizationId" = varOrganizationId
	AND ledger."RecordStatus" <> 'D'
	AND ledger."IsHide" = '0'
	AND ledger."AgentLedgerId" = varLedgerId
	ORDER BY ledger."LedgerName" ASC;
END;
$$;
