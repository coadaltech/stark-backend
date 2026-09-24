-- Converted from MySQL procedure `payroll_sys_staff_salary_unpaid`.
-- MySQL `SELECT ... INTO` errors on >1 row and leaves the variable unchanged on 0 rows;
-- reproduced with SELECT ... INTO STRICT + NO_DATA_FOUND handler (TOO_MANY_ROWS propagates).
DROP ROUTINE IF EXISTS "payroll_sys_staff_salary_unpaid";
CREATE OR REPLACE FUNCTION "payroll_sys_staff_salary_unpaid"(
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
    VoucherIds varchar(5000);
BEGIN
    BEGIN
        SELECT k."PaidVoucherId"::text INTO STRICT VoucherIds
        FROM "kist" k
        JOIN "payroll_salary_detail" psd ON psd."KistId" = k."KistId"
        JOIN "payroll_salary" ps ON ps."SalaryId" = psd."SalaryId"
        WHERE (ps."OrganizationId" = varOrganizationId)
          AND (COALESCE(ps."LedgerId", 0) = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
          AND (COALESCE(ps."SalaryId", 0) = varSalaryId OR COALESCE(varSalaryId, 0) = 0)
          AND COALESCE(ps."VoucherId", 0) != 0
          AND ps."RecordStatus" != 'D'
          AND psd."RecordStatus" != 'D'
          AND ps."SalaryMonth" = varMonth
          AND ps."SalaryYear" = varYear;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        NULL;
    END;

    /* Kist voucher delete */
    DELETE FROM "voucher" v
    WHERE v."VoucherId"::text = ANY(string_to_array(VoucherIds, ','));

    DELETE FROM "voucher_detail" vd
    WHERE vd."VoucherId"::text = ANY(string_to_array(VoucherIds, ','));

    /*   Kist Update */
    UPDATE "kist" k SET "PaidVoucherId" = 0
        , "KistStatus" = 'UNPAID'
    WHERE COALESCE(k."KistId", 0) IN (
        SELECT psd."KistId"
        FROM "payroll_salary_detail" psd
        JOIN "payroll_salary" ps ON ps."SalaryId" = psd."SalaryId"
        WHERE (ps."OrganizationId" = varOrganizationId)
          AND (COALESCE(ps."LedgerId", 0) = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
          AND (COALESCE(ps."SalaryId", 0) = varSalaryId OR COALESCE(varSalaryId, 0) = 0)
          AND COALESCE(ps."VoucherId", 0) != 0
          AND ps."RecordStatus" != 'D'
          AND psd."RecordStatus" != 'D'
          AND ps."SalaryMonth" = varMonth
          AND ps."SalaryYear" = varYear
    );

    /*   Salary Voucher Delete */
    BEGIN
        SELECT ps."VoucherId"::text INTO STRICT VoucherIds
        FROM "payroll_salary" ps
        WHERE (ps."OrganizationId" = varOrganizationId)
          AND (COALESCE(ps."LedgerId", 0) = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
          AND (COALESCE(ps."SalaryId", 0) = varSalaryId OR COALESCE(varSalaryId, 0) = 0)
          AND COALESCE(ps."VoucherId", 0) != 0
          AND ps."RecordStatus" != 'D'
          AND ps."SalaryMonth" = varMonth
          AND ps."SalaryYear" = varYear;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        NULL;
    END;

    DELETE FROM "voucher" v
    WHERE v."VoucherId"::text = ANY(string_to_array(VoucherIds, ','));

    DELETE FROM "voucher_detail" vd
    WHERE vd."VoucherId"::text = ANY(string_to_array(VoucherIds, ','));

    /*   Salary update */
    UPDATE "payroll_salary" ps SET "VoucherId" = 0
    WHERE (ps."OrganizationId" = varOrganizationId)
      AND (COALESCE(ps."LedgerId", 0) = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
      AND (COALESCE(ps."SalaryId", 0) = varSalaryId OR COALESCE(varSalaryId, 0) = 0)
      AND COALESCE(ps."VoucherId", 0) != 0
      AND ps."RecordStatus" != 'D'
      AND ps."SalaryMonth" = varMonth
      AND ps."SalaryYear" = varYear;

    RETURN QUERY SELECT 1 AS "Flag";
END;
$$;
