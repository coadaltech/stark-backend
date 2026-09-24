-- Converted from MySQL procedure `rpt_Trans_Productivity_Topper_Looser`.
-- NOTE: varOnDate is unused (as in the MySQL source).
DROP ROUTINE IF EXISTS "rpt_Trans_Productivity_Topper_Looser";
CREATE OR REPLACE FUNCTION "rpt_Trans_Productivity_Topper_Looser"(
    varOrganizationId bigint,
    varOnDate date
) RETURNS TABLE(
    "NumberCount" bigint,
    "TotalAmount" double precision,
    "AddedBy" text,
    "Mobile" text,
    "Address" text,
    "LoginStatus" integer,
    "LoginName" text,
    "LoginType" integer,
    "RoleId" integer,
    "RoleName" text,
    "TopFlag" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT tl."NumberCount", tl."TotalAmount", tl."AddedBy"::text,
           tl."Mobile"::text, tl."Address"::text, tl."LoginStatus", tl."LoginName"::text,
           tl."LoginType", tl."RoleId", tl."RoleName"::text, tl."TopFlag"
    FROM "toppers_losser" tl
    WHERE tl."OrganizationId" = varOrganizationId
    ORDER BY tl."NumberCountOrder" ASC;
END
$$;
