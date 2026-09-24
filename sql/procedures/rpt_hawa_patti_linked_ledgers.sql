-- Converted from MySQL procedure `rpt_hawa_patti_linked_ledgers`.
-- NOTE: the MySQL select list contained `ledger.AddedBy` twice (same value); PG RETURNS TABLE cannot
-- have duplicate column names, so the second (identical) AddedBy column is omitted.
DROP ROUTINE IF EXISTS "rpt_hawa_patti_linked_ledgers";
CREATE OR REPLACE FUNCTION "rpt_hawa_patti_linked_ledgers"(
    varOrganizationId bigint,
    varLedgerId bigint,
    varToDate date
)
RETURNS TABLE(
    "LedgerId" bigint,
    "OrganizationId" bigint,
    "ParentLedgerId" bigint,
    "LedgerName" text,
    "GroupId" integer,
    "RecordStatus" text,
    "AddedBy" text,
    "Mobile" text,
    "UserName" text,
    "LedgerBalance" double precision,
    "Amount" numeric,
    "AmountType" text,
    "OppositeLedgerId" integer,
    "Remark" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp,
    "IsSettDone" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT ledger."LedgerId",
        ledger."OrganizationId",
        ledger."ParentLedgerId",
        ledger."LedgerName"::text,
        ledger."GroupId",
        ledger."RecordStatus"::text
        , ledger."AddedBy"::text
        , COALESCE(login."Mobile", 'NA')::text AS "Mobile"
        , COALESCE(login."UserName", 'NA')::text AS "UserName"
        , ledger_limit."LedgerBalance"
        , voucher_detail."Closing" AS "Amount"
        , 'Cr'::text AS "AmountType"
        , 0 AS "OppositeLedgerId"
        , ''::text AS "Remark"
        -- , ledger.AddedBy  (duplicate column in MySQL, omitted)
        , ledger."AddedDate"
        , ledger."UpdatedBy"::text
        , ledger."UpdatedDate"
        , (CASE WHEN COALESCE(sett."SettLedgerId", 0) <> 0 THEN 1 ELSE 0 END) AS "IsSettDone"
    FROM "ledger"
    LEFT JOIN (SELECT (sum(CASE WHEN vd."AmountType" = 'Cr' THEN vd."Amount" ELSE -vd."Amount" END))::numeric(16,2) AS "Closing", vd."LedgerId"
               FROM "voucher_detail" vd
               WHERE vd."OrganizationId" = varOrganizationId
                 AND vd."RecordStatus" != 'D'
                 AND vd."VoucherType" != 2
                 AND vd."VoucherDate" <= varToDate
               GROUP BY vd."LedgerId") AS voucher_detail ON voucher_detail."LedgerId" = ledger."LedgerId"
    LEFT JOIN "login" ON ledger."LedgerId" = login."LedgerId"
    JOIN "ledger_limit" ON ledger."LedgerId" = ledger_limit."LedgerId"
    LEFT JOIN (SELECT hs."LedgerId" AS "SettLedgerId" FROM "hp_settelment" hs
               WHERE hs."SettelmentToDate" >= varToDate
                 AND hs."RecordStatus" != 'D'
               GROUP BY hs."LedgerId") AS sett ON sett."SettLedgerId" = ledger."LedgerId"
    WHERE ledger."OrganizationId" = varOrganizationId
      AND ledger."RecordStatus" != 'D'
      AND ledger."IsHide" = '0'
      AND ledger."HPLedgerId" = varLedgerId
    ORDER BY ledger."LedgerName" ASC;
END;
$$;
