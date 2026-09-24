-- Converted from MySQL procedure `auto_hp_create`.
DROP ROUTINE IF EXISTS "auto_hp_create";
CREATE OR REPLACE PROCEDURE "auto_hp_create"(
	varOrganizationId bigint,
	varFromDate date,
	varToDate date,
	varTransactionDate date,
	varToLedgerIds bigint,
	varLoginUserName varchar
)
LANGUAGE plpgsql AS $$
DECLARE
	varHPFromDate date;
	varHPBaseAmount double precision;
	varAmount double precision;
	varHPPercent double precision;
	varHPLedgerId bigint;

	v_VoucherId bigint := 0;

	varVoucherType smallint := 5;
	varOppositLedgerId bigint := 11;
	varShiftId bigint := 0;

	varLedgerId bigint := 0;

	rec record;
BEGIN
	varVoucherType := 5;
	varOppositLedgerId := 11;
	varShiftId := 0;

	-- MySQL: SELECT DISTINCT ... ORDER BY l.LedgerName. PG requires DISTINCT ORDER BY keys in the
	-- select list, so LedgerName (functionally dependent on LedgerId) is carried as "SortName".
	FOR rec IN
		SELECT q.* FROM (
		SELECT DISTINCT l."LedgerId" AS "LedgerId"
		,coalesce(vd."FromDate", coalesce(vd."FromDate", vd."FromDate")) AS "FromDate"
		,hissa."Hissa" AS "Hissa"
		,coalesce(l."HPLedgerId", 0) AS "HPLedgerId"
		,coalesce(sum(vd."ProfitAndLoss"), 0) AS "ProfitAndLoss"
		,(coalesce(sum(vd."ProfitAndLoss"), 0) * coalesce(hissa."Hissa", 0)) / 100 AS "HPAmount"
		,l."LedgerName" AS "SortName"
		FROM (SELECT ledger."LedgerId", ledger."LedgerName", ledger."AddedDate", ledger."HPLedgerId", ledger."AgentLedgerId"
			FROM "ledger" ledger WHERE ledger."GroupId" = 5 AND ledger."RecordStatus" <> 'D'
			AND (varToLedgerIds = 0 OR coalesce(ledger."HPLedgerId", 0) = varToLedgerIds)
			AND ledger."OrganizationId" = varOrganizationId
			) AS l
		JOIN "hissa" hissa ON hissa."LedgerId" = l."LedgerId" AND hissa."HissaLedgerId" = 11 AND hissa."RecordStatus" <> 'D' AND coalesce(hissa."Hissa", 0) <> 0
		LEFT JOIN "ledger" AS hpHissaTo ON hpHissaTo."LedgerId" = l."HPLedgerId"
		LEFT JOIN (SELECT
			vd."LedgerId", varFromDate AS "FromDate",
			sum(CASE WHEN vd."ShiftId" <> 0 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE - vd."Amount" END) ELSE 0 END) AS "ProfitAndLoss"
			FROM "voucher_detail" AS vd
			WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
			AND vd."LedgerId" NOT IN (SELECT hp_hissa."LedgerId" FROM "hp_hissa" hp_hissa WHERE hp_hissa."RecordStatus" <> 'D' AND hp_hissa."HPFromDate" = varFromDate)
			AND (vd."RecordStatus" <> 'D')
			GROUP BY vd."LedgerId"
			) AS vd ON vd."LedgerId" = l."LedgerId"
		GROUP BY l."LedgerId", l."LedgerName", hissa."Hissa"
		,vd."FromDate", l."AddedDate"
		,coalesce(l."HPLedgerId", 0)
		,coalesce(hpHissaTo."LedgerName", '')
		HAVING coalesce(sum(vd."ProfitAndLoss"), 0) <> 0
		) q
		ORDER BY q."SortName"
	LOOP
		varLedgerId := rec."LedgerId";
		varHPFromDate := rec."FromDate";
		varHPPercent := rec."Hissa";
		varHPLedgerId := rec."HPLedgerId";
		varHPBaseAmount := rec."ProfitAndLoss";
		varAmount := rec."HPAmount";

		/*      Voucher */
		INSERT INTO "voucher"("OrganizationId","VoucherDate","ShiftId","VoucherType","VoucherMode"
		,"Amount","Remark","LagaiKhai"
		,"RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
		VALUES(varOrganizationId,varTransactionDate,varShiftId,varVoucherType,'AUTO',varAmount,'AUTO_HP',0
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
		,varHPLedgerId
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,(CASE WHEN varAmount > 0 THEN varAmount ELSE -varAmount END)
		,(CASE WHEN varAmount > 0 THEN 'Cr' ELSE 'Dr' END)
		,varOppositLedgerId
		,varLedgerId::text,(SELECT max(l2."LedgerName") FROM "ledger" l2 WHERE l2."LedgerId" = varLedgerId),0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp)
		;

		/* HP from HP Account */
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
		,varHPLedgerId
		,varLedgerId::text,(SELECT max(l2."LedgerName") FROM "ledger" l2 WHERE l2."LedgerId" = varLedgerId),0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp
		)
		;

		/*      HP Table Entry */
		INSERT INTO "hp_hissa"
		(
		"OrganizationId",
		"LedgerId",
		"HPLedgerId",
		"VoucherId",
		"VoucherDate",
		"HPFromDate",
		"HPToDate",
		"BaseAmount",
		"HPPercent",
		"HPAmount",
		"RecordStatus",
		"AddedBy",
		"AddedDate",
		"UpdatedBy",
		"UpdatedDate")
		VALUES
		(
		varOrganizationId,
		varLedgerId,
		varHPLedgerId,
		v_VoucherId,
		varTransactionDate,
		varFromDate,
		varToDate,
		varHPBaseAmount,
		varHPPercent,
		varAmount,
		'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp);

	END LOOP;
END;
$$;
