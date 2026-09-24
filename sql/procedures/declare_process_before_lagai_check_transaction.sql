-- Converted from MySQL procedure `declare_process_before_lagai_check_transaction`.
DROP ROUTINE IF EXISTS "declare_process_before_lagai_check_transaction";
CREATE OR REPLACE FUNCTION "declare_process_before_lagai_check_transaction"(
    varOrganizationId integer,
    varShiftId integer,
    varTransactionDate date
)
RETURNS TABLE("TransactionCount" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT (CASE COALESCE(sum(t."TransactionCount"), 0) WHEN 0 THEN 0 ELSE 1 END)::integer AS "TransactionCount"
    FROM
    (
        SELECT (CASE COALESCE(sum(1), 0) WHEN 0 THEN 0 ELSE 1 END) AS "TransactionCount"
        FROM "transaction_declare" td
        WHERE td."TransactionDate" = varTransactionDate
          AND (td."ShiftId" = varShiftId)
          AND td."OrganizationId" = varOrganizationId
          AND td."TransactionMode" = 0
          AND td."RecordStatus" != 'D'
        UNION ALL
        SELECT (CASE COALESCE(sum(1), 0) WHEN 0 THEN 0 ELSE 1 END) AS "TransactionCount"
        FROM "transaction" tr
        WHERE tr."TransactionDate" = varTransactionDate
          AND (tr."ShiftId" = varShiftId)
          AND tr."OrganizationId" = varOrganizationId
          AND tr."TransactionMode" = 0
          AND tr."RecordStatus" != 'D'
    ) AS t;
END;
$$;
