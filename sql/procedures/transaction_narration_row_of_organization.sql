-- Converted from MySQL procedure `transaction_narration_row_of_organization`.
DROP ROUTINE IF EXISTS "transaction_narration_row_of_organization";
CREATE OR REPLACE FUNCTION "transaction_narration_row_of_organization"(
    varOrganizationId integer,
    varTransactionId bigint
)
RETURNS TABLE(
    "TransactionNarrationId" bigint,
    "TransactionId" bigint,
    "OrganizationId" bigint,
    "Type" text,
    "Number1" text,
    "Number2" text,
    "Number3" text,
    "Amount" double precision,
    "Joda" text,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    -- MySQL: SELECT tn.* (all columns of transaction_narration)
    RETURN QUERY
    SELECT tn."TransactionNarrationId", tn."TransactionId", tn."OrganizationId",
           tn."Type"::text, tn."Number1"::text, tn."Number2"::text, tn."Number3"::text,
           tn."Amount", tn."Joda"::text, tn."RecordStatus"::text,
           tn."AddedBy"::text, tn."AddedDate", tn."UpdatedBy"::text, tn."UpdatedDate"
    FROM "transaction_narration" tn
    WHERE tn."OrganizationId" = varOrganizationId
      AND tn."TransactionId" = varTransactionId
      AND tn."RecordStatus" != 'D';
END;
$$;
