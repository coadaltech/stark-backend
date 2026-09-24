-- Converted from MySQL procedure `check_comman_master_before_delete`.
DROP ROUTINE IF EXISTS "check_comman_master_before_delete";
CREATE OR REPLACE FUNCTION "check_comman_master_before_delete"(
    varLedgerIds integer,
    varCommanMasterType integer
)
RETURNS TABLE("returnValue" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    returnValue integer;
BEGIN
    returnValue := 0;

    IF EXISTS (SELECT 1 FROM "comman_master" cm
               WHERE cm."LedgerId" = varLedgerIds
                 AND cm."CommanMasterType" = varCommanMasterType) THEN
        returnValue := 1;
    END IF;

    RETURN QUERY SELECT returnValue;
END;
$$;
