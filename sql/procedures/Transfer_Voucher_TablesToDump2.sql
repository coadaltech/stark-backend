-- Converted from MySQL procedure `Transfer_Voucher_TablesToDump2`.
-- Note: VoucherDetailId was selected without being grouped (MySQL any value) -> any_value().
-- Numeric literals inserted into varchar columns (AddedBy/UpdatedBy -1, Flag1 0) are written as strings.
DROP ROUTINE IF EXISTS "Transfer_Voucher_TablesToDump2";
CREATE OR REPLACE PROCEDURE "Transfer_Voucher_TablesToDump2"(UpToDate date)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO "voucher_tmp"
        ("VoucherId", "OrganizationId", "ShiftId", "VoucherDate", "VoucherType", "Amount", "Remark", "LagaiKhai",
         "VoucherMode", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT -1, 0, 0, UpToDate, 1, 0, '', 0,
           NULL /* TODO(convert): MySQL inserted 0 into ENUM('MANUAL','AUTO') = '' error value; PG CHECK rejects '' -> NULL */,
           'S', '-1', localtimestamp, '-1', localtimestamp;

    INSERT INTO "voucher_detail_tmp"
        ("VoucherDetailId", "OrganizationId", "VoucherId", "ShiftId", "LedgerId", "OppositeLedgerId", "FromLedgerId",
         "VoucherType", "VoucherDetailType", "VoucherDate", "Amount", "AmountType", "OpenAmount", "SelfHissa", "OtherHissa",
         "Flag1", "Remark", "MondayFinalFlag", "VoucherMode", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT any_value(d."VoucherDetailId"),
           d."OrganizationId",
           -1,
           0,
           d."LedgerId",
           0,
           0,
           1,
           0,
           UpToDate,
           sum((CASE WHEN d."AmountType" = 'Dr' THEN d."Amount" ELSE -d."Amount" END)),
           'Dr',
           0,
           0,
           0,
           '0',
           '',
           'True',
           'AUTO',
           'S',
           '-1',
           localtimestamp,
           '-1',
           localtimestamp
    FROM "voucher_detail_dump" d
    WHERE d."VoucherType" != 2
      AND d."RecordStatus" <> 'D'
    GROUP BY d."LedgerId", d."OrganizationId";

    INSERT INTO "voucher_tmp"
        ("VoucherId", "OrganizationId", "ShiftId", "VoucherDate", "VoucherType", "Amount", "Remark", "LagaiKhai",
         "VoucherMode", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT -2, 0, 0, UpToDate, 2, 0, '', 0,
           NULL /* TODO(convert): MySQL inserted 0 into ENUM('MANUAL','AUTO') = '' error value; PG CHECK rejects '' -> NULL */,
           'S', '-1', localtimestamp, '-1', localtimestamp;

    INSERT INTO "voucher_detail_tmp"
        ("VoucherDetailId", "OrganizationId", "VoucherId", "ShiftId", "LedgerId", "OppositeLedgerId", "FromLedgerId",
         "VoucherType", "VoucherDetailType", "VoucherDate", "Amount", "AmountType", "OpenAmount", "SelfHissa", "OtherHissa",
         "Flag1", "Remark", "MondayFinalFlag", "VoucherMode", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    SELECT any_value(d."VoucherDetailId"),
           d."OrganizationId",
           -2,
           0,
           d."LedgerId",
           0,
           0,
           2,
           0,
           UpToDate,
           sum((CASE WHEN d."AmountType" = 'Dr' THEN d."Amount" ELSE -d."Amount" END)),
           'Dr',
           0,
           0,
           0,
           '0',
           '',
           'True',
           'AUTO',
           'S',
           '-1',
           localtimestamp,
           '-1',
           localtimestamp
    FROM "voucher_detail_dump" d
    WHERE d."VoucherType" = 2
      AND d."RecordStatus" <> 'D'
    GROUP BY d."LedgerId", d."OrganizationId";
END;
$$;
