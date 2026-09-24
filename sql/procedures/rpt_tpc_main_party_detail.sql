-- Converted from MySQL procedure `rpt_tpc_main_party_detail`.
-- MySQL grouped only by lm.LedgerName; the non-grouped columns are wrapped in any_value().
DROP ROUTINE IF EXISTS "rpt_tpc_main_party_detail";
CREATE OR REPLACE FUNCTION "rpt_tpc_main_party_detail"(
	FromDate date
	, ToDate date
	, TPCLedgerId bigint
)
RETURNS TABLE(
	"FromLedgerId" bigint
	,"LedgerName" text
	,"Amount" double precision
	,"AgentName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT any_value(a."FromLedgerId") AS "FromLedgerId", lm."LedgerName"::text
	,sum(a."Amount") AS "Amount"
	,coalesce(any_value(agent."LedgerName")::text, 'NA') AS "AgentName"
	FROM "voucher_detail" a
	JOIN "ledger" lm ON a."FromLedgerId" = lm."LedgerId"
	LEFT JOIN "ledger" agent ON agent."LedgerId" = lm."AgentLedgerId"
	WHERE (a."RecordStatus" <> 'D')
	AND a."VoucherType" = 32
	AND a."LedgerId" = TPCLedgerId
	AND a."VoucherDate" BETWEEN FromDate AND ToDate
	GROUP BY lm."LedgerName";
END;
$$;
