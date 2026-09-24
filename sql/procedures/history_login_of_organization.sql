-- Converted from MySQL procedure `history_login_of_organization`.
-- NOTE: MySQL returned sl.* plus a second column also labelled AddedDate (formatted string). PG cannot return
-- duplicate column names, so "AddedDate" is returned once, as the formatted text (what a name-keyed client saw).
DROP ROUTINE IF EXISTS "history_login_of_organization";
CREATE OR REPLACE FUNCTION "history_login_of_organization"(
    varOrganizationId bigint,
    varLoginId bigint,
    varFromDate date,
    varToDate date,
    varAddedBy varchar
) RETURNS TABLE(
    "LogId" bigint,
    "OrganizationId" bigint,
    "LoginId" bigint,
    "Logs" text,
    "TableName" varchar,
    "FieldName" varchar,
    "FieldValue" bigint,
    "OldJson" text,
    "NewJson" text,
    "RecordStatus" char,
    "AddedBy" varchar,
    "AddedDate" text,
    "UpdatedBy" varchar,
    "UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT sl."LogId", sl."OrganizationId", sl."LoginId", sl."Logs", sl."TableName"::varchar, sl."FieldName"::varchar,
           sl."FieldValue", sl."OldJson", sl."NewJson", sl."RecordStatus"::char, sl."AddedBy"::varchar,
           to_char(sl."AddedDate", 'DD-MM-YYYY HH12:MI:SS AM'),
           sl."UpdatedBy"::varchar, sl."UpdatedDate"
    FROM "sys_logs" sl
    WHERE sl."OrganizationId" = varOrganizationId
      AND sl."AddedDate"::date >= varFromDate
      AND sl."AddedDate"::date <= varToDate
      AND (sl."LoginId" = varLoginId OR COALESCE(varLoginId, 0) = 0)
      AND sl."RecordStatus" != 'D'
      AND (sl."AddedBy" = varAddedBy OR COALESCE(varAddedBy, '') = '')
    ORDER BY sl."AddedDate" DESC;
END
$$;
