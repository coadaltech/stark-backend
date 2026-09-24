-- Converted from MySQL procedure `payroll_rpt_comman_master`.
DROP ROUTINE IF EXISTS "payroll_rpt_comman_master";
CREATE OR REPLACE FUNCTION "payroll_rpt_comman_master"(
    varOrganizationId bigint,
    varCommanMasterType bigint,
    varCommanMasterName varchar
)
RETURNS TABLE(
    "CommanMasterId" bigint,
    "CommanName" text,
    "OrganizationId" bigint,
    "CommanType" integer,
    "IsAllow" integer,
    "CommanOrder" integer,
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
    SELECT pcm."CommanMasterId"
        , pcm."CommanName"::text
        , pcm."OrganizationId"
        , pcm."CommanType"
        , pcm."IsAllow"
        , pcm."CommanOrder"
        , pcm."RecordStatus"::text
        , pcm."AddedBy"::text
        , pcm."AddedDate"
        , pcm."UpdatedBy"::text
        , pcm."UpdatedDate"
    FROM "payroll_comman_master" pcm
    WHERE pcm."CommanType" = varCommanMasterType
      AND (COALESCE(pcm."CommanName", '') ILIKE (COALESCE(varCommanMasterName, '')::text || '%'))
      AND (COALESCE(pcm."OrganizationId", 0) = varOrganizationId OR COALESCE(pcm."OrganizationId", 0) = 0 OR COALESCE(varOrganizationId, 0) = 0)
      AND pcm."RecordStatus" != 'D'
    ORDER BY pcm."CommanOrder";
END;
$$;
