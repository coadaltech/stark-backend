-- Converted from MySQL procedure `declare_transaction_row_of_organization`.
DROP ROUTINE IF EXISTS "declare_transaction_row_of_organization";
CREATE OR REPLACE FUNCTION "declare_transaction_row_of_organization"(
    varOrganizationId integer,
    varTransactionId bigint
)
RETURNS TABLE(
    "TransactionId" bigint,
    "OrganizationId" bigint,
    "LedgerId" bigint,
    "SelfHissa" double precision,
    "OtherHissa" double precision,
    "LedgerName" text,
    "ShiftId" bigint,
    "TotalAmount" double precision,
    "UpdatedBy" text,
    "TransactionDateDB" date,
    "TransactionType" text,
    "KFlag" text,
    "IsHissa" text,
    "DaraRate" double precision,
    "DaraCommission" double precision,
    "AkharRate" double precision,
    "AkharCommission" double precision,
    "DeviceType" text,
    "TransactionDate" text,
    "AddedDate" text,
    "UpdatedDate" text,
    "Tax" double precision
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT t."TransactionId", t."OrganizationId", t."LedgerId"
        , t."SelfHissa"
        , t."OtherHissa"
        , l."LedgerName"::text, t."ShiftId", t."TotalAmount", t."UpdatedBy"::text, t."TransactionDate" AS "TransactionDateDB",
          t."TransactionType"::text, t."KFlag"::text, t."IsHissa"::text, t."DaraRate", t."DaraCommission", t."AkharRate", t."AkharCommission", t."DeviceType"::text,
          to_char(t."TransactionDate", 'DD-MM-YYYY') AS "TransactionDate",
          to_char(t."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
          to_char(t."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate"
        , t."Tax"
    FROM "transaction_declare" t
    JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
    WHERE t."OrganizationId" = varOrganizationId
      AND t."TransactionId" = varTransactionId
      AND t."RecordStatus" != 'D'
    ORDER BY t."UpdatedDate" DESC;
END;
$$;
