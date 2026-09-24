-- Converted from MySQL procedure `update_ledger_Status`.
-- NOTE: the MySQL source used `UpdatedDate = getdate()` (a SQL Server function that does not exist in
-- MySQL, so the MySQL procedure failed at EXECUTE). Converted to localtimestamp to implement the intent.
-- Other quirks are preserved: SET RecordStatus uses varRecordStatus (not varUpdateRecordStatus), and
-- when neither update flag is given the generated statement is invalid (as in MySQL).
DROP ROUTINE IF EXISTS "update_ledger_Status";
CREATE OR REPLACE PROCEDURE "update_ledger_Status"(
	varLedgerId integer
	, varUpdateRecordStatus varchar
	, varUpdateIsHide bigint
	, varRecordStatus varchar
	, varIsHide bigint
	, varUpdatedBy bigint
	)
LANGUAGE plpgsql AS $$
DECLARE
	v_s text;
BEGIN
	v_s := 'update "ledger" ';

	IF coalesce(varUpdateRecordStatus, '') <> '' THEN
		v_s := v_s || format(' set "RecordStatus" = %L ', varRecordStatus);
		-- MySQL: ifnull(varUpdateIsHide,'') != ''  (true for any non-NULL value)
		IF coalesce(varUpdateIsHide::text, '') <> '' THEN
			v_s := v_s || format(' , "IsHide" = %L ', varUpdateIsHide::text);
		END IF;
	ELSE
		IF coalesce(varUpdateIsHide::text, '') <> '' THEN
			v_s := v_s || format('set "IsHide" = %L ', varUpdateIsHide::text);
		END IF;
	END IF;
	v_s := v_s || format(' , "UpdatedBy" = %L ', varUpdatedBy::text);
	v_s := v_s || ' , "UpdatedDate" = localtimestamp ';
	v_s := v_s || ' where 1=1 ';
	v_s := v_s || format(' and "RecordStatus" <> %L ', varRecordStatus);
	v_s := v_s || format(' and "IsHide" <> %L ', varIsHide::text);
	v_s := v_s || format(' and ("ledger"."LedgerId" = %s
		or ("ledger"."LedgerId" in (select Retailer."LedgerId" from "ledger" as Retailer where Retailer."ParentLedgerId" = %s))
		or ("ledger"."LedgerId" in (select Retailer."LedgerId" from "ledger" as Retailer
			where Retailer."ParentLedgerId" in (select Distributer."LedgerId" from "ledger" as Distributer where Distributer."ParentLedgerId" = %s))
			)
		)', coalesce(varLedgerId::text, 'NULL'), coalesce(varLedgerId::text, 'NULL'), coalesce(varLedgerId::text, 'NULL'));

	EXECUTE v_s;
END;
$$;
