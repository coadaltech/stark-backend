-- Converted from MySQL procedure `auto_limit_close`.
DROP ROUTINE IF EXISTS "auto_limit_close";
CREATE OR REPLACE PROCEDURE "auto_limit_close"(varOrganizationId bigint, varTransactionDate date, varLoginUserName varchar)
LANGUAGE plpgsql AS $$
DECLARE
    varAmount double precision;
    v_VoucherId bigint := 0;
    varVoucherType smallint := 2;
    varOppositLedgerId bigint := 6;
    varShiftId bigint := 0;
    varLedgerId integer := 0;
    rec record;
BEGIN
    varVoucherType := 2;
    varOppositLedgerId := 6;
    varShiftId := 0;

    FOR rec IN
        SELECT l."LedgerId", opbal."opening"
        FROM (SELECT lg."LedgerId", lg."LedgerName"
              FROM "ledger" lg WHERE lg."GroupId" = 5 AND lg."RecordStatus" != 'D'
                AND COALESCE(lg."ParentLedgerId", 0) = 0
                AND lg."OrganizationId" = 1001) AS l   -- NOTE: hard-coded 1001 as in MySQL source
        LEFT JOIN (
            SELECT t."LedgerId"
            FROM (SELECT td."LedgerId" FROM "transaction_declare" td
                  WHERE td."TransactionDate" BETWEEN (varTransactionDate - 7) AND varTransactionDate
                    AND td."RecordStatus" != 'D'
                  UNION ALL
                  SELECT tr."LedgerId" FROM "transaction" tr
                  WHERE tr."TransactionDate" BETWEEN (varTransactionDate - 7) AND varTransactionDate
                    AND tr."RecordStatus" != 'D'
                 ) AS t
            GROUP BY t."LedgerId"
        ) AS t ON t."LedgerId" = l."LedgerId"
        INNER JOIN (SELECT aa."LedgerId",
                           sum((CASE WHEN aa."AmountType" = 'Dr' THEN COALESCE(aa."Amount", 0) ELSE -COALESCE(aa."Amount", 0) END)) AS "opening"
                    FROM "voucher_detail" aa
                    WHERE aa."VoucherType" = 2
                      AND aa."RecordStatus" != 'D'
                      AND aa."OrganizationId" = varOrganizationId
                    GROUP BY aa."LedgerId"
        ) AS opbal ON opbal."LedgerId" = l."LedgerId"
        WHERE t."LedgerId" IS NULL
          AND opbal."opening" > 0
        ORDER BY l."LedgerName"
    LOOP
        varLedgerId := rec."LedgerId";
        varAmount := rec."opening";

        /*      Voucher */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
                              "Amount", "Remark", "LagaiKhai",
                              "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varVoucherType, 'AUTO', varAmount, 'AUTO_LIMIT_REV', 0,
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
                '0', 'AUTO_LIMIT_REV', 0, 0,
                'False', 'AUTO', 0,
                0,
                'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp);

        /* party to HP  */
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
                '0', 'AUTO_LIMIT_REV', 0, 0,
                'False', 'AUTO', 0,
                0,
                'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp);

        UPDATE "ledger" SET "IsRisky" = 1 WHERE "ledger"."LedgerId" = varLedgerId;
    END LOOP;
END;
$$;
