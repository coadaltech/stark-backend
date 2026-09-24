-- Converted from MySQL procedure `rpt_custom_voucher_detail`.
DROP ROUTINE IF EXISTS "rpt_custom_voucher_detail";
CREATE OR REPLACE FUNCTION "rpt_custom_voucher_detail"(LedgerIds bigint, FromToDate date)
RETURNS TABLE(
    "VoucherDetailId" bigint,
    "VoucherId" bigint,
    "LedgerId" bigint,
    "OppositeLedgerName" text,
    "Remark" text,
    "MondayFinalFlag" text,
    "VoucherDate" date,
    "VoucherType" integer,
    "Amount" double precision,
    "AmountType" text,
    "OppositeLedgerId" bigint,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT a."VoucherDetailId", a."VoucherId", a."LedgerId", l."LedgerName"::text AS "OppositeLedgerName",
           a."Remark"::text, a."MondayFinalFlag"::text,
           a."VoucherDate", a."VoucherType", a."Amount", a."AmountType"::text,
           a."OppositeLedgerId", a."AddedBy"::text, a."AddedDate", a."UpdatedBy"::text, a."UpdatedDate"
    FROM "voucher_detail" a
    JOIN "ledger" l ON a."OppositeLedgerId" = l."LedgerId"
    WHERE (a."RecordStatus" != 'D')
      AND (LedgerIds IS NULL OR a."LedgerId" = LedgerIds)
      AND (a."VoucherDate" = FromToDate)
      AND (a."VoucherType" IN (1, 3, 4))
    ORDER BY a."AddedDate" DESC;
END;
$$;
