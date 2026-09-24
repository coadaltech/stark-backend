-- Converted from MySQL procedure `rpt_vapsi_from_to_report`.
DROP ROUTINE IF EXISTS "rpt_vapsi_from_to_report";
CREATE OR REPLACE FUNCTION "rpt_vapsi_from_to_report"(varOrganizationId bigint, varFromDate date, varToDate date, LedgerIds bigint, varCashAgentId bigint)
RETURNS TABLE("LedgerId" bigint, "LedgerName" text, "VoucherId" bigint, "VapsiFromDate" date, "VapsiToDate" date,
              "BaseAmount" double precision, "VapsiPercent" double precision, "VapsiAmount" double precision,
              "Mobile" text, "AgentName" text, "AddedBy" text, "AddedDate" timestamp, "UpdatedBy" text, "UpdatedDate" timestamp)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT DISTINCT l."LedgerId", l."LedgerName"::text, vp."VoucherId", vp."VapsiFromDate", vp."VapsiToDate", vp."BaseAmount", vp."VapsiPercent", vp."VapsiAmount",
           lg."Mobile"::text, COALESCE(agent."CommanMasterName"::text, 'NA') AS "AgentName",
           vp."AddedBy"::text,
           vp."AddedDate",
           vp."UpdatedBy"::text,
           vp."UpdatedDate"
    FROM (SELECT x."OrganizationId", x."LedgerId", x."ParentsLedgerId", x."VoucherId", x."VapsiFromDate", x."VapsiToDate",
                 x."BaseAmount", x."VapsiPercent", x."VapsiAmount", x."VapsiOn",
                 x."AddedBy", x."AddedDate", x."UpdatedBy", x."UpdatedDate"
          FROM "vapsi" x
          WHERE x."VapsiToDate" BETWEEN varFromDate AND varToDate
            -- and vapsi.VoucherDate between varFromDate and varToDate
            AND x."OrganizationId" = varOrganizationId
            AND x."RecordStatus" != 'D') AS vp
    JOIN (SELECT led."LedgerId", led."LedgerName", led."AddedDate", led."HPLedgerId", led."AgentLedgerId"
          FROM "ledger" led
          WHERE led."GroupId" = 5 AND led."RecordStatus" != 'D'
            AND led."OrganizationId" = varOrganizationId
            AND (COALESCE(LedgerIds, 0) = 0 OR led."LedgerId" = LedgerIds)
            AND (COALESCE(varCashAgentId, 0) = 0 OR led."AgentLedgerId" IN (SELECT cm."CommanMasterId" FROM "comman_master" cm WHERE cm."LedgerId" = varCashAgentId))
         ) AS l ON vp."LedgerId" = l."LedgerId"
    LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
    LEFT JOIN "login" lg ON lg."LedgerId" = l."LedgerId";
END;
$$;
