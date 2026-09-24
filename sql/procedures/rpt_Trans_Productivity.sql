-- Converted from MySQL procedure `rpt_Trans_Productivity`.
-- NOTE: the MySQL source wrote `@varEndDate = AA.AddedDate` (comparison, not `:=` assignment) in the
-- select list, so the session variables never changed from their initial values
-- (@varEndDate = varFromDate, @varCheckShiftId = 0, @varCheckAddedBy = ''). Because
-- @varCheckShiftId = 0 always, FreeTimeInSec was always TIMESTAMPDIFF(start, start) = 0.
-- This behaviour is preserved literally below.
DROP ROUTINE IF EXISTS "rpt_Trans_Productivity";
CREATE OR REPLACE FUNCTION "rpt_Trans_Productivity"(
	varOrganizationId bigint
	, varFromDate date
	, varToDate date
	, varShiftId integer
	, varDiffInMin integer
	)
RETURNS TABLE(
	"NumberCount" numeric
	,"TotalAmount" double precision
	,"AddedBy" text
	,"Mobile" text
	,"Address" text
	,"LoginStatus" text
	,"LoginName" text
	,"LoginType" smallint
	,"RoleId" integer
	,"RoleName" text
	,"FreeTime" numeric
	,"FreeTimeInSec" numeric
	,"NoOfFreeTime" bigint
	,"Timetaken" numeric
	,"TimetakenInSec" numeric
	,"StartTime" timestamp
	,"EndTime" timestamp
	,"TotalTime" numeric
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
	v_varEndDate timestamp := varFromDate;   -- @varEndDate (never reassigned in MySQL)
	v_varCheckShiftId bigint := 0;           -- @varCheckShiftId (never reassigned in MySQL)
	v_varCheckAddedBy text := '';            -- @varCheckAddedBy (never reassigned in MySQL)
BEGIN
	RETURN QUERY
	SELECT sum(AA."NumberCount")::numeric AS "NumberCount", sum(AA."TotalAmount") AS "TotalAmount"
	, AA."AddedBy"::text
	,AA."Mobile"::text, AA."Address"::text, AA."LoginStatus"::text, AA."LoginName"::text
	,AA."LoginType", AA."RoleId", AA."RoleName"::text

	,round(sum(AA."FreeTimeInSec")::numeric / 60) AS "FreeTime"
	,sum(AA."FreeTimeInSec")::numeric AS "FreeTimeInSec"

	,(sum((CASE WHEN AA."FreeTimeInSec"::numeric / 60 >= varDiffInMin THEN 1 ELSE 0 END)))::bigint AS "NoOfFreeTime"

	,round(sum(AA."TimetakenInSec")::numeric / 3600) + (mod(round(sum(AA."TimetakenInSec")::numeric / 60, 4), 60) / 100) AS "Timetaken"
	,(sum(AA."TimetakenInSec"))::numeric AS "TimetakenInSec"
	,min(AA."TransactionStartTime") AS "StartTime"
	,max(AA."AddedDate") AS "EndTime"
	,round(trunc(extract(epoch FROM (max(AA."AddedDate") - min(AA."TransactionStartTime"))))::numeric / 3600)
	+ (mod(round(trunc(extract(epoch FROM (max(AA."AddedDate") - min(AA."TransactionStartTime"))))::numeric / 60, 4), 60) / 100) AS "TotalTime"

	FROM (
		SELECT (AA."NumberCount") AS "NumberCount", (AA."TotalAmount") AS "TotalAmount"
		, AA."AddedBy"
		,AA."Mobile", AA."Address", AA."LoginStatus", AA."LoginName"
		,AA."LoginType", AA."RoleId", AA."RoleName"
		,trunc(extract(epoch FROM (AA."TransactionStartTime"
				- (CASE WHEN v_varCheckShiftId = 0 OR v_varCheckAddedBy <> AA."AddedBy" THEN AA."TransactionStartTime" ELSE v_varEndDate END))))::bigint AS "FreeTimeInSec"
		,trunc(extract(epoch FROM (AA."AddedDate" - AA."TransactionStartTime")))::bigint AS "TimetakenInSec"
		,(AA."TransactionStartTime") AS "TransactionStartTime"
		,(AA."AddedDate") AS "AddedDate"
		FROM (
			SELECT count(1) AS "NumberCount", sum(td."Amount") AS "TotalAmount", t."AddedBy"
			,lm."Mobile", lm."Address", lm."AccountStatus" AS "LoginStatus", lm."LoginName"
			,any_value(lm."LoginType") AS "LoginType", any_value(role."RoleId") AS "RoleId", any_value(role."RoleName") AS "RoleName"
			,t."TransactionStartTime", t."AddedDate"
			,t."TransactionId"
			,t."TransactionDate", t."ShiftId", t."OrganizationId"
			FROM "transaction_detail" td
			JOIN "transaction" t ON td."TransactionId" = t."TransactionId"
			JOIN "login" lm ON lm."UserName" = t."AddedBy" AND lm."RecordStatus" <> 'D'
			LEFT JOIN "role" role ON role."RoleId" = lm."LoginType" AND role."RecordStatus" <> 'D' AND role."OrganizationId" = varOrganizationId
			WHERE (td."RecordStatus" <> 'D')
			AND (t."RecordStatus" <> 'D')
			AND (t."TransactionDate" BETWEEN varFromDate AND varToDate)
			AND (coalesce(varShiftId, 0) = 0 OR t."ShiftId" = varShiftId)
			AND t."OrganizationId" = varOrganizationId
			AND lm."LoginType" NOT IN (3,4,5)
			GROUP BY t."AddedBy", lm."Mobile", lm."Address", lm."AccountStatus", lm."LoginName"
			,t."TransactionStartTime", t."AddedDate"
			,t."TransactionId"
			,t."TransactionDate", t."ShiftId", t."OrganizationId"

			UNION ALL

			SELECT count(1) AS "NumberCount", sum(td."Amount") AS "TotalAmount", t."AddedBy"
			,lm."Mobile", lm."Address", lm."AccountStatus" AS "LoginStatus", lm."LoginName"
			,any_value(lm."LoginType") AS "LoginType", any_value(role."RoleId") AS "RoleId", any_value(role."RoleName") AS "RoleName"
			,t."TransactionStartTime", t."AddedDate"
			,t."TransactionId"
			,t."TransactionDate", t."ShiftId", t."OrganizationId"
			FROM "transaction_detail_declare" td
			JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
			JOIN "login" lm ON lm."UserName" = t."AddedBy" AND lm."RecordStatus" <> 'D'
			LEFT JOIN "role" role ON role."RoleId" = lm."LoginType" AND role."RecordStatus" <> 'D' AND role."OrganizationId" = varOrganizationId
			WHERE (td."RecordStatus" <> 'D')
			AND (t."RecordStatus" <> 'D')
			AND (t."TransactionDate" BETWEEN varFromDate AND varToDate)
			AND (coalesce(varShiftId, 0) = 0 OR t."ShiftId" = varShiftId)
			AND t."OrganizationId" = varOrganizationId
			AND lm."LoginType" NOT IN (3,4,5)
			GROUP BY t."AddedBy", lm."Mobile", lm."Address", lm."AccountStatus", lm."LoginName"
			,t."TransactionStartTime", t."AddedDate"
			,t."TransactionId"
			,t."TransactionDate", t."ShiftId", t."OrganizationId"
		) AS AA
	) AS AA
	GROUP BY AA."AddedBy"
	,AA."Mobile", AA."Address", AA."LoginStatus", AA."LoginName"
	,AA."LoginType", AA."RoleId", AA."RoleName"
	ORDER BY 1 ASC
	;
END;
$$;
