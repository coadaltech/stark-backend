-- Converted from MySQL procedure `check_ledger_before_delete`.
DROP ROUTINE IF EXISTS "check_ledger_before_delete";
CREATE OR REPLACE FUNCTION "check_ledger_before_delete"(LedgerIds integer)
RETURNS TABLE("returnValue" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    returnValue integer;
BEGIN
    returnValue := 0;

    IF EXISTS (SELECT * FROM "transaction" t
               WHERE t."LedgerId" = LedgerIds) THEN
        returnValue := 1;
    END IF;

    IF EXISTS (SELECT vd."LedgerId" FROM "voucher_detail" vd
               WHERE vd."LedgerId" = LedgerIds) THEN
        returnValue := 1;
    END IF;

    RETURN QUERY SELECT returnValue;
END;
$$;
