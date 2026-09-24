-- Converted from MySQL procedure `sys_hpLedgerId_update`.
DROP ROUTINE IF EXISTS "sys_hpLedgerId_update";
CREATE OR REPLACE PROCEDURE "sys_hpLedgerId_update"(varOrganizationId bigint)
LANGUAGE plpgsql AS $$
DECLARE
    v_VoucherId bigint := 0;  -- unused in original
    rec record;
BEGIN
    FOR rec IN
        SELECT ledger."LedgerId" AS "LedgerId", any_value(hissa."HissaLedgerId") AS "HissaLedgerId"
        FROM (
            SELECT l."LedgerName", l."LedgerId" FROM "ledger" l
            WHERE l."LedgerId" IN (SELECT h."LedgerId" FROM "hissa" h WHERE h."RecordStatus" != 'D')
              AND l."LedgerId" NOT IN (SELECT h."LedgerId" FROM "hissa" h WHERE h."RecordStatus" != 'D' AND h."HissaLedgerId" = 11)
              AND l."OrganizationId" = varOrganizationId AND l."GroupId" = 5
              AND l."RecordStatus" != 'D') AS ledger
        JOIN "hissa" hissa ON hissa."LedgerId" = ledger."LedgerId" AND hissa."RecordStatus" != 'D'
        LEFT JOIN "ledger" AS ledgerHissa ON hissa."HissaLedgerId" = ledgerHissa."LedgerId"
        WHERE ledger."LedgerId" != hissa."HissaLedgerId"
        GROUP BY ledger."LedgerName", ledger."LedgerId"
    LOOP
        UPDATE "ledger" l SET "HPLedgerId" = rec."HissaLedgerId"
        WHERE l."LedgerId" = rec."LedgerId";

        UPDATE "hissa" h SET "HissaLedgerId" = 11
        WHERE h."LedgerId" = rec."LedgerId";
    END LOOP;
END;
$$;
