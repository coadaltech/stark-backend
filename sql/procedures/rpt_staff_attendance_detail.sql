-- Converted from MySQL procedure `rpt_staff_attendance_detail`.
DROP ROUTINE IF EXISTS "rpt_staff_attendance_detail";
CREATE OR REPLACE FUNCTION "rpt_staff_attendance_detail"(
	varOrganizationId integer,
	varFromDate date,
	varToDate date,
	varUserName varchar,
	varLedgerId integer
)
RETURNS TABLE(
	"LedgerId" bigint
	,"LedgerName" text
	,"UserName" text
	,"AddedDate" date
	,"EntryCount" bigint
	,"Mobile" text
	,"Address" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT ledger."LedgerId", ledger."LedgerName"::text, login."UserName"::text, day_transaction."AddedDate"
	,coalesce(day_transaction."EntryCount", 0) AS "EntryCount"
	,login."Mobile"::text
	,login."Address"::text
	FROM (SELECT l."LedgerId", l."LedgerName" FROM "ledger" l
		WHERE l."OrganizationId" = varOrganizationId
		AND (coalesce(l."LedgerId", 0) = varLedgerId OR coalesce(varLedgerId, 0) = 0)
		AND l."GroupId" = 7
		AND l."RecordStatus" = 'A') AS ledger
	INNER JOIN "login" login ON login."LedgerId" = ledger."LedgerId" AND login."LoginType" NOT IN (2,7)
		AND (coalesce(login."UserName", '0') = varUserName OR coalesce(varUserName, '') = '')
	LEFT JOIN (
		SELECT td."OrganizationId", td."AddedDate"::date AS "AddedDate"
		,td."AddedBy", count(1) AS "EntryCount" FROM "transaction_declare" td
		WHERE td."OrganizationId" = varOrganizationId
		AND td."RecordStatus" <> 'D'
		AND td."AddedDate"::date BETWEEN varFromDate AND varToDate
		AND (coalesce(td."AddedBy", '0') = varUserName OR coalesce(varUserName, '') = '')
		GROUP BY td."AddedDate"::date, td."AddedBy", td."OrganizationId"
	) AS day_transaction ON login."UserName" = day_transaction."AddedBy"
	ORDER BY ledger."LedgerName", day_transaction."AddedDate"
	;
END;
$$;
