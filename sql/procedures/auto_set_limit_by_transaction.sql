-- Converted from MySQL procedure `auto_set_limit_by_transaction`.
DROP ROUTINE IF EXISTS "auto_set_limit_by_transaction";
CREATE OR REPLACE FUNCTION "auto_set_limit_by_transaction"(
    varOrganizationId bigint,
    varTransactionDate date,
    varLimitMultipule integer,
    varForDayas integer
)
RETURNS TABLE("Flag" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varLoginUserName varchar(50);
    varAmount double precision;
    v_VoucherId bigint;
    varVoucherType smallint;
    varOppositLedgerId bigint;
    varShiftId bigint;
    varLedgerId integer;
    orgrec record;
    rec record;
BEGIN
    FOR orgrec IN
        SELECT o."OrganizationId", o."AbsentLedgerLockDays"
        FROM "organization" o
        WHERE (COALESCE(o."OrganizationId", 0) = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
          AND o."AbsentLedgerLockDays" > 0
          AND o."RecordStatus" != 'D'
    LOOP
        varOrganizationId := orgrec."OrganizationId";
        varForDayas := orgrec."AbsentLedgerLockDays";

        IF varLimitMultipule < 1 THEN
            varLimitMultipule := 1;
        END IF;

        -- inner block (MySQL BEGIN ... END with its own declarations)
        v_VoucherId := 0;
        varVoucherType := 2;
        varOppositLedgerId := 6;
        varShiftId := 0;
        varLedgerId := 0;
        varLoginUserName := 'SYSTEM';

        FOR rec IN
            SELECT tdc."LedgerId",
                   (COALESCE(opbal."opening", 0) - COALESCE(tdc."TotalAmount", 0) * varLimitMultipule) AS "opening"
            FROM (
                SELECT x."LedgerId",
                       (round(avg(x."TotalAmount")::numeric, -2)) AS "TotalAmount"
                FROM (
                    SELECT td."LedgerId", td."TransactionDate", sum((td."TotalAmount")) AS "TotalAmount"
                    FROM "transaction_declare" td
                    WHERE td."OrganizationId" = varOrganizationId
                      AND td."RecordStatus" <> 'D'
                      AND td."TransactionDate" > '2024-11-30'::date
                    GROUP BY td."LedgerId", td."TransactionDate"
                ) AS x
                GROUP BY x."LedgerId"
            ) AS tdc
            INNER JOIN (SELECT aa."LedgerId",
                               sum((CASE WHEN aa."AmountType" = 'Dr' THEN COALESCE(aa."Amount", 0) ELSE -COALESCE(aa."Amount", 0) END)) AS "opening"
                        FROM "voucher_detail" aa
                        WHERE aa."VoucherType" = 2
                          AND aa."RecordStatus" != 'D'
                          AND aa."OrganizationId" = varOrganizationId
                        GROUP BY aa."LedgerId"
            ) AS opbal ON opbal."LedgerId" = tdc."LedgerId"
            LEFT JOIN "ledger" l ON l."LedgerId" = tdc."LedgerId"
            WHERE l."GroupId" = 5 AND l."RecordStatus" != 'D'
              AND COALESCE(l."ParentLedgerId", 0) = 0
              AND (COALESCE(opbal."opening", 0) - COALESCE(tdc."TotalAmount", 0) * varLimitMultipule) > 0
        LOOP
            varLedgerId := rec."LedgerId";
            varAmount := rec."opening";

            IF varAmount > 0 THEN
                /*      Voucher */
                INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
                                      "Amount", "Remark", "LagaiKhai",
                                      "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
                VALUES (varOrganizationId, varTransactionDate, varShiftId, varVoucherType, 'AUTO', varAmount, 'AUTO_SET_REMOVE_LIMIT', 0,
                        'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp)
                RETURNING "VoucherId" INTO v_VoucherId;

                /* Limit to party */
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
                        varAmount,
                        'Cr',
                        varOppositLedgerId,
                        '0', 'AUTO_SET_REMOVE_LIMIT', 0, 0,
                        'False', 'AUTO', 0,
                        0,
                        'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp);

                /* party to Limit  */
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
                        'Dr',
                        varLedgerId,
                        '0', 'AUTO_SET_REMOVE_LIMIT', 0, 0,
                        'False', 'AUTO', 0,
                        0,
                        'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp);
            END IF;
            /*
            update ledger set TransactionLock = 1 where LedgerId  = varLedgerId
            ;
            */
        END LOOP;
    END LOOP;

    RETURN QUERY SELECT 1 AS "Flag";
END;
$$;
