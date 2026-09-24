-- Converted from MySQL procedure `auto_hp_vapsi_settelment_create`.
DROP ROUTINE IF EXISTS "auto_hp_vapsi_settelment_create";
CREATE OR REPLACE PROCEDURE "auto_hp_vapsi_settelment_create"(
	varOrganizationId bigint,
	varFromDate date,
	varToDate date,
	varTransactionDate date,
	varToLedgerIds bigint,
	varLoginUserName varchar
)
LANGUAGE plpgsql AS $$
BEGIN
	CALL "auto_vapsi_create"(varOrganizationId, varFromDate, varToDate, varTransactionDate, varToLedgerIds, varLoginUserName);
	CALL "auto_hp_create"(varOrganizationId, varFromDate, varToDate, varTransactionDate, varToLedgerIds, varLoginUserName);
	CALL "auto_settelment_create"(varOrganizationId, varFromDate, varToDate, varTransactionDate, varToLedgerIds, varLoginUserName);
END;
$$;
