-- Converted from MySQL procedure `Transfer_Voucher_TablesToDump3`.
DROP ROUTINE IF EXISTS "Transfer_Voucher_TablesToDump3";
CREATE OR REPLACE PROCEDURE "Transfer_Voucher_TablesToDump3"(UpToDate date)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM "voucher" v
    WHERE v."VoucherDate" <= UpToDate;

    DELETE FROM "voucher_detail" vd
    WHERE vd."VoucherDate" <= UpToDate;
END;
$$;
