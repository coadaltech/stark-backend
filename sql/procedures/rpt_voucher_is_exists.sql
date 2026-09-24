-- Converted from MySQL procedure `rpt_voucher_is_exists`.
DROP ROUTINE IF EXISTS "rpt_voucher_is_exists";
-- returns jsonb: [0] when varFlag = 0: one row {IsExists}; otherwise: matching voucher rows {VoucherId, AddedBy, AddedDate, UpdatedBy, UpdatedDate}
CREATE OR REPLACE FUNCTION "rpt_voucher_is_exists"(
    varOrganizationId bigint,
    varLedgerId bigint,
    varOppositeLedgerId bigint,
    varAmount double precision,
    varAmountType varchar,
    varVoucherDate date,
    varVoucherType integer,
    varFlag integer
)
RETURNS jsonb
LANGUAGE plpgsql AS $$
BEGIN
    CASE varFlag
    WHEN 0 THEN
        RETURN jsonb_build_array((SELECT coalesce(jsonb_agg(t), '[]'::jsonb) FROM (
            SELECT (CASE WHEN
                        (SELECT count(1) AS "NoofTrans"
                         FROM "voucher_detail" vd
                         WHERE vd."VoucherDate" = varVoucherDate
                           AND vd."RecordStatus" != 'D'
                           AND vd."VoucherType" = varVoucherType
                           AND vd."OrganizationId" = varOrganizationId
                           AND vd."LedgerId" = varLedgerId
                           AND vd."OppositeLedgerId" = varOppositeLedgerId
                           AND vd."Amount" = varAmount
                           AND vd."AmountType" = varAmountType
                        ) > 0 THEN 1
                    ELSE 0
                    END) AS "IsExists"
        ) t));
    ELSE
        RETURN jsonb_build_array((SELECT coalesce(jsonb_agg(t), '[]'::jsonb) FROM (
            SELECT vd."VoucherId",
                   vd."AddedBy",
                   vd."AddedDate",
                   vd."UpdatedBy",
                   vd."UpdatedDate"
            FROM "voucher_detail" vd
            WHERE vd."VoucherDate" = varVoucherDate
              AND vd."RecordStatus" != 'D'
              AND vd."VoucherType" = varVoucherType
              AND vd."OrganizationId" = varOrganizationId
              AND vd."LedgerId" = varLedgerId
              AND vd."OppositeLedgerId" = varOppositeLedgerId
              AND vd."Amount" = varAmount
              AND vd."AmountType" = varAmountType
        ) t));
    END CASE;
END;
$$;
