-- Converted from MySQL procedure `staff_transaction_permission`.
DROP ROUTINE IF EXISTS "staff_transaction_permission";
CREATE OR REPLACE FUNCTION "staff_transaction_permission"(
	varOrganizationId integer
	, varLedgerName varchar
	, varLedgerId integer
	, varRoleId integer
	, varLoginId integer
)
RETURNS TABLE(
	"LoginId" bigint
	,"OrganizationId" bigint
	,"LedgerId" bigint
	,"LoginName" text
	,"UserName" text
	,"LoginType" smallint
	,"AccountStatus" text
	,"RoleName" text
	,"GroupId" integer
	,"ShiftCount" bigint
	,"IsExpiry" integer
	,"sub2" bigint
	,"sub1" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT lg."LoginId",
		lg."OrganizationId",
		lg."LedgerId",
		lg."LoginName"::text,
		lg."UserName"::text,
		lg."LoginType",
		lg."AccountStatus"::text,
		r."RoleName"::text,
		l."GroupId",
		coalesce(rpt."ShiftCount", 0) AS "ShiftCount"
		,(CASE WHEN localtimestamp >= coalesce(rpt."ExpiryDateTime", localtimestamp) THEN 1 ELSE 0 END) AS "IsExpiry"
		-- MySQL: convert(substr(UserName, <first digit pos>), signed) -> leading integer, 0 if none
		,coalesce(substring(substr(lg."UserName", least(
				CASE WHEN position('0' in lg."UserName") = 0 THEN 100 ELSE position('0' in lg."UserName") END,
				CASE WHEN position('1' in lg."UserName") = 0 THEN 100 ELSE position('1' in lg."UserName") END,
				CASE WHEN position('2' in lg."UserName") = 0 THEN 100 ELSE position('2' in lg."UserName") END,
				CASE WHEN position('3' in lg."UserName") = 0 THEN 100 ELSE position('3' in lg."UserName") END,
				CASE WHEN position('4' in lg."UserName") = 0 THEN 100 ELSE position('4' in lg."UserName") END,
				CASE WHEN position('5' in lg."UserName") = 0 THEN 100 ELSE position('5' in lg."UserName") END,
				CASE WHEN position('6' in lg."UserName") = 0 THEN 100 ELSE position('6' in lg."UserName") END,
				CASE WHEN position('7' in lg."UserName") = 0 THEN 100 ELSE position('7' in lg."UserName") END,
				CASE WHEN position('8' in lg."UserName") = 0 THEN 100 ELSE position('8' in lg."UserName") END,
				CASE WHEN position('9' in lg."UserName") = 0 THEN 100 ELSE position('9' in lg."UserName") END
				)) from '^[0-9]+')::bigint, 0) AS "sub2"
		,substr(lg."UserName", 1
			,least(
				CASE WHEN position('0' in lg."UserName") = 0 THEN 100 ELSE position('0' in lg."UserName") END,
				CASE WHEN position('1' in lg."UserName") = 0 THEN 100 ELSE position('1' in lg."UserName") END,
				CASE WHEN position('2' in lg."UserName") = 0 THEN 100 ELSE position('2' in lg."UserName") END,
				CASE WHEN position('3' in lg."UserName") = 0 THEN 100 ELSE position('3' in lg."UserName") END,
				CASE WHEN position('4' in lg."UserName") = 0 THEN 100 ELSE position('4' in lg."UserName") END,
				CASE WHEN position('5' in lg."UserName") = 0 THEN 100 ELSE position('5' in lg."UserName") END,
				CASE WHEN position('6' in lg."UserName") = 0 THEN 100 ELSE position('6' in lg."UserName") END,
				CASE WHEN position('7' in lg."UserName") = 0 THEN 100 ELSE position('7' in lg."UserName") END,
				CASE WHEN position('8' in lg."UserName") = 0 THEN 100 ELSE position('8' in lg."UserName") END,
				CASE WHEN position('9' in lg."UserName") = 0 THEN 100 ELSE position('9' in lg."UserName") END
				) - 1
			)::text AS "sub1"
	FROM "login" lg
	JOIN "role" r ON lg."LoginType" = r."RoleId" AND r."RecordStatus" <> 'D' AND r."OrganizationId" = varOrganizationId
	JOIN "ledger" l ON lg."LedgerId" = l."LedgerId" AND l."GroupId" = 7 AND l."IsHide" = '0'
	LEFT JOIN (SELECT count(1) AS "ShiftCount", x."LoginId", max(x."ExpiryDateTime") AS "ExpiryDateTime"
				FROM "role_permission_transaction" x
				WHERE x."RecordStatus" <> 'D' AND coalesce(x."IsPageAllow", '0') = '1'
				GROUP BY x."LoginId"
				) AS rpt ON lg."LoginId" = rpt."LoginId"
	WHERE l."OrganizationId" = varOrganizationId
	AND lg."RecordStatus" <> 'D'
	AND ((varLedgerName IS NULL OR upper(l."LedgerName") LIKE (upper(varLedgerName) || '%'))
	OR (varLedgerName IS NULL OR upper(lg."UserName") LIKE (upper(varLedgerName) || '%')))
	AND (lg."LoginType" = varRoleId OR coalesce(varRoleId, 0) = 0)
	AND (lg."LedgerId" = varLedgerId OR coalesce(varLedgerId, 0) = 0)
	AND (lg."LoginId" = varLoginId OR coalesce(varLoginId, 0) = 0)
	ORDER BY 13, 12 ASC  -- sub1, sub2
	;
END;
$$;
