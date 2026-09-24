-- Converted from MySQL procedure `transaction_kwada_total_party_wise`.
DROP ROUTINE IF EXISTS "transaction_kwada_total_party_wise";
CREATE OR REPLACE FUNCTION "transaction_kwada_total_party_wise"(
    varOrganizationId integer,
    varShiftId integer,
    varShiftDate date,
    varLedgerId integer,
    varUserName varchar,
    varAmount double precision,
    varCount integer
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "TotalAmount" double precision,
    "ShiftId" integer,
    "ShiftDate" date
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT DISTINCT t."LedgerId", t."LedgerName"::text
        , (SELECT sum(ts."TotalAmount") FROM "transaction" AS ts
           WHERE ts."LedgerId" = t."LedgerId"
             AND ts."ShiftId" = varShiftId
             AND ts."TransactionDate" = varShiftDate
             AND ts."RecordStatus" != 'D'
          ) AS "TotalAmount"
        , varShiftId AS "ShiftId", varShiftDate AS "ShiftDate"
    FROM
    (
        SELECT t."LedgerId", l."LedgerName", sum(td."Amount") AS "Amount", td."Number", td."NumberType"
        FROM "transaction" t
        JOIN "transaction_detail" td ON t."TransactionId" = td."TransactionId"
        JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
        WHERE t."OrganizationId" = varOrganizationId
          AND t."ShiftId" = varShiftId
          AND t."TransactionDate" = varShiftDate
          AND t."RecordStatus" != 'D'
          AND td."RecordStatus" != 'D'
        GROUP BY t."LedgerId"
            , l."LedgerName", td."NumberType"
            , td."Number"
        HAVING sum(td."Amount") >= varAmount
    ) AS t
    GROUP BY t."LedgerId", t."LedgerName", t."Amount"
    HAVING count(1) >= varCount;
END;
$$;
