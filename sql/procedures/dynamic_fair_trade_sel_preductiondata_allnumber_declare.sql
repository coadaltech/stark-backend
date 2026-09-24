-- Converted from MySQL procedure `dynamic_fair_trade_sel_preductiondata_allnumber_declare`.
-- returns jsonb: [0] result set of the selected branch:
--   varIsNotShow = 0 -> mainjantrinumbersprofit row(s) (amount1..amount100) + Amount + NetSale
--   varIsNotShow = 1 -> per-number rows: Num, Profit, Amount, NetSale, Percent, DeclareCountForLastMonth
--   otherwise        -> [] (no result set)
DROP ROUTINE IF EXISTS "dynamic_fair_trade_sel_preductiondata_allnumber_declare";
CREATE OR REPLACE FUNCTION "dynamic_fair_trade_sel_preductiondata_allnumber_declare"(
	varTransactionDate date,
	varShiftId bigint,
	varOrganizationId bigint,
	varIsNotShow smallint
)
RETURNS jsonb
LANGUAGE plpgsql AS $$
DECLARE
	intRow smallint := 0;
	v_s text;
	v_sTemp text;
	v_result jsonb := '[]'::jsonb;
BEGIN

	DELETE FROM "mainjantrinumbersprofit";

	-- Build: insert into mainjantrinumbersprofit(amount1..amount100) select sum(...) as amount1, ...
	-- MySQL compared `Number = <n>` (varchar vs int) numerically; emulated with a guarded integer cast.
	-- The two derived patterns (right(lpad((n mod 10)*111,3,'0'),3) and
	-- right(lpad((floor(n/10) mod 10)*1111,4,'0'),4)) depend only on n and are precomputed as literals.
	v_s := 'insert into "mainjantrinumbersprofit"(';
	v_sTemp := '';
	intRow := 1;
	WHILE intRow <= 100 LOOP
		v_s := v_s || CASE WHEN intRow = 1 THEN '' ELSE ',' END || format('%I', 'amount' || intRow::text);
		v_sTemp := v_sTemp || CASE WHEN intRow = 1 THEN '' ELSE ',' END || format(
			'sum((coalesce((CASE WHEN ((CASE WHEN transaction_detail_declare."Number" ~ ''^[0-9]+$'' THEN transaction_detail_declare."Number"::bigint END) = %s'
			' or transaction_detail_declare."Number" = %L or transaction_detail_declare."Number" = %L)'
			' and transaction_declare."TransactionMode" = 1 THEN transaction_detail_declare."Amount" * transaction_detail_declare."Rate" ELSE 0 END), 0)'
			' - coalesce((CASE WHEN transaction_declare."TransactionMode" = 1 THEN transaction_detail_declare."FinalAmount" ELSE 0 END), 0)'
			' )'
			' *(((100 - coalesce(transaction_declare."SelfHissa", 0)) / 100))*(((100 - coalesce(transaction_declare."OtherHissa", 0)) / 100))'
			' ) as %I ',
			intRow,
			right(lpad(((intRow % 10) * 111)::text, 3, '0'), 3),
			right(lpad(((floor(intRow / 10.0)::int % 10) * 1111)::text, 4, '0'), 4),
			'amount' || intRow::text);
		intRow := intRow + 1;
	END LOOP;

	v_s := v_s || ') select ';
	v_sTemp := v_sTemp || format(
		' from "transaction_declare" transaction_declare'
		' inner join "transaction_detail_declare" transaction_detail_declare on transaction_declare."TransactionId" = transaction_detail_declare."TransactionId"'
		' where transaction_declare."TransactionDate" = %L::date'
		' and transaction_declare."ShiftId" = %L::bigint'
		' and transaction_declare."OrganizationId" = %L::bigint'
		' and transaction_declare."TransactionMode" = 1'
		' and transaction_declare."RecordStatus" <> ''D'''
		' and transaction_detail_declare."RecordStatus" <> ''D''',
		varTransactionDate, varShiftId, varOrganizationId);

	v_s := v_s || v_sTemp;
	EXECUTE v_s;

	intRow := 1;
	WHILE intRow <= 100 LOOP
		EXECUTE format('update "mainjantrinumbers" set "profit" = (select coalesce(%I, 0) from "mainjantrinumbersprofit") where "Num" = %s',
			'amount' || intRow::text, intRow);
		intRow := intRow + 1;
	END LOOP;

	IF coalesce(varIsNotShow, 0) = 0 THEN
		v_result := v_result || jsonb_build_array((SELECT coalesce(jsonb_agg(t), '[]'::jsonb) FROM (
			SELECT p.*, coalesce(TotalSaleTable."Amount", 0) AS "Amount"
			,round(coalesce(TotalSaleTable."NetSale", 0)) AS "NetSale"
			FROM "mainjantrinumbersprofit" p
			LEFT JOIN (
				SELECT coalesce(sum(tdd."Amount"), 0) AS "Amount"
				,coalesce(sum((tdd."FinalAmount") * (((100 - coalesce(td."SelfHissa", 0)) / 100)) * (((100 - coalesce(td."OtherHissa", 0)) / 100))), 0) AS "NetSale"
				FROM "transaction_declare" td
				INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
				WHERE td."TransactionDate" = varTransactionDate
				AND td."ShiftId" = varShiftId
				AND td."OrganizationId" = varOrganizationId
				AND td."TransactionMode" = 1
				AND td."RecordStatus" <> 'D'
				AND tdd."RecordStatus" <> 'D'
			) AS TotalSaleTable ON 1=1
		) t));
	ELSIF coalesce(varIsNotShow, 0) = 1 THEN
		v_result := v_result || jsonb_build_array((SELECT coalesce(jsonb_agg(t ORDER BY t."Profit"), '[]'::jsonb) FROM (
			SELECT m."Num", coalesce((-(m."profit")), 0) AS "Profit"
			,coalesce(TotalSaleTable."Amount", 0) AS "Amount"
			,round(coalesce(TotalSaleTable."NetSale", 0)) AS "NetSale"
			,round((coalesce((-(m."profit")), 0) /
				coalesce((SELECT CASE WHEN coalesce(sum((tdd."FinalAmount")
					* (((100 - coalesce(td."SelfHissa", 0)) / 100)) * (((100 - coalesce(td."OtherHissa", 0)) / 100))), 0) = 0 THEN
						1
					ELSE
						coalesce(sum((tdd."FinalAmount")
						* (((100 - coalesce(td."SelfHissa", 0)) / 100)) * (((100 - coalesce(td."OtherHissa", 0)) / 100))), 0)
					END
				FROM "transaction_declare" td
				INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
				WHERE td."TransactionDate" = varTransactionDate
				AND td."ShiftId" = varShiftId
				AND td."OrganizationId" = varOrganizationId
				AND td."TransactionMode" = 1
				AND td."RecordStatus" <> 'D'
				AND tdd."RecordStatus" <> 'D'
				), 1)
			) * 100)
			AS "Percent", coalesce(declare_count."DeclareCountForLastMonth", 0) AS "DeclareCountForLastMonth"
			FROM "mainjantrinumbers" m
			LEFT JOIN (
				-- MySQL grouped by (case when length(Number) > 2 then Number else convert(Number, signed) end)
				-- and selected a non-grouped Number; the join Number = Num was a numeric comparison.
				SELECT coalesce(sum(tdd."Amount"), 0) AS "Amount"
				,any_value(tdd."Number") AS "Number"
				,coalesce(sum((tdd."FinalAmount") * (((100 - coalesce(td."SelfHissa", 0)) / 100)) * (((100 - coalesce(td."OtherHissa", 0)) / 100))), 0)
				AS "NetSale"
				FROM "transaction_declare" td
				INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
				WHERE td."TransactionDate" = varTransactionDate
				AND td."ShiftId" = varShiftId
				AND td."OrganizationId" = varOrganizationId
				AND td."TransactionMode" = 1
				AND td."RecordStatus" <> 'D'
				AND tdd."RecordStatus" <> 'D'
				GROUP BY (CASE WHEN length(tdd."Number") > 2 THEN tdd."Number"::text
					ELSE (CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::bigint ELSE 0 END)::text END)
			) AS TotalSaleTable ON (CASE WHEN TotalSaleTable."Number" ~ '^[0-9]+$' THEN TotalSaleTable."Number"::bigint END) = m."Num"
			LEFT JOIN (
				SELECT count(1) AS "DeclareCountForLastMonth", dr."DeclareNumber" FROM "declare_result" dr
				WHERE dr."ShiftId" = varShiftId
				AND dr."DeclareDate" BETWEEN (varTransactionDate - make_interval(months => 1))::date AND (varTransactionDate - 1)
				AND dr."RecordStatus" <> 'D'
				GROUP BY dr."DeclareNumber"
			) AS declare_count ON declare_count."DeclareNumber" = m."Num"
		) t));
	END IF;

	RETURN v_result;
END;
$$;
