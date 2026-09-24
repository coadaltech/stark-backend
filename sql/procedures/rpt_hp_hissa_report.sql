-- Converted from MySQL procedure `rpt_hp_hissa_report`.
DROP ROUTINE IF EXISTS "rpt_hp_hissa_report";
CREATE OR REPLACE FUNCTION "rpt_hp_hissa_report"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date,
    LedgerIds bigint,
    varCashAgentId bigint
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "VoucherId" bigint,
    "HPFromDate" date,
    "HPToDate" date,
    "BaseAmount" double precision,
    "HPPercent" double precision,
    "HPAmount" double precision,
    "Mobile" text,
    "AgentName" text,
    "HPLedgerName" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT DISTINCT l."LedgerId", l."LedgerName"::text, hp_hissa."VoucherId", hp_hissa."HPFromDate", hp_hissa."HPToDate",
           hp_hissa."BaseAmount", hp_hissa."HPPercent", hp_hissa."HPAmount",
           login."Mobile"::text, COALESCE(agent."CommanMasterName", 'NA')::text AS "AgentName",
           ledgerTo."LedgerName"::text AS "HPLedgerName",
           hp_hissa."AddedBy"::text,
           hp_hissa."AddedDate",
           hp_hissa."UpdatedBy"::text,
           hp_hissa."UpdatedDate"
    FROM (SELECT h."OrganizationId", h."LedgerId", h."HPLedgerId", h."VoucherId", h."HPFromDate", h."HPToDate",
                 h."BaseAmount", h."HPPercent", h."HPAmount", h."AddedBy", h."AddedDate", h."UpdatedBy", h."UpdatedDate"
          FROM "hp_hissa" h
          WHERE h."HPToDate" BETWEEN varFromDate AND varToDate
            AND h."OrganizationId" = varOrganizationId
            AND h."RecordStatus" != 'D'
            AND (COALESCE(LedgerIds, 0) = 0 OR h."HPLedgerId" = LedgerIds)
         ) AS hp_hissa
    JOIN (SELECT ledger."LedgerId", ledger."LedgerName", ledger."AddedDate", ledger."HPLedgerId", ledger."AgentLedgerId"
          FROM "ledger" ledger
          WHERE ledger."GroupId" = 5 AND ledger."RecordStatus" != 'D'
            AND ledger."OrganizationId" = varOrganizationId
            AND (COALESCE(varCashAgentId, 0) = 0
                 OR ledger."AgentLedgerId" IN (SELECT cm."CommanMasterId" FROM "comman_master" cm WHERE cm."LedgerId" = varCashAgentId))
         ) AS l ON hp_hissa."LedgerId" = l."LedgerId"
    JOIN "ledger" AS ledgerTo ON ledgerTo."LedgerId" = hp_hissa."HPLedgerId"
    LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
    LEFT JOIN "login" login ON login."LedgerId" = l."LedgerId";
END;
$$;
