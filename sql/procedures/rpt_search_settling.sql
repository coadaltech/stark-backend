-- Converted from MySQL procedure `rpt_search_settling`.
-- Note: the outer query selected non-grouped vd.* columns in TodayProfit (MySQL any value);
-- each group has exactly one vd row (single ledger, one vd row per VoucherDate) -> any_value().
DROP ROUTINE IF EXISTS "rpt_search_settling";
CREATE OR REPLACE FUNCTION "rpt_search_settling"(varOrganizationId bigint, FromDate date, ToDate date, varLedgerId bigint)
RETURNS TABLE(
    "VoucherDate" date, "TotalSale" numeric, "DaraSale" numeric, "BaharKaAkharSale" numeric, "AnderKaAkharSale" numeric,
    "TotalCommission" numeric, "TotalProfit" numeric, "DaraOpen" numeric, "BaharKaAkharOpen" numeric, "AnderKaAkharOpen" numeric,
    "DaraOpenProfit" numeric, "BaharKaAkharOpenProfit" numeric, "AnderKaAkharOpenProfit" numeric, "TPC" numeric, "Hissa" numeric,
    "OpeningBalance" double precision, "Kist" double precision, "Payment" double precision, "VapsiAmount" double precision,
    "HPAmount" double precision, "MondayFinal" integer, "TodayProfit" numeric)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT COALESCE(vd."VoucherDate", FromDate) AS "VoucherDate",
           COALESCE(sum(vd."TotalSale"), 0) AS "TotalSale",
           COALESCE(sum(vd."DaraSale"), 0) AS "DaraSale",
           COALESCE(sum(vd."BaharKaAkharSale"), 0) AS "BaharKaAkharSale",
           COALESCE(sum(vd."AnderKaAkharSale"), 0) AS "AnderKaAkharSale",
           COALESCE(sum(vd."TotalCommission"), 0) AS "TotalCommission",

           COALESCE(sum(vd."TotalProfit"), 0) AS "TotalProfit",

           COALESCE(sum(vd."DaraOpen"), 0) AS "DaraOpen",
           COALESCE(sum(vd."BaharKaAkharOpen"), 0) AS "BaharKaAkharOpen",
           COALESCE(sum(vd."AnderKaAkharOpen"), 0) AS "AnderKaAkharOpen",

           COALESCE(sum(vd."DaraOpenProfit"), 0) AS "DaraOpenProfit",
           COALESCE(sum(vd."BaharKaAkharOpenProfit"), 0) AS "BaharKaAkharOpenProfit",
           COALESCE(sum(vd."AnderKaAkharOpenProfit"), 0) AS "AnderKaAkharOpenProfit",
           COALESCE(sum(vd."TPC"), 0) AS "TPC",
           COALESCE(sum(vd."Hissa"), 0) AS "Hissa",
           COALESCE(OPBal."opening", 0) AS "OpeningBalance",
           COALESCE(sum(vd."Kist"), 0) AS "Kist",
           COALESCE(sum(vd."Payment"), 0) AS "Payment",
           COALESCE(sum(vd."VapsiAmount"), 0) AS "VapsiAmount",
           COALESCE(sum(vd."HPAmount"), 0) AS "HPAmount",
           COALESCE(max(vd."MondayFinal"), 2) AS "MondayFinal",
           COALESCE(any_value(vd."TotalSale"), 0)
             + COALESCE(any_value(vd."TotalCommission"), 0)
             + COALESCE(any_value(vd."TotalProfit"), 0)
             + COALESCE(any_value(vd."Hissa"), 0)
             + COALESCE(any_value(vd."TPC"), 0) AS "TodayProfit"
    FROM (SELECT led."LedgerId" FROM "ledger" led WHERE led."LedgerId" = varLedgerId) AS l
    LEFT JOIN (
        SELECT
            sum(CASE WHEN x."VoucherType" = 22 OR x."VoucherType" = 23 OR x."VoucherType" = 24 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END)::numeric(16,2) AS "TotalSale",
            sum(CASE WHEN x."VoucherType" = 22 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END)::numeric(16,2) AS "DaraSale",
            sum(CASE WHEN x."VoucherType" = 23 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END)::numeric(16,2) AS "BaharKaAkharSale",
            sum(CASE WHEN x."VoucherType" = 24 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END)::numeric(16,2) AS "AnderKaAkharSale",
            sum(CASE WHEN x."VoucherType" = 25 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END)::numeric(16,2) AS "TotalCommission",
            sum(CASE WHEN x."VoucherType" = 26 OR x."VoucherType" = 27 OR x."VoucherType" = 28 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END)::numeric(16,2) AS "TotalProfit",

            sum(CASE WHEN x."VoucherType" = 26 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END)::numeric(16,2) AS "DaraOpenProfit",
            sum(CASE WHEN x."VoucherType" = 27 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END)::numeric(16,2) AS "BaharKaAkharOpenProfit",
            sum(CASE WHEN x."VoucherType" = 28 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END)::numeric(16,2) AS "AnderKaAkharOpenProfit",

            sum(CASE WHEN x."VoucherType" = 26 THEN CASE WHEN x."AmountType" = 'Dr' THEN -x."OpenAmount" ELSE x."OpenAmount" END ELSE 0 END)::numeric(16,2) AS "DaraOpen",
            sum(CASE WHEN x."VoucherType" = 27 THEN CASE WHEN x."AmountType" = 'Dr' THEN -x."OpenAmount" ELSE x."OpenAmount" END ELSE 0 END)::numeric(16,2) AS "BaharKaAkharOpen",
            sum(CASE WHEN x."VoucherType" = 28 THEN CASE WHEN x."AmountType" = 'Dr' THEN -x."OpenAmount" ELSE x."OpenAmount" END ELSE 0 END)::numeric(16,2) AS "AnderKaAkharOpen",

            sum(CASE WHEN x."VoucherType" = 32 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END)::numeric(16,2) AS "TPC",

            sum(CASE WHEN x."VoucherType" = 29 OR x."VoucherType" = 30 OR x."VoucherType" = 31 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END)::numeric(16,2) AS "Hissa",

            sum(CASE WHEN x."VoucherType" = 3 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END) AS "Kist",
            sum(CASE WHEN x."VoucherType" = 1 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END) AS "Payment",

            sum(CASE WHEN x."VoucherType" = 4 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END) AS "VapsiAmount",
            sum(CASE WHEN x."VoucherType" = 5 THEN CASE WHEN x."AmountType" = 'Dr' THEN x."Amount" ELSE -x."Amount" END ELSE 0 END) AS "HPAmount",

            x."VoucherDate", x."LedgerId",
            max(CASE WHEN x."MondayFinalFlag" = 'True' THEN 0 ELSE 1 END) AS "MondayFinal"
        FROM "voucher_detail" x
        WHERE x."LedgerId" = varLedgerId
          AND x."VoucherType" != 2
          AND x."OrganizationId" = varOrganizationId
          AND (x."VoucherDate" BETWEEN FromDate AND ToDate)
          AND (x."RecordStatus" != 'D')
        GROUP BY x."VoucherDate", x."LedgerId"
    ) AS vd ON vd."LedgerId" = l."LedgerId"
    LEFT JOIN (SELECT aa."LedgerId",
                      sum((CASE WHEN aa."AmountType" = 'Dr' THEN COALESCE(aa."Amount", 0) ELSE -COALESCE(aa."Amount", 0) END)) AS "opening"
               FROM "voucher_detail" aa
               WHERE aa."VoucherDate" < FromDate
                 AND aa."OrganizationId" = varOrganizationId
                 AND aa."VoucherType" != 2
                 AND aa."RecordStatus" != 'D'
               GROUP BY aa."LedgerId") AS OPBal ON OPBal."LedgerId" = l."LedgerId"
    /*
    and l.LedgerId = varLedgerId
    and l.GroupId in (1,2)
    */
    GROUP BY vd."VoucherDate", OPBal."opening"
    ORDER BY vd."VoucherDate";
END;
$$;
