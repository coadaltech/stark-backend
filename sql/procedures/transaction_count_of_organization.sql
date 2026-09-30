-- Converted from MySQL procedure `transaction_count_of_organization`.
DROP ROUTINE IF EXISTS "transaction_count_of_organization";
CREATE OR REPLACE FUNCTION "transaction_count_of_organization"(
	varOrganizationId integer
	, varShiftId integer
	, varShiftDate date
	, varIsAfterDeclare integer
)
RETURNS TABLE(
	"LedgerId" bigint
	,"LedgerName" text
	,"TransactionCount" bigint
	,"TotalAmount" double precision
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	/* varIsAfterDeclare = 0 live, = 1 after declare */
	CASE WHEN coalesce(varIsAfterDeclare, 0) = 0 THEN
		RETURN QUERY
		SELECT
			t."LedgerId", l."LedgerName"::text, count(1) AS "TransactionCount", sum(t."TotalAmount") AS "TotalAmount"
		FROM "transaction" t
		JOIN "ledger" l ON t."LedgerId" = l."LedgerId" AND coalesce(l."ParentLedgerId", 0) = 0
		JOIN "shift" shift ON shift."ShiftId" = t."ShiftId"
		JOIN "login" login ON login."UserName" = t."AddedBy" AND login."OrganizationId" = t."OrganizationId"
		WHERE t."OrganizationId" = varOrganizationId
		AND t."TransactionDate" = varShiftDate
		AND (coalesce(varShiftId, 0) = 0 OR t."ShiftId" = varShiftId)
		AND t."RecordStatus" <> 'D'
		AND login."LoginType" NOT IN (3,4,5)
		GROUP BY t."LedgerId", l."LedgerName"
		ORDER BY l."LedgerName";
	ELSE
		RETURN QUERY
		SELECT
			t."LedgerId", l."LedgerName"::text, count(1) AS "TransactionCount", sum(t."TotalAmount") AS "TotalAmount"
		FROM "transaction_declare" t
		JOIN "ledger" l ON t."LedgerId" = l."LedgerId" AND coalesce(l."ParentLedgerId", 0) = 0
		JOIN "shift" shift ON shift."ShiftId" = t."ShiftId"
		JOIN "login" login ON login."UserName" = t."AddedBy" AND login."OrganizationId" = t."OrganizationId"
		WHERE t."OrganizationId" = varOrganizationId
		AND t."TransactionDate" = varShiftDate
		AND (coalesce(varShiftId, 0) = 0 OR t."ShiftId" = varShiftId)
		AND t."RecordStatus" <> 'D'
		AND login."LoginType" NOT IN (3,4,5)
		GROUP BY t."LedgerId", l."LedgerName"
		ORDER BY l."LedgerName";
	END CASE;
END;
$$;
