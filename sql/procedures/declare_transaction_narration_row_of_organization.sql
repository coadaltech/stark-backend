-- Converted from MySQL procedure `declare_transaction_narration_row_of_organization`.
DROP ROUTINE IF EXISTS "declare_transaction_narration_row_of_organization";
CREATE OR REPLACE FUNCTION "declare_transaction_narration_row_of_organization"(
    varOrganizationId integer,
    varTransactionId bigint
) RETURNS TABLE(
    "TransactionNarrationId" bigint,
    "TransactionId" bigint,
    "OrganizationId" bigint,
    "Type" varchar,
    "Number1" varchar,
    "Number2" varchar,
    "Number3" varchar,
    "Amount" double precision,
    "Joda" varchar,
    "RecordStatus" char,
    "AddedBy" varchar,
    "AddedDate" timestamp,
    "UpdatedBy" varchar,
    "UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT tn."TransactionNarrationId", tn."TransactionId", tn."OrganizationId", tn."Type"::varchar,
           tn."Number1"::varchar, tn."Number2"::varchar, tn."Number3"::varchar, tn."Amount",
           tn."Joda"::varchar, tn."RecordStatus"::char, tn."AddedBy"::varchar, tn."AddedDate",
           tn."UpdatedBy"::varchar, tn."UpdatedDate"
    FROM "transaction_narration_declare" tn
    WHERE tn."OrganizationId" = varOrganizationId
      AND tn."TransactionId" = varTransactionId
      AND tn."RecordStatus" != 'D';
END
$$;
