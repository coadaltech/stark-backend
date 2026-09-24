-- Converted from MySQL procedure `declare_process_Re`.
-- Re-declare: rebuilds the AUTO vouchers (Khai loop, TransactionMode = 1, then Lagai loop, TransactionMode = 0) for a
-- shift/date and bumps declare_result.ReDeclareNos. No result set is sent to the client.
-- Conversion notes:
--  * MySQL `SELECT LedgerId INTO v ... ` keeps the previous value when no row matches; emulated with
--    v := COALESCE((SELECT ...), v) (still errors on >1 row, like MySQL).
--  * voucher."VoucherMode" was inserted as integer 1 into a MySQL ENUM('MANUAL','AUTO') => enum index 1 = 'MANUAL'.
--  * transaction_detail_declare."Number" (varchar) = varDeclareNumber was a numeric comparison in MySQL; emulated for
--    all-digit Numbers. The Akhar targets (right(lpad(...))) are loop-invariant and precomputed into v_Num2 / v_Num3.
--  * Non-grouped SelfHissa/OtherHissa in the GROUP BY inserts -> any_value() (MySQL picked an arbitrary row too).
--  * Ledger-id variables widened from smallint to bigint (they hold ledger."LedgerId", bigint).
DROP ROUTINE IF EXISTS "declare_process_Re";
CREATE OR REPLACE PROCEDURE "declare_process_Re"(
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
    varAddedDate timestamp;

    v_Num2 text;
    v_Num3 text;
BEGIN
    varAddedDate := (SELECT dr."AddedDate"
                     FROM "declare_result" dr
                     WHERE dr."DeclareDate" = varTransactionDate
                       AND dr."ShiftId" = varShiftId
                       AND dr."OrganizationId" = varOrganizationId
                       AND dr."RecordStatus" <> 'D');

    varTaxId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI TAX A/C'), varTaxId);

    -- MySQL: right(lpad((varDeclareNumber mod 10) * 111, 3, '0'), 3) / right(lpad((floor(varDeclareNumber/10) mod 10) * 1111, 4, '0'), 4)
    v_Num2 := right(lpad(((varDeclareNumber % 10) * 111)::text, 3, '0'), 3);
    v_Num3 := right(lpad(((floor(varDeclareNumber::numeric / 10)::bigint % 10) * 1111)::text, 4, '0'), 4);

    /*
    delete from voucher_detail where VoucherId in (select voucher.VoucherId from voucher
        where voucher.OrganizationId = varOrganizationId and voucher.ShiftId = varShiftId and voucher.VoucherDate = varTransactionDate);
    */
    DELETE FROM "voucher_detail" vd
    WHERE vd."OrganizationId" = varOrganizationId AND vd."ShiftId" = varShiftId AND vd."VoucherDate" = varTransactionDate;

    DELETE FROM "voucher" v
    WHERE v."OrganizationId" = varOrganizationId AND v."ShiftId" = varShiftId AND v."VoucherDate" = varTransactionDate;

    varNumberType := 1;
    WHILE varNumberType <= 3 LOOP

        IF varNumberType = 1 THEN
            varNumberTypeWords := 'Dada';
            varSaleType := 22;
            varSaleId := 1002;
            varSaleId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varSaleId);

            varProfitType := 26;
            varProfitId := 1001;
            varProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varProfitId);

            varCommitionType := 25;
            varCommitionId := 1006;
            varCommitionId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varCommitionId);

            varHissaType := 29;
            varHissaId := 1002;
            varHissaId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaId);

            varHissaProfitType := 29;
            varHissaProfitId := 1001;
            varHissaProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaProfitId);
            varTPCType := 32;
            varTPCId := 1006;
            varTPCId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varTPCId);
        ELSIF varNumberType = 2 THEN
            varNumberTypeWords := 'Bahar Ka Akhar';
            varSaleType := 23;
            varSaleId := 1002;
            varSaleId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varSaleId);

            varProfitType := 27;
            varProfitId := 1001;
            varProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varProfitId);

            varCommitionType := 25;
            varCommitionId := 1006;
            varCommitionId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varCommitionId);

            varHissaType := 30;
            varHissaId := 1002;
            varHissaId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaId);

            varHissaProfitType := 30;
            varHissaProfitId := 1001;
            varHissaProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaProfitId);
            varTPCType := 32;
            varTPCId := 1006;
            varTPCId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varTPCId);
        ELSIF varNumberType = 3 THEN
            varNumberTypeWords := 'Andar Ka Akhar';
            varSaleType := 24;
            varSaleId := 1002;
            varSaleId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varSaleId);

            varProfitType := 28;
            varProfitId := 1001;
            varProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varProfitId);

            varCommitionType := 25;
            varCommitionId := 1006;
            varCommitionId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varCommitionId);

            varHissaType := 31;
            varHissaId := 1002;
            varHissaId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaId);

            varHissaProfitType := 31;
            varHissaProfitId := 1001;
            varHissaProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaProfitId);
            varTPCType := 32;
            varTPCId := 1006;
            varTPCId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varTPCId);
        END IF;

        /*     Sale Voucher */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varSaleType, 'MANUAL', 0, (varNumberTypeWords || ' Sale'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varSaleId,
            0, varShiftId,
            varTransactionDate,
            varSaleType,
            COALESCE((
            SELECT COALESCE(sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" ELSE 0 END, 0)), 0)
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        ), 0),
            'Cr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            td."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varSaleType,
            COALESCE(sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" ELSE 0 END, 0)), 0),
            'Dr',
            varSaleId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', 0,
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        GROUP BY td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission";

        /* Profit Voucher */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varProfitType, 'MANUAL', 0, (varNumberTypeWords || ' Profit'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varProfitId,
            0, varShiftId,
            varTransactionDate,
            varProfitType,
            COALESCE((
            SELECT sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" * tdd."Rate" ELSE 0 END, 0))
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        ), 0),
            'Dr',
            -- NOTE: MySQL source puts sum(Amount) into OppositeLedgerId here (kept as-is)
            COALESCE((
            SELECT sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" ELSE 0 END, 0))
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        ), 0)::bigint,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            td."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varProfitType,
            COALESCE(sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" * tdd."Rate" ELSE 0 END, 0)), 0),
            'Cr',
            varProfitId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', 0,
            COALESCE(sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" ELSE 0 END, 0)), 0)::bigint,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        GROUP BY td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission";

        /* Commission Voucher */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varCommitionType, 'MANUAL', 0, (varNumberTypeWords || ' Comm.'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varCommitionId,
            0, varShiftId,
            varTransactionDate,
            varCommitionType,
            COALESCE((
            SELECT sum(COALESCE((tdd."Amount" * (tdd."Commission" -
                (CASE WHEN l."TPCommission" = 'No' THEN 0 ELSE COALESCE((SELECT sum(CASE WHEN varNumberType = 1 THEN tpc2."CommissionDara" ELSE tpc2."CommissionAkhar" END) FROM "third_party_commission" tpc2 WHERE tpc2."LedgerId" = td."LedgerId" AND tpc2."RecordStatus" != 'D'), 0) END)
                )) / 100, 0))
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            td."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varCommitionType,
            COALESCE(sum(COALESCE((tdd."Amount" * (tdd."Commission" -
                (CASE WHEN l."TPCommission" = 'No' THEN 0 ELSE COALESCE((SELECT sum(CASE WHEN varNumberType = 1 THEN tpc2."CommissionDara" ELSE tpc2."CommissionAkhar" END) FROM "third_party_commission" tpc2 WHERE tpc2."LedgerId" = td."LedgerId" AND tpc2."RecordStatus" != 'D'), 0) END)
                )) / 100, 0)), 0),
            'Cr',
            varCommitionId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', 0,
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND tdd."Commission" > 0
        GROUP BY td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission";

        /* TPC Return */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varTPCType, 'MANUAL', 0, (varNumberTypeWords || ' TPC'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varTPCId,
            0, varShiftId,
            varTransactionDate,
            varTPCType,
            COALESCE((
            SELECT COALESCE(sum(COALESCE((tdd."Amount" * ((CASE WHEN varNumberType = 1 THEN tpc."CommissionDara" ELSE tpc."CommissionAkhar" END))) / 100, 0)), 0)
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            INNER JOIN "third_party_commission" tpc ON tpc."LedgerId" = td."LedgerId" AND tpc."RecordStatus" != 'D'
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND l."TPCommission" = 'YES'
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            tpc."CommissionLedgerId",
            0, varShiftId,
            varTransactionDate,
            varTPCType,
            COALESCE(sum(COALESCE((tdd."Amount" * ((CASE WHEN varNumberType = 1 THEN tpc."CommissionDara" ELSE tpc."CommissionAkhar" END))) / 100, 0)), 0),
            'Cr',
            varTPCId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', td."LedgerId",
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            INNER JOIN "third_party_commission" tpc ON tpc."LedgerId" = td."LedgerId" AND tpc."RecordStatus" != 'D'
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND l."TPCommission" = 'YES'
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        GROUP BY tpc."CommissionLedgerId", td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission"
        HAVING COALESCE(sum(COALESCE((tdd."Amount" * (tdd."Commission")) / 100, 0)), 0) != 0;

        /* Hissa Voucher */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varHissaType, 'MANUAL', 0, (varNumberTypeWords || ' Sale Hissa'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varHissaId,
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            COALESCE((
            SELECT
                sum((
                    (tdd."FinalAmount")
                    - (tdd."FinalAmount" * (COALESCE(td."SelfHissa", 0) / 100))
                ) * (COALESCE((SELECT sum(h2."Hissa") FROM "hissa" h2
                         WHERE h2."RecordStatus" != 'D' AND h2."LedgerId" = td."LedgerId" AND h2."LedgerId" != h2."HissaLedgerId"), 0) / 100))
                + sum(tdd."FinalAmount" * (COALESCE(td."SelfHissa", 0) / 100))
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        /* Self Hissa */
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            td."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            sum((tdd."FinalAmount" * COALESCE(td."SelfHissa", 0)) / 100),
            'Cr',
            varHissaId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', td."LedgerId",
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        GROUP BY td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission"
        HAVING sum(tdd."FinalAmount" * COALESCE(td."SelfHissa", 0)) != 0;
        /* Other Hissa */
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            h."HissaLedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            sum(((tdd."FinalAmount") - (tdd."FinalAmount" * (COALESCE(td."SelfHissa", 0) / 100))) * COALESCE(h."Hissa", 0) / 100),
            'Cr',
            varHissaId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', td."LedgerId",
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            INNER JOIN "hissa" h ON h."RecordStatus" != 'D' AND h."LedgerId" = td."LedgerId" AND h."LedgerId" != h."HissaLedgerId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        GROUP BY h."HissaLedgerId", td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission"
        HAVING sum(tdd."FinalAmount" * COALESCE(h."Hissa", 0)) != 0;

        /* Profit Hissa */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varHissaProfitType, 'MANUAL', 0, (varNumberTypeWords || ' Profit Hissa'), 1,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varHissaProfitId,
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            COALESCE((
            SELECT
                sum((
                    (tdd."Rate" * tdd."Amount")
                    - (tdd."Rate" * tdd."Amount" * (COALESCE(td."SelfHissa" / 100, 0)))
                ) * (COALESCE((SELECT sum(h2."Hissa") FROM "hissa" h2
                         WHERE h2."RecordStatus" != 'D' AND h2."LedgerId" = td."LedgerId" AND h2."LedgerId" != h2."HissaLedgerId") / 100, 0)))
                + sum((tdd."Rate" * tdd."Amount") * (COALESCE(td."SelfHissa" / 100, 0)))
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        ), 0),
            'Cr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        /* Self Hissa */
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            td."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            sum(((tdd."Rate" * tdd."Amount") * COALESCE(td."SelfHissa", 0)) / 100),
            'Dr',
            varHissaProfitId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', td."LedgerId",
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        GROUP BY td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission"
        HAVING sum((tdd."Rate" * tdd."Amount") * COALESCE(td."SelfHissa", 0)) != 0;
        /* Other Hissa */
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            h."HissaLedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            sum(((tdd."Rate" * tdd."Amount") - (tdd."Rate" * tdd."Amount" * (COALESCE(td."SelfHissa" / 100, 0)))) * COALESCE(h."Hissa", 0) / 100),
            'Dr',
            varHissaProfitId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', td."LedgerId",
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            INNER JOIN "hissa" h ON h."RecordStatus" != 'D' AND h."LedgerId" = td."LedgerId" AND h."LedgerId" != h."HissaLedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 1
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        GROUP BY h."HissaLedgerId", td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission"
        HAVING sum((tdd."Rate" * tdd."Amount") * COALESCE(h."Hissa", 0)) != 0;

        varNumberType := varNumberType + 1;
    END LOOP;

    -- and transaction.TransactionMode = 1 Khai = 1 Lagai = 0 not using yet
    -- From here downwards is Lagai process

    varNumberType := 1;
    WHILE varNumberType <= 3 LOOP

        IF varNumberType = 1 THEN
            varNumberTypeWords := 'Dada';
            varSaleType := 22;
            varSaleId := 1002;
            varSaleId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varSaleId);

            varProfitType := 26;
            varProfitId := 1001;
            varProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varProfitId);

            varCommitionType := 25;
            varCommitionId := 1006;
            varCommitionId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varCommitionId);

            varHissaType := 29;
            varHissaId := 1002;
            varHissaId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaId);

            varHissaProfitType := 29;
            varHissaProfitId := 1001;
            varHissaProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaProfitId);
            varTPCType := 32;
            varTPCId := 1006;
            varTPCId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varTPCId);
        ELSIF varNumberType = 2 THEN
            varNumberTypeWords := 'Bahar Ka Akhar';
            varSaleType := 23;
            varSaleId := 1002;
            varSaleId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varSaleId);

            varProfitType := 27;
            varProfitId := 1001;
            varProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varProfitId);

            varCommitionType := 25;
            varCommitionId := 1006;
            varCommitionId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varCommitionId);

            varHissaType := 30;
            varHissaId := 1002;
            varHissaId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaId);

            varHissaProfitType := 30;
            varHissaProfitId := 1001;
            varHissaProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaProfitId);
            varTPCType := 32;
            varTPCId := 1006;
            varTPCId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varTPCId);
        ELSIF varNumberType = 3 THEN
            varNumberTypeWords := 'Andar Ka Akhar';
            varSaleType := 24;
            varSaleId := 1002;
            varSaleId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varSaleId);

            varProfitType := 28;
            varProfitId := 1001;
            varProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varProfitId);

            varCommitionType := 25;
            varCommitionId := 1006;
            varCommitionId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varCommitionId);

            varHissaType := 31;
            varHissaId := 1002;
            varHissaId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI SALE A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaId);

            varHissaProfitType := 31;
            varHissaProfitId := 1001;
            varHissaProfitId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI P&L A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varHissaProfitId);
            varTPCType := 32;
            varTPCId := 1006;
            varTPCId := COALESCE((SELECT l."LedgerId" FROM "ledger" l WHERE l."LedgerName" = 'MANDI COMMISSION A/C'
                               /* and l."OrganizationId" = varOrganizationId */), varTPCId);
        END IF;

        /*     Sale Voucher */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varSaleType, 'MANUAL', 0, (varNumberTypeWords || ' Sale'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varSaleId,
            0, varShiftId,
            varTransactionDate,
            varSaleType,
            COALESCE((
            SELECT COALESCE(sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" ELSE 0 END, 0)), 0)
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            td."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varSaleType,
            COALESCE(sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" ELSE 0 END, 0)), 0),
            'Cr',
            varSaleId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', 0,
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        GROUP BY td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission";

        /* Profit Voucher */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varProfitType, 'MANUAL', 0, (varNumberTypeWords || ' Profit'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varProfitId,
            0, varShiftId,
            varTransactionDate,
            varProfitType,
            COALESCE((
            SELECT sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" * tdd."Rate" ELSE 0 END, 0))
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        ), 0),
            'Cr',
            -- NOTE: MySQL source puts sum(Amount) into OppositeLedgerId here (kept as-is)
            COALESCE((
            SELECT sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" ELSE 0 END, 0))
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        ), 0)::bigint,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            td."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varProfitType,
            COALESCE(sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" * tdd."Rate" ELSE 0 END, 0)), 0),
            'Dr',
            varProfitId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', 0,
            COALESCE(sum(COALESCE(CASE WHEN td."RecordStatus" != 'D' AND tdd."RecordStatus" != 'D' THEN tdd."Amount" ELSE 0 END, 0)), 0)::bigint,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        GROUP BY td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission";

        /* Commission Voucher */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varCommitionType, 'MANUAL', 0, (varNumberTypeWords || ' Comm.'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varCommitionId,
            0, varShiftId,
            varTransactionDate,
            varCommitionType,
            COALESCE((
            SELECT sum(COALESCE((tdd."Amount" * (tdd."Commission" -
                (CASE WHEN l."TPCommission" = 'No' THEN 0 ELSE COALESCE((SELECT sum(CASE WHEN varNumberType = 1 THEN tpc2."CommissionDara" ELSE tpc2."CommissionAkhar" END) FROM "third_party_commission" tpc2 WHERE tpc2."LedgerId" = td."LedgerId" AND tpc2."RecordStatus" != 'D'), 0) END)
                )) / 100, 0))
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        ), 0),
            'Cr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            td."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varCommitionType,
            COALESCE(sum(COALESCE((tdd."Amount" * (tdd."Commission" -
                (CASE WHEN l."TPCommission" = 'No' THEN 0 ELSE COALESCE((SELECT sum(CASE WHEN varNumberType = 1 THEN tpc2."CommissionDara" ELSE tpc2."CommissionAkhar" END) FROM "third_party_commission" tpc2 WHERE tpc2."LedgerId" = td."LedgerId" AND tpc2."RecordStatus" != 'D'), 0) END)
                )) / 100, 0)), 0),
            'Dr',
            varCommitionId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', 0,
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND tdd."Commission" > 0
        GROUP BY td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission";

        /* Tax Voucher */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varTaxType, 'MANUAL', 0, (varNumberTypeWords || ' Tax'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varTaxId,
            0, varShiftId,
            varTransactionDate,
            varTaxType,
            COALESCE((
            SELECT sum(COALESCE((tdd."Amount" * (tdd."Tax")) / 100, 0))
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            td."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varTaxType,
            COALESCE(sum(COALESCE((tdd."Amount" * (tdd."Tax")) / 100, 0)), 0),
            'Cr',
            varTaxId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', 0,
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        GROUP BY td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission";

        /* TPC Return */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varTPCType, 'MANUAL', 0, (varNumberTypeWords || ' TPC'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varTPCId,
            0, varShiftId,
            varTransactionDate,
            varTPCType,
            COALESCE((
            SELECT COALESCE(sum(COALESCE((tdd."Amount" * ((CASE WHEN varNumberType = 1 THEN tpc."CommissionDara" ELSE tpc."CommissionAkhar" END))) / 100, 0)), 0)
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            INNER JOIN "third_party_commission" tpc ON tpc."LedgerId" = td."LedgerId" AND tpc."RecordStatus" != 'D'
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND l."TPCommission" = 'YES'
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        ), 0),
            'Cr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            tpc."CommissionLedgerId",
            0, varShiftId,
            varTransactionDate,
            varTPCType,
            COALESCE(sum(COALESCE((tdd."Amount" * ((CASE WHEN varNumberType = 1 THEN tpc."CommissionDara" ELSE tpc."CommissionAkhar" END))) / 100, 0)), 0),
            'Dr',
            varTPCId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', td."LedgerId",
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            INNER JOIN "third_party_commission" tpc ON tpc."LedgerId" = td."LedgerId" AND tpc."RecordStatus" != 'D'
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND l."TPCommission" = 'YES'
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        GROUP BY tpc."CommissionLedgerId", td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission"
        HAVING COALESCE(sum(COALESCE((tdd."Amount" * (tdd."Commission")) / 100, 0)), 0) != 0;

        /* Hissa Voucher */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varHissaType, 'MANUAL', 0, (varNumberTypeWords || ' Sale Hissa'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varHissaId,
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            COALESCE((
            SELECT
                sum((
                    (tdd."FinalAmount")
                    - (tdd."FinalAmount" * (COALESCE(td."SelfHissa", 0) / 100))
                ) * (COALESCE((SELECT sum(h2."Hissa") FROM "hissa" h2
                         WHERE h2."RecordStatus" != 'D' AND h2."LedgerId" = td."LedgerId" AND h2."LedgerId" != h2."HissaLedgerId"), 0) / 100))
                + sum(tdd."FinalAmount" * (COALESCE(td."SelfHissa", 0) / 100))
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        ), 0),
            'Cr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        /* Self Hissa */
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            td."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            sum((tdd."FinalAmount" * COALESCE(td."SelfHissa", 0)) / 100),
            'Dr',
            varHissaId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', td."LedgerId",
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        GROUP BY td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission"
        HAVING sum(tdd."FinalAmount" * COALESCE(td."SelfHissa", 0)) != 0;
        /* Other Hissa */
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            h."HissaLedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaType,
            sum(((tdd."FinalAmount") - (tdd."FinalAmount" * (COALESCE(td."SelfHissa", 0) / 100))) * COALESCE(h."Hissa", 0) / 100),
            'Dr',
            varHissaId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', td."LedgerId",
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            INNER JOIN "hissa" h ON h."RecordStatus" != 'D' AND h."LedgerId" = td."LedgerId" AND h."LedgerId" != h."HissaLedgerId"
            LEFT JOIN "ledger" l ON l."LedgerId" = td."LedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
        GROUP BY h."HissaLedgerId", td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission"
        HAVING sum(tdd."FinalAmount" * COALESCE(h."Hissa", 0)) != 0;

        /* Profit Hissa */
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode",
            "Amount", "Remark", "LagaiKhai",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, varTransactionDate, varShiftId, varHissaProfitType, 'MANUAL', 0, (varNumberTypeWords || ' Profit Hissa'), 0,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO v_VoucherId;
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, v_VoucherId,
            varHissaProfitId,
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            COALESCE((
            SELECT
                sum((
                    (tdd."Rate" * tdd."Amount")
                    - (tdd."Rate" * tdd."Amount" * (COALESCE(td."SelfHissa" / 100, 0)))
                ) * (COALESCE((SELECT sum(h2."Hissa") FROM "hissa" h2
                         WHERE h2."RecordStatus" != 'D' AND h2."LedgerId" = td."LedgerId" AND h2."LedgerId" != h2."HissaLedgerId") / 100, 0)))
                + sum((tdd."Rate" * tdd."Amount") * (COALESCE(td."SelfHissa" / 100, 0)))
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        ), 0),
            'Dr',
            0,
            '', '', 0, 0,
            'False', 'AUTO', 0,
            0,
            'SERVER', localtimestamp,
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
        /* Self Hissa */
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            td."LedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            sum(((tdd."Rate" * tdd."Amount") * COALESCE(td."SelfHissa", 0)) / 100),
            'Cr',
            varHissaProfitId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', td."LedgerId",
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        GROUP BY td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission"
        HAVING sum((tdd."Rate" * tdd."Amount") * COALESCE(td."SelfHissa", 0)) != 0;
        /* Other Hissa */
        INSERT INTO "voucher_detail"("OrganizationId", "VoucherId", "LedgerId", "VoucherDetailType", "ShiftId", "VoucherDate", "VoucherType",
            "Amount", "AmountType", "OppositeLedgerId", "Flag1", "Remark", "SelfHissa", "OtherHissa",
            "MondayFinalFlag", "VoucherMode", "FromLedgerId", "OpenAmount", "VerifyBy", "VerifyDate",
            "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        SELECT varOrganizationId, v_VoucherId,
            h."HissaLedgerId",
            0, varShiftId,
            varTransactionDate,
            varHissaProfitType,
            sum(((tdd."Rate" * tdd."Amount") - (tdd."Rate" * tdd."Amount" * (COALESCE(td."SelfHissa" / 100, 0)))) * COALESCE(h."Hissa", 0) / 100),
            'Cr',
            varHissaProfitId,
            '', (td."DaraRate"::text || '/' || td."DaraCommission"::text || '-' || td."AkharRate"::text || '/' || td."AkharCommission"::text), any_value(td."SelfHissa"), any_value(td."OtherHissa"),
            'False', 'AUTO', td."LedgerId",
            0,
            (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN 'SERVER' ELSE NULL END), (CASE WHEN varAddedDate > max(tdd."UpdatedDate") THEN localtimestamp ELSE NULL END),
            'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp
            FROM "transaction_declare" td
            INNER JOIN "transaction_detail_declare" tdd ON td."TransactionId" = tdd."TransactionId"
            INNER JOIN "hissa" h ON h."RecordStatus" != 'D' AND h."LedgerId" = td."LedgerId" AND h."LedgerId" != h."HissaLedgerId"
            WHERE td."TransactionDate" = varTransactionDate
              AND td."TransactionMode" = 0
              AND td."ShiftId" = varShiftId
              AND td."OrganizationId" = varOrganizationId
              AND td."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
              AND tdd."NumberType" = varNumberType
              AND ((CASE WHEN tdd."Number" ~ '^[0-9]+$' THEN tdd."Number"::numeric END = varDeclareNumber AND varNumberType = 1)
                   OR (tdd."Number" = v_Num2 AND varNumberType = 2)
                   OR (tdd."Number" = v_Num3 AND varNumberType = 3))
        GROUP BY h."HissaLedgerId", td."LedgerId", td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission"
        HAVING sum((tdd."Rate" * tdd."Amount") * COALESCE(h."Hissa", 0)) != 0;

        varNumberType := varNumberType + 1;
    END LOOP;

    /* (commented-out block in MySQL source: update shift / insert declare_result / reset UpdateLimitFlag) */

    UPDATE "declare_result" dr SET "IsNeeded" = 'No',
        "ReDeclareNos" = dr."ReDeclareNos" + 1
    WHERE dr."DeclareDate" = varTransactionDate
      AND dr."ShiftId" = varShiftId
      AND dr."OrganizationId" = varOrganizationId
      AND dr."RecordStatus" <> 'D';
END
$$;
