-- Converted from MySQL procedure `declare_transaction_detail_row_of_organization`.
-- NOTE: MySQL returned `td.*` plus a second computed `Number` column (duplicate label; client
-- drivers keep the last one). PG cannot return duplicate column names, so td columns are listed
-- explicitly and "Number" holds the computed value (IF(CHAR_LENGTH(Number)=2, ROUND(Number), Number)).
DROP ROUTINE IF EXISTS "declare_transaction_detail_row_of_organization";
CREATE OR REPLACE FUNCTION "declare_transaction_detail_row_of_organization"(
    varOrganizationId integer,
    varTransactionId bigint,
    varLedgerId bigint,
    varShiftDate date,
    varShiftId bigint
)
RETURNS TABLE(
    "TransactionDetailId" bigint,
    "TransactionId" bigint,
    "OrganizationId" bigint,
    "Number" text,
    "NumberType" integer,
    "Amount" double precision,
    "Rate" double precision,
    "Commission" double precision,
    "Tax" double precision,
    "FinalAmount" double precision,
    "OrderNumber" integer,
    "UpdateLimitFlag" integer,
    "RecordStatus" char(1),
    "AddedBy" varchar,
    "AddedDate" timestamp,
    "UpdatedBy" varchar,
    "UpdatedDate" timestamp
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT td."TransactionDetailId", td."TransactionId", td."OrganizationId",
           (CASE WHEN char_length(td."Number") = 2
                 THEN (CASE WHEN td."Number" ~ '^-?[0-9]+$' THEN round(td."Number"::numeric)::text ELSE '0' END)  -- MySQL ROUND('x') = 0
                 ELSE td."Number"::text END) AS "Number",
           td."NumberType", td."Amount", td."Rate", td."Commission", td."Tax", td."FinalAmount",
           td."OrderNumber", td."UpdateLimitFlag", td."RecordStatus",
           td."AddedBy", td."AddedDate", td."UpdatedBy", td."UpdatedDate"
    FROM "transaction_detail_declare" td
    JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
    WHERE td."OrganizationId" = varOrganizationId
      AND (COALESCE(varTransactionId, 0) = 0 OR td."TransactionId" = varTransactionId)
      AND (COALESCE(varLedgerId, 0) = 0 OR t."LedgerId" = varLedgerId)
      AND (COALESCE(varShiftId, 0) = 0 OR t."ShiftId" = varShiftId)
      AND t."TransactionDate" = varShiftDate
      AND td."RecordStatus" != 'D'
      AND t."RecordStatus" != 'D'
    ORDER BY td."OrderNumber" ASC;
END;
$$;
