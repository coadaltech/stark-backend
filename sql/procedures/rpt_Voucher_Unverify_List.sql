-- Converted from MySQL procedure `rpt_Voucher_Unverify_List`.
DROP ROUTINE IF EXISTS "rpt_Voucher_Unverify_List";
CREATE OR REPLACE FUNCTION "rpt_Voucher_Unverify_List"(varOrganizationId bigint)
RETURNS TABLE("ShiftId" bigint, "ShiftName" text, "VoucherDate" date, "UpdatedBy" text, "UpdatedDate" timestamp)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT vd."ShiftId", s."ShiftName"::text, vd."VoucherDate", vd."UpdatedBy"::text, vd."UpdatedDate"
    FROM (
        SELECT x."ShiftId", x."VoucherDate", x."UpdatedBy", any_value(x."UpdatedDate") AS "UpdatedDate"
        FROM "voucher_detail" x
        WHERE x."OrganizationId" = varOrganizationId
          AND x."LedgerId" > 100
          AND COALESCE(x."VerifyBy", '') = ''
        GROUP BY x."ShiftId", x."VoucherDate", x."UpdatedBy", x."UpdatedDate"::date
    ) AS vd
    JOIN "shift" s ON s."ShiftId" = vd."ShiftId"
    ORDER BY vd."VoucherDate", s."ShiftName";
END;
$$;
