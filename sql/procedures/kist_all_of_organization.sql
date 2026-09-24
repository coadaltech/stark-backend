-- Converted from MySQL procedure `kist_all_of_organization`.
DROP ROUTINE IF EXISTS "kist_all_of_organization";
CREATE OR REPLACE FUNCTION "kist_all_of_organization"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date,
    varLedgerId bigint,
    varAgentId bigint
) RETURNS TABLE(
    "KistId" bigint,
    "OrganizationId" bigint,
    "VoucherId" bigint,
    "LedgerId" bigint,
    "KistDate" date,
    "Amount" double precision,
    "KistType" varchar,
    "KistStatus" varchar,
    "PaidVoucherId" bigint,
    "RecordStatus" char,
    "AddedBy" varchar,
    "AddedDate" timestamp,
    "UpdatedBy" varchar,
    "UpdatedDate" timestamp,
    "LedgerName" varchar
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT k."KistId", k."OrganizationId", k."VoucherId", k."LedgerId", k."KistDate", k."Amount",
           k."KistType"::varchar, k."KistStatus"::varchar, k."PaidVoucherId", k."RecordStatus"::char,
           k."AddedBy"::varchar, k."AddedDate", k."UpdatedBy"::varchar, k."UpdatedDate",
           l."LedgerName"::varchar
    FROM "kist" k
    JOIN "ledger" l ON k."LedgerId" = l."LedgerId"
    WHERE k."OrganizationId" = varOrganizationId
      AND k."KistDate" >= varFromDate
      AND k."KistDate" <= varToDate
      AND k."RecordStatus" != 'D'
      AND (COALESCE(varLedgerId, 0) = 0 OR k."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId
           OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
      -- NOTE: hard-coded AgentLedgerId = 31 preserved from the MySQL source (varAgentId only toggles the filter).
      AND (COALESCE(varAgentId, 0) = 0 OR l."ParentLedgerId" IN (SELECT res."LedgerId" FROM "ledger" AS res
                WHERE res."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."AgentLedgerId" = 31)))
    ORDER BY k."KistDate" ASC;
END
$$;
