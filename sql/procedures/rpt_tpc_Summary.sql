-- Converted from MySQL procedure `rpt_tpc_Summary`.
-- MySQL `GROUP BY lm.LedgerName` with non-aggregated a.LedgerId / agent name -> any_value().
DROP ROUTINE IF EXISTS "rpt_tpc_Summary";
CREATE OR REPLACE FUNCTION "rpt_tpc_Summary"(varOrganizationId bigint, FromDate date, ToDate date, varParentId bigint)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "Amount" double precision,
    "AgentName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT any_value(a."LedgerId") AS "LedgerId",
           lm."LedgerName"::text,
           sum(a."Amount") AS "Amount",
           COALESCE(any_value(agent."CommanMasterName"), 'NA')::text AS "AgentName"
    FROM "voucher_detail" a
    JOIN "ledger" lm ON a."LedgerId" = lm."LedgerId"
    LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = lm."AgentLedgerId" AND agent."CommanMasterType" = 1
    WHERE (a."RecordStatus" != 'D')
      AND a."OrganizationId" = varOrganizationId
      AND a."VoucherType" = 32
      AND (lm."LedgerId" = varParentId OR lm."ParentLedgerId" = varParentId OR COALESCE(varParentId, 0) = 0)
      AND lm."GroupId" IN (3, 4, 5)
      AND a."VoucherDate" BETWEEN FromDate AND ToDate
    GROUP BY lm."LedgerName";
END;
$$;
