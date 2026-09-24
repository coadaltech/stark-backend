-- Converted from MySQL procedure `rpt_cashagent_by_parantagent`.
DROP ROUTINE IF EXISTS "rpt_cashagent_by_parantagent";
CREATE OR REPLACE FUNCTION "rpt_cashagent_by_parantagent"(
	varOrganizationId bigint
	, varAgentId bigint
)
RETURNS TABLE(
	"LedgerId" bigint
	,"LedgerName" text
	,"GroupId" integer
	,"GroupName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT ledger."LedgerId", ledger."LedgerName"::text, ledger."GroupId"
	,ledger_group."GroupName"::text
	FROM "comman_master" comman_master
	JOIN "ledger" ledger ON comman_master."LedgerId" = ledger."LedgerId"
	JOIN "ledger_group" ledger_group ON ledger."GroupId" = ledger_group."GroupId"
	WHERE comman_master."ParentAgentLedgerId" = varAgentId
	AND comman_master."OrganizationId" = varOrganizationId
	GROUP BY ledger."LedgerId", ledger."LedgerName", ledger."GroupId"
	,ledger_group."GroupName"
	ORDER BY ledger."LedgerName";
END;
$$;
