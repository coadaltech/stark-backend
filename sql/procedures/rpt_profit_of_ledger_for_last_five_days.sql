-- Converted from MySQL procedure `rpt_profit_of_ledger_for_last_five_days`.
DROP ROUTINE IF EXISTS "rpt_profit_of_ledger_for_last_five_days";
CREATE OR REPLACE FUNCTION "rpt_profit_of_ledger_for_last_five_days"(varOrganizationId bigint, varLedgerId bigint, varFromDate date, varToDate date, varShiftId bigint)
RETURNS TABLE(
    "VoucherDate" date,
    "TodayProfit" numeric
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT vd."VoucherDate",
           round(COALESCE(vd."TotalSale", 0)
               + COALESCE(vd."TotalCommission", 0)
               + COALESCE(vd."TotalProfit", 0)
               + COALESCE(vd."Hissa", 0)
               + COALESCE(vd."TPC", 0), 0) AS "TodayProfit"
    FROM (SELECT d."VoucherDate",
                 round(sum(CASE WHEN d."VoucherType" = 22 OR d."VoucherType" = 23 OR d."VoucherType" = 24 THEN CASE WHEN d."AmountType" = 'Dr' THEN d."Amount" ELSE -d."Amount" END ELSE 0 END)::numeric, 2) AS "TotalSale",
                 round(sum(CASE WHEN d."VoucherType" = 25 THEN CASE WHEN d."AmountType" = 'Dr' THEN d."Amount" ELSE -d."Amount" END ELSE 0 END)::numeric, 2) AS "TotalCommission",
                 round(sum(CASE WHEN d."VoucherType" = 26 OR d."VoucherType" = 27 OR d."VoucherType" = 28 THEN CASE WHEN d."AmountType" = 'Dr' THEN d."Amount" ELSE -d."Amount" END ELSE 0 END)::numeric, 2) AS "TotalProfit",
                 round(sum(CASE WHEN d."VoucherType" = 32 THEN CASE WHEN d."AmountType" = 'Dr' THEN d."Amount" ELSE -d."Amount" END ELSE 0 END)::numeric, 2) AS "TPC",
                 round(sum(CASE WHEN d."VoucherType" = 29 OR d."VoucherType" = 30 OR d."VoucherType" = 31 THEN CASE WHEN d."AmountType" = 'Dr' THEN d."Amount" ELSE -d."Amount" END ELSE 0 END)::numeric, 2) AS "Hissa"
          FROM "voucher_detail" AS d
          JOIN (SELECT lg."LedgerId", lg."ParentLedgerId" FROM "ledger" lg
                WHERE lg."LedgerId" = varLedgerId
               ) AS ledger ON d."LedgerId" = ledger."LedgerId" OR d."LedgerId" = ledger."ParentLedgerId"
          WHERE (d."VoucherDate" BETWEEN varFromDate AND varToDate)
            AND (d."RecordStatus" != 'D')
            AND d."ShiftId" = varShiftId
            AND (d."LedgerId" = varLedgerId OR ledger."ParentLedgerId" = varLedgerId)
          GROUP BY d."VoucherDate"
         ) AS vd
    WHERE COALESCE(vd."TotalSale", 0)
        + COALESCE(vd."TotalCommission", 0)
        + COALESCE(vd."TotalProfit", 0)
        + COALESCE(vd."Hissa", 0)
        + COALESCE(vd."TPC", 0) < 0;
END;
$$;
