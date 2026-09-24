-- Converted from MySQL procedure `rpt_Trail_Balance`.
DROP ROUTINE IF EXISTS "rpt_Trail_Balance";
CREATE OR REPLACE FUNCTION "rpt_Trail_Balance"(
    varOrganizationId bigint,
    varOnDate date
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "CreditLimit" double precision,
    "Remark" text,
    "Credit" double precision,
    "Debit" double precision,
    "AmountType" text,
    "Amount" double precision
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT o."LedgerId", o."LedgerName"::text, o."CreditLimit", o."Remark"::text, o."Credit", o."Debit",
        (CASE WHEN o."Credit" > o."Debit" THEN 'Cr' ELSE CASE WHEN o."Debit" > o."Credit" THEN 'Dr' ELSE 'Dr' END END)::text
        AS "AmountType",
        (CASE
            WHEN o."Credit" > o."Debit" THEN o."Credit" - o."Debit"
            ELSE CASE
                WHEN o."Debit" > o."Credit" THEN o."Debit" - o."Credit"
                ELSE 0
            END
        END)::double precision AS "Amount"
    FROM (
        SELECT
            i."LedgerId", i."LedgerName", max(i."CreditLimit") AS "CreditLimit", max(i."Remark") AS "Remark",
            sum(i."Credit") AS "Credit", sum(i."Debit") AS "Debit", 1 AS z
        FROM (
            SELECT
                a."LedgerId", b."LedgerName", max(ledger_limit."LedgerLimit") AS "CreditLimit", max(a."Remark") AS "Remark",
                a."AmountType", sum(a."Amount") AS "Credit", 0 AS "Debit", 2 AS z
            FROM "voucher_detail" a
            JOIN "voucher" voucher ON voucher."VoucherId" = a."VoucherId"
            JOIN "ledger" b ON a."LedgerId" = b."LedgerId"
            JOIN "ledger_limit" ledger_limit ON b."LedgerId" = ledger_limit."LedgerId"
            WHERE (a."VoucherDate" <= varOnDate)
              AND a."OrganizationId" = varOrganizationId
              AND a."RecordStatus" != 'D'
              AND voucher."RecordStatus" != 'D'
              AND a."AmountType" = 'Cr'
              AND voucher."VoucherType" != 2
            GROUP BY a."LedgerId", b."LedgerName", a."Remark", a."AmountType"
            UNION ALL
            SELECT
                a."LedgerId", b."LedgerName", max(ledger_limit."LedgerLimit") AS "CreditLimit", max(a."Remark") AS "Remark",
                a."AmountType", 0 AS "Credit", sum(a."Amount") AS "Debit", 3 AS z
            FROM "voucher_detail" a
            JOIN "voucher" voucher ON voucher."VoucherId" = a."VoucherId"
            JOIN "ledger" b ON a."LedgerId" = b."LedgerId"
            JOIN "ledger_limit" ledger_limit ON b."LedgerId" = ledger_limit."LedgerId"
            WHERE (a."VoucherDate" <= varOnDate)
              AND a."OrganizationId" = varOrganizationId
              AND a."RecordStatus" != 'D'
              AND voucher."RecordStatus" != 'D'
              AND a."AmountType" = 'Dr'
              AND voucher."VoucherType" != 2
            GROUP BY a."LedgerId", b."LedgerName", a."Remark", a."AmountType"
        ) i
        GROUP BY i."LedgerName", i."LedgerId"
    ) o
    WHERE o."Debit" - o."Credit" <> 0
    ORDER BY o."LedgerName";
END;
$$;
