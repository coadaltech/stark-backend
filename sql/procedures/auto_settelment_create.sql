-- Converted from MySQL procedure `auto_settelment_create`.
DROP ROUTINE IF EXISTS "auto_settelment_create";
CREATE OR REPLACE PROCEDURE "auto_settelment_create"(
	varOrganizationId bigint,
	varFromDate date,
	varToDate date,
	varTransactionDate date,
	varToLedgerIds bigint,
	varLoginUserName varchar
)
LANGUAGE plpgsql AS $$
DECLARE
	varAmount double precision;

	v_VoucherId bigint := 0;

	varVoucherType smallint := 1;
	-- MySQL declared smallint; it receives ledger.HPLedgerId (bigint), widened to avoid out-of-range errors.
	varOppositLedgerId bigint := 0;
	varShiftId bigint := 0;

	varLedgerId bigint := 0;

	rec record;
BEGIN
	varVoucherType := 1;
	varOppositLedgerId := 0;
	varShiftId := 0;

	FOR rec IN
		SELECT DISTINCT l."LedgerId" AS "LedgerId"
		,(OPBal."opening") AS "opening", l."HPLedgerId" AS "HPLedgerId"
		FROM (SELECT ledger."LedgerId", ledger."LedgerName", ledger."AddedDate", ledger."HPLedgerId", ledger."AgentLedgerId"
			FROM "ledger" ledger WHERE ledger."GroupId" = 5 AND ledger."RecordStatus" <> 'D'
			AND (varToLedgerIds = 0 OR coalesce(ledger."HPLedgerId", 0) = varToLedgerIds)
			AND ledger."OrganizationId" = varOrganizationId
			AND ledger."LedgerId" NOT IN (SELECT hs."LedgerId" FROM "hp_settelment" hs WHERE hs."SettelmentToDate" >= varToDate AND hs."RecordStatus" <> 'D')
			) AS l
		LEFT JOIN (SELECT aa."LedgerId"
				,sum((CASE WHEN aa."AmountType" = 'Dr' THEN coalesce(aa."Amount", 0) ELSE - coalesce(aa."Amount", 0) END)) AS "opening"
				FROM "voucher_detail" aa
				WHERE aa."VoucherDate" <= varToDate
				AND aa."VoucherType" <> 2
				AND aa."RecordStatus" <> 'D'
				AND aa."OrganizationId" = varOrganizationId
				GROUP BY aa."LedgerId"
			) AS OPBal ON OPBal."LedgerId" = l."LedgerId"
		WHERE coalesce(OPBal."opening", 0) <> 0
		ORDER BY l."LedgerId"
	LOOP
		varLedgerId := rec."LedgerId";
		varAmount := rec."opening";
		varOppositLedgerId := rec."HPLedgerId";

		/*      Voucher */
		INSERT INTO "voucher"("OrganizationId","VoucherDate","ShiftId","VoucherType","VoucherMode"
		,"Amount","Remark","LagaiKhai"
		,"RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
		VALUES(varOrganizationId,varTransactionDate,varShiftId,varVoucherType,'AUTO',varAmount,'AUTO_SETT',0
		,'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp)
		RETURNING "VoucherId" INTO v_VoucherId;

		/* HP to party */
		INSERT INTO "voucher_detail"("OrganizationId",
		"VoucherId"
		,"LedgerId"
		,"VoucherDetailType","ShiftId"
		,"VoucherDate"
		,"VoucherType"
		,"Amount"
		,"AmountType"
		,"OppositeLedgerId"
		,"Flag1"
		,"Remark","SelfHissa","OtherHissa"
		,"MondayFinalFlag","VoucherMode","FromLedgerId"
		,"OpenAmount"
		,"RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate"
		)
		VALUES(varOrganizationId,v_VoucherId
		,varLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,(CASE WHEN varAmount > 0 THEN varAmount ELSE -varAmount END)
		,(CASE WHEN varAmount > 0 THEN 'Cr' ELSE 'Dr' END)
		,varOppositLedgerId
		,'0',(SELECT max(l2."LedgerName") FROM "ledger" l2 WHERE l2."LedgerId" = varOppositLedgerId),0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp)
		;

		/* party to HP  */
		INSERT INTO "voucher_detail"("OrganizationId",
		"VoucherId"
		,"LedgerId"
		,"VoucherDetailType","ShiftId"
		,"VoucherDate"
		,"VoucherType"
		,"Amount"
		,"AmountType"
		,"OppositeLedgerId"
		,"Flag1"
		,"Remark","SelfHissa","OtherHissa"
		,"MondayFinalFlag","VoucherMode","FromLedgerId"
		,"OpenAmount"
		,"RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate"
		)
		VALUES(varOrganizationId,v_VoucherId
		,varOppositLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,(CASE WHEN varAmount > 0 THEN varAmount ELSE -varAmount END)
		,(CASE WHEN varAmount > 0 THEN 'Dr' ELSE 'Cr' END)
		,varLedgerId
		,'0',(SELECT max(l2."LedgerName") FROM "ledger" l2 WHERE l2."LedgerId" = varLedgerId),0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp
		)
		;

		/*      Setttelment Table Entry */
		INSERT INTO "hp_settelment"
		(
		"OrganizationId",
		"LedgerId",
		"SettelmentLedgerId",
		"VoucherId",
		"VoucherDate",
		"SettelmentFromDate",
		"SettelmentToDate",
		"SettelmentAmount",
		"RecordStatus",
		"AddedBy",
		"AddedDate",
		"UpdatedBy",
		"UpdatedDate")
		VALUES
		(
		varOrganizationId,
		varLedgerId,
		varToLedgerIds,
		v_VoucherId,
		varTransactionDate,
		varFromDate,
		varToDate,
		varAmount,
		'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp);

	END LOOP;
END;
$$;
