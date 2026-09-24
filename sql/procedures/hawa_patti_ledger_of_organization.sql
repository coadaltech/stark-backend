-- Converted from MySQL procedure `hawa_patti_ledger_of_organization`.
-- LIKE -> ILIKE: MySQL's default collation compared case-insensitively.
DROP ROUTINE IF EXISTS "hawa_patti_ledger_of_organization";
CREATE OR REPLACE FUNCTION "hawa_patti_ledger_of_organization"(varOrganizationId bigint, varLedgerName varchar)
RETURNS TABLE(
    "LedgerId" bigint,
    "OrganizationId" bigint,
    "ParentLedgerId" bigint,
    "LedgerName" text,
    "GroupId" integer,
    "RecordStatus" text,
    "AddedBy" text,
    "Mobile" text,
    "UserName" text
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
           ledger."RecordStatus"::text,
           ledger."AddedBy"::text,
           COALESCE(login."Mobile", 'NA')::text AS "Mobile",
           COALESCE(login."UserName", 'NA')::text AS "UserName"
    FROM "ledger" ledger
    LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
    WHERE ledger."LedgerId" IN (SELECT hp."HPLedgerId" FROM "ledger" AS hp
                                WHERE hp."OrganizationId" = varOrganizationId
                                  AND hp."RecordStatus" != 'D'
                                  AND hp."IsHide" = '0')
      AND ledger."LedgerName" ILIKE (varLedgerName || '%')
    ORDER BY ledger."LedgerName" ASC;
END;
$$;
