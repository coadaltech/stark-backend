-- Converted from MySQL procedure `rpt_transaction_duplicate`.
DROP ROUTINE IF EXISTS "rpt_transaction_duplicate";
CREATE OR REPLACE FUNCTION "rpt_transaction_duplicate"(
	varOrganizationId bigint
	, varShiftId bigint
	, varShiftDate date
)
RETURNS TABLE(
	"TransactionId" bigint
	,"OrganizationId" bigint
	,"ShiftId" bigint
	,"LedgerId" bigint
	,"TransactionDate" text
	,"TransactionMode" smallint
	,"TransactionType" text
	,"TotalAmount" double precision
	,"FinalAmount" double precision
	,"TransactionStartTime" timestamp
	,"ShiftName" text
	,"LedgerName" text
	,"currentTrans" integer
	,"NoofTrans" bigint
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT
		any_value(t."TransactionId") AS "TransactionId",
		t."OrganizationId",
		t."ShiftId",
		t."LedgerId",
		to_char(t."TransactionDate", 'YYYY-MM-DD') AS "TransactionDate",
		t."TransactionMode",
		t."TransactionType"::text,
		t."TotalAmount",
		t."FinalAmount",
		t."TransactionStartTime",
		shift."ShiftName"::text,
		ledger."LedgerName"::text,
		0 AS "currentTrans",
		count(1) AS "NoofTrans"
	FROM "transaction_declare" AS t
	JOIN "shift" shift ON shift."ShiftId" = t."ShiftId"
	JOIN "ledger" ledger ON ledger."LedgerId" = t."LedgerId"
	WHERE t."TransactionDate" = varShiftDate
	AND t."RecordStatus" <> 'D'
	AND (t."ShiftId" = varShiftId OR coalesce(varShiftId, 0) = 0)
	AND t."OrganizationId" = varOrganizationId
	GROUP BY
		t."OrganizationId",
		t."ShiftId",
		t."LedgerId",
		t."TransactionDate",
		t."TransactionMode",
		t."TransactionType",
		t."TotalAmount",
		t."FinalAmount",
		t."TransactionStartTime",
		shift."ShiftName",
		ledger."LedgerName"
		,t."AddedBy"
	HAVING count(1) > 1
	UNION ALL
	SELECT
		any_value(t."TransactionId") AS "TransactionId",
		t."OrganizationId",
		t."ShiftId",
		t."LedgerId",
		to_char(t."TransactionDate", 'YYYY-MM-DD') AS "TransactionDate",
		t."TransactionMode",
		t."TransactionType"::text,
		t."TotalAmount",
		t."FinalAmount",
		t."TransactionStartTime",
		shift."ShiftName"::text,
		ledger."LedgerName"::text,
		1 AS "currentTrans",
		count(1) AS "NoofTrans"
	FROM "transaction" AS t
	JOIN "shift" shift ON shift."ShiftId" = t."ShiftId"
	JOIN "ledger" ledger ON ledger."LedgerId" = t."LedgerId"
	WHERE t."TransactionDate" = varShiftDate
	AND t."RecordStatus" <> 'D'
	AND (t."ShiftId" = varShiftId OR coalesce(varShiftId, 0) = 0)
	AND t."OrganizationId" = varOrganizationId
	GROUP BY
		t."OrganizationId",
		t."ShiftId",
		t."LedgerId",
		t."TransactionDate",
		t."TransactionMode",
		t."TransactionType",
		t."TotalAmount",
		t."FinalAmount",
		t."TransactionStartTime",
		shift."ShiftName",
		ledger."LedgerName"
		,t."AddedBy"
	HAVING count(1) > 1
	;
END;
$$;
