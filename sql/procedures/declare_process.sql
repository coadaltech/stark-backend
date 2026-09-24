-- Converted from MySQL procedure `declare_process`.
-- No result set is sent to the client -> PROCEDURE.
-- Notes:
--  * local `VoucherId` renamed to v_VoucherId (column-name clash); LAST_INSERT_ID() -> INSERT ... RETURNING.
--  * voucher."VoucherMode": MySQL inserted integer 1 into ENUM('MANUAL','AUTO') = 'MANUAL'.
--  * ledger lookups use INTO STRICT + no_data_found handler so the preset defaults survive a missing
--    ledger (MySQL SELECT ... INTO keeps the old value on no row, errors on >1 row).
--  * unaggregated SelfHissa/OtherHissa in the GROUP BY inserts -> any_value(t."...").
DROP ROUTINE IF EXISTS "declare_process";
CREATE OR REPLACE PROCEDURE "declare_process"(
    varOrganizationId bigint,
    varShiftId bigint,
    varDeclareNumber smallint,
    varTransactionDate date
)
LANGUAGE plpgsql AS $$
DECLARE
    v_VoucherId bigint := 0;
    varNumberType smallint := 0;

    varSaleType smallint := 0;
    varSaleId bigint := 0;
    varProfitType smallint := 0;
    varProfitId bigint := 0;
    varCommitionType smallint := 0;
    varCommitionId bigint := 0;
    varHissaType smallint := 0;
    varHissaId bigint := 0;
    varHissaProfitType smallint := 0;
    varHissaProfitId bigint := 0;
    varTPCType smallint := 0;
    varTPCId bigint := 0;
    varNumberTypeWords varchar(200);

    varTaxId bigint := 12;
    varTaxType smallint := 35;
BEGIN
    UPDATE "sys_options" so SET "Value" = '1'
    WHERE so."Slug" = 'DeclareInQuee';

    varTaxType := 35;
    varTaxId := 12;
    varNumberType := 1;

    BEGIN
        SELECT l0."LedgerId" INTO STRICT varTaxId FROM "ledger" l0
        WHERE l0."LedgerName" = 'MANDI TAX A/C';
    EXCEPTION WHEN no_data_found THEN NULL;
    END;

    -- Khai process (TransactionMode = 1, LagaiKhai = 1)
    WHILE varNumberType <= 3 LOOP

        IF varNumberType = 1 THEN
            varNumberTypeWords := 'Dada';
            varSaleType := 22;
            varSaleId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varSaleId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varProfitType := 26;
            varProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varCommitionType := 25;
            varCommitionId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varCommitionId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaType := 29;
            varHissaId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaProfitType := 29;
            varHissaProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
            varTPCType := 32;
            varTPCId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varTPCId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
        ELSIF varNumberType = 2 THEN
            varNumberTypeWords := 'Bahar Ka Akhar';
            varSaleType := 23;
            varSaleId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varSaleId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varProfitType := 27;
            varProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varCommitionType := 25;
            varCommitionId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varCommitionId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaType := 30;
            varHissaId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaProfitType := 30;
            varHissaProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
            varTPCType := 32;
            varTPCId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varTPCId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
        ELSIF varNumberType = 3 THEN
            varNumberTypeWords := 'Andar Ka Akhar';
            varSaleType := 24;
            varSaleId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varSaleId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varProfitType := 28;
            varProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varCommitionType := 25;
            varCommitionId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varCommitionId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaType := 31;
            varHissaId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaProfitType := 31;
            varHissaProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
            varTPCType := 32;
            varTPCId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varTPCId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
        END IF;

        /*     Sale Voucher */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varSaleType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' Sale'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varSaleId,
            0, varShiftId,
            varTransactionDate,
            varSaleType,
            COALESCE((
                SELECT COALESCE(sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" ELSE 0 END, 0)), 0)
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
            ), 0),
            'Cr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            t."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varSaleType,
            COALESCE(sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" ELSE 0 END, 0)), 0),
            'Dr',
            varSaleId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
        GROUP BY t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission";


        /* Profit Voucher */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varProfitType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' Profit'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varProfitId,
            0, varShiftId,
            varTransactionDate,
            varProfitType,
            COALESCE((
                SELECT sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" * td."Rate" ELSE 0 END, 0))
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
            ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            COALESCE((
                SELECT sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" ELSE 0 END, 0))
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
            ), 0),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            t."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varProfitType,
            COALESCE(sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" * td."Rate" ELSE 0 END, 0)), 0),
            'Cr',
            varProfitId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', 0,
            COALESCE(sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" ELSE 0 END, 0)), 0),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
        GROUP BY t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission";


        /* Commission Voucher */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varCommitionType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' Comm.'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varCommitionId,
            0, varShiftId,
            varTransactionDate,
            varCommitionType,
            COALESCE((
                SELECT sum(COALESCE((td."Amount" * (td."Commission" - (CASE WHEN l."TPCommission" = 'No' THEN 0 ELSE COALESCE((SELECT sum(CASE WHEN varNumberType = 1 THEN tpc2."CommissionDara" ELSE tpc2."CommissionAkhar" END) FROM "third_party_commission" tpc2 WHERE tpc2."LedgerId" = t."LedgerId" AND tpc2."RecordStatus" != 'D'), 0) END))) / 100, 0))
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
            ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            t."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varCommitionType,
            COALESCE(sum(COALESCE((td."Amount" * (td."Commission" - (CASE WHEN l."TPCommission" = 'No' THEN 0 ELSE COALESCE((SELECT sum(CASE WHEN varNumberType = 1 THEN tpc2."CommissionDara" ELSE tpc2."CommissionAkhar" END) FROM "third_party_commission" tpc2 WHERE tpc2."LedgerId" = t."LedgerId" AND tpc2."RecordStatus" != 'D'), 0) END))) / 100, 0)), 0),
            'Cr',
            varCommitionId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND td."Commission" > 0
        GROUP BY t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission";


        /* TPC Return */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varTPCType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' TPC'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varTPCId,
            0, varShiftId,
            varTransactionDate,
            varTPCType,
            COALESCE((
                SELECT COALESCE(sum(COALESCE((td."Amount" * (CASE WHEN varNumberType = 1 THEN tpc."CommissionDara" ELSE tpc."CommissionAkhar" END)) / 100, 0)), 0)
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            INNER JOIN "third_party_commission" tpc ON tpc."LedgerId" = t."LedgerId" AND tpc."RecordStatus" != 'D'
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND l."TPCommission" = 'YES'
            ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            tpc."CommissionLedgerId",
            0, varShiftId,
            varTransactionDate,
            varTPCType,
            COALESCE(sum(COALESCE((td."Amount" * (CASE WHEN varNumberType = 1 THEN tpc."CommissionDara" ELSE tpc."CommissionAkhar" END)) / 100, 0)), 0),
            'Cr',
            varTPCId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', t."LedgerId",
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            INNER JOIN "third_party_commission" tpc ON tpc."LedgerId" = t."LedgerId" AND tpc."RecordStatus" != 'D'
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND l."TPCommission" = 'YES'
        GROUP BY tpc."CommissionLedgerId", t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission"
        HAVING COALESCE(sum(COALESCE((td."Amount" * (td."Commission")) / 100, 0)), 0) != 0;


        /* Hissa Voucher */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varHissaType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' Sale Hissa'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varHissaId,
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            COALESCE((
                SELECT sum(((td."FinalAmount") - ((td."FinalAmount") * COALESCE(t."SelfHissa" / 100, 0))) * COALESCE((SELECT sum(h2."Hissa") FROM "hissa" h2 WHERE h2."RecordStatus" != 'D' AND h2."LedgerId" = t."LedgerId" AND h2."LedgerId" != h2."HissaLedgerId") / 100, 0))
                + sum((td."FinalAmount") * COALESCE(t."SelfHissa" / 100, 0))
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
            ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        /* Self Hissa */

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            t."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            sum((td."FinalAmount" * COALESCE(t."SelfHissa", 0)) / 100),
            'Cr',
            varHissaId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', t."LedgerId",
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
        GROUP BY t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission"
        HAVING sum(td."FinalAmount" * COALESCE(t."SelfHissa", 0)) != 0;

        /* Other Hissa */

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            h."HissaLedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            sum((((td."FinalAmount") - (td."FinalAmount" * COALESCE(t."SelfHissa" / 100, 0))) * COALESCE(h."Hissa", 0)) / 100),
            'Cr',
            varHissaId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', t."LedgerId",
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            INNER JOIN "hissa" h ON h."RecordStatus" != 'D' AND h."LedgerId" = t."LedgerId" AND h."LedgerId" != h."HissaLedgerId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
        GROUP BY h."HissaLedgerId", t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission"
        HAVING sum(td."FinalAmount" * COALESCE(h."Hissa", 0)) != 0;


        /* Profit Hissa */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varHissaProfitType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' Profit Hissa'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varHissaProfitId,
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            COALESCE((
                SELECT sum(((td."Rate" * td."Amount") - ((td."Rate" * td."Amount") * COALESCE(t."SelfHissa" / 100, 0))) * COALESCE((SELECT sum(h2."Hissa") FROM "hissa" h2 WHERE h2."RecordStatus" != 'D' AND h2."LedgerId" = t."LedgerId" AND h2."LedgerId" != h2."HissaLedgerId") / 100, 0))
                + sum((td."Rate" * td."Amount") * COALESCE(t."SelfHissa" / 100, 0))
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
            ), 0),
            'Cr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        /* self hissa */

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            t."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            sum(((td."Rate" * td."Amount") * COALESCE(t."SelfHissa", 0)) / 100),
            'Dr',
            varHissaProfitId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', t."LedgerId",
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
        GROUP BY t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission"
        HAVING sum((td."Rate" * td."Amount") * COALESCE(t."SelfHissa", 0)) != 0;

        /* other hissa */

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            h."HissaLedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            sum((((td."Rate" * td."Amount") - ((td."Rate" * td."Amount") * COALESCE(t."SelfHissa" / 100, 0))) * COALESCE(h."Hissa", 0)) / 100),
            'Dr',
            varHissaProfitId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', t."LedgerId",
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            INNER JOIN "hissa" h ON h."RecordStatus" != 'D' AND h."LedgerId" = t."LedgerId" AND h."LedgerId" != h."HissaLedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 1
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
        GROUP BY h."HissaLedgerId", t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission"
        HAVING sum((td."Rate" * td."Amount") * COALESCE(h."Hissa", 0)) != 0;

        varNumberType := varNumberType + 1;
    END LOOP;

    varNumberType := 1;
    -- and transaction.TransactionMode = 1 Khai = 1 Lagai = 0 not using yet
    -- From here downwords is Lagai process (TransactionMode = 0, LagaiKhai = 0)
    WHILE varNumberType <= 3 LOOP

        IF varNumberType = 1 THEN
            varNumberTypeWords := 'Dada';
            varSaleType := 22;
            varSaleId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varSaleId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varProfitType := 26;
            varProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varCommitionType := 25;
            varCommitionId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varCommitionId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaType := 29;
            varHissaId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaProfitType := 29;
            varHissaProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
            varTPCType := 32;
            varTPCId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varTPCId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
        ELSIF varNumberType = 2 THEN
            varNumberTypeWords := 'Bahar Ka Akhar';
            varSaleType := 23;
            varSaleId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varSaleId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varProfitType := 27;
            varProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varCommitionType := 25;
            varCommitionId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varCommitionId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaType := 30;
            varHissaId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaProfitType := 30;
            varHissaProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
            varTPCType := 32;
            varTPCId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varTPCId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
        ELSIF varNumberType = 3 THEN
            varNumberTypeWords := 'Andar Ka Akhar';
            varSaleType := 24;
            varSaleId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varSaleId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varProfitType := 28;
            varProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varCommitionType := 25;
            varCommitionId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varCommitionId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaType := 31;
            varHissaId := 1002;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI SALE A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;

            varHissaProfitType := 31;
            varHissaProfitId := 1001;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varHissaProfitId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI P&L A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
            varTPCType := 32;
            varTPCId := 1006;
            BEGIN
                SELECT l0."LedgerId" INTO STRICT varTPCId FROM "ledger" l0
                WHERE l0."LedgerName" = 'MANDI COMMISSION A/C';  -- (MySQL: #and ledger.OrganizationId = varOrganizationId)
            EXCEPTION WHEN no_data_found THEN NULL;
            END;
        END IF;

        /*     Sale Voucher */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varSaleType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' Sale'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varSaleId,
            0, varShiftId,
            varTransactionDate,
            varSaleType,
            COALESCE((
                SELECT COALESCE(sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" ELSE 0 END, 0)), 0)
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
            ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            t."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varSaleType,
            COALESCE(sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" ELSE 0 END, 0)), 0),
            'Cr',
            varSaleId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
        GROUP BY t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission";


        /* Profit Voucher */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varProfitType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' Profit'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varProfitId,
            0, varShiftId,
            varTransactionDate,
            varProfitType,
            COALESCE((
                SELECT sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" * td."Rate" ELSE 0 END, 0))
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
            ), 0),
            'Cr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            COALESCE((
                SELECT sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" ELSE 0 END, 0))
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
            ), 0),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            t."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varProfitType,
            COALESCE(sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" * td."Rate" ELSE 0 END, 0)), 0),
            'Dr',
            varProfitId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', 0,
            COALESCE(sum(COALESCE(CASE WHEN t."RecordStatus" != 'D' AND td."RecordStatus" != 'D' THEN td."Amount" ELSE 0 END, 0)), 0),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
        GROUP BY t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission";


        /* Commission Voucher */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varCommitionType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' Comm.'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varCommitionId,
            0, varShiftId,
            varTransactionDate,
            varCommitionType,
            COALESCE((
                SELECT sum(COALESCE((td."Amount" * (td."Commission" - (CASE WHEN l."TPCommission" = 'No' THEN 0 ELSE COALESCE((SELECT sum(CASE WHEN varNumberType = 1 THEN tpc2."CommissionDara" ELSE tpc2."CommissionAkhar" END) FROM "third_party_commission" tpc2 WHERE tpc2."LedgerId" = t."LedgerId" AND tpc2."RecordStatus" != 'D'), 0) END))) / 100, 0))
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
            ), 0),
            'Cr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            t."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varCommitionType,
            COALESCE(sum(COALESCE((td."Amount" * (td."Commission" - (CASE WHEN l."TPCommission" = 'No' THEN 0 ELSE COALESCE((SELECT sum(CASE WHEN varNumberType = 1 THEN tpc2."CommissionDara" ELSE tpc2."CommissionAkhar" END) FROM "third_party_commission" tpc2 WHERE tpc2."LedgerId" = t."LedgerId" AND tpc2."RecordStatus" != 'D'), 0) END))) / 100, 0)), 0),
            'Dr',
            varCommitionId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND td."Commission" > 0
        GROUP BY t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission";


        /* Tax Voucher */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varTaxType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' Tax'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varTaxId,
            0, varShiftId,
            varTransactionDate,
            varTaxType,
            COALESCE((
                SELECT sum(COALESCE((td."Amount" * (td."Tax")) / 100, 0))
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
            ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            t."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varTaxType,
            COALESCE(sum(COALESCE((td."Amount" * (td."Tax")) / 100, 0)), 0),
            'Cr',
            varTaxId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
        GROUP BY t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission";


        /* TPC Return */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varTPCType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' TPC'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varTPCId,
            0, varShiftId,
            varTransactionDate,
            varTPCType,
            COALESCE((
                SELECT COALESCE(sum(COALESCE((td."Amount" * (CASE WHEN varNumberType = 1 THEN tpc."CommissionDara" ELSE tpc."CommissionAkhar" END)) / 100, 0)), 0)
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            INNER JOIN "third_party_commission" tpc ON tpc."LedgerId" = t."LedgerId" AND tpc."RecordStatus" != 'D'
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND l."TPCommission" = 'YES'
            ), 0),
            'Cr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            tpc."CommissionLedgerId",
            0, varShiftId,
            varTransactionDate,
            varTPCType,
            COALESCE(sum(COALESCE((td."Amount" * (CASE WHEN varNumberType = 1 THEN tpc."CommissionDara" ELSE tpc."CommissionAkhar" END)) / 100, 0)), 0),
            'Dr',
            varTPCId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', t."LedgerId",
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            INNER JOIN "third_party_commission" tpc ON tpc."LedgerId" = t."LedgerId" AND tpc."RecordStatus" != 'D'
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND l."TPCommission" = 'YES'
        GROUP BY tpc."CommissionLedgerId", t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission"
        HAVING COALESCE(sum(COALESCE((td."Amount" * (td."Commission")) / 100, 0)), 0) != 0;


        /* Hissa Voucher */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varHissaType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' Sale Hissa'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varHissaId,
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            COALESCE((
                SELECT sum(((td."FinalAmount") - ((td."FinalAmount") * COALESCE(t."SelfHissa" / 100, 0))) * COALESCE((SELECT sum(h2."Hissa") FROM "hissa" h2 WHERE h2."RecordStatus" != 'D' AND h2."LedgerId" = t."LedgerId" AND h2."LedgerId" != h2."HissaLedgerId") / 100, 0))
                + sum((td."FinalAmount") * COALESCE(t."SelfHissa" / 100, 0))
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
            ), 0),
            'Cr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        /* Self Hissa */

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            t."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            sum((td."FinalAmount" * COALESCE(t."SelfHissa", 0)) / 100),
            'Dr',
            varHissaId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', t."LedgerId",
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
        GROUP BY t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission"
        HAVING sum(td."FinalAmount" * COALESCE(t."SelfHissa", 0)) != 0;

        /* Other Hissa */

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            h."HissaLedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            sum((((td."FinalAmount") - (td."FinalAmount" * COALESCE(t."SelfHissa" / 100, 0))) * COALESCE(h."Hissa", 0)) / 100),
            'Dr',
            varHissaId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', t."LedgerId",
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            INNER JOIN "hissa" h ON h."RecordStatus" != 'D' AND h."LedgerId" = t."LedgerId" AND h."LedgerId" != h."HissaLedgerId"
            LEFT JOIN "ledger" l ON l."LedgerId" = t."LedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
        GROUP BY h."HissaLedgerId", t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission"
        HAVING sum(td."FinalAmount" * COALESCE(h."Hissa", 0)) != 0;


        /* Profit Hissa */

        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varHissaProfitType, 'MANUAL' /* MySQL: 1 = ENUM index 1 */,
            0, (varNumberTypeWords || ' Profit Hissa'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varHissaProfitId,
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            COALESCE((
                SELECT sum(((td."Rate" * td."Amount") - ((td."Rate" * td."Amount") * COALESCE(t."SelfHissa" / 100, 0))) * COALESCE((SELECT sum(h2."Hissa") FROM "hissa" h2 WHERE h2."RecordStatus" != 'D' AND h2."LedgerId" = t."LedgerId" AND h2."LedgerId" != h2."HissaLedgerId") / 100, 0))
                + sum((td."Rate" * td."Amount") * COALESCE(t."SelfHissa" / 100, 0))
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
            ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        /* self hissa */

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            t."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            sum(((td."Rate" * td."Amount") * COALESCE(t."SelfHissa", 0)) / 100),
            'Cr',
            varHissaProfitId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', t."LedgerId",
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
        GROUP BY t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission"
        HAVING sum((td."Rate" * td."Amount") * COALESCE(t."SelfHissa", 0)) != 0;

        /* other hissa */

        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType", "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa", "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            h."HissaLedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            sum((((td."Rate" * td."Amount") - ((td."Rate" * td."Amount") * COALESCE(t."SelfHissa" / 100, 0))) * COALESCE(h."Hissa", 0)) / 100),
            'Cr',
            varHissaProfitId,
            '', (t."DaraRate"::text || '/' || t."DaraCommission"::text || '-' || t."AkharRate"::text || '/' || t."AkharCommission"::text), any_value(t."SelfHissa"), any_value(t."OtherHissa"),
            'False', 'AUTO', t."LedgerId",
            0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction" t
            INNER JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
            INNER JOIN "hissa" h ON h."RecordStatus" != 'D' AND h."LedgerId" = t."LedgerId" AND h."LedgerId" != h."HissaLedgerId"
            WHERE t."TransactionDate" = varTransactionDate
              AND t."TransactionMode" = 0
              AND t."ShiftId" = varShiftId
              AND t."OrganizationId" = varOrganizationId
              AND t."RecordStatus" != 'D'
              AND td."RecordStatus" != 'D'
              AND td."NumberType" = varNumberType
              AND ((CASE WHEN td."Number" ~ '^[0-9]+$' THEN td."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                OR (td."Number" = right(lpad((mod(varDeclareNumber, 10) * 111)::text, 3, '0'), 3) AND varNumberType = 2)
                OR (td."Number" = right(lpad((mod(floor(varDeclareNumber::numeric / 10)::bigint, 10) * 1111)::text, 4, '0'), 4) AND varNumberType = 3))
        GROUP BY h."HissaLedgerId", t."LedgerId", t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission"
        HAVING sum((td."Rate" * td."Amount") * COALESCE(h."Hissa", 0)) != 0;

        varNumberType := varNumberType + 1;
    END LOOP;

    INSERT INTO "transaction_declare"
    ("TransactionId", "OrganizationId", "ShiftId", "LedgerId", "TransactionDate", "TransactionMode",
     "TransactionType", "KFlag", "EntryType", "ClientRemarks", "IsHissa", "SelfHissa", "OtherHissa",
     "DaraRate", "DaraCommission", "AkharRate", "AkharCommission", "Tax", "TotalAmount", "TotalCommission",
     "TotalTax", "FinalAmount", "TransactionStartTime", "DeviceType", "RecordStatus", "AddedBy", "AddedDate",
     "UpdatedBy", "UpdatedDate")
    SELECT t."TransactionId", t."OrganizationId", t."ShiftId", t."LedgerId", t."TransactionDate", t."TransactionMode",
        t."TransactionType", t."KFlag", t."EntryType", t."ClientRemarks", t."IsHissa", t."SelfHissa", t."OtherHissa",
        t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."Tax", t."TotalAmount", t."TotalCommission",
        t."TotalTax", t."FinalAmount", t."TransactionStartTime", t."DeviceType", t."RecordStatus", t."AddedBy", t."AddedDate",
        t."UpdatedBy", t."UpdatedDate"
    FROM "transaction" t
    WHERE t."ShiftId" = varShiftId
      AND t."TransactionDate" = varTransactionDate
      AND t."OrganizationId" = varOrganizationId;

    INSERT INTO "transaction_detail_declare"
    ("TransactionDetailId", "TransactionId", "OrganizationId", "Number", "NumberType", "Amount", "Rate",
     "Commission", "Tax", "FinalAmount", "OrderNumber", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT td."TransactionDetailId", td."TransactionId", td."OrganizationId", td."Number", td."NumberType", td."Amount", td."Rate",
        td."Commission", td."Tax", td."FinalAmount", td."OrderNumber", td."RecordStatus", td."AddedBy", td."AddedDate", td."UpdatedBy", td."UpdatedDate"
    FROM "transaction_detail" td
    WHERE td."TransactionId" IN (SELECT t."TransactionId" FROM "transaction" t
        WHERE t."ShiftId" = varShiftId
          AND t."TransactionDate" = varTransactionDate
          AND t."OrganizationId" = varOrganizationId);

    DELETE FROM "transaction_detail" td
    WHERE td."TransactionId" IN (SELECT t."TransactionId" FROM "transaction" t
        WHERE t."ShiftId" = varShiftId
          AND t."TransactionDate" = varTransactionDate
          AND t."OrganizationId" = varOrganizationId);

    DELETE FROM "transaction" t
    WHERE t."ShiftId" = varShiftId
      AND t."TransactionDate" = varTransactionDate
      AND t."OrganizationId" = varOrganizationId;

    UPDATE "shift" s SET "ShiftDate" = '1970-01-01'
    WHERE s."ShiftId" = varShiftId
      AND s."OrganizationId" = varOrganizationId;

    INSERT INTO "declare_result"("DeclareDate", "ShiftId", "OrganizationId", "DeclareNumber", "IsNeeded",
        "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    VALUES (varTransactionDate, varShiftId, varOrganizationId, varDeclareNumber, 'No',
        'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

    INSERT INTO "voucher_first"("VoucherId", "OrganizationId", "ShiftId", "VoucherDate", "VoucherType", "Amount",
        "Remark", "LagaiKhai", "VoucherMode", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT v."VoucherId", v."OrganizationId", v."ShiftId", v."VoucherDate", v."VoucherType", v."Amount",
        v."Remark", v."LagaiKhai", v."VoucherMode", v."RecordStatus", v."AddedBy", v."AddedDate", v."UpdatedBy", v."UpdatedDate"
    FROM "voucher" v
    WHERE v."OrganizationId" = varOrganizationId AND v."ShiftId" = varShiftId AND v."VoucherDate" = varTransactionDate;

    INSERT INTO "voucher_detail_first"("VoucherDetailId", "OrganizationId", "VoucherId", "ShiftId", "LedgerId",
        "OppositeLedgerId", "FromLedgerId", "VoucherType", "VoucherDetailType", "VoucherDate", "Amount", "AmountType",
        "OpenAmount", "SelfHissa", "OtherHissa", "Flag1", "Remark", "MondayFinalFlag", "VoucherMode", "RecordStatus",
        "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT vd."VoucherDetailId", vd."OrganizationId", vd."VoucherId", vd."ShiftId", vd."LedgerId",
        vd."OppositeLedgerId", vd."FromLedgerId", vd."VoucherType", vd."VoucherDetailType", vd."VoucherDate", vd."Amount", vd."AmountType",
        vd."OpenAmount", vd."SelfHissa", vd."OtherHissa", vd."Flag1", vd."Remark", vd."MondayFinalFlag", vd."VoucherMode", vd."RecordStatus",
        vd."AddedBy", vd."AddedDate", vd."UpdatedBy", vd."UpdatedDate"
    FROM "voucher_detail" vd
    WHERE vd."OrganizationId" = varOrganizationId
      AND vd."ShiftId" = varShiftId
      AND vd."VoucherDate" = varTransactionDate;

    UPDATE "sys_options" so SET "Value" = '0'
    WHERE so."Slug" = 'DeclareInQuee';
END;
$$;
