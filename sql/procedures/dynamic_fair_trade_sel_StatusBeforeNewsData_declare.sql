-- Converted from MySQL procedure `dynamic_fair_trade_sel_StatusBeforeNewsData_declare`.
DROP ROUTINE IF EXISTS "dynamic_fair_trade_sel_StatusBeforeNewsData_declare";
-- returns jsonb: [0] rows {LedgerId, LastFiveDayProfitNo, LedgerName, TotSale, Amount1, Number1, ..., AmountN, NumberN}
--   (one Amount<i>/Number<i> column pair per comma-separated number in varNumber; column list is dynamic).
CREATE OR REPLACE FUNCTION "dynamic_fair_trade_sel_StatusBeforeNewsData_declare"(
    varTransactionDate date,
    varShiftId bigint,
    varOrganizationId bigint,
    varNumber varchar
)
RETURNS jsonb
LANGUAGE plpgsql AS $$
DECLARE
    intRow smallint := 0;
    SingleNumber varchar(10);
    v_s text;
    v_rows jsonb;
BEGIN
    -- NOTE: MySQL compared varchar "Number" with the (integer) literal numerically; emulated with
    -- (Number ~ '^[0-9]+$' AND Number::integer = n). Numbers are passed as %L::integer (MySQL spliced them raw).
    v_s := 'select tdc."LedgerId" AS "LedgerId"
        , COALESCE(any_value(pt."NoOfProfit"), 0) AS "LastFiveDayProfitNo"
        , lg."LedgerName" AS "LedgerName", sum(tdd."Amount") AS "TotSale"';
    intRow := 1;

    WHILE strpos(varNumber, ',') > 0 LOOP
        SingleNumber := split_part(varNumber, ',', 1);
        varNumber := substr(varNumber, length(SingleNumber) + 2);

        v_s := v_s || format(
            ', -sum((COALESCE((CASE WHEN ((tdd."Number" ~ ''^[0-9]+$'' AND tdd."Number"::integer = %1$L::integer)'
            ' OR tdd."Number" = right(lpad(((%1$L::integer %% 10) * 111)::text, 3, ''0''), 3)'
            ' OR tdd."Number" = right(lpad(((floor(%1$L::integer::numeric / 10) %% 10) * 1111)::text, 4, ''0''), 4))'
            ' AND tdc."TransactionMode" = 1 THEN tdd."Amount" * tdd."Rate" ELSE 0 END), 0)'
            ' - COALESCE((CASE WHEN tdc."TransactionMode" = 1 THEN tdd."FinalAmount" ELSE 0 END), 0))'
            ' * (((100 - COALESCE(tdc."SelfHissa", 0)) / 100)) * (((100 - COALESCE(tdc."OtherHissa", 0)) / 100))'
            ') AS %2$I, %1$L::integer AS %3$I',
            trim(SingleNumber), 'Amount' || intRow::text, 'Number' || intRow::text);

        intRow := intRow + 1;
    END LOOP;

    v_s := v_s || format(
        ', -sum((COALESCE((CASE WHEN ((tdd."Number" ~ ''^[0-9]+$'' AND tdd."Number"::integer = %1$L::integer)'
        ' OR tdd."Number" = right(lpad(((%1$L::integer %% 10) * 111)::text, 3, ''0''), 3)'
        ' OR tdd."Number" = right(lpad(((floor(%1$L::integer::numeric / 10) %% 10) * 1111)::text, 4, ''0''), 4))'
        ' AND tdc."TransactionMode" = 1 THEN tdd."Amount" * tdd."Rate" ELSE 0 END), 0)'
        ' - COALESCE((CASE WHEN tdc."TransactionMode" = 1 THEN tdd."FinalAmount" ELSE 0 END), 0))'
        ' * (((100 - COALESCE(tdc."SelfHissa", 0)) / 100)) * (((100 - COALESCE(tdc."OtherHissa", 0)) / 100))'
        ') AS %2$I, %1$L::integer AS %3$I',
        trim(varNumber), 'Amount' || intRow::text, 'Number' || intRow::text);

    v_s := v_s || format('
        from "transaction_declare" tdc
        inner join "transaction_detail_declare" tdd on tdc."TransactionId" = tdd."TransactionId"
        left join "ledger" lg on lg."LedgerId" = tdc."LedgerId"
        left join
            (
            select sum(case when aa."TodayProfit" < 0 then 1 else 0 end) as "NoOfProfit"
            , aa."LedgerId"
            from
            (
                select vd."VoucherDate",
                    round(sum(case when vd."VoucherType" in (22,23,24,25,26,27,28,29,30,31,32) then (case when vd."AmountType" = ''Dr'' then vd."Amount" else -vd."Amount" end) else 0 end)::numeric, 2)
                    as "TodayProfit"
                    , vd."LedgerId"
                from "voucher_detail" as vd
                where (vd."VoucherDate" between %1$L::date and %2$L::date)
                  and (vd."RecordStatus" != ''D'')
                  and (vd."ShiftId" = %3$L::bigint)
                group by vd."VoucherDate", vd."LedgerId"
            ) as aa
            group by aa."LedgerId"
            ) as pt on pt."LedgerId" = tdc."LedgerId"
        where tdc."TransactionDate" = %4$L::date
          and tdc."ShiftId" = %3$L::bigint
          and tdc."OrganizationId" = %5$L::bigint
          and tdc."TransactionMode" = 1
          and tdc."RecordStatus" != ''D''
          and tdd."RecordStatus" != ''D''
        group by tdc."LedgerId", lg."LedgerName"
        order by lg."LedgerName"',
        varTransactionDate - 5, varTransactionDate - 1, varShiftId, varTransactionDate, varOrganizationId);

    EXECUTE format('SELECT coalesce(jsonb_agg(t), ''[]''::jsonb) FROM (%s) t', v_s)
        INTO v_rows;

    RETURN jsonb_build_array(v_rows);
END;
$$;
