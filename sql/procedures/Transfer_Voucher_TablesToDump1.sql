-- Converted from MySQL procedure `Transfer_Voucher_TablesToDump1`.
-- The commented-out ALTER TABLE DROP/ADD INDEX blocks of the original are omitted (they were inactive).
DROP ROUTINE IF EXISTS "Transfer_Voucher_TablesToDump1";
CREATE OR REPLACE PROCEDURE "Transfer_Voucher_TablesToDump1"(UpToDate date)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM "voucher_tmp";
    DELETE FROM "voucher_detail_tmp";

    INSERT INTO "voucher_dump"
    ("VoucherId", "OrganizationId", "ShiftId", "VoucherDate", "VoucherType", "Amount", "Remark",
     "LagaiKhai", "VoucherMode", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT v."VoucherId", v."OrganizationId", v."ShiftId", v."VoucherDate", v."VoucherType", v."Amount", v."Remark",
           v."LagaiKhai", v."VoucherMode", v."RecordStatus", v."AddedBy", v."AddedDate", v."UpdatedBy", v."UpdatedDate"
    FROM "voucher" v
    WHERE v."VoucherDate" <= UpToDate
      AND v."RecordStatus" <> 'D'
      AND v."VoucherId" NOT IN (-1, -2);

    INSERT INTO "voucher_detail_dump"
    ("VoucherDetailId", "OrganizationId", "VoucherId", "ShiftId", "LedgerId", "OppositeLedgerId", "FromLedgerId",
     "VoucherType", "VoucherDetailType", "VoucherDate", "Amount", "AmountType", "OpenAmount", "SelfHissa",
     "OtherHissa", "Flag1", "Remark", "MondayFinalFlag", "VoucherMode", "RecordStatus", "AddedBy", "AddedDate",
     "UpdatedBy", "UpdatedDate")
    SELECT vd."VoucherDetailId", vd."OrganizationId", vd."VoucherId", vd."ShiftId", vd."LedgerId", vd."OppositeLedgerId", vd."FromLedgerId",
           vd."VoucherType", vd."VoucherDetailType", vd."VoucherDate", vd."Amount", vd."AmountType", vd."OpenAmount", vd."SelfHissa",
           vd."OtherHissa", vd."Flag1", vd."Remark", vd."MondayFinalFlag", vd."VoucherMode", vd."RecordStatus", vd."AddedBy", vd."AddedDate",
           vd."UpdatedBy", vd."UpdatedDate"
    FROM "voucher_detail" vd
    WHERE vd."VoucherDate" <= UpToDate
      AND vd."RecordStatus" <> 'D'
      AND vd."VoucherId" NOT IN (-1, -2);
END;
$$;
