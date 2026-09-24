-- Converted from MySQL procedure `rpt_ledger_summary_detail`.
DROP ROUTINE IF EXISTS "rpt_ledger_summary_detail";
CREATE OR REPLACE FUNCTION "rpt_ledger_summary_detail"(varOrganizationId bigint, varLedgerId bigint)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "LedgerStatus" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT summary."LedgerId", l."LedgerName"::text, summary."LedgerStatus"
    FROM (
        SELECT h."LedgerId", 'InHissa'::text AS "LedgerStatus" FROM "hissa" h
        WHERE h."OrganizationId" = varOrganizationId
          AND h."HissaLedgerId" = varLedgerId
          AND h."RecordStatus" != 'D'
        UNION ALL
        SELECT tpc."LedgerId", 'InTPC'::text AS "LedgerStatus" FROM "third_party_commission" tpc
        WHERE tpc."OrganizationId" = varOrganizationId
          AND tpc."CommissionLedgerId" = varLedgerId
          AND tpc."RecordStatus" != 'D'
        UNION ALL
        SELECT tpv."LedgerId", 'InTPV'::text AS "LedgerStatus" FROM "third_party_vapsi" tpv
        WHERE tpv."OrganizationId" = varOrganizationId
          AND tpv."VapsiLedgerId" = varLedgerId
          AND tpv."RecordStatus" != 'D'
        UNION ALL
        SELECT lg."LedgerId", 'InHPLedger'::text AS "LedgerStatus" FROM "ledger" lg
        WHERE lg."OrganizationId" = varOrganizationId
          AND lg."HPLedgerId" = varLedgerId
          AND lg."RecordStatus" != 'D'
    ) AS summary
    JOIN "ledger" l ON l."LedgerId" = summary."LedgerId";
END;
$$;
