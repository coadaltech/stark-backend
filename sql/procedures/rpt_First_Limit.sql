-- Converted from MySQL procedure `rpt_First_Limit`.
-- NOTE: the MySQL source did `voucher_detail.* UNION ALL voucher_detail_dump.*`, but the two tables
-- have different column counts (voucher_detail has VerifyBy/VerifyDate), which would fail at runtime.
-- Only the columns used by the outer query (VoucherDate, LedgerId, Amount) are selected here.
-- MySQL `GROUP BY LedgerId` with non-aggregated AA.Amount -> any_value(); ledger/ledger_limit
-- columns are made functionally dependent by grouping on their PKs (equal to AA.LedgerId).
DROP ROUTINE IF EXISTS "rpt_First_Limit";
CREATE OR REPLACE FUNCTION "rpt_First_Limit"(
    varOrganizationId bigint,
    varLedgerId bigint
)
RETURNS TABLE(
    "VoucherDate" date,
    "LedgerId" bigint,
    "Amount" double precision,
    "LedgerName" text,
    "LedgerBalance" double precision,
    "LedgerLimit" double precision,
    "FinalLimit" double precision
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT min(aa."VoucherDate") AS "VoucherDate", aa."LedgerId", any_value(aa."Amount") AS "Amount"
         , ledger."LedgerName"::text
         , ledger_limit."LedgerBalance"
         , ledger_limit."LedgerLimit"
         , ledger_limit."FinalLimit"
    FROM
    (
        SELECT vd."VoucherDate", vd."LedgerId", vd."Amount" FROM "voucher_detail" vd
        JOIN (
            SELECT min(vd2."VoucherId") AS "VoucherId", vd2."LedgerId"
            FROM "voucher_detail" vd2
            JOIN (
                SELECT min(vd3."VoucherDate") AS "VoucherDate", vd3."LedgerId"
                FROM "voucher_detail" vd3
                WHERE vd3."OrganizationId" = varOrganizationId
                  AND vd3."VoucherType" = 2
                  AND vd3."RecordStatus" != 'D'
                  AND vd3."VoucherId" <> -2
                GROUP BY vd3."LedgerId"
            ) vddate
              ON vddate."VoucherDate" = vd2."VoucherDate"
             AND vddate."LedgerId" = vd2."LedgerId"
             AND vd2."RecordStatus" != 'D'
             AND vd2."VoucherId" <> -2
            GROUP BY vd2."LedgerId"
        ) vddate ON vddate."VoucherId" = vd."VoucherId"

        UNION ALL

        SELECT vdd."VoucherDate", vdd."LedgerId", vdd."Amount" FROM "voucher_detail_dump" vdd
        JOIN (
            SELECT min(vdd2."VoucherId") AS "VoucherId", vdd2."LedgerId"
            FROM "voucher_detail_dump" vdd2
            JOIN (
                SELECT min(vdd3."VoucherDate") AS "VoucherDate", vdd3."LedgerId"
                FROM "voucher_detail_dump" vdd3
                WHERE vdd3."OrganizationId" = varOrganizationId
                  AND vdd3."VoucherType" = 2
                  AND vdd3."RecordStatus" != 'D'
                  AND vdd3."VoucherId" <> -2
                GROUP BY vdd3."LedgerId"
            ) vddate
              ON vddate."VoucherDate" = vdd2."VoucherDate"
             AND vddate."LedgerId" = vdd2."LedgerId"
             AND vdd2."RecordStatus" != 'D'
             AND vdd2."VoucherId" <> -2
            GROUP BY vdd2."LedgerId"
        ) vddate ON vddate."VoucherId" = vdd."VoucherId"
    ) AS aa
    JOIN "ledger" ledger ON ledger."LedgerId" = aa."LedgerId"
    JOIN "ledger_limit" ledger_limit ON ledger_limit."LedgerId" = aa."LedgerId"
    GROUP BY aa."LedgerId", ledger."LedgerId", ledger_limit."LedgerId";
END;
$$;
