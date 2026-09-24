-- Converted from MySQL procedure `rpt_ledger_limit_transaction`.
DROP ROUTINE IF EXISTS "rpt_ledger_limit_transaction";
CREATE OR REPLACE FUNCTION "rpt_ledger_limit_transaction"(
    varOrganizationId bigint,
    FromDate date,
    ToDate date,
    varLedgerId bigint,
    varIsBackLimitPopup integer
)
RETURNS TABLE(
    "LedgerId" bigint,
    "VoucherDate" date,
    "Payment" double precision,
    "LimitValue" double precision
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT vd."LedgerId", vd."VoucherDate", vd."Payment", vd."LimitValue"
    FROM (
        SELECT vd."LedgerId",
               vd."VoucherDate",
               sum(CASE WHEN vd."VoucherType" = 1 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END) AS "Payment",
               sum(CASE WHEN vd."VoucherType" = 2 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END) AS "LimitValue"
        FROM "voucher_detail" AS vd
        WHERE (vd."VoucherDate" BETWEEN FromDate AND ToDate)
          /* and voucher_detail.VoucherType in (1,2) */
          AND (vd."RecordStatus" != 'D')
          AND vd."OrganizationId" = varOrganizationId
          AND (vd."LedgerId" = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
          AND vd."LedgerId" <> 6
        GROUP BY vd."LedgerId", vd."VoucherDate"
    ) AS vd
    JOIN "ledger" ledger ON ledger."LedgerId" = vd."LedgerId"
    WHERE (varIsBackLimitPopup = 1 OR ledger."HPLedgerId" = 0)
      AND vd."LimitValue" <> 0;
END;
$$;
