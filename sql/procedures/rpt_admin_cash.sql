-- Converted from MySQL procedure `rpt_admin_cash`.
-- Second UNION branch groups by (shift-or-voucher, VoucherDate, ShiftId); columns MySQL left
-- non-aggregated are wrapped in any_value().
DROP ROUTINE IF EXISTS "rpt_admin_cash";
CREATE OR REPLACE FUNCTION "rpt_admin_cash"(
    varOrganizationId bigint,
    varLedgerId integer,
    varFromDate date,
    varToDate date
)
RETURNS TABLE(
    "LedgerName" text,
    "Amount" double precision,
    "AmountType" text,
    "OppositeLedgerId" bigint,
    "Remark" text,
    "VoucherRemark" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp,
    "VoucherDate" date,
    "VoucherType" integer,
    "ShiftId" bigint,
    "VoucherId" bigint
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT 'OPENING'::text AS "LedgerName"
         , COALESCE(sum(CASE WHEN voucher_detail."AmountType" = 'Cr' THEN voucher_detail."Amount" ELSE -voucher_detail."Amount" END), 0) AS "Amount"
         , 'Cr'::text AS "AmountType"
         , 0::bigint AS "OppositeLedgerId"
         , ''::text AS "Remark"
         , ''::text AS "VoucherRemark"
         , ''::text AS "AddedBy"
         , varFromDate::timestamp AS "AddedDate"
         , ''::text AS "UpdatedBy"
         , varFromDate::timestamp AS "UpdatedDate"
         , varFromDate AS "VoucherDate"
         , 0 AS "VoucherType"
         , 0::bigint AS "ShiftId"
         , (-1000)::bigint AS "VoucherId"
    FROM "voucher_detail" voucher_detail
    LEFT JOIN "voucher" voucher ON voucher."VoucherId" = voucher_detail."VoucherId"
    LEFT JOIN "ledger" ledger ON ledger."LedgerId" = voucher_detail."OppositeLedgerId"
    WHERE voucher."VoucherDate" < varFromDate
      AND voucher_detail."OrganizationId" = varOrganizationId
      AND voucher_detail."RecordStatus" != 'D'
      AND voucher."RecordStatus" != 'D'
      AND voucher_detail."LedgerId" = varLedgerId
      AND voucher."VoucherType" != 2
    UNION ALL
    SELECT (CASE WHEN COALESCE(voucher."ShiftId", 0) != 0
                 THEN (SELECT s."ShiftName" FROM "shift" s WHERE s."ShiftId" = voucher."ShiftId")
                 ELSE (SELECT lg."LedgerName" FROM "ledger" lg WHERE lg."LedgerId" = any_value(voucher_detail."OppositeLedgerId"))
            END)::text AS "LedgerName"
         , COALESCE(sum(CASE WHEN voucher_detail."AmountType" = 'Cr' THEN voucher_detail."Amount" ELSE -voucher_detail."Amount" END), 0) AS "Amount"
         , 'Cr'::text AS "AmountType"
         , (CASE WHEN COALESCE(voucher."ShiftId", 0) != 0 THEN 0 ELSE any_value(voucher_detail."OppositeLedgerId") END)::bigint AS "OppositeLedgerId"
         , (CASE WHEN COALESCE(voucher."ShiftId", 0) != 0 THEN '' ELSE any_value(voucher_detail."Remark") END)::text AS "Remark"
         , (CASE WHEN COALESCE(voucher."ShiftId", 0) != 0 THEN '' ELSE any_value(voucher."Remark") END)::text AS "VoucherRemark"
         , (CASE WHEN COALESCE(voucher."ShiftId", 0) != 0 THEN '' ELSE any_value(voucher."AddedBy") END)::text AS "AddedBy"
         , (CASE WHEN COALESCE(voucher."ShiftId", 0) != 0 THEN NULL ELSE any_value(voucher."AddedDate") END)::timestamp AS "AddedDate"
         , (CASE WHEN COALESCE(voucher."ShiftId", 0) != 0 THEN max(voucher."UpdatedBy") ELSE any_value(voucher."UpdatedBy") END)::text AS "UpdatedBy"
         , (CASE WHEN COALESCE(voucher."ShiftId", 0) != 0 THEN max(voucher."UpdatedDate") ELSE any_value(voucher."UpdatedDate") END)::timestamp AS "UpdatedDate"
         , voucher."VoucherDate"
         , any_value(voucher."VoucherType")::integer AS "VoucherType"
         , voucher."ShiftId"
         , (CASE WHEN COALESCE(voucher."ShiftId", 0) != 0 THEN 0 ELSE voucher."VoucherId" END)::bigint AS "VoucherId"
    FROM "voucher_detail" voucher_detail
    LEFT JOIN "voucher" voucher ON voucher."VoucherId" = voucher_detail."VoucherId"
    WHERE voucher."VoucherDate" BETWEEN varFromDate AND varToDate
      AND voucher_detail."OrganizationId" = varOrganizationId
      AND voucher."RecordStatus" != 'D'
      AND voucher_detail."RecordStatus" != 'D'
      AND voucher_detail."LedgerId" = varLedgerId
      AND voucher."VoucherType" != 2
    GROUP BY (CASE WHEN COALESCE(voucher."ShiftId", 0) != 0 THEN 0 ELSE voucher."VoucherId" END), voucher."VoucherDate", voucher."ShiftId"
    ORDER BY 11 /* VoucherDate */, 14 /* VoucherId */, 8 /* AddedDate */;
END;
$$;
