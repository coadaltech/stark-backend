-- Converted from MySQL procedure `process_hp_voucher`.
DROP ROUTINE IF EXISTS "process_hp_voucher";
CREATE OR REPLACE PROCEDURE "process_hp_voucher"(
    varOrganizationId bigint,
    varLedgerId bigint,
    varHPLedgerId bigint,
    varTransactionDate date,
    varFromDate date,
    varToDate date,
    varHPBaseAmount double precision,
    varAmount double precision,
    varHPPercent double precision,
    varLoginUserName varchar
)
LANGUAGE plpgsql AS $$
DECLARE
    v_VoucherId bigint := 0;
    varVoucherType smallint := 5;
    varOppositLedgerId bigint := 11;
    varShiftId bigint := 0;
BEGIN
    varVoucherType := 5;
    varOppositLedgerId := 11;
    varShiftId := 0;

    /*      Voucher */
    INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode"
        , "Amount", "Remark", "LagaiKhai"
        , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    VALUES (varOrganizationId, varTransactionDate, varShiftId, varVoucherType, 'AUTO', varAmount, 'AUTO_HP', 0
        , 'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp)
    RETURNING "VoucherId" INTO v_VoucherId;

    /* HP to party */
    INSERT INTO "voucher_detail"("OrganizationId",
        "VoucherId"
        , "LedgerId"
        , "VoucherDetailType", "ShiftId"
        , "VoucherDate"
        , "VoucherType"
        , "Amount"
        , "AmountType"
        , "OppositeLedgerId"
        , "Flag1"
        , "Remark", "SelfHissa", "OtherHissa"
        , "MondayFinalFlag", "VoucherMode", "FromLedgerId"
        , "OpenAmount"
        , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate"
    )
    VALUES (varOrganizationId, v_VoucherId
        , varHPLedgerId
        , 0, varShiftId
        , varTransactionDate
        , varVoucherType
        , (CASE WHEN varAmount > 0 THEN varAmount ELSE -varAmount END)
        , (CASE WHEN varAmount > 0 THEN 'Cr' ELSE 'Dr' END)
        , varOppositLedgerId
        , varLedgerId::text, (SELECT max(l."LedgerName") FROM "ledger" l WHERE l."LedgerId" = varLedgerId), 0, 0
        , 'False', 'AUTO', 0
        , 0
        , 'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp);

    /* HP from HP Account */
    INSERT INTO "voucher_detail"("OrganizationId",
        "VoucherId"
        , "LedgerId"
        , "VoucherDetailType", "ShiftId"
        , "VoucherDate"
        , "VoucherType"
        , "Amount"
        , "AmountType"
        , "OppositeLedgerId"
        , "Flag1"
        , "Remark", "SelfHissa", "OtherHissa"
        , "MondayFinalFlag", "VoucherMode", "FromLedgerId"
        , "OpenAmount"
        , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate"
    )
    VALUES (varOrganizationId, v_VoucherId
        , varOppositLedgerId
        , 0, varShiftId
        , varTransactionDate
        , varVoucherType
        , (CASE WHEN varAmount > 0 THEN varAmount ELSE -varAmount END)
        , (CASE WHEN varAmount > 0 THEN 'Dr' ELSE 'Cr' END)
        , varHPLedgerId
        , varLedgerId::text, (SELECT max(l."LedgerName") FROM "ledger" l WHERE l."LedgerId" = varLedgerId), 0, 0
        , 'False', 'AUTO', 0
        , 0
        , 'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp);

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
        'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp);
END;
$$;
