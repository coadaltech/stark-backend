-- Converted from MySQL procedure `transaction_capping`.
DROP ROUTINE IF EXISTS "transaction_capping";
CREATE OR REPLACE FUNCTION "transaction_capping"(
    varOrganizationId integer,
    varLedgerId integer,
    varShiftId integer,
    varShiftDate date,
    varTransactionId bigint,
    varIsAfterDeclare integer
)
RETURNS TABLE(
    "Number" text,
    "NumberType" integer,
    "Amount" double precision
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    /* varIsAfterDeclare = 0 live, = 1 after declare */
    IF COALESCE(varIsAfterDeclare, 0) = 0 THEN
        RETURN QUERY
        SELECT td."Number"::text, td."NumberType", sum(td."Amount") AS "Amount"
        FROM "transaction" t
        INNER JOIN "transaction_detail" td ON td."TransactionId" = t."TransactionId"
        WHERE t."OrganizationId" = varOrganizationId
          AND t."TransactionDate" = varShiftDate
          AND (COALESCE(varShiftId, 0) = 0 OR t."ShiftId" = varShiftId)
          AND t."LedgerId" = varLedgerId
          AND t."RecordStatus" != 'D'
          AND td."RecordStatus" != 'D'
          AND t."TransactionId" != varTransactionId
        GROUP BY td."Number", td."NumberType"
        ORDER BY td."Number", td."NumberType";
    ELSE
        RETURN QUERY
        SELECT td."Number"::text, td."NumberType", sum(td."Amount") AS "Amount"
        FROM "transaction_declare" t
        INNER JOIN "transaction_detail_declare" td ON td."TransactionId" = t."TransactionId"
        WHERE t."OrganizationId" = varOrganizationId
          AND t."TransactionDate" = varShiftDate
          AND (COALESCE(varShiftId, 0) = 0 OR t."ShiftId" = varShiftId)
          AND t."LedgerId" = varLedgerId
          AND t."RecordStatus" != 'D'
          AND td."RecordStatus" != 'D'
          AND t."TransactionId" != varTransactionId
        GROUP BY td."Number", td."NumberType"
        ORDER BY td."Number", td."NumberType";
    END IF;
END;
$$;
