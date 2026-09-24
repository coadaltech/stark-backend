-- Converted from MySQL procedure `rpt_AccessBlock`.
DROP ROUTINE IF EXISTS "rpt_AccessBlock";
CREATE OR REPLACE FUNCTION "rpt_AccessBlock"(
    varOrganizationId integer,
    varRecordStatus varchar
)
RETURNS TABLE(
    "AccessBlockId" bigint,
    "OrganizationId" bigint,
    "LoginId" bigint,
    "IP" text,
    "Attempt" integer,
    "Remark" text,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp,
    "Mobile" text,
    "Address" text,
    "UserName" text,
    "LoginStatus" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT sab."AccessBlockId"
        , sab."OrganizationId"
        , sab."LoginId"
        , sab."IP"::text
        , sab."Attempt"
        , sab."Remark"
        , sab."RecordStatus"::text
        , sab."AddedBy"::text
        , sab."AddedDate"
        , sab."UpdatedBy"::text
        , sab."UpdatedDate"
        , login."Mobile"::text
        , login."Address"::text
        , login."UserName"::text
        , login."AccountStatus"::text AS "LoginStatus"
    FROM "sys_access_block" sab
    LEFT JOIN "login" ON sab."LoginId" = login."LoginId"
    WHERE sab."OrganizationId" = varOrganizationId
      AND sab."RecordStatus" = varRecordStatus
    ORDER BY sab."AddedDate" DESC;
END;
$$;
