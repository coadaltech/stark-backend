-- Converted from MySQL procedure `rpt_profit_loss`.
-- Note: MySQL used SELECT DISTINCT ... GROUP BY v.ShiftId; DISTINCT is a no-op there (one row per
-- ShiftId) and PG forbids ORDER BY on a non-selected column with DISTINCT, so it is dropped.
DROP ROUTINE IF EXISTS "rpt_profit_loss";
CREATE OR REPLACE FUNCTION "rpt_profit_loss"(varOrganizationId bigint, varFromDate date, varToDate date, varParentId bigint)
RETURNS TABLE("ShiftId" bigint, "ShiftTypeName" text,
              "TotalSale" numeric, "DaraSale" numeric, "BaharKaAkharSale" numeric, "AnderKaAkharSale" numeric,
              "TotalCommission" numeric, "TotalProfit" numeric, "DaraOpenProfit" numeric, "BaharKaAkharOpenProfit" numeric,
              "AnderKaAkharOpenProfit" numeric, "DaraOpen" numeric, "BaharKaAkharOpen" numeric, "AnderKaAkharOpen" numeric,
              "TPC" numeric, "Hissa" numeric, "Balance" numeric)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT v."ShiftId",
           (s."ShiftName"::text || COALESCE((SELECT ' { K-' || max(dr."DeclareNumber")::text || ' }'
                                             FROM "declare_result" dr
                                             WHERE dr."ShiftId" = v."ShiftId" AND dr."DeclareDate" = varFromDate AND dr."DeclareDate" = varToDate), ''))
               AS "ShiftTypeName",
           sum(CASE WHEN vd."VoucherType" = 22 OR vd."VoucherType" = 23 OR vd."VoucherType" = 24 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "TotalSale",
           sum(CASE WHEN vd."VoucherType" = 22 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "DaraSale",
           sum(CASE WHEN vd."VoucherType" = 23 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "BaharKaAkharSale",
           sum(CASE WHEN vd."VoucherType" = 24 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "AnderKaAkharSale",
           sum(CASE WHEN vd."VoucherType" = 25 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "TotalCommission",
           sum(CASE WHEN vd."VoucherType" = 26 OR vd."VoucherType" = 27 OR vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "TotalProfit",
           sum(CASE WHEN vd."VoucherType" = 26 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "DaraOpenProfit",
           sum(CASE WHEN vd."VoucherType" = 27 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "BaharKaAkharOpenProfit",
           sum(CASE WHEN vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "AnderKaAkharOpenProfit",

           sum(CASE WHEN vd."VoucherType" = 26 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END)::numeric(16,2) AS "DaraOpen",
           sum(CASE WHEN vd."VoucherType" = 27 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END)::numeric(16,2) AS "BaharKaAkharOpen",
           sum(CASE WHEN vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END)::numeric(16,2) AS "AnderKaAkharOpen",

           sum(CASE WHEN vd."VoucherType" = 32 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "TPC",

           sum(CASE WHEN vd."VoucherType" = 29 OR vd."VoucherType" = 30 OR vd."VoucherType" = 31 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "Hissa",
           sum(CASE WHEN vd."VoucherType" IN (22,23,24,25,26,27,28,29,30,31,32,35) THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric(16,2) AS "Balance"
    FROM "voucher_detail" vd
    JOIN "voucher" v ON vd."VoucherId" = v."VoucherId"
    JOIN "shift" s ON s."ShiftId" = v."ShiftId"
    JOIN "ledger" l ON vd."LedgerId" = l."LedgerId"
    WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
      AND vd."OrganizationId" = varOrganizationId
      AND (l."OrganizationId" = varOrganizationId OR COALESCE(l."OrganizationId", 0) = 0)
      AND (vd."RecordStatus" != 'D')
      AND l."GroupId" IN (2,3,4,5)
      AND (COALESCE(varParentId, 0) = 0 OR l."LedgerId" = varParentId OR l."ParentLedgerId" = varParentId
           OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varParentId))
    GROUP BY v."ShiftId", s."ShiftName", s."ShiftOrder"
    ORDER BY s."ShiftOrder";
END;
$$;
