-- Converted from MySQL procedure `rpt_cash_report`.
DROP ROUTINE IF EXISTS "rpt_cash_report";
CREATE OR REPLACE FUNCTION "rpt_cash_report"(varOrganizationId bigint, varFromDate date, varToDate date)
RETURNS TABLE("LedgerId" bigint, "LedgerName" text, "Opening" numeric, "Amount" numeric, "Closing" numeric)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT vd."LedgerId", l."LedgerName"::text,
           round(sum(CASE WHEN vd."VoucherDate" < varFromDate THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric) AS "Opening",
           round(sum(CASE WHEN vd."VoucherDate" BETWEEN varFromDate AND varToDate THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric) AS "Amount",
           round(sum(CASE WHEN vd."VoucherDate" <= varToDate THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END)::numeric) AS "Closing"
    FROM "voucher_detail" vd
    JOIN "voucher" v ON v."VoucherId" = vd."VoucherId"
    JOIN "ledger" l ON vd."LedgerId" = l."LedgerId"
    WHERE (vd."VoucherDate" <= varToDate)
      AND vd."OrganizationId" = varOrganizationId
      AND vd."RecordStatus" != 'D'
      AND v."RecordStatus" != 'D'
      AND v."VoucherType" != 2
      AND l."GroupId" = 6
    GROUP BY vd."LedgerId", l."LedgerName"
    HAVING NOT (
            sum(CASE WHEN vd."VoucherDate" < varFromDate THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END) BETWEEN -1 AND 1
        AND sum(CASE WHEN vd."VoucherDate" BETWEEN varFromDate AND varToDate THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END) BETWEEN -1 AND 1
        AND sum(CASE WHEN vd."VoucherDate" <= varToDate THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END) BETWEEN -1 AND 1
    )
    ORDER BY l."LedgerName";
END;
$$;
