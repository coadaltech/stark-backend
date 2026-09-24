-- Converted from MySQL procedure `ledger_List_for_voucher`.
-- varListType: 0 self, 1 only ressaler, 2 only panter, 3 ressaler and panter, else org list.
-- LIKE -> ILIKE: MySQL's default collation compared case-insensitively.
DROP ROUTINE IF EXISTS "ledger_List_for_voucher";
CREATE OR REPLACE FUNCTION "ledger_List_for_voucher"(
    varLedgerId integer,
    varListType integer,
    varLedgerName varchar
)
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
    CASE varListType
    WHEN 3 THEN
        RETURN QUERY
        SELECT ledger."LedgerId", ledger."OrganizationId", ledger."ParentLedgerId", ledger."LedgerName"::text,
               ledger."GroupId", ledger."RecordStatus"::text, ledger."AddedBy"::text,
               COALESCE(login."Mobile", 'NA')::text AS "Mobile", COALESCE(login."UserName", 'NA')::text AS "UserName"
        FROM "ledger" ledger
        LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
        WHERE (ledger."LedgerId" = varLedgerId OR ledger."ParentLedgerId" = varLedgerId
               OR ledger."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
          AND ledger."LedgerName" ILIKE ('' || varLedgerName || '%')
          AND ledger."RecordStatus" != 'D'
          AND ledger."IsHide" = '0'
        ORDER BY ledger."LedgerName" ASC;
    WHEN 2 THEN
        RETURN QUERY
        SELECT ledger."LedgerId", ledger."OrganizationId", ledger."ParentLedgerId", ledger."LedgerName"::text,
               ledger."GroupId", ledger."RecordStatus"::text, ledger."AddedBy"::text,
               COALESCE(login."Mobile", 'NA')::text AS "Mobile", COALESCE(login."UserName", 'NA')::text AS "UserName"
        FROM "ledger" ledger
        LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
        WHERE (ledger."LedgerId" = varLedgerId
               OR ((ledger."ParentLedgerId" = varLedgerId
                    OR ledger."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
                   AND ledger."GroupId" IN (5)))
          AND ledger."LedgerName" ILIKE ('' || varLedgerName || '%')
          AND ledger."RecordStatus" != 'D'
          AND ledger."IsHide" = '0'
        ORDER BY ledger."LedgerName" ASC;
    WHEN 1 THEN
        RETURN QUERY
        SELECT ledger."LedgerId", ledger."OrganizationId", ledger."ParentLedgerId", ledger."LedgerName"::text,
               ledger."GroupId", ledger."RecordStatus"::text, ledger."AddedBy"::text,
               COALESCE(login."Mobile", 'NA')::text AS "Mobile", COALESCE(login."UserName", 'NA')::text AS "UserName"
        FROM "ledger" ledger
        LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
        WHERE (ledger."LedgerId" = varLedgerId
               OR ((ledger."ParentLedgerId" = varLedgerId
                    OR ledger."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
                   AND ledger."GroupId" IN (4)))
          AND ledger."LedgerName" ILIKE ('' || varLedgerName || '%')
          AND ledger."RecordStatus" != 'D'
          AND ledger."IsHide" = '0'
        ORDER BY ledger."LedgerName" ASC;
    WHEN 0 THEN
        RETURN QUERY
        SELECT ledger."LedgerId", ledger."OrganizationId", ledger."ParentLedgerId", ledger."LedgerName"::text,
               ledger."GroupId", ledger."RecordStatus"::text, ledger."AddedBy"::text,
               COALESCE(login."Mobile", 'NA')::text AS "Mobile", COALESCE(login."UserName", 'NA')::text AS "UserName"
        FROM "ledger" ledger
        LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
        WHERE ledger."LedgerId" = varLedgerId
          AND ledger."LedgerName" ILIKE ('' || varLedgerName || '%')
          AND ledger."RecordStatus" != 'D'
          AND ledger."IsHide" = '0'
        ORDER BY ledger."LedgerName" ASC;
    ELSE
        RETURN QUERY
        SELECT ledger."LedgerId", ledger."OrganizationId", ledger."ParentLedgerId", ledger."LedgerName"::text,
               ledger."GroupId", ledger."RecordStatus"::text, ledger."AddedBy"::text,
               COALESCE(login."Mobile", 'NA')::text AS "Mobile", COALESCE(login."UserName", 'NA')::text AS "UserName"
        FROM "ledger" ledger
        LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
        WHERE (ledger."OrganizationId" = varLedgerId OR ledger."OrganizationId" = 0)
          AND ledger."LedgerName" ILIKE ('' || varLedgerName || '%')
          AND ledger."RecordStatus" != 'D'
          AND ledger."IsHide" = '0'
        ORDER BY ledger."LedgerName" ASC;
    END CASE;
END;
$$;
