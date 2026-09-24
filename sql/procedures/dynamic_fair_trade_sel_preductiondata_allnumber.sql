-- Converted from MySQL procedure `dynamic_fair_trade_sel_preductiondata_allnumber`.
-- returns jsonb: [0] result set of the selected branch:
--   varIsNotShow = 0 (or NULL) -> mainjantrinumbersprofit row(s) (amount1..amount100) + Amount + NetSale
--   varIsNotShow = 1           -> per-number rows: Num, Profit, Amount, NetSale, Percent, DeclareCountForLastMonth (ordered by Profit)
--   otherwise (e.g. 2)         -> [] (no result set; only refreshes mainjantrinumbersprofit / mainjantrinumbers.profit)
DROP ROUTINE IF EXISTS "dynamic_fair_trade_sel_preductiondata_allnumber";
CREATE OR REPLACE FUNCTION "dynamic_fair_trade_sel_preductiondata_allnumber"(
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
    -- MySQL compared `Number = <n>` (varchar vs int) numerically; emulated with a guarded numeric cast.
    -- The two akhar patterns right(lpad((n mod 10)*111,3,'0'),3) and right(lpad((floor(n/10) mod 10)*1111,4,'0'),4)
    -- depend only on n and are precomputed as string literals (MySQL compared them as strings).
    v_s := 'insert into "mainjantrinumbersprofit"(';
    v_sTemp := '';
    intRow := 1;
    WHILE intRow <= 100 LOOP
        v_s := v_s || CASE WHEN intRow = 1 THEN '' ELSE ',' END || format('%I', 'amount' || intRow::text);
        v_sTemp := v_sTemp || CASE WHEN intRow = 1 THEN '' ELSE ',' END || format(
            'sum((coalesce((CASE WHEN ((CASE WHEN tdt."Number" ~ ''^[0-9]+$'' THEN tdt."Number"::numeric END) = %s'
            ' or tdt."Number" = %L or tdt."Number" = %L)'
            ' and tr."TransactionMode" = 1 THEN tdt."Amount" * tdt."Rate" ELSE 0 END), 0)'
            ' - coalesce((CASE WHEN tr."TransactionMode" = 1 THEN tdt."FinalAmount" ELSE 0 END), 0)'
            ' )'
            ' *(((100 - coalesce(tr."SelfHissa", 0)) / 100))*(((100 - coalesce(tr."OtherHissa", 0)) / 100))'
            ' ) as %I ',
            intRow,
            right(lpad(((intRow % 10) * 111)::text, 3, '0'), 3),
            right(lpad(((floor(intRow / 10.0)::int % 10) * 1111)::text, 4, '0'), 4),
            'amount' || intRow::text);
        intRow := intRow + 1;
    END LOOP;

    v_s := v_s || ') select ';
    v_sTemp := v_sTemp ||
        ' from "transaction" tr'
        ' inner join "transaction_detail" tdt on tr."TransactionId" = tdt."TransactionId"'
        ' where tr."TransactionDate" = $1'
        ' and tr."ShiftId" = $2'
        ' and tr."OrganizationId" = $3'
        ' and tr."TransactionMode" = 1'
        ' and tr."RecordStatus" <> ''D'''
        ' and tdt."RecordStatus" <> ''D''';

    v_s := v_s || v_sTemp;
    EXECUTE v_s USING varTransactionDate, varShiftId, varOrganizationId;

    intRow := 1;
    WHILE intRow <= 100 LOOP
        EXECUTE format('update "mainjantrinumbers" set "profit" = (select coalesce(%I, 0) from "mainjantrinumbersprofit") where "Num" = %s',
            'amount' || intRow::text, intRow);
        intRow := intRow + 1;
    END LOOP;

    IF coalesce(varIsNotShow, 0) = 0 THEN
        v_result := v_result || jsonb_build_array((SELECT coalesce(jsonb_agg(t), '[]'::jsonb) FROM (
            SELECT p.*, coalesce(TotalSaleTable."Amount", 0) AS "Amount"
                , round(coalesce(TotalSaleTable."NetSale", 0)) AS "NetSale"
            FROM "mainjantrinumbersprofit" p
            LEFT JOIN (
                -- MySQL selected a non-aggregated transaction_detail.Number here (unused by the outer select).
                SELECT coalesce(sum(tdt."Amount"), 0) AS "Amount", any_value(tdt."Number") AS "Number"
                    , coalesce(sum((tdt."FinalAmount") * (((100 - coalesce(tr."SelfHissa", 0)) / 100)) * (((100 - coalesce(tr."OtherHissa", 0)) / 100))), 0) AS "NetSale"
                FROM "transaction" tr
                INNER JOIN "transaction_detail" tdt ON tr."TransactionId" = tdt."TransactionId"
                WHERE tr."TransactionDate" = varTransactionDate
                  AND tr."ShiftId" = varShiftId
                  AND tr."OrganizationId" = varOrganizationId
                  AND tr."TransactionMode" = 1
                  AND tr."RecordStatus" <> 'D'
                  AND tdt."RecordStatus" <> 'D'
            ) AS TotalSaleTable ON 1 = 1
        ) t));
    ELSIF coalesce(varIsNotShow, 0) = 1 THEN
        v_result := v_result || jsonb_build_array((SELECT coalesce(jsonb_agg(t ORDER BY t."Profit"), '[]'::jsonb) FROM (
            SELECT m."Num"
                , coalesce((-(m."profit")), 0) AS "Profit"
                , coalesce(TotalSaleTable."Amount", 0) AS "Amount"
                , round(coalesce(TotalSaleTable."NetSale", 0)) AS "NetSale"
                , round((coalesce((-(m."profit")), 0) /
                    coalesce((SELECT CASE WHEN coalesce(sum((tdt."FinalAmount")
                            * (((100 - coalesce(tr."SelfHissa", 0)) / 100)) * (((100 - coalesce(tr."OtherHissa", 0)) / 100))), 0) = 0 THEN
                                1
                            ELSE
                                coalesce(sum((tdt."FinalAmount")
                                * (((100 - coalesce(tr."SelfHissa", 0)) / 100)) * (((100 - coalesce(tr."OtherHissa", 0)) / 100))), 0)
                            END
                        FROM "transaction" tr
                        INNER JOIN "transaction_detail" tdt ON tr."TransactionId" = tdt."TransactionId"
                        WHERE tr."TransactionDate" = varTransactionDate
                          AND tr."ShiftId" = varShiftId
                          AND tr."OrganizationId" = varOrganizationId
                          AND tr."TransactionMode" = 1
                          AND tr."RecordStatus" <> 'D'
                          AND tdt."RecordStatus" <> 'D'
                    ), 1)
                  ) * 100)
                  AS "Percent"
                , coalesce(declare_count."DeclareCountForLastMonth", 0) AS "DeclareCountForLastMonth"
            FROM "mainjantrinumbers" m
            LEFT JOIN (
                -- MySQL grouped by (case when length(Number) > 2 then Number else convert(Number, signed) end)
                -- and selected a non-grouped Number; the join Number = Num was a numeric comparison.
                SELECT coalesce(sum(tdt."Amount"), 0) AS "Amount"
                    , any_value(tdt."Number") AS "Number"
                    , coalesce(sum((tdt."FinalAmount") * (((100 - coalesce(tr."SelfHissa", 0)) / 100)) * (((100 - coalesce(tr."OtherHissa", 0)) / 100))), 0) AS "NetSale"
                FROM "transaction" tr
                INNER JOIN "transaction_detail" tdt ON tr."TransactionId" = tdt."TransactionId"
                WHERE tr."TransactionDate" = varTransactionDate
                  AND tr."ShiftId" = varShiftId
                  AND tr."OrganizationId" = varOrganizationId
                  AND tr."TransactionMode" = 1
                  AND tr."RecordStatus" <> 'D'
                  AND tdt."RecordStatus" <> 'D'
                GROUP BY (CASE WHEN length(tdt."Number") > 2 THEN tdt."Number"::text
                    ELSE (CASE WHEN tdt."Number" ~ '^[0-9]+$' THEN tdt."Number"::bigint ELSE 0 END)::text END)
            ) AS TotalSaleTable ON (CASE WHEN TotalSaleTable."Number" ~ '^[0-9]+$' THEN TotalSaleTable."Number"::numeric END) = m."Num"
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
