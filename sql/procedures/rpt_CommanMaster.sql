-- Converted from MySQL procedure `rpt_CommanMaster`.
DROP ROUTINE IF EXISTS "rpt_CommanMaster";
CREATE OR REPLACE FUNCTION "rpt_CommanMaster"(varOrganizationId bigint, varCommanMasterType bigint, varCommanMasterName varchar)
RETURNS TABLE(
    "LedgerName" text,
    "CommanMasterId" bigint,
    "CommanMasterName" text,
    "OrganizationId" bigint,
    "CommanMasterType" integer,
    "LedgerId" bigint,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp,
    "ParentAgentLedgerId" bigint,
    "ParentAgentLedgerName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT l."LedgerName"::text, cm."CommanMasterId", cm."CommanMasterName"::text,
           cm."OrganizationId", cm."CommanMasterType", cm."LedgerId",
           cm."RecordStatus"::text, cm."AddedBy"::text, cm."AddedDate", cm."UpdatedBy"::text,
           cm."UpdatedDate",
           cm."ParentAgentLedgerId",
           COALESCE(pl."LedgerName"::text, '') AS "ParentAgentLedgerName"
    FROM "comman_master" cm
    LEFT JOIN "ledger" l ON l."LedgerId" = cm."LedgerId"
    LEFT JOIN "ledger" AS pl ON pl."LedgerId" = cm."ParentAgentLedgerId"
    WHERE cm."CommanMasterType" = varCommanMasterType
      AND (varCommanMasterName IS NULL OR cm."CommanMasterName" ILIKE (varCommanMasterName::text || '%'))
      AND (COALESCE(cm."OrganizationId", 0) = varOrganizationId OR COALESCE(cm."OrganizationId", 0) = 0)
      AND cm."RecordStatus" != 'D'
    ORDER BY cm."CommanMasterName";
END;
$$;
