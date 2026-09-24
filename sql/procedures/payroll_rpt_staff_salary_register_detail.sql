-- Converted from MySQL procedure `payroll_rpt_staff_salary_register_detail`.
DROP ROUTINE IF EXISTS "payroll_rpt_staff_salary_register_detail";
CREATE OR REPLACE FUNCTION "payroll_rpt_staff_salary_register_detail"(varOrganizationId integer, varSalaryId bigint)
RETURNS TABLE("CommanName" text, "SalaryDetailId" bigint, "OrganizationId" bigint, "SalaryId" bigint,
              "CommanMasterId" bigint, "Amount" double precision, "KistId" bigint, "DetailRemark" text,
              "CommanType" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT pcm."CommanName"::text, psd."SalaryDetailId",
           psd."OrganizationId", psd."SalaryId",
           psd."CommanMasterId", psd."Amount", psd."KistId",
           psd."DetailRemark"::text,
           pcm."CommanType"
    FROM "payroll_salary_detail" psd
    JOIN "payroll_comman_master" pcm ON pcm."CommanMasterId" = psd."CommanMasterId"
         AND pcm."RecordStatus" != 'D'
    WHERE (psd."OrganizationId" = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
      AND psd."RecordStatus" != 'D'
      AND psd."SalaryId" = varSalaryId
    ORDER BY pcm."CommanOrder";
END;
$$;
