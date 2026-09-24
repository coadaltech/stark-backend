-- Converted from MySQL procedure `rpt_redeclare_prediction`.
-- Note: MySQL compared varchar Number to int varNumber numerically ('05' = 5); preserved via a
-- numeric comparison guarded by a digits-only regex. declare_result.ReDeclareNos was not grouped
-- in MySQL (any value) -> any_value().
DROP ROUTINE IF EXISTS "rpt_redeclare_prediction";
CREATE OR REPLACE FUNCTION "rpt_redeclare_prediction"(
    varOrganizationId bigint,
    varShiftId bigint,
    varTransactionDate date,
    varNumber integer)
RETURNS TABLE(
    "LedgerId" bigint, "LedgerName" text, "FirstProfit" numeric, "LastSale" numeric, "FirstSale" numeric,
    "DiffrenceSale" numeric, "LastProfit" numeric, "DeclareNumber" integer, "DiffrenceProfit" numeric,
    "RedelareCount" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    v_n3 text := right(lpad(((varNumber % 10) * 111)::text, 3, '0'), 3);
    v_n4 text := right(lpad(((floor(varNumber::numeric / 10)::bigint % 10) * 1111)::text, 4, '0'), 4);
BEGIN
    RETURN QUERY
    SELECT td0."LedgerId",
           l."LedgerName"::text,
           -round(COALESCE(pt."OldProfit", 0), 0) AS "FirstProfit",
           round(sum(tdd."Amount")::numeric, 0) AS "LastSale",
           round(COALESCE(pt."OldSale", 0), 0) AS "FirstSale",
           round((sum(tdd."Amount") - (COALESCE(pt."OldSale", 0)))::numeric, 0) AS "DiffrenceSale",
           round(sum((COALESCE((CASE WHEN ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varNumber) OR tdd."Number" = v_n3 OR tdd."Number" = v_n4)
                                           AND td0."TransactionMode" = 1 THEN tdd."Amount" * tdd."Rate" ELSE 0 END), 0)
                      - COALESCE((CASE WHEN td0."TransactionMode" = 1 THEN tdd."FinalAmount" ELSE 0 END), 0))
                     * (((100 - COALESCE(td0."SelfHissa", 0)) / 100)) * (((100 - COALESCE(td0."OtherHissa", 0)) / 100))
                    )::numeric, 0) AS "LastProfit",
           varNumber AS "DeclareNumber",
           round((sum((COALESCE((CASE WHEN ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varNumber) OR tdd."Number" = v_n3 OR tdd."Number" = v_n4)
                                            AND td0."TransactionMode" = 1 THEN tdd."Amount" * tdd."Rate" ELSE 0 END), 0)
                       - COALESCE((CASE WHEN td0."TransactionMode" = 1 THEN tdd."FinalAmount" ELSE 0 END), 0))
                      * (((100 - COALESCE(td0."SelfHissa", 0)) / 100)) * (((100 - COALESCE(td0."OtherHissa", 0)) / 100))
                     )
                  + COALESCE(pt."OldProfit", 0))::numeric, 0) AS "DiffrenceProfit",
           any_value(dr."ReDeclareNos") AS "RedelareCount"
    FROM "transaction_declare" td0
    INNER JOIN "transaction_detail_declare" tdd ON td0."TransactionId" = tdd."TransactionId"
    LEFT JOIN "ledger" l ON l."LedgerId" = td0."LedgerId"
    LEFT JOIN (
        SELECT vd."VoucherDate",
               sum(CASE WHEN vd."VoucherType" IN (22,23,24,25,26,27,28,29,30,31,32) THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2)
                   AS "OldProfit",
               sum(CASE WHEN vd."VoucherType" IN (22,23,24) THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2)
                   AS "OldSale",
               vd."LedgerId"
        FROM "voucher_detail_first" AS vd
        WHERE (vd."VoucherDate" = varTransactionDate)
          AND (vd."RecordStatus" != 'D')
          AND (vd."ShiftId" = varShiftId)
        GROUP BY vd."VoucherDate", vd."LedgerId"
    ) AS pt ON pt."LedgerId" = td0."LedgerId"
    INNER JOIN (SELECT x."ReDeclareNos" FROM "declare_result" x WHERE x."DeclareDate" = varTransactionDate AND x."ShiftId" = varShiftId) AS dr ON 1 = 1
    WHERE td0."TransactionDate" = varTransactionDate
      AND td0."ShiftId" = varShiftId
      AND td0."OrganizationId" = varOrganizationId
      AND td0."TransactionMode" = 1
      AND td0."RecordStatus" != 'D'
      AND tdd."RecordStatus" != 'D'
    GROUP BY td0."LedgerId", l."LedgerName", pt."OldProfit", pt."OldSale"
    HAVING NOT (round((COALESCE(pt."OldProfit", 0)
                       + sum((COALESCE((CASE WHEN ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varNumber) OR tdd."Number" = v_n3 OR tdd."Number" = v_n4)
                                                  AND td0."TransactionMode" = 1 THEN tdd."Amount" * tdd."Rate" ELSE 0 END), 0)
                              - COALESCE((CASE WHEN td0."TransactionMode" = 1 THEN tdd."FinalAmount" ELSE 0 END), 0))
                             * (((100 - COALESCE(td0."SelfHissa", 0)) / 100)) * (((100 - COALESCE(td0."OtherHissa", 0)) / 100))
                            ))::numeric, 0)
                BETWEEN -1 AND +1)
    ORDER BY l."LedgerName";
END;
$$;
