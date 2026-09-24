-- Converted from MySQL procedure `rpt_Daily_List_Voucher_Verify_Process`.
DROP ROUTINE IF EXISTS "rpt_Daily_List_Voucher_Verify_Process";
CREATE OR REPLACE FUNCTION "rpt_Daily_List_Voucher_Verify_Process"(
    varOrganizationId bigint,
    varShiftIds bigint,
    varShiftDate date,
    varLedgerId bigint,
    varVarifyBy varchar,
    varVerifyDate timestamp,
    IsVerify integer)
RETURNS TABLE("1" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    IF IsVerify = 1 THEN
        -- NOTE: original MySQL sets VerifyBy = varVerifyDate (not varVarifyBy); preserved as-is.
        UPDATE "voucher_detail" vd SET
            "VerifyBy" = varVerifyDate::text,
            "VerifyDate" = varVerifyDate
        WHERE (vd."VoucherDate" = varShiftDate)
          AND (vd."ShiftId" = varShiftIds)
          AND (vd."LedgerId" = varLedgerId
               OR vd."LedgerId" IN (SELECT l."LedgerId" FROM "ledger" l WHERE l."ParentLedgerId" = varLedgerId))
          AND (vd."RecordStatus" != 'D')
          AND vd."OrganizationId" = varOrganizationId;
    ELSE
        UPDATE "voucher_detail" vd SET
            "VerifyBy" = NULL,
            "VerifyDate" = NULL
        WHERE (vd."VoucherDate" = varShiftDate)
          AND (vd."ShiftId" = varShiftIds)
          AND (vd."LedgerId" = varLedgerId
               OR vd."LedgerId" IN (SELECT l."LedgerId" FROM "ledger" l WHERE l."ParentLedgerId" = varLedgerId))
          AND (vd."RecordStatus" != 'D')
          AND vd."OrganizationId" = varOrganizationId;
    END IF;

    RETURN QUERY SELECT 1;
END;
$$;
