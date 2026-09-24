-- Converted from MySQL procedure `process_vapsi_voucher`.
DROP ROUTINE IF EXISTS "process_vapsi_voucher";
CREATE OR REPLACE PROCEDURE "process_vapsi_voucher"(
    varOrganizationId bigint,
    varLedgerId bigint,
    varTransactionDate date,
    varFromDate date,
    varToDate date,
    varVapsiBaseAmount double precision,
    varAmount double precision,
    varVapsiPercent double precision,
    varVapsiAmountOn integer,   -- 1 for P&L 2 for Payment
    varLoginUserName varchar
)
LANGUAGE plpgsql AS $$
DECLARE
    v_VoucherId bigint := 0;
    varVoucherType smallint := 4;
    varOppositLedgerId bigint := 5;
    varShiftId bigint := 0;
BEGIN
    varVoucherType := 4;
    varOppositLedgerId := 5;
    varShiftId := 0;

    /*      Voucher */
    INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
                          "Amount", "Remark", "LagaiKhai",
                          "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    VALUES (varOrganizationId, varTransactionDate, varShiftId, varVoucherType, 'AUTO', varAmount, 'AUTO_VAPSI', 0,
            'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp)
    RETURNING "VoucherId" INTO v_VoucherId;

    /* Vapsi to party */
    IF varVapsiPercent - COALESCE((SELECT sum(tpv."Vapsi")
                                     FROM "third_party_vapsi" tpv
                                     WHERE tpv."LedgerId" = varLedgerId
                                       AND tpv."RecordStatus" != 'D'), 0) <> 0 THEN
        INSERT INTO "voucher_detail"("OrganizationId",
                                 "VoucherId",
                                 "LedgerId",
                                 "VoucherDetailType", "ShiftId",
                                 "VoucherDate",
                                 "VoucherType",
                                 "Amount",
                                 "AmountType",
                                 "OppositeLedgerId",
                                 "Flag1",
                                 "Remark", "SelfHissa", "OtherHissa",
                                 "MondayFinalFlag", "VoucherMode", "FromLedgerId",
                                 "OpenAmount",
                                 "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
                varLedgerId,
                0, varShiftId,
                varTransactionDate,
                varVoucherType,
                (varAmount * (varVapsiPercent - COALESCE((SELECT sum(tpv."Vapsi")
                                     FROM "third_party_vapsi" tpv
                                     WHERE tpv."LedgerId" = varLedgerId
                                       AND tpv."RecordStatus" != 'D'), 0)) / NULLIF(varVapsiPercent, 0)),
                'Cr',
                varOppositLedgerId,
                '', 'SELF', 0, 0,
                'False', 'AUTO', 0,
                0,
                'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp);
    END IF;

    /* Vapsi to TPV */
    INSERT INTO "voucher_detail"("OrganizationId",
                                 "VoucherId",
                                 "LedgerId",
                                 "VoucherDetailType", "ShiftId",
                                 "VoucherDate",
                                 "VoucherType",
                                 "Amount",
                                 "AmountType",
                                 "OppositeLedgerId",
                                 "Flag1",
                                 "Remark", "SelfHissa", "OtherHissa",
                                 "MondayFinalFlag", "VoucherMode", "FromLedgerId",
                                 "OpenAmount",
                                 "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT varOrganizationId, v_VoucherId,
           (CASE WHEN t."VapsiLedgerId" = 11 THEN l."HPLedgerId" ELSE t."VapsiLedgerId" END),
           0, varShiftId,
           varTransactionDate,
           varVoucherType,
           varAmount * (COALESCE(t."Vapsi", 0)) / NULLIF(varVapsiPercent, 0),
           'Cr',
           varOppositLedgerId,
           '', COALESCE((SELECT max(lx."LedgerName") FROM "ledger" lx WHERE lx."LedgerId" = varLedgerId), ''), 0, 0,
           'False', 'AUTO', 0,
           0,
           'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp
    FROM "third_party_vapsi" t
    JOIN "ledger" l ON l."LedgerId" = t."LedgerId" AND l."RecordStatus" != 'D'
    WHERE t."LedgerId" = varLedgerId
      AND t."RecordStatus" != 'D';

    /* Vapsi from Hissa */
    /*
    insert into voucher_detail(...)
    select varOrganizationId,VoucherId ,HissaLedgerId ,0,varShiftId ,varTransactionDate ,varVoucherType
    ,varAmount * (ifnull(Hissa,0))/100 ,'Dr' ,varOppositLedgerId ,'','AUTO_VAPSI',0,0 ,'False','AUTO',0 ,0
    ,'A',varLoginUserName,CURRENT_TIMESTAMP(),varLoginUserName,CURRENT_TIMESTAMP()
    from hissa where LedgerId = varLedgerId and RecordStatus != 'D';
    */

    /* Vapsi from Vapsi Account */
    INSERT INTO "voucher_detail"("OrganizationId",
                                 "VoucherId",
                                 "LedgerId",
                                 "VoucherDetailType", "ShiftId",
                                 "VoucherDate",
                                 "VoucherType",
                                 "Amount",
                                 "AmountType",
                                 "OppositeLedgerId",
                                 "Flag1",
                                 "Remark", "SelfHissa", "OtherHissa",
                                 "MondayFinalFlag", "VoucherMode", "FromLedgerId",
                                 "OpenAmount",
                                 "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    VALUES (varOrganizationId, v_VoucherId,
            varOppositLedgerId,
            0, varShiftId,
            varTransactionDate,
            varVoucherType,
            varAmount,
            /*
            ,(varAmount * (100 - ifnull((select sum(Hissa) from hissa where LedgerId = varLedgerId and RecordStatus != 'D'),0))/100)
            */
            'Dr',
            varLedgerId,
            '', 'AUTO_VAPSI', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp);

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
    SELECT varOrganizationId,
           varLedgerId,
           tp."VapsiLedgerId",
           v_VoucherId,
           varTransactionDate,
           varFromDate,
           varToDate,
           varVapsiBaseAmount,
           COALESCE(tp."Vapsi", 0),
           varAmount * (COALESCE(tp."Vapsi", 0)) / NULLIF(varVapsiPercent, 0),
           varVapsiAmountOn,
           'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp
    FROM (
        SELECT varLedgerId AS "VapsiLedgerId",
               (varVapsiPercent - COALESCE((SELECT sum(tpv."Vapsi")
                                     FROM "third_party_vapsi" tpv
                                     WHERE tpv."LedgerId" = varLedgerId
                                       AND tpv."RecordStatus" != 'D'), 0)) AS "Vapsi"
        UNION ALL
        SELECT (CASE WHEN t."VapsiLedgerId" = 11 THEN l."HPLedgerId" ELSE t."VapsiLedgerId" END) AS "VapsiLedgerId", t."Vapsi"
        FROM "third_party_vapsi" t
        JOIN "ledger" l ON l."LedgerId" = t."LedgerId" AND l."RecordStatus" != 'D'
        WHERE t."LedgerId" = varLedgerId
          AND t."RecordStatus" != 'D'
    ) AS tp
    WHERE tp."Vapsi" != 0;
END;
$$;
