-- Converted from MySQL procedure `rpt_ledger_asign_list_for_allshift_report`.
DROP ROUTINE IF EXISTS "rpt_ledger_asign_list_for_allshift_report";
CREATE OR REPLACE FUNCTION "rpt_ledger_asign_list_for_allshift_report"(
    varOrganizationId integer,
    varAsignDate date,
    varStaffLoginId integer
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "LedgerAsignId" bigint,
    "OrganizationId" bigint,
    "AsignDate" date,
    "StaffLoginId" bigint,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT ledger_asign."LedgerId",
           ledger."LedgerName"::text,
           ledger_asign."LedgerAsignId",
           ledger_asign."OrganizationId",
           ledger_asign."AsignDate",
           ledger_asign."StaffLoginId",
           ledger_asign."RecordStatus"::text,
           ledger_asign."AddedBy"::text,
           ledger_asign."AddedDate",
           ledger_asign."UpdatedBy"::text,
           ledger_asign."UpdatedDate"
    FROM "ledger_asign" ledger_asign
    LEFT JOIN "ledger" ledger ON ledger."LedgerId" = ledger_asign."LedgerId"
    WHERE ledger_asign."AsignDate" = varAsignDate
      AND ledger_asign."StaffLoginId" = varStaffLoginId
      AND ledger_asign."RecordStatus" != 'D'
    ORDER BY ledger."LedgerName";
END;
$$;
