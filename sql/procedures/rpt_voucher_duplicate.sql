-- Converted from MySQL procedure `rpt_voucher_duplicate`.
-- Inner GROUP BY: non-grouped VoucherId -> any_value(). Outer MySQL GROUP BY
-- (VoucherId, VoucherType, VoucherDate, Amount) with non-aggregated columns -> DISTINCT ON
-- over the same keys (one arbitrary row per group, ordered like MySQL 5.x implicit GROUP BY sort).
DROP ROUTINE IF EXISTS "rpt_voucher_duplicate";
CREATE OR REPLACE FUNCTION "rpt_voucher_duplicate"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date,
    varVoucherType integer
)
RETURNS TABLE(
    "VoucherId" bigint,
    "LedgerId" bigint,
    "LedgerName" text,
    "OppositeLedgerName" text,
    "OppositeLedgerId" bigint,
    "VoucherType" integer,
    "VoucherDate" date,
    "Amount" double precision,
    "AmountType" text,
    "DuplicateCount" bigint
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT DISTINCT ON (voucher_detail."VoucherId", voucher_detail."VoucherType", voucher_detail."VoucherDate", voucher_detail."Amount")
           voucher_detail."VoucherId",
           voucher_detail."LedgerId",
           l."LedgerName"::text,
           opposite."LedgerName"::text AS "OppositeLedgerName",
           voucher_detail."OppositeLedgerId",
           voucher_detail."VoucherType",
           voucher_detail."VoucherDate",
           voucher_detail."Amount",
           voucher_detail."AmountType"::text,
           voucher_detail."DuplicateCount"
    FROM (SELECT any_value(vd."VoucherId") AS "VoucherId",
                 vd."LedgerId",
                 vd."OppositeLedgerId",
                 vd."VoucherType",
                 vd."VoucherDate",
                 vd."Amount",
                 vd."AmountType",
                 count(1) AS "DuplicateCount"
          FROM "voucher_detail" vd
          WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
            AND vd."RecordStatus" != 'D'
            AND (vd."VoucherType" = varVoucherType OR COALESCE(varVoucherType, 0) = 0)
            AND vd."OrganizationId" = varOrganizationId
          GROUP BY vd."LedgerId", vd."OppositeLedgerId", vd."VoucherType", vd."VoucherDate", vd."Amount", vd."AmountType"
          HAVING count(1) > 1
         ) AS voucher_detail
    LEFT JOIN "ledger" l ON voucher_detail."LedgerId" = l."LedgerId"
    LEFT JOIN "ledger" opposite ON voucher_detail."OppositeLedgerId" = opposite."LedgerId"
    ORDER BY voucher_detail."VoucherId", voucher_detail."VoucherType", voucher_detail."VoucherDate", voucher_detail."Amount";
END;
$$;
