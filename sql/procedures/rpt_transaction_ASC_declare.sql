-- Converted from MySQL procedure `rpt_transaction_ASC_declare`.
-- MySQL compared varchar Number with integer Num numerically; emulated with a guarded integer cast.
-- Non-grouped columns (MySQL ONLY_FULL_GROUP_BY off) are wrapped in any_value().
DROP ROUTINE IF EXISTS "rpt_transaction_ASC_declare";
CREATE OR REPLACE FUNCTION "rpt_transaction_ASC_declare"(
	varOrganizationId bigint,
	varTransactionDate date,
	varShiftId bigint,
	varAmountFrom smallint
)
RETURNS TABLE(
	"LedgerId" bigint
	,"LedgerName" text
	,"Number" text
	,"SaleAmount" double precision
	,"ProfitLossAmount" numeric
	,"Rate" double precision
	,"SelfHissa" double precision
	,"OtherHissa" double precision
	,"Commission" double precision
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT t."LedgerId", l."LedgerName"::text
	,td."Number"::text
	,sum(td."Amount") AS "SaleAmount"
	,coalesce((any_value(ProfitTable."PLAmount"))::numeric(16,0), 0)::numeric AS "ProfitLossAmount"
	,any_value(td."Rate") AS "Rate"
	,any_value(t."SelfHissa") AS "SelfHissa"
	,any_value(t."OtherHissa") AS "OtherHissa"
	,any_value(td."Commission") AS "Commission"
	FROM "transaction_detail_declare" td
	LEFT JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
	JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
	LEFT JOIN (
		SELECT sum((coalesce((CASE WHEN (((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::bigint END) = m."Num"
			OR tdd."Number" = right(lpad(((m."Num" % 10) * 111)::text, 3, '0'), 3)
			OR tdd."Number" = right(lpad(((floor(m."Num" / 10.0)::bigint % 10) * 1111)::text, 4, '0'), 4))
			AND tdcl."TransactionMode" = 1) THEN tdd."Amount" * tdd."Rate" ELSE 0 END), 0)
		- coalesce((CASE WHEN tdcl."TransactionMode" = 1 THEN tdd."FinalAmount" ELSE 0 END), 0)
		)
		*(((100 - coalesce(LH."Hissa", 0)) / 100))
		) AS "PLAmount", m."Num" AS "OpenNumber", tdcl."LedgerId"
		FROM "transaction_declare" tdcl
		INNER JOIN "transaction_detail_declare" tdd ON tdcl."TransactionId" = tdd."TransactionId"
		LEFT JOIN (SELECT sum(h."Hissa") AS "Hissa", h."LedgerId" FROM "hissa" h WHERE h."RecordStatus" <> 'D' AND h."HissaLedgerId" = h."LedgerId" GROUP BY h."LedgerId")
			AS LH ON LH."LedgerId" = tdcl."LedgerId"
		JOIN "mainjantrinumbers" m ON 1 = 1
		WHERE tdcl."TransactionDate" = varTransactionDate
		AND tdcl."ShiftId" = varShiftId
		AND tdcl."OrganizationId" = varOrganizationId
		AND tdcl."TransactionMode" = 1
		AND tdcl."RecordStatus" <> 'D'
		AND tdd."RecordStatus" <> 'D'
		GROUP BY m."Num", tdcl."LedgerId"
	) AS ProfitTable
	ON (CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::bigint END) = ProfitTable."OpenNumber" AND ProfitTable."LedgerId" = l."LedgerId"

	WHERE t."TransactionMode" = 1
	AND td."RecordStatus" <> 'D'
	AND t."RecordStatus" <> 'D'
	AND t."ShiftId" = varShiftId
	AND t."TransactionDate" = varTransactionDate
	AND t."OrganizationId" = varOrganizationId
	GROUP BY t."LedgerId", td."Number", l."LedgerName"
	HAVING sum(td."Amount") >= varAmountFrom
	ORDER BY 4 DESC  -- SaleAmount
	;
END;
$$;
