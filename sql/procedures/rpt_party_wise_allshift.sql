-- Converted from MySQL procedure `rpt_party_wise_allshift`.
-- vd.SelfHissa is not grouped in MySQL -> any_value(). PG does not allow ORDER BY on a
-- non-selected column with SELECT DISTINCT, so the DISTINCT query is wrapped and ordered
-- by shift.ShiftOrder / shift.ShiftName carried through as hidden columns.
DROP ROUTINE IF EXISTS "rpt_party_wise_allshift";
CREATE OR REPLACE FUNCTION "rpt_party_wise_allshift"(
    varOrganizationId bigint,
    FromDate date,
    ToDate date,
    varPartyId bigint
)
RETURNS TABLE(
    "ShiftId" bigint,
    "ShiftName" text,
    "TotalSale" numeric,
    "DaraSale" numeric,
    "BaharKaAkharSale" numeric,
    "AnderKaAkharSale" numeric,
    "TotalCommission" numeric,
    "TotalProfit" numeric,
    "DaraOpenProfit" numeric,
    "BaharKaAkharOpenProfit" numeric,
    "AnderKaAkharOpenProfit" numeric,
    "DaraOpen" numeric,
    "BaharKaAkharOpen" numeric,
    "AnderKaAkharOpen" numeric,
    "TPC" numeric,
    "Hissa" numeric,
    "Balance" numeric,
    "Remark" text,
    "SelfHissa" double precision
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT x."ShiftId", x."ShiftName", x."TotalSale", x."DaraSale", x."BaharKaAkharSale", x."AnderKaAkharSale",
           x."TotalCommission", x."TotalProfit", x."DaraOpenProfit", x."BaharKaAkharOpenProfit", x."AnderKaAkharOpenProfit",
           x."DaraOpen", x."BaharKaAkharOpen", x."AnderKaAkharOpen", x."TPC", x."Hissa", x."Balance",
           x."Remark", x."SelfHissa"
    FROM (
        SELECT DISTINCT v."ShiftId"
            , (shift."ShiftName"::text || COALESCE((SELECT ' { K-' || max(dr."DeclareNumber")::text || ' }'
                                                    FROM "declare_result" dr
                                                    WHERE dr."ShiftId" = v."ShiftId"
                                                      AND dr."DeclareDate" = FromDate
                                                      AND dr."DeclareDate" = ToDate), '')) AS "ShiftName"
            , (sum(CASE WHEN vd."VoucherType" = 22 OR vd."VoucherType" = 23 OR vd."VoucherType" = 24 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "TotalSale"
            , (sum(CASE WHEN vd."VoucherType" = 22 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "DaraSale"
            , (sum(CASE WHEN vd."VoucherType" = 23 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "BaharKaAkharSale"
            , (sum(CASE WHEN vd."VoucherType" = 24 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "AnderKaAkharSale"
            , (sum(CASE WHEN vd."VoucherType" = 25 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "TotalCommission"
            , (sum(CASE WHEN vd."VoucherType" = 26 OR vd."VoucherType" = 27 OR vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "TotalProfit"
            , (sum(CASE WHEN vd."VoucherType" = 26 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "DaraOpenProfit"
            , (sum(CASE WHEN vd."VoucherType" = 27 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpenProfit"
            , (sum(CASE WHEN vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpenProfit"
            , (sum(CASE WHEN vd."VoucherType" = 26 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END))::numeric(16,2) AS "DaraOpen"
            , (sum(CASE WHEN vd."VoucherType" = 27 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpen"
            , (sum(CASE WHEN vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpen"
            , (sum(CASE WHEN vd."VoucherType" = 32 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "TPC"
            , (sum(CASE WHEN vd."VoucherType" = 29 OR vd."VoucherType" = 30 OR vd."VoucherType" = 31 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "Hissa"
            , (sum(CASE WHEN vd."VoucherType" IN (22,23,24,25,26,27,28,29,30,31,32) THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "Balance"
            , vd."Remark"::text AS "Remark"
            , any_value(vd."SelfHissa") AS "SelfHissa"
            , any_value(shift."ShiftOrder") AS ord_shift_order
            , shift."ShiftName" AS ord_shift_name
        FROM "voucher_detail" vd
        JOIN "voucher" v ON v."VoucherId" = vd."VoucherId"
        JOIN "shift" shift ON shift."ShiftId" = v."ShiftId"
        WHERE vd."VoucherDate" BETWEEN FromDate AND ToDate
          AND vd."OrganizationId" = varOrganizationId
          AND (vd."RecordStatus" != 'D')
          AND (vd."LedgerId" = varPartyId OR COALESCE(varPartyId, 0) = 0)
        GROUP BY v."ShiftId", shift."ShiftName", vd."Remark"
    ) x
    ORDER BY x.ord_shift_order, x.ord_shift_name;
END;
$$;
