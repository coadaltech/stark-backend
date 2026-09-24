-- Converted from MySQL procedure `Shift_timing_all_of_organization`.
-- MySQL `GROUP BY s.RoleId` with non-aggregated s.* picked one arbitrary row per RoleId;
-- DISTINCT ON (RoleId) keeps one whole row per RoleId (same semantics, row-consistent).
DROP ROUTINE IF EXISTS "Shift_timing_all_of_organization";
CREATE OR REPLACE FUNCTION "Shift_timing_all_of_organization"(varOrganizationId integer, varShiftId integer)
RETURNS TABLE(
    "ShiftTimeId" bigint,
    "ShiftId" bigint,
    "OrganizationId" bigint,
    "RoleId" bigint,
    "EndTime" text,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp,
    "RoleName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT DISTINCT ON (s."RoleId")
           s."ShiftTimeId", s."ShiftId", s."OrganizationId", s."RoleId", s."EndTime"::text,
           s."RecordStatus"::text, s."AddedBy"::text, s."AddedDate", s."UpdatedBy"::text, s."UpdatedDate",
           r."RoleName"::text
    FROM "shift_timing" s
    JOIN "role" r ON s."RoleId" = r."RoleId"
    WHERE s."OrganizationId" = varOrganizationId
      AND s."ShiftId" = varShiftId
      AND s."RecordStatus" != 'D'
    ORDER BY s."RoleId" ASC;
END;
$$;
