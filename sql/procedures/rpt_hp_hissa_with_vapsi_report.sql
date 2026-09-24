-- Converted from MySQL procedure `rpt_hp_hissa_with_vapsi_report`.
DROP ROUTINE IF EXISTS "rpt_hp_hissa_with_vapsi_report";
CREATE OR REPLACE FUNCTION "rpt_hp_hissa_with_vapsi_report"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date,
    LedgerIds bigint
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "HPBaseAmount" numeric,
    "HPPercent" numeric,
    "HPAmount" numeric,
    "VapsiBaseAmount" numeric,
    "VapsiPercent" numeric,
    "VapsiAmount" numeric,
    "VapsiOn" numeric,
    "SettelmentAmount" numeric,
    "Mobile" text,
    "AgentName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT DISTINCT l."LedgerId", l."LedgerName"::text
        , round(COALESCE(hp_hissa."BaseAmount", 0)::numeric, 0) AS "HPBaseAmount"
        , round(COALESCE(hp_hissa."HPPercent", 0)::numeric, 0) AS "HPPercent"
        , round(COALESCE(hp_hissa."HPAmount", 0)::numeric, 0) AS "HPAmount"
        , round(COALESCE(vapsi."BaseAmount", 0)::numeric, 0) AS "VapsiBaseAmount"
        , round(COALESCE(vapsi."VapsiPercent", 0)::numeric, 0) AS "VapsiPercent"
        , round(COALESCE(vapsi."VapsiAmount", 0)::numeric, 0) AS "VapsiAmount"
        , round(COALESCE(vapsi."VapsiOn", 0)::numeric, 0) AS "VapsiOn"
        , round(COALESCE(hp_settelment."SettelmentAmount", 0)::numeric) AS "SettelmentAmount"
        , login."Mobile"::text, COALESCE(agent."CommanMasterName", 'NA')::text AS "AgentName"
    FROM (SELECT ledger."LedgerId", ledger."LedgerName", ledger."AddedDate", ledger."HPLedgerId", ledger."AgentLedgerId"
          FROM "ledger" WHERE ledger."GroupId" = 5 AND ledger."RecordStatus" != 'D'
            AND ledger."OrganizationId" = varOrganizationId
         ) AS l
    LEFT JOIN (SELECT
                   hh."LedgerId",
                   sum(hh."BaseAmount") AS "BaseAmount",
                   hh."HPPercent",
                   sum(hh."HPAmount") AS "HPAmount"
               FROM "hp_hissa" hh
               WHERE hh."VoucherDate" BETWEEN varFromDate AND varToDate AND hh."OrganizationId" = varOrganizationId
                 AND hh."RecordStatus" != 'D'
                 AND (COALESCE(LedgerIds, 0) = 0 OR hh."HPLedgerId" = LedgerIds)
               GROUP BY hh."LedgerId", hh."HPPercent"
              ) AS hp_hissa ON hp_hissa."LedgerId" = l."LedgerId"
    LEFT JOIN (SELECT
                   v."LedgerId",
                   sum(v."BaseAmount") AS "BaseAmount",
                   v."VapsiPercent",
                   sum(v."VapsiAmount") AS "VapsiAmount",
                   sum(v."VapsiOn") AS "VapsiOn"
               FROM "vapsi" v
               WHERE v."VoucherDate" BETWEEN varFromDate AND varToDate AND v."OrganizationId" = varOrganizationId
                 AND v."RecordStatus" != 'D' AND v."ParentsLedgerId" = LedgerIds
               GROUP BY v."LedgerId", v."VapsiPercent") AS vapsi ON vapsi."LedgerId" = l."LedgerId"
    LEFT JOIN (SELECT
                   hs."LedgerId",
                   sum(hs."SettelmentAmount") AS "SettelmentAmount"
               FROM "hp_settelment" hs
               WHERE hs."VoucherDate" BETWEEN varFromDate AND varToDate AND hs."OrganizationId" = varOrganizationId
                 AND hs."RecordStatus" != 'D'
                 AND (COALESCE(LedgerIds, 0) = 0 OR hs."SettelmentLedgerId" = LedgerIds)
               GROUP BY hs."LedgerId") AS hp_settelment ON hp_settelment."LedgerId" = l."LedgerId"
    LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
    LEFT JOIN "login" ON login."LedgerId" = l."LedgerId"
    WHERE COALESCE(hp_hissa."HPAmount", 0) != 0 OR COALESCE(vapsi."VapsiAmount", 0) != 0 OR COALESCE(hp_settelment."SettelmentAmount", 0) != 0
    ORDER BY l."LedgerName"::text;
END;
$$;
