-- Converted from MySQL procedure `auto_transaction_lock_for_inactive`.
-- Local `VoucherId` renamed to v_VoucherId (column-name clash). MySQL `varAmount float` (single
-- precision) is double precision here, per conversion rules.
DROP ROUTINE IF EXISTS "auto_transaction_lock_for_inactive";
CREATE OR REPLACE FUNCTION "auto_transaction_lock_for_inactive"(
    varOrganizationId bigint,
    varTransactionDate date,
    varForDayas integer
)
RETURNS TABLE("Flag" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varLoginUserName varchar(50);
    rec_org record;
    rec record;
    varAmount double precision;
    v_VoucherId bigint := 0;
    varVoucherType smallint := 2;
    varOppositLedgerId bigint := 6;
    varShiftId bigint := 0;
    varLedgerId integer := 0;
BEGIN
    FOR rec_org IN
        SELECT o."OrganizationId", o."AbsentLedgerLockDays" FROM "organization" o
        WHERE (COALESCE(o."OrganizationId", 0) = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
          AND o."AbsentLedgerLockDays" > 0
          AND o."RecordStatus" != 'D'
    LOOP
        varOrganizationId := rec_org."OrganizationId";
        varForDayas := rec_org."AbsentLedgerLockDays";

        varVoucherType := 2;
        varOppositLedgerId := 6;
        varShiftId := 0;
        varLoginUserName := 'SYSTEM';

        FOR rec IN
            SELECT l."LedgerId", COALESCE(opbal.opening, 0) AS opening
            FROM (SELECT lg."LedgerId", lg."LedgerName"
                  FROM "ledger" lg WHERE lg."GroupId" = 5 AND lg."RecordStatus" != 'D'
                   AND COALESCE(lg."ParentLedgerId", 0) = 0
                   AND lg."OrganizationId" = varOrganizationId) AS l
            LEFT JOIN (
                SELECT t."LedgerId"
                FROM (SELECT td."LedgerId" FROM "transaction_declare" td
                        WHERE td."TransactionDate" BETWEEN (varTransactionDate - varForDayas) AND varTransactionDate
                          AND td."RecordStatus" != 'D'
                      UNION ALL
                      SELECT tr."LedgerId" FROM "transaction" tr
                        WHERE tr."TransactionDate" BETWEEN (varTransactionDate - varForDayas) AND varTransactionDate
                          AND tr."RecordStatus" != 'D'
                     ) AS t
                GROUP BY t."LedgerId"
            ) AS t ON t."LedgerId" = l."LedgerId"
            INNER JOIN (SELECT aa."LedgerId"
                            , sum((CASE WHEN aa."AmountType" = 'Dr' THEN COALESCE(aa."Amount", 0) ELSE -COALESCE(aa."Amount", 0) END)) AS opening
                        FROM "voucher_detail" aa
                        WHERE aa."VoucherType" = 2
                          AND aa."RecordStatus" != 'D'
                          AND aa."OrganizationId" = varOrganizationId
                        GROUP BY aa."LedgerId"
                       ) AS opbal ON opbal."LedgerId" = l."LedgerId"
            WHERE t."LedgerId" IS NULL
              AND opbal.opening > 0
            ORDER BY l."LedgerName"
        LOOP
            varLedgerId := rec."LedgerId";
            varAmount := rec.opening;

            IF varAmount > 0 THEN
                /*      Voucher */
                INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode"
                    , "Amount", "Remark", "LagaiKhai"
                    , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
                VALUES (varOrganizationId, varTransactionDate, varShiftId, varVoucherType, 'AUTO', varAmount, 'AUTO_LIMIT_REV_LOCK', 0
                    , 'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp)
                RETURNING "VoucherId" INTO v_VoucherId;

                /* Limit to party */
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
                    , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
                VALUES (varOrganizationId, v_VoucherId
                    , varLedgerId
                    , 0, varShiftId
                    , varTransactionDate
                    , varVoucherType
                    , varAmount
                    , 'Cr'
                    , varOppositLedgerId
                    , '0', 'AUTO_LIMIT_REV_LOCK', 0, 0
                    , 'False', 'AUTO', 0
                    , 0
                    , 'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp);

                /* party to Limit  */
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
                    , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
                VALUES (varOrganizationId, v_VoucherId
                    , varOppositLedgerId
                    , 0, varShiftId
                    , varTransactionDate
                    , varVoucherType
                    , varAmount
                    , 'Dr'
                    , varLedgerId
                    , '0', 'AUTO_LIMIT_REV_LOCK', 0, 0
                    , 'False', 'AUTO', 0
                    , 0
                    , 'A', varLoginUserName, localtimestamp, varLoginUserName, localtimestamp);
            END IF;
/*
            update ledger set TransactionLock = 1 where LedgerId  = varLedgerId
            ;
*/
        END LOOP;

        UPDATE "ledger" lu SET "TransactionLock" = 1
        WHERE lu."LedgerId" IN (
            SELECT l."LedgerId"
            FROM (SELECT lg."LedgerId", lg."LedgerName"
                  FROM "ledger" lg WHERE lg."GroupId" = 5 AND lg."RecordStatus" != 'D'
                   AND COALESCE(lg."ParentLedgerId", 0) = 0
                   AND lg."OrganizationId" = varOrganizationId) AS l
            LEFT JOIN (
                SELECT t."LedgerId"
                FROM (SELECT td."LedgerId" FROM "transaction_declare" td
                        WHERE td."TransactionDate" BETWEEN (varTransactionDate - varForDayas) AND varTransactionDate
                          AND td."RecordStatus" != 'D'
                      UNION ALL
                      SELECT tr."LedgerId" FROM "transaction" tr
                        WHERE tr."TransactionDate" BETWEEN (varTransactionDate - varForDayas) AND varTransactionDate
                          AND tr."RecordStatus" != 'D'
                     ) AS t
                GROUP BY t."LedgerId"
            ) AS t ON t."LedgerId" = l."LedgerId"
            WHERE t."LedgerId" IS NULL
        )
          AND lu."OrganizationId" = varOrganizationId
          AND lu."TransactionLock" = 0;

    END LOOP;

    RETURN QUERY SELECT 1 AS "Flag";
END;
$$;
