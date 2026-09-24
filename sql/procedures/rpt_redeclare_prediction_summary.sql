-- Converted from MySQL procedure `rpt_redeclare_prediction_summary`.
-- MySQL compared `Number = varNumber` (varchar vs int) numerically; emulated with a guarded integer cast.
DROP ROUTINE IF EXISTS "rpt_redeclare_prediction_summary";
CREATE OR REPLACE FUNCTION "rpt_redeclare_prediction_summary"(
	varOrganizationId bigint,
	varShiftId bigint,
	varTransactionDate date,
	varNumber integer
)
RETURNS TABLE(
	"FirstProfit" numeric
	,"FirstSale" numeric
	,"LastSale" numeric
	,"DiffrenceSale" numeric
	,"LastProfit" numeric
	,"DiffrenceProfit" numeric
	,"DeclareNumber" integer
	,"RedelareCount" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT round(coalesce(ProfitTable."OldProfit", 0), 0) AS "FirstProfit"
	,round(coalesce(ProfitTable."OldSale", 0), 0) AS "FirstSale"
	,round(sum(tdd."Amount")::numeric, 0) AS "LastSale"

	,round((sum(tdd."Amount")
		- (coalesce(ProfitTable."OldSale", 0))::double precision)::numeric, 0) AS "DiffrenceSale"

	,-round(sum((coalesce((CASE WHEN ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::bigint END) = varNumber
			OR tdd."Number" = right(lpad(((varNumber % 10) * 111)::text, 3, '0'), 3)
			OR tdd."Number" = right(lpad(((floor(varNumber / 10.0)::bigint % 10) * 1111)::text, 4, '0'), 4))
			AND td."TransactionMode" = 1 THEN tdd."Amount" * tdd."Rate" ELSE 0 END), 0)
		- coalesce((CASE WHEN td."TransactionMode" = 1 THEN tdd."FinalAmount" ELSE 0 END), 0)
		)
		*(((100 - coalesce(td."SelfHissa", 0)) / 100))*(((100 - coalesce(td."OtherHissa", 0)) / 100))
		)::numeric, 0) AS "LastProfit"

	,round(((coalesce(ProfitTable."OldProfit", 0))::double precision
		+ sum((coalesce((CASE WHEN ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::bigint END) = varNumber
			OR tdd."Number" = right(lpad(((varNumber % 10) * 111)::text, 3, '0'), 3)
			OR tdd."Number" = right(lpad(((floor(varNumber / 10.0)::bigint % 10) * 1111)::text, 4, '0'), 4))
			AND td."TransactionMode" = 1 THEN tdd."Amount" * tdd."Rate" ELSE 0 END), 0)
		- coalesce((CASE WHEN td."TransactionMode" = 1 THEN tdd."FinalAmount" ELSE 0 END), 0)
		)
		*(((100 - coalesce(td."SelfHissa", 0)) / 100))*(((100 - coalesce(td."OtherHissa", 0)) / 100))
		))::numeric, 0) AS "DiffrenceProfit"

	,varNumber AS "DeclareNumber"
	,any_value(declare_result."ReDeclareNos") AS "RedelareCount"

	FROM "transaction_declare" td
	INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
	LEFT JOIN "ledger" ledger ON ledger."LedgerId" = td."LedgerId"
	LEFT JOIN
		(
			SELECT
				(sum(CASE WHEN vd."VoucherType" IN (22,23,24,25,26,27,28,29,30,31,32) THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE - vd."Amount" END) ELSE 0 END))::numeric(16,2)
				AS "OldProfit"
				,(sum(CASE WHEN vd."VoucherType" IN (22,23,24) THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE - vd."Amount" END) ELSE 0 END))::numeric(16,2)
				AS "OldSale"
			FROM "voucher_detail_first" AS vd
			JOIN "ledger" l ON vd."LedgerId" = l."LedgerId"
			WHERE (vd."VoucherDate" = varTransactionDate)
			AND l."GroupId" IN (3,4,5)
			AND (vd."RecordStatus" <> 'D')
			AND (vd."ShiftId" = varShiftId)
		) AS ProfitTable ON 1=1
	INNER JOIN (SELECT dr."ReDeclareNos" FROM "declare_result" dr WHERE dr."DeclareDate" = varTransactionDate AND dr."ShiftId" = varShiftId) AS declare_result ON 1 = 1

	WHERE td."TransactionDate" = varTransactionDate
	AND td."ShiftId" = varShiftId
	AND td."OrganizationId" = varOrganizationId
	AND td."TransactionMode" = 1
	AND td."RecordStatus" <> 'D'
	AND tdd."RecordStatus" <> 'D'
	GROUP BY ProfitTable."OldProfit", ProfitTable."OldSale"
	;
END;
$$;
