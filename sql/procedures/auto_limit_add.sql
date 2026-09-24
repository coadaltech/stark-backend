-- Converted from MySQL procedure `auto_limit_add`.
DROP ROUTINE IF EXISTS "auto_limit_add";
CREATE OR REPLACE PROCEDURE "auto_limit_add"(varOrganizationId bigint, varTransactionDate date, varAmount double precision)
LANGUAGE plpgsql AS $$
DECLARE
    v_VoucherId bigint := 0;
    varLimitType smallint := 2;
    varLimitId bigint := 6;
    varShiftId bigint := 0;
    varLedgerId integer := 0;
    rec record;
BEGIN
    varLimitType := 2;
    varLimitId := 6;
    varShiftId := 0;

    FOR rec IN
        SELECT l."LedgerId" FROM "ledger" l
        WHERE l."GroupId" = 5
          AND l."OrganizationId" = varOrganizationId
          AND l."AccountStatus" = '1'
          AND l."IsHide" = '0'
          AND l."RecordStatus" = 'A'
    LOOP
        varLedgerId := rec."LedgerId";

        /*     Sale Voucher */
        INSERT INTO "voucher"("OrganizationId","VoucherDate","ShiftId","VoucherType","VoucherMode",
                              "Amount","Remark","LagaiKhai",
                              "RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varLimitType, 'AUTO', varAmount, 'FIRST_LIMIT', 0,
                'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId",
                                     "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1",
                                     "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId",
                                     "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId, varLedgerId, 0, varShiftId,
                varTransactionDate, varLimitType, varAmount, 'Dr', varLimitId, '',
                'FIRST_LIMIT', 0, 0, 'False', 'AUTO', 0,
                0, 'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId",
                                     "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1",
                                     "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId",
                                     "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId, varLimitId, 0, varShiftId,
                varTransactionDate, varLimitType, varAmount, 'Cr', varLedgerId, '',
                'FIRST_LIMIT', 0, 0, 'False', 'AUTO', 0,
                0, 'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
    END LOOP;
END;
$$;
