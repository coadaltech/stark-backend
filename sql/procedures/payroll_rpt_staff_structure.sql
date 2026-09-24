-- Converted from MySQL procedure `payroll_rpt_staff_structure`.
DROP ROUTINE IF EXISTS "payroll_rpt_staff_structure";
CREATE OR REPLACE FUNCTION "payroll_rpt_staff_structure"(varOrganizationId bigint, varLedgerId bigint, varCommanMasterType integer)
RETURNS TABLE(
    "CommanName" text,
    "CommanType" integer,
    "StructureId" bigint,
    "LedgerId" bigint,
    "OrganizationId" bigint,
    "CommanMasterId" bigint,
    "Amount" double precision,
    "AmountType" double precision,
    "Remark" text,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT pcm."CommanName"::text,
           pcm."CommanType",
           pss."StructureId",
           pss."LedgerId",
           pss."OrganizationId",
           pss."CommanMasterId",
           pss."Amount",
           pss."AmountType",
           pss."Remark"::text,
           pss."RecordStatus"::text,
           pss."AddedBy"::text,
           pss."AddedDate",
           pss."UpdatedBy"::text,
           pss."UpdatedDate"
    FROM "payroll_staff_structure" pss
    JOIN "payroll_comman_master" pcm ON pss."CommanMasterId" = pcm."CommanMasterId"
    WHERE pcm."CommanType" = varCommanMasterType
      AND pss."LedgerId" = varLedgerId
      AND (COALESCE(pss."OrganizationId", 0) = varOrganizationId)
      AND pss."RecordStatus" != 'D'
    ORDER BY pcm."CommanOrder";
END;
$$;
