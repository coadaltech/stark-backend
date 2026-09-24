-- Converted from MySQL procedure `dynamic_fair_trade_sel_StatusBeforeNewsData`.
DROP ROUTINE IF EXISTS "dynamic_fair_trade_sel_StatusBeforeNewsData";
-- returns jsonb: [0] rows {LedgerId, LedgerName, LastFiveDayProfitNo, TotSale, Amount1, Number1, ..., AmountN, NumberN}
--   (one Amount<i>/Number<i> column pair per comma-separated number in varNumber; the column list is dynamic,
--    hence jsonb instead of RETURNS TABLE).
CREATE OR REPLACE FUNCTION "dynamic_fair_trade_sel_StatusBeforeNewsData"(
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
    -- one numbered Amount/Number column pair; %1$L = the number, %2$I / %3$I = column labels
    c_col constant text :=
        ', -sum((COALESCE((CASE WHEN ((CASE WHEN tdt."Number" ~ ''^[0-9]+$'' THEN tdt."Number"::numeric END) = %1$L::numeric'
        ' OR tdt."Number" = right(lpad(((%1$L::integer %% 10) * 111)::text, 3, ''0''), 3)'
        ' OR tdt."Number" = right(lpad(((floor(%1$L::numeric / 10)::bigint %% 10) * 1111)::text, 4, ''0''), 4))'
        ' AND tr."TransactionMode" = 1 THEN tdt."Amount" * tdt."Rate" ELSE 0 END), 0)'
        ' - COALESCE((CASE WHEN tr."TransactionMode" = 1 THEN tdt."FinalAmount" ELSE 0 END), 0))'
        ' * (((100 - COALESCE(tr."SelfHissa", 0)) / 100)) * (((100 - COALESCE(tr."OtherHissa", 0)) / 100))'
        ') AS %2$I, %1$L::integer AS %3$I';
BEGIN
    -- NOTE: MySQL compared varchar "Number" with the spliced integer literal numerically; emulated with a guarded
    -- numeric cast. The number is passed as a quoted literal cast to integer (MySQL spliced it raw into the SQL).
    v_s := 'select tr."LedgerId" AS "LedgerId", lg."LedgerName" AS "LedgerName"
        , COALESCE(pt."NoOfProfit", 0) AS "LastFiveDayProfitNo"
        , sum(tdt."Amount") AS "TotSale"';
    intRow := 1;

    WHILE strpos(varNumber, ',') > 0 LOOP
        SingleNumber := split_part(varNumber, ',', 1);
        varNumber := substr(varNumber, length(SingleNumber) + 2);

        v_s := v_s || format(c_col, trim(SingleNumber), 'Amount' || intRow::text, 'Number' || intRow::text);

        intRow := intRow + 1;
    END LOOP;

    v_s := v_s || format(c_col, trim(varNumber), 'Amount' || intRow::text, 'Number' || intRow::text);

    v_s := v_s || format('
        from "transaction" tr
        inner join "transaction_detail" tdt on tr."TransactionId" = tdt."TransactionId"
        inner join "ledger" lg on lg."LedgerId" = tr."LedgerId"
        left join
            (
            select sum(case when aa."TodayProfit" < 0 then 1 else 0 end) as "NoOfProfit"
            , aa."LedgerId"
            from
            (
                select vd."VoucherDate",
                    (sum(case when vd."VoucherType" in (22,23,24,25,26,27,28,29,30,31,32) then (case when vd."AmountType" = ''Dr'' then vd."Amount" else -vd."Amount" end) else 0 end))::numeric(16,2)
                    as "TodayProfit"
                    , vd."LedgerId"
                from "voucher_detail" as vd
                where (vd."VoucherDate" between %1$L::date and %2$L::date)
                  and (vd."RecordStatus" != ''D'')
                  and (vd."ShiftId" = %3$L::bigint)
                group by vd."VoucherDate", vd."LedgerId"
            ) as aa
            group by aa."LedgerId"
            ) as pt on pt."LedgerId" = tr."LedgerId"
        where tr."TransactionDate" = %4$L::date
          and tr."ShiftId" = %3$L::bigint
          and tr."OrganizationId" = %5$L::bigint
          and tr."TransactionMode" = 1
          and tr."RecordStatus" != ''D''
          and tdt."RecordStatus" != ''D''
        -- pt."NoOfProfit" added to GROUP BY: pt has one row per LedgerId (MySQL allowed it non-grouped)
        group by tr."LedgerId", lg."LedgerName", pt."NoOfProfit"
        order by lg."LedgerName"',
        varTransactionDate - 5, varTransactionDate - 1, varShiftId, varTransactionDate, varOrganizationId);

    EXECUTE format('SELECT coalesce(jsonb_agg(t), ''[]''::jsonb) FROM (%s) t', v_s)
        INTO v_rows;

    RETURN jsonb_build_array(v_rows);
END;
$$;
