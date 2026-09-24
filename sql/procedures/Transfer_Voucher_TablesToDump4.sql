-- Converted from MySQL procedure `Transfer_Voucher_TablesToDump4`.
-- NOTE: parameter UpToDate is unused (as in the MySQL source).
DROP ROUTINE IF EXISTS "Transfer_Voucher_TablesToDump4";
CREATE OR REPLACE PROCEDURE "Transfer_Voucher_TablesToDump4"(UpToDate date)
LANGUAGE plpgsql AS $$
BEGIN
	INSERT INTO "voucher"
	("VoucherId","OrganizationId","ShiftId","VoucherDate","VoucherType","Amount","Remark","LagaiKhai","VoucherMode","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
	SELECT vt."VoucherId",vt."OrganizationId",vt."ShiftId",vt."VoucherDate",vt."VoucherType",vt."Amount",vt."Remark",vt."LagaiKhai",vt."VoucherMode",vt."RecordStatus",vt."AddedBy",vt."AddedDate",vt."UpdatedBy",vt."UpdatedDate"
	FROM "voucher_tmp" vt
	;

	INSERT INTO "voucher_detail"
	("VoucherDetailId","OrganizationId","VoucherId","ShiftId","LedgerId","OppositeLedgerId","FromLedgerId","VoucherType","VoucherDetailType","VoucherDate","Amount","AmountType","OpenAmount","SelfHissa","OtherHissa","Flag1","Remark","MondayFinalFlag","VoucherMode","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
	SELECT vdt."VoucherDetailId",vdt."OrganizationId",vdt."VoucherId",vdt."ShiftId",vdt."LedgerId",vdt."OppositeLedgerId",vdt."FromLedgerId",vdt."VoucherType",vdt."VoucherDetailType",vdt."VoucherDate",vdt."Amount",vdt."AmountType",vdt."OpenAmount",vdt."SelfHissa",vdt."OtherHissa",vdt."Flag1",vdt."Remark",vdt."MondayFinalFlag",vdt."VoucherMode",vdt."RecordStatus",vdt."AddedBy",vdt."AddedDate",vdt."UpdatedBy",vdt."UpdatedDate"
	FROM "voucher_detail_tmp" vdt
	;

	-- MySQL advances AUTO_INCREMENT past explicitly inserted ids; PG identity sequences do not.
	PERFORM setval(pg_get_serial_sequence('"voucher"', 'VoucherId'), coalesce(max(v."VoucherId"), 0) + 1, false) FROM "voucher" v;
	PERFORM setval(pg_get_serial_sequence('"voucher_detail"', 'VoucherDetailId'), coalesce(max(vd."VoucherDetailId"), 0) + 1, false) FROM "voucher_detail" vd;
END;
$$;
