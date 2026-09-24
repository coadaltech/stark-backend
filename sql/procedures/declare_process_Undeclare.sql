-- Converted from MySQL procedure `declare_process_Undeclare`.
DROP ROUTINE IF EXISTS "declare_process_Undeclare";
CREATE OR REPLACE PROCEDURE "declare_process_Undeclare"(
    varOrganizationId bigint,
    varShiftId bigint,
    varDeclareNumber smallint,
    varTransactionDate date)
LANGUAGE plpgsql AS $$
BEGIN
    /*
    delete from voucher_detail where VoucherId in (select voucher.VoucherId from voucher
        where voucher.OrganizationId = varOrganizationId and voucher.ShiftId = varShiftId and voucher.VoucherDate = varTransactionDate);
    */
    DELETE FROM "voucher_detail" vd
    WHERE vd."OrganizationId" = varOrganizationId AND vd."ShiftId" = varShiftId AND vd."VoucherDate" = varTransactionDate;

    DELETE FROM "voucher" v
    WHERE v."OrganizationId" = varOrganizationId AND v."ShiftId" = varShiftId AND v."VoucherDate" = varTransactionDate;

    INSERT INTO "transaction"
        ("TransactionId", "OrganizationId", "ShiftId", "LedgerId", "TransactionDate", "TransactionMode",
         "TransactionType", "KFlag", "EntryType", "ClientRemarks", "IsHissa", "SelfHissa", "OtherHissa",
         "DaraRate", "DaraCommission", "AkharRate", "AkharCommission", "Tax", "TotalAmount", "TotalCommission",
         "TotalTax", "FinalAmount", "TransactionStartTime", "DeviceType", "RecordStatus", "AddedBy", "AddedDate",
         "UpdatedBy", "UpdatedDate")
    SELECT td."TransactionId", td."OrganizationId", td."ShiftId", td."LedgerId", td."TransactionDate", td."TransactionMode",
           td."TransactionType", td."KFlag", td."EntryType", td."ClientRemarks", td."IsHissa", td."SelfHissa", td."OtherHissa",
           td."DaraRate", td."DaraCommission", td."AkharRate", td."AkharCommission", td."Tax", td."TotalAmount", td."TotalCommission",
           td."TotalTax", td."FinalAmount", td."TransactionStartTime", td."DeviceType", td."RecordStatus", td."AddedBy", td."AddedDate",
           td."UpdatedBy", td."UpdatedDate"
    FROM "transaction_declare" td
    WHERE td."ShiftId" = varShiftId
      AND td."TransactionDate" = varTransactionDate
      AND td."OrganizationId" = varOrganizationId;

    INSERT INTO "transaction_detail"
        ("TransactionDetailId", "TransactionId", "OrganizationId", "Number", "NumberType", "Amount", "Rate",
         "Commission", "Tax", "FinalAmount", "OrderNumber", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT tdd."TransactionDetailId", tdd."TransactionId", tdd."OrganizationId", tdd."Number", tdd."NumberType", tdd."Amount", tdd."Rate",
           tdd."Commission", tdd."Tax", tdd."FinalAmount", tdd."OrderNumber", tdd."RecordStatus", tdd."AddedBy", tdd."AddedDate", tdd."UpdatedBy", tdd."UpdatedDate"
    FROM "transaction_detail_declare" tdd
    WHERE tdd."TransactionId" IN (SELECT td."TransactionId" FROM "transaction_declare" td
                                  WHERE td."ShiftId" = varShiftId
                                    AND td."TransactionDate" = varTransactionDate
                                    AND td."OrganizationId" = varOrganizationId);

    DELETE FROM "transaction_detail_declare" tdd
    WHERE tdd."TransactionId" IN (SELECT td."TransactionId" FROM "transaction_declare" td
                                  WHERE td."ShiftId" = varShiftId
                                    AND td."TransactionDate" = varTransactionDate
                                    AND td."OrganizationId" = varOrganizationId);

    DELETE FROM "transaction_declare" td
    WHERE td."ShiftId" = varShiftId
      AND td."TransactionDate" = varTransactionDate
      AND td."OrganizationId" = varOrganizationId;

    UPDATE "shift" s SET
        "ShiftDate" = varTransactionDate
    WHERE s."ShiftId" = varShiftId
      AND s."OrganizationId" = varOrganizationId;

    DELETE FROM "declare_result" dr
    WHERE dr."DeclareDate" = varTransactionDate AND dr."ShiftId" = varShiftId AND dr."OrganizationId" = varOrganizationId;
END;
$$;
