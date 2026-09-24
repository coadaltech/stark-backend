-- Converted from MySQL procedure `ledger_by_group`.
DROP ROUTINE IF EXISTS "ledger_by_group";
CREATE OR REPLACE FUNCTION "ledger_by_group"(
    varOrganizationId integer,
    varLedgerName varchar,
    varGroupId varchar,
    varParentId integer,
    varDistributerId integer
)
RETURNS TABLE(
    "LedgerName" text,
    "LedgerId" bigint,
    "GroupId" integer,
    "RecordStatus" text,
    "Mobile" text,
    "UserName" text,
    "AccountStatus" text,
    "ParentLedgerId" bigint,
    "Grantor" text,
    "LedgerBalance" numeric,
    "LedgerLimit" numeric,
    "TransConsum" numeric,
    "FinalLimit" numeric
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT ledger."LedgerName"::text, ledger."LedgerId", ledger."GroupId", ledger."RecordStatus"::text
         , COALESCE(login."Mobile", '')::text AS "Mobile"
         , COALESCE(login."UserName", '')::text AS "UserName"
         , COALESCE(ledger."AccountStatus", '')::text AS "AccountStatus"
         , COALESCE(ledger."ParentLedgerId", 0)::bigint AS "ParentLedgerId"
         , ledger."Grantor"::text
         , round(ledger_limit."LedgerBalance"::numeric, 0) AS "LedgerBalance"
         , round(ledger_limit."LedgerLimit"::numeric, 0) AS "LedgerLimit"
         , round(ledger_limit."TransConsum"::numeric, 0) AS "TransConsum"
         , round(ledger_limit."FinalLimit"::numeric, 0) AS "FinalLimit"
    FROM "ledger" ledger
    LEFT JOIN "ledger_limit" ledger_limit ON ledger_limit."LedgerId" = ledger."LedgerId"
    LEFT JOIN "login" login ON login."LedgerId" = ledger."LedgerId"
    WHERE (ledger."OrganizationId" = varOrganizationId OR ledger."OrganizationId" = 0 OR COALESCE(varOrganizationId, 0) = 0)
      AND ledger."LedgerName" ILIKE ('' || COALESCE(varLedgerName, '') || '%')
      AND (ledger."GroupId"::text = ANY(string_to_array(varGroupId, ',')) OR COALESCE(varGroupId, '') = '')
      AND (ledger."ParentLedgerId" = varParentId OR COALESCE(varParentId, 0) = 0 OR ledger."LedgerId" = varParentId)
      AND ((ledger."LedgerId" IN (SELECT retailer."LedgerId" FROM "ledger" AS retailer
                WHERE retailer."ParentLedgerId" IN (SELECT distributer."LedgerId" FROM "ledger" AS distributer WHERE distributer."ParentLedgerId" = varDistributerId))
                OR COALESCE(varDistributerId, 0) = 0)
           OR (ledger."ParentLedgerId" = varDistributerId OR COALESCE(varDistributerId, 0) = 0)
           OR ledger."LedgerId" = varDistributerId
          )
      AND ledger."RecordStatus" != 'D'
      AND ledger."IsHide" = '0'
    ORDER BY ledger."LedgerName" ASC;
END;
$$;
