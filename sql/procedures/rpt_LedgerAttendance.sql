-- Converted from MySQL procedure `rpt_LedgerAttendance`.
DROP ROUTINE IF EXISTS "rpt_LedgerAttendance";
CREATE OR REPLACE FUNCTION "rpt_LedgerAttendance"(
    FromDate date,
    ToDate date,
    varLedgerId bigint
)
RETURNS TABLE("LedgerId" bigint, "VoucherDate" date, "IsPresent" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT
        vd."LedgerId"
        , vd."VoucherDate"
        , max(CASE WHEN vd."ShiftId" > 0 THEN 1 ELSE 0 END) AS "IsPresent"
    FROM "voucher_detail" AS vd
    WHERE (vd."VoucherDate" BETWEEN FromDate AND ToDate)
      AND (vd."RecordStatus" != 'D')
      AND (vd."LedgerId" = COALESCE(varLedgerId, 0) OR COALESCE(varLedgerId, 0) = 0)
    GROUP BY vd."VoucherDate", vd."LedgerId";
END;
$$;
