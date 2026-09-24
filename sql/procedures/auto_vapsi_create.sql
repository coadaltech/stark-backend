-- Converted from MySQL procedure `auto_vapsi_create`.
DROP ROUTINE IF EXISTS "auto_vapsi_create";
CREATE OR REPLACE PROCEDURE "auto_vapsi_create"(
	varOrganizationId bigint,
	varFromDate date,
	varToDate date,
	varTransactionDate date,
	varToLedgerIds bigint,
	varLoginUserName varchar
)
LANGUAGE plpgsql AS $$
DECLARE
	varVapsiFromDate date;
	varVapsiBaseAmount double precision;
	varAmount double precision;
	varVapsiPercent double precision;
	varVapsiAmountOn integer := 1; -- 1 for P&L 2 for Payment

	v_VoucherId bigint := 0;
	varVapsiWorkingDays integer := 0;

	varVoucherType smallint := 4;
	varOppositLedgerId bigint := 5;
	varShiftId bigint := 0;

	varLedgerId bigint := 0;

	rec record;
BEGIN
	SELECT o."VapsiWorkingDays" INTO varVapsiWorkingDays
	FROM "organization" o
	WHERE o."OrganizationId" = varOrganizationId;

	varVoucherType := 4;
	varOppositLedgerId := 5;
	varShiftId := 0;

	FOR rec IN
		SELECT DISTINCT l."LedgerId" AS "LedgerId"
		,varFromDate AS "FromDate"
		,l."Vapsi" AS "Vapsi"
		,(coalesce((CASE WHEN sum(vd."ProfitAndLoss") > 0 THEN sum(vd."ProfitAndLoss") ELSE 0 END), 0) * (100 - coalesce(hissa."Hissa", 0))) / 100 AS "VapsiBaseAmount"
		,(((coalesce((CASE WHEN sum(vd."ProfitAndLoss") > 0 THEN sum(vd."ProfitAndLoss") ELSE 0 END), 0) * (100 - coalesce(hissa."Hissa", 0))) / 100)
			* coalesce(l."Vapsi", 0)) / 100 AS "vapsiAmount"
		FROM (SELECT ledger."LedgerId", ledger."LedgerName", ledger."AddedDate", ledger."Vapsi", ledger."AgentLedgerId"
			FROM "ledger" ledger
			WHERE ledger."GroupId" IN (3,4,5)
			AND coalesce(ledger."Vapsi", 0) <> 0 AND ledger."RecordStatus" <> 'D'
			AND coalesce(ledger."ParentLedgerId", 0) = 0
			AND ledger."OrganizationId" = varOrganizationId
			AND (varToLedgerIds = 0 OR coalesce(ledger."HPLedgerId", 0) = varToLedgerIds)
			AND (coalesce(varVapsiWorkingDays, 0) = 0
					OR ledger."LedgerId" IN (
						SELECT vd."LedgerId"
							FROM (
								SELECT vd."LedgerId", vd."VoucherDate"
								FROM "voucher_detail" AS vd
								WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
								AND (vd."RecordStatus" <> 'D')
								AND vd."VoucherType" IN (22,23,24)
								GROUP BY vd."LedgerId", vd."VoucherDate"
							) AS vd
						GROUP BY vd."LedgerId"
						HAVING count(1) >= varVapsiWorkingDays
					)
				)
			) AS l
		LEFT JOIN (SELECT
			(CASE WHEN ledger."ParentLedgerId" = 0 THEN vd."LedgerId" WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
																ELSE ledgerBaap."ParentLedgerId" END) AS "LedgerId", varFromDate AS "FromDate",
			sum(CASE WHEN vd."ShiftId" <> 0 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE - vd."Amount" END) ELSE 0 END) AS "ProfitAndLoss"
			FROM "voucher_detail" AS vd
			INNER JOIN "shift" shift ON vd."ShiftId" = shift."ShiftId" AND coalesce(shift."IsCreateVapsi", 1) = 1
			LEFT JOIN (SELECT ledger."LedgerId", ledger."ParentLedgerId" FROM "ledger" ledger
			WHERE (ledger."RecordStatus" <> 'D')
			AND ledger."OrganizationId" = varOrganizationId
			AND ledger."GroupId" IN (3,4,5)
			) AS ledger ON vd."LedgerId" = ledger."LedgerId"
			LEFT JOIN (SELECT ledger."LedgerId", ledger."ParentLedgerId" FROM "ledger" ledger
			WHERE (ledger."RecordStatus" <> 'D')
			AND ledger."OrganizationId" = varOrganizationId
			AND ledger."GroupId" IN (3,4,5)
			) AS ledgerBaap ON ledger."ParentLedgerId" = ledgerBaap."LedgerId"
			WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
			AND (CASE WHEN ledger."ParentLedgerId" = 0 THEN vd."LedgerId"
				WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
				ELSE ledgerBaap."ParentLedgerId" END) NOT IN (SELECT vapsi."LedgerId" FROM "vapsi" vapsi WHERE vapsi."RecordStatus" <> 'D' AND vapsi."VapsiFromDate" = varFromDate)
			AND (vd."RecordStatus" <> 'D')
			GROUP BY (CASE WHEN ledger."ParentLedgerId" = 0 THEN vd."LedgerId" WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
																ELSE ledgerBaap."ParentLedgerId" END)
			) AS vd ON vd."LedgerId" = l."LedgerId"
		LEFT JOIN (SELECT sum(h."Hissa") AS "Hissa", h."LedgerId" FROM "hissa" h WHERE h."LedgerId" <> h."HissaLedgerId" AND h."RecordStatus" <> 'D' GROUP BY h."LedgerId")
				AS hissa ON hissa."LedgerId" = l."LedgerId"
		GROUP BY l."LedgerId", l."Vapsi"
		,vd."FromDate", l."AddedDate", coalesce(hissa."Hissa", 0)
		HAVING (coalesce(sum(vd."ProfitAndLoss"), 0) > 0)
		ORDER BY l."LedgerId"
	LOOP
		varLedgerId := rec."LedgerId";
		varVapsiFromDate := rec."FromDate";
		varVapsiPercent := rec."Vapsi";
		varVapsiBaseAmount := rec."VapsiBaseAmount";
		varAmount := rec."vapsiAmount";

		/*      Voucher */
		INSERT INTO "voucher"("OrganizationId","VoucherDate","ShiftId","VoucherType","VoucherMode"
		,"Amount","Remark","LagaiKhai"
		,"RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
		VALUES(varOrganizationId,varTransactionDate,varShiftId,varVoucherType,'AUTO',varAmount,'AUTO_VAPSI',0
		,'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp)
		RETURNING "VoucherId" INTO v_VoucherId;

		/* Vapsi to party */
		IF varVapsiPercent - coalesce((SELECT sum(t."Vapsi")
						FROM "third_party_vapsi" t
						WHERE t."LedgerId" = varLedgerId
						AND t."RecordStatus" <> 'D'
					), 0) <> 0 THEN

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
			,(varAmount * (varVapsiPercent - coalesce((SELECT sum(t."Vapsi")
							FROM "third_party_vapsi" t
							WHERE t."LedgerId" = varLedgerId
							AND t."RecordStatus" <> 'D'
						), 0)) / NULLIF(varVapsiPercent, 0))
			,'Cr'
			,varOppositLedgerId
			,'','SELF',0,0
			,'False','AUTO',0
			,0
			,'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp)
			;
		END IF;

		/* Vapsi to TPV */
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
		SELECT varOrganizationId, v_VoucherId
		,(CASE WHEN tpv."VapsiLedgerId" = 11 THEN (CASE WHEN l."HPLedgerId" = 0 THEN l."LedgerId" ELSE l."HPLedgerId" END)
					ELSE tpv."VapsiLedgerId" END)
		,0,varShiftId
		,varTransactionDate
		,varVoucherType
		,varAmount * (coalesce(tpv."Vapsi", 0)) / NULLIF(varVapsiPercent, 0)
		,'Cr'
		,varOppositLedgerId
		,'',coalesce((SELECT max(l2."LedgerName") FROM "ledger" l2 WHERE l2."LedgerId" = varLedgerId), ''),0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp
		FROM "third_party_vapsi" tpv
		JOIN "ledger" l ON l."LedgerId" = tpv."LedgerId" AND l."RecordStatus" <> 'D'
		WHERE tpv."LedgerId" = varLedgerId
		AND tpv."RecordStatus" <> 'D'
		;

		/* Vapsi from Hissa -- (commented out in the MySQL source) */

		/* Vapsi from Vapsi Account */
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
		,varAmount
		,'Dr'
		,varLedgerId
		,'','AUTO_VAPSI',0,0
		,'False','AUTO',0
		,0
		,'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp
		)
		;

		/*      Vapsi Table Entry */
		INSERT INTO "vapsi"
		(
		"OrganizationId",
		"LedgerId",
		"ParentsLedgerId",
		"VoucherId",
		"VoucherDate",
		"VapsiFromDate",
		"VapsiToDate",
		"BaseAmount",
		"VapsiPercent",
		"VapsiAmount",
		"VapsiOn",
		"RecordStatus",
		"AddedBy",
		"AddedDate",
		"UpdatedBy",
		"UpdatedDate")
		SELECT
		varOrganizationId,
		varLedgerId,
		tp."VapsiLedgerId",
		v_VoucherId,
		varTransactionDate,
		varVapsiFromDate,
		varToDate,
		varVapsiBaseAmount,
		coalesce(tp."Vapsi", 0),
		varAmount * (coalesce(tp."Vapsi", 0)) / NULLIF(varVapsiPercent, 0),
		varVapsiAmountOn,
		'A',varLoginUserName,localtimestamp,varLoginUserName,localtimestamp
		FROM
		(
		SELECT varLedgerId AS "VapsiLedgerId", (varVapsiPercent - coalesce((SELECT sum(t."Vapsi")
							FROM "third_party_vapsi" t
							WHERE t."LedgerId" = varLedgerId
							AND t."RecordStatus" <> 'D'
						), 0)) AS "Vapsi"
		UNION ALL
		SELECT (CASE WHEN tpv."VapsiLedgerId" = 11 THEN l."HPLedgerId" ELSE tpv."VapsiLedgerId" END) AS "VapsiLedgerId", tpv."Vapsi"
		FROM "third_party_vapsi" tpv
		JOIN "ledger" l ON l."LedgerId" = tpv."LedgerId" AND l."RecordStatus" <> 'D'
		WHERE tpv."LedgerId" = varLedgerId
		AND tpv."RecordStatus" <> 'D'
		) AS tp WHERE tp."Vapsi" <> 0
		;

	END LOOP;
END;
$$;
