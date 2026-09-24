-- Converted from MySQL procedure `transaction_detail_row_of_organization`.
-- Note: MySQL returned td.* plus a computed `Number` column (duplicate label; the computed
-- one wins for name-based clients). Here td columns are listed explicitly with the computed
-- "Number" in place of the raw one.
DROP ROUTINE IF EXISTS "transaction_detail_row_of_organization";
CREATE OR REPLACE FUNCTION "transaction_detail_row_of_organization"(
    varOrganizationId integer,
    varTransactionId bigint,
    varLedgerId bigint,
    varShiftDate date,
    varShiftId bigint)
RETURNS TABLE(
    "TransactionDetailId" bigint, "TransactionId" bigint, "OrganizationId" bigint, "NumberType" integer,
    "Number" text, "Amount" double precision, "Rate" double precision, "Commission" double precision,
    "Tax" double precision, "FinalAmount" double precision, "OrderNumber" integer, "UpdateLimitFlag" integer,
    "RecordStatus" text, "AddedBy" text, "AddedDate" timestamp, "UpdatedBy" text, "UpdatedDate" timestamp)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT td."TransactionDetailId", td."TransactionId", td."OrganizationId", td."NumberType",
           CASE WHEN char_length(td."Number") = 2
                THEN (CASE WHEN td."Number" ~ '^-?[0-9]+$' THEN round(td."Number"::numeric)::text ELSE '0' END)  -- MySQL ROUND('x') = 0
                ELSE td."Number"::text END AS "Number",
           td."Amount", td."Rate", td."Commission", td."Tax", td."FinalAmount", td."OrderNumber", td."UpdateLimitFlag",
           td."RecordStatus"::text, td."AddedBy"::text, td."AddedDate", td."UpdatedBy"::text, td."UpdatedDate"
    FROM "transaction_detail" td
    JOIN "transaction" t ON t."TransactionId" = td."TransactionId"
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
