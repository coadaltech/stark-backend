-- Converted from MySQL procedure `rpt_ledger_summary`.
DROP ROUTINE IF EXISTS "rpt_ledger_summary";
CREATE OR REPLACE FUNCTION "rpt_ledger_summary"(
	varOrganizationId bigint
	,varLedgerId bigint
)
RETURNS TABLE(
	"InVoucher" numeric
	,"TotalDr" double precision
	,"TotalCr" double precision
	,"InHissa" numeric
	,"InTPC" numeric
	,"InTPV" numeric
	,"InHPLedger" numeric
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT sum(summary."InVoucher")::numeric AS "InVoucher"
		, sum(summary."TotalDr") AS "TotalDr"
		, sum(summary."TotalCr") AS "TotalCr"
		, sum(summary."InHissa")::numeric AS "InHissa"
		, sum(summary."InTPC")::numeric AS "InTPC"
		, sum(summary."InTPV")::numeric AS "InTPV"
		, sum(summary."InHPLedger")::numeric AS "InHPLedger"
	FROM
		(
		SELECT
			sum(1) AS "InVoucher"
			, sum(CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE 0 END) AS "TotalDr"
			, sum(CASE WHEN vd."AmountType" = 'Cr' THEN vd."Amount" ELSE 0 END) AS "TotalCr"
			,0::bigint AS "InHissa"
			,0::bigint AS "InTPC"
			,0::bigint AS "InTPV"
			,0::bigint AS "InHPLedger"
		FROM "voucher_detail" vd
		WHERE vd."OrganizationId" = varOrganizationId
		AND vd."VoucherType" <> 2
		AND vd."LedgerId" = varLedgerId
		AND vd."RecordStatus" <> 'D'
		UNION ALL
		SELECT
			0 AS "InVoucher"
			, 0 AS "TotalDr"
			, 0 AS "TotalCr"
			,(SELECT count(1) FROM "hissa" h
			WHERE h."OrganizationId" = varOrganizationId
			AND h."HissaLedgerId" = varLedgerId
			AND h."RecordStatus" <> 'D'
			) AS "InHissa"
			,(SELECT count(1) FROM "third_party_commission" c
			WHERE c."OrganizationId" = varOrganizationId
			AND c."CommissionLedgerId" = varLedgerId
			AND c."RecordStatus" <> 'D'
			) AS "InTPC"
			,(SELECT count(1) FROM "third_party_vapsi" v
			WHERE v."OrganizationId" = varOrganizationId
			AND v."VapsiLedgerId" = varLedgerId
			AND v."RecordStatus" <> 'D'
			) AS "InTPV"
			,(SELECT count(1) FROM "ledger" l
			WHERE l."OrganizationId" = varOrganizationId
			AND l."HPLedgerId" = varLedgerId
			AND l."RecordStatus" <> 'D'
			) AS "InHPLedger"
		) AS summary
	;
END;
$$;
