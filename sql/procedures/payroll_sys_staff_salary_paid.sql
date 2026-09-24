-- Converted from MySQL procedure `payroll_sys_staff_salary_paid`.
-- NOTE: MySQL declared varAmount / varDeductions / varKistAmount as FLOAT (single precision); double precision is used here.
DROP ROUTINE IF EXISTS "payroll_sys_staff_salary_paid";
CREATE OR REPLACE FUNCTION "payroll_sys_staff_salary_paid"(
    varOrganizationId integer,
    varMonth integer,
    varYear integer,
    varLedgerId bigint,
    varSalaryId bigint
)
RETURNS TABLE("Flag" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varVoucherId bigint;
    varAmount double precision;
    varDeductions double precision;
    varVoucherType integer;
    varSalaryLedgerId integer;

    varKistVoucherType integer;
    varKistLedgerId integer;

    recLedger record;
    recKist record;
    varKistId bigint;
    varKistAmount double precision;
    varKistStatus varchar(20);
BEGIN
/*
    (MySQL source had a commented-out block deleting previous salary vouchers / resetting payroll_salary.VoucherId)
*/

    varVoucherType := 1;      -- voucher type 1 for genral voucher
    varSalaryLedgerId := 14;  -- Salary Account LedgerId

    varKistVoucherType := 3;  -- voucher type 1 for kist voucher
    varKistLedgerId := 7;     -- kist Account LedgerId

    -- cursor curLedger (query evaluated once at open, before the params are overwritten by FETCH)
    <<getLedger>>
    FOR recLedger IN
        SELECT ps."SalaryId", ps."LedgerId", ps."Deductions", ps."NetSalary"
        FROM "payroll_salary" ps
        WHERE (ps."OrganizationId" = varOrganizationId)
          AND (COALESCE(ps."LedgerId", 0) = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
          AND (COALESCE(ps."SalaryId", 0) = varSalaryId OR COALESCE(varSalaryId, 0) = 0)
          AND COALESCE(ps."VoucherId", 0) = 0
          AND ps."RecordStatus" != 'D'
          AND ps."SalaryMonth" = varMonth
          AND ps."SalaryYear" = varYear
    LOOP
        -- FETCH curLedger INTO varSalaryId, varLedgerId, varDeductions, varAmount;
        varSalaryId := recLedger."SalaryId";
        varLedgerId := recLedger."LedgerId";
        varDeductions := recLedger."Deductions";
        varAmount := recLedger."NetSalary";

        <<getkist>>
        FOR recKist IN
            SELECT psd."KistId", psd."Amount", kist."KistStatus"
            FROM "payroll_salary_detail" psd
            JOIN "kist" ON kist."KistId" = psd."KistId"
            WHERE psd."RecordStatus" = 'A'
              AND psd."OrganizationId" = varOrganizationId
              AND psd."SalaryId" = varSalaryId
              AND psd."KistId" != 0
        LOOP
            varKistId := recKist."KistId";
            varKistAmount := recKist."Amount";
            varKistStatus := recKist."KistStatus";

            varDeductions := varDeductions - varKistAmount;
            varAmount := varAmount + varKistAmount;

            IF varKistStatus = 'UNPAID' THEN
                varVoucherId := 0;

                INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode"
                    , "Amount", "Remark", "LagaiKhai"
                    , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
                VALUES (varOrganizationId, current_date, 0, varKistVoucherType, 'AUTO', varKistAmount, 'KIST IN SALARY', 1
                    , 'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
                RETURNING "VoucherId" INTO varVoucherId;

                INSERT INTO "voucher_detail"("OrganizationId",
                    "VoucherId"
                    , "LedgerId"
                    , "VoucherDetailType", "ShiftId"
                    , "VoucherDate"
                    , "VoucherType"
                    , "Amount"
                    , "AmountType"
                    , "OppositeLedgerId"
                    , "Flag1"
                    , "Remark", "SelfHissa", "OtherHissa"
                    , "MondayFinalFlag", "VoucherMode", "FromLedgerId"
                    , "OpenAmount"
                    , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate"
                )
                VALUES (varOrganizationId, varVoucherId
                    , varLedgerId
                    , 0, 0
                    , current_date
                    , varKistVoucherType
                    , varKistAmount
                    , 'Dr'
                    , varKistLedgerId
                    , '', '', 0, 0
                    , 'False', 'AUTO', 0
                    , 0
                    , 'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

                INSERT INTO "voucher_detail"("OrganizationId",
                    "VoucherId"
                    , "LedgerId"
                    , "VoucherDetailType", "ShiftId"
                    , "VoucherDate"
                    , "VoucherType"
                    , "Amount"
                    , "AmountType"
                    , "OppositeLedgerId"
                    , "Flag1"
                    , "Remark", "SelfHissa", "OtherHissa"
                    , "MondayFinalFlag", "VoucherMode", "FromLedgerId"
                    , "OpenAmount"
                    , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate"
                )
                VALUES (varOrganizationId, varVoucherId
                    , varKistLedgerId
                    , 0, 0
                    , current_date
                    , varKistVoucherType
                    , varKistAmount
                    , 'Cr'
                    , varLedgerId
                    , '', '', 0, 0
                    , 'False', 'AUTO', 0
                    , 0
                    , 'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

                UPDATE "kist" SET "PaidVoucherId" = varVoucherId
                    , "KistStatus" = 'PAID'
                WHERE COALESCE(kist."KistId", 0) = varKistId;
            END IF;
        END LOOP getkist;

        varVoucherId := 0;
        INSERT INTO "voucher"("OrganizationId", "VoucherDate", "ShiftId", "VoucherType", "VoucherMode"
            , "Amount", "Remark", "LagaiKhai"
            , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
        VALUES (varOrganizationId, current_date, 0, varVoucherType, 'AUTO', varAmount, 'SALARY', 1
            , 'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
        RETURNING "VoucherId" INTO varVoucherId;

        INSERT INTO "voucher_detail"("OrganizationId",
            "VoucherId"
            , "LedgerId"
            , "VoucherDetailType", "ShiftId"
            , "VoucherDate"
            , "VoucherType"
            , "Amount"
            , "AmountType"
            , "OppositeLedgerId"
            , "Flag1"
            , "Remark", "SelfHissa", "OtherHissa"
            , "MondayFinalFlag", "VoucherMode", "FromLedgerId"
            , "OpenAmount"
            , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate"
        )
        VALUES (varOrganizationId, varVoucherId
            , varLedgerId
            , 0, 0
            , current_date
            , varVoucherType
            , varAmount
            , 'Cr'
            , varSalaryLedgerId
            , '', '', 0, 0
            , 'False', 'AUTO', 0
            , 0
            , 'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        INSERT INTO "voucher_detail"("OrganizationId",
            "VoucherId"
            , "LedgerId"
            , "VoucherDetailType", "ShiftId"
            , "VoucherDate"
            , "VoucherType"
            , "Amount"
            , "AmountType"
            , "OppositeLedgerId"
            , "Flag1"
            , "Remark", "SelfHissa", "OtherHissa"
            , "MondayFinalFlag", "VoucherMode", "FromLedgerId"
            , "OpenAmount"
            , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate"
        )
        VALUES (varOrganizationId, varVoucherId
            , varSalaryLedgerId
            , 0, 0
            , current_date
            , varVoucherType
            , varAmount
            , 'Dr'
            , varLedgerId
            , '', '', 0, 0
            , 'False', 'AUTO', 0
            , 0
            , 'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);

        UPDATE "payroll_salary" SET "VoucherId" = varVoucherId
        WHERE COALESCE(payroll_salary."SalaryId", 0) = varSalaryId;

    END LOOP getLedger;

    RETURN QUERY SELECT 1 AS "Flag";
END;
$$;
