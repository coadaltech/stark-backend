-- Converted from MySQL procedure `voucher_all_of_organization`.
-- NOTE: MySQL selected `v.VoucherId, vd.*, v.Remark, ...`, producing duplicate labels "VoucherId"
-- (same value) and "Remark" (vd.Remark then v.Remark). PG RETURNS TABLE cannot repeat names, so
-- "VoucherId" appears once (first position) and "Remark" carries v.Remark (the later duplicate, which
-- name-keyed clients saw); vd.Remark is not returned.
DROP ROUTINE IF EXISTS "voucher_all_of_organization";
CREATE OR REPLACE FUNCTION "voucher_all_of_organization"(
	varOrganizationId bigint
	, varFromDate date
	, varToDate date
	, varLedgerId bigint
	, varVoucherType integer
	, varAgentId bigint
	, varIsDeleted integer
)
RETURNS TABLE(
	"VoucherId" bigint
	,"VoucherDetailId" bigint
	,"OrganizationId" bigint
	,"ShiftId" bigint
	,"LedgerId" bigint
	,"OppositeLedgerId" bigint
	,"FromLedgerId" bigint
	,"VoucherType" integer
	,"VoucherDetailType" smallint
	,"VoucherDate" date
	,"Amount" double precision
	,"AmountType" text
	,"OpenAmount" bigint
	,"SelfHissa" double precision
	,"OtherHissa" double precision
	,"Flag1" text
	,"MondayFinalFlag" text
	,"VoucherMode" text
	,"VerifyBy" text
	,"VerifyDate" timestamp
	,"RecordStatus" text
	,"AddedBy" text
	,"AddedDate" timestamp
	,"UpdatedBy" text
	,"UpdatedDate" timestamp
	,"Remark" text
	,"VoucherRemark" text
	,"LedgerName" text
	,"OppositLedgerName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT v."VoucherId" AS "VoucherId"
		,vd."VoucherDetailId"
		,vd."OrganizationId"
		,vd."ShiftId"
		,vd."LedgerId"
		,vd."OppositeLedgerId"
		,vd."FromLedgerId"
		,vd."VoucherType"
		,vd."VoucherDetailType"
		,vd."VoucherDate"
		,vd."Amount"
		,vd."AmountType"::text
		,vd."OpenAmount"
		,vd."SelfHissa"
		,vd."OtherHissa"
		,vd."Flag1"::text
		,vd."MondayFinalFlag"::text
		,vd."VoucherMode"::text
		,vd."VerifyBy"::text
		,vd."VerifyDate"
		,vd."RecordStatus"::text
		,vd."AddedBy"::text
		,vd."AddedDate"
		,vd."UpdatedBy"::text
		,vd."UpdatedDate"
		,v."Remark"
		,(CASE WHEN coalesce(v."ShiftId", 0) <> 0 THEN '' ELSE v."Remark" END)::text AS "VoucherRemark"
		,l."LedgerName"::text AS "LedgerName", ol."LedgerName"::text AS "OppositLedgerName"
	FROM "voucher" v
	JOIN "voucher_detail" vd ON v."VoucherId" = vd."VoucherId"
	JOIN (SELECT min(x."VoucherDetailId") AS "VoucherDetailId" FROM "voucher_detail" x
			WHERE (CASE WHEN varIsDeleted = 1 THEN true ELSE x."RecordStatus" <> 'D' END)
			GROUP BY x."VoucherId") AS MinVoucher ON MinVoucher."VoucherDetailId" = vd."VoucherDetailId"
	JOIN "ledger" l ON vd."LedgerId" = l."LedgerId"
	JOIN "ledger" ol ON vd."OppositeLedgerId" = ol."LedgerId"
	WHERE v."OrganizationId" = varOrganizationId
	AND v."VoucherType" = varVoucherType
	AND v."VoucherDate" >= varFromDate
	AND v."VoucherDate" <= varToDate
	AND (coalesce(varLedgerId, 0) = 0 OR vd."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId
		OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
	AND (coalesce(varAgentId, 0) = 0 OR l."ParentLedgerId" IN (SELECT Res."LedgerId" FROM "ledger" AS Res
												WHERE Res."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."AgentLedgerId" = 31))
		)
	AND (CASE WHEN varIsDeleted = 1 THEN v."RecordStatus" = 'D' ELSE v."RecordStatus" <> 'D' AND vd."RecordStatus" <> 'D' END)
	ORDER BY vd."VoucherDate" DESC, vd."UpdatedDate" DESC;
END;
$$;
