-- Converted from MySQL procedure `rpt_cash_report_detail`.
DROP ROUTINE IF EXISTS "rpt_cash_report_detail";
CREATE OR REPLACE FUNCTION "rpt_cash_report_detail"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date,
    varLedgerId bigint
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "VoucherType" integer,
    "VoucherId" bigint,
    "AmountType" text,
    "RemarkVoucher" text,
    "RemarkVoucherDetail" text,
    "Amount" double precision,
    "VoucherDate" date,
    "OppositeLedgerId" bigint,
    "OppositeLedgerName" text,
    "OrderFlag" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT vd."LedgerId", vd."LedgerName"::text, vd."VoucherType"::integer, vd."VoucherId"::bigint, vd."AmountType"::text
        , vd."RemarkVoucher"::text, vd."RemarkVoucherDetail"::text
        , vd."Amount"::double precision
        , vd."VoucherDate"::date AS "VoucherDate"
        , vd."OppositeLedgerId"::bigint, vd."OppositeLedgerName"::text
        , vd."OrderFlag"::integer
    FROM
    (
        SELECT vd."LedgerId", l."LedgerName", 0 AS "VoucherType", 0::bigint AS "VoucherId", 'Dr'::text AS "AmountType", 'Opening'::text AS "RemarkVoucher", 'Opening'::text AS "RemarkVoucherDetail"
            , sum(CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) AS "Amount"
            , varFromDate AS "VoucherDate"
            , 0::bigint AS "OppositeLedgerId", ''::text AS "OppositeLedgerName"
            , 0 AS "OrderFlag"
        FROM "voucher_detail" vd
        JOIN "voucher" ON voucher."VoucherId" = vd."VoucherId"
        JOIN "ledger" l ON vd."LedgerId" = l."LedgerId"
        WHERE (vd."VoucherDate" < varFromDate)
          AND vd."OrganizationId" = varOrganizationId
          AND vd."RecordStatus" != 'D'
          AND voucher."RecordStatus" != 'D'
          AND voucher."VoucherType" != 2
          AND l."GroupId" = 6
          AND (varLedgerId = 0 OR vd."LedgerId" = varLedgerId)
        GROUP BY vd."LedgerId", l."LedgerName"
        UNION ALL
        SELECT vd."LedgerId", l."LedgerName", 0 AS "VoucherType", vd."VoucherId", vd."AmountType"::text, voucher."Remark"::text AS "RemarkVoucher", vd."Remark"::text AS "RemarkVoucherDetail"
            , vd."Amount" AS "Amount"
            , vd."VoucherDate" AS "VoucherDate"
            , vd."OppositeLedgerId", o_l."LedgerName"::text AS "OppositeLedgerName"
            , 1 AS "OrderFlag"
        FROM "voucher_detail" vd
        JOIN "voucher" ON voucher."VoucherId" = vd."VoucherId"
        JOIN "ledger" l ON vd."LedgerId" = l."LedgerId"
        LEFT JOIN "ledger" o_l ON vd."OppositeLedgerId" = o_l."LedgerId"
        WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
          AND vd."OrganizationId" = varOrganizationId
          AND vd."RecordStatus" != 'D'
          AND voucher."RecordStatus" != 'D'
          AND voucher."VoucherType" != 2
          AND l."GroupId" = 6
          AND (varLedgerId = 0 OR vd."LedgerId" = varLedgerId)
    ) AS vd
    ORDER BY vd."LedgerId", vd."LedgerName", vd."OrderFlag", vd."VoucherDate", vd."VoucherId";
END;
$$;
