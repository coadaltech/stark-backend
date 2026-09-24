-- Converted from MySQL procedure `rpt_admin_cash_voucher_audit`.
DROP ROUTINE IF EXISTS "rpt_admin_cash_voucher_audit";
CREATE OR REPLACE FUNCTION "rpt_admin_cash_voucher_audit"(
	varOrganizationId bigint
	,varLedgerId integer
)
RETURNS TABLE(
	"VoucherAuditId" bigint
	,"OrganizationId" bigint
	,"VoucherId" bigint
	,"LedgerId" bigint
	,"LedgerName" text
	,"OppositeLedgerId" bigint
	,"OppositeLegerName" text
	,"VoucherDate" date
	,"VoucherType" smallint
	,"Amount" double precision
	,"AmountType" text
	,"Remark" text
	,"AuditType" smallint
	,"AuditStatus" smallint
	,"RecordStatus" text
	,"AddedBy" text
	,"AddedDate" timestamp
	,"UpdatedBy" text
	,"UpdatedDate" timestamp
	,"IsOppositeFlag" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT
		va."VoucherAuditId",
		va."OrganizationId",
		va."VoucherId",
		(CASE WHEN va."OppositeLedgerId" = varLedgerId THEN va."LedgerId" ELSE va."OppositeLedgerId" END) AS "LedgerId",
		(CASE WHEN va."OppositeLedgerId" = varLedgerId THEN ledger."LedgerName" ELSE Opposite."LedgerName" END)::text AS "LedgerName",
		(CASE WHEN va."OppositeLedgerId" = varLedgerId THEN va."OppositeLedgerId" ELSE va."LedgerId" END) AS "OppositeLedgerId",
		(CASE WHEN va."OppositeLedgerId" = varLedgerId THEN Opposite."LedgerName" ELSE ledger."LedgerName" END)::text AS "OppositeLegerName",
		va."VoucherDate",
		va."VoucherType",
		va."Amount",
		(CASE WHEN va."OppositeLedgerId" = varLedgerId THEN (CASE WHEN va."AmountType" = 'Dr' THEN 'Cr' ELSE 'Dr' END) ELSE va."AmountType" END)::text AS "AmountType",
		va."Remark",
		va."AuditType",
		va."AuditStatus",
		va."RecordStatus"::text,
		va."AddedBy"::text,
		va."AddedDate",
		va."UpdatedBy"::text,
		va."UpdatedDate"
		,(CASE WHEN va."OppositeLedgerId" = varLedgerId THEN 1 ELSE 0 END) AS "IsOppositeFlag"
	FROM "voucher_audit" va
	JOIN "ledger" ledger ON ledger."LedgerId" = va."LedgerId"
	JOIN "ledger" AS Opposite ON Opposite."LedgerId" = va."OppositeLedgerId"
	WHERE va."OrganizationId" = varOrganizationId
	AND va."RecordStatus" <> 'D'
	AND (va."LedgerId" = varLedgerId OR va."OppositeLedgerId" = varLedgerId)
	AND va."AuditStatus" = 1
	AND va."AuditType" = 1

	UNION ALL

	SELECT
		voucher_audit."VoucherAuditId",
		voucher_audit."OrganizationId",
		voucher_audit."VoucherId",
		voucher_audit."LedgerId",
		ledger."LedgerName"::text AS "LedgerName",
		voucher_audit."OppositeLedgerId",
		Opposite."LedgerName"::text AS "OppositeLegerName",
		voucher_audit."VoucherDate",
		voucher_audit."VoucherType",
		voucher_audit."Amount",
		voucher_audit."AmountType"::text,
		voucher_audit."Remark",
		voucher_audit."AuditType",
		voucher_audit."AuditStatus",
		voucher_audit."RecordStatus"::text,
		voucher_audit."AddedBy"::text,
		voucher_audit."AddedDate",
		voucher_audit."UpdatedBy"::text,
		voucher_audit."UpdatedDate"
		,voucher_audit."IsOppositeFlag"
	FROM
		(
		SELECT
			va."VoucherAuditId",
			va."OrganizationId",
			va."VoucherId",
			(CASE WHEN coalesce(va."OppositeLedgerId", 0) = varLedgerId OR vd."OppositeLedgerId" = varLedgerId
				THEN
					(CASE WHEN coalesce(va."LedgerId", 0) <> 0 THEN va."LedgerId" ELSE vd."LedgerId" END)
				ELSE
					(CASE WHEN coalesce(va."OppositeLedgerId", 0) <> 0 THEN va."OppositeLedgerId" ELSE vd."OppositeLedgerId" END)
				END) AS "LedgerId",
			(CASE WHEN coalesce(va."OppositeLedgerId", 0) = varLedgerId OR vd."OppositeLedgerId" = varLedgerId
				THEN
					(CASE WHEN coalesce(va."OppositeLedgerId", 0) <> 0 THEN va."OppositeLedgerId" ELSE vd."OppositeLedgerId" END)
				ELSE
					(CASE WHEN coalesce(va."LedgerId", 0) <> 0 THEN va."LedgerId" ELSE vd."LedgerId" END)
				END) AS "OppositeLedgerId",
			va."VoucherDate",
			va."VoucherType",
			(CASE WHEN coalesce(va."Amount", 0) <> 0 THEN va."Amount" ELSE vd."Amount" END) AS "Amount",
			(CASE WHEN coalesce(va."OppositeLedgerId", 0) = varLedgerId OR vd."OppositeLedgerId" = varLedgerId
				THEN
					(CASE WHEN coalesce(va."OppositeLedgerId", 0) <> 0 THEN (CASE WHEN va."AmountType" = 'Dr' THEN 'Cr' ELSE 'Dr' END) ELSE (CASE WHEN vd."AmountType" = 'Dr' THEN 'Cr' ELSE 'Dr' END) END)
				ELSE
					(CASE WHEN coalesce(va."OppositeLedgerId", 0) <> 0 THEN va."AmountType" ELSE vd."AmountType" END)
				END) AS "AmountType",
			va."Remark",
			va."AuditType",
			va."AuditStatus",
			va."RecordStatus",
			va."AddedBy",
			va."AddedDate",
			va."UpdatedBy",
			va."UpdatedDate"
			,(CASE WHEN va."OppositeLedgerId" = varLedgerId OR vd."OppositeLedgerId" = varLedgerId THEN 1 ELSE 0 END) AS "IsOppositeFlag"
		FROM "voucher_audit" va
		JOIN "voucher_detail" vd ON va."VoucherId" = vd."VoucherId" AND (CASE WHEN va."AuditType" IN (2,3) THEN true ELSE vd."RecordStatus" <> 'D' END)
		JOIN (SELECT min(v."VoucherDetailId") AS "VoucherDetailId"
			,min(CASE WHEN v."RecordStatus" <> 'D' THEN 9223372036854000000 ELSE v."VoucherDetailId" END) AS "VoucherDetailIdWithoutDeleted"
			FROM "voucher_detail" v
			/* where voucher_detail.RecordStatus != 'D' */
			GROUP BY v."VoucherId") AS MinVoucher ON (CASE WHEN va."AuditType" IN (2,3) THEN
												MinVoucher."VoucherDetailId" = vd."VoucherDetailId"
											ELSE
												MinVoucher."VoucherDetailIdWithoutDeleted" = vd."VoucherDetailId"
											END)
		WHERE va."OrganizationId" = varOrganizationId
		AND va."RecordStatus" <> 'D'
		AND (va."LedgerId" = varLedgerId OR va."OppositeLedgerId" = varLedgerId OR vd."LedgerId" = varLedgerId OR vd."OppositeLedgerId" = varLedgerId)
		AND va."AuditStatus" = 1
		AND va."AuditType" <> 1
	) AS voucher_audit
	LEFT JOIN "ledger" ledger ON ledger."LedgerId" = voucher_audit."LedgerId"
	LEFT JOIN "ledger" AS Opposite ON Opposite."LedgerId" = voucher_audit."OppositeLedgerId"

	ORDER BY 1
	;
END;
$$;
