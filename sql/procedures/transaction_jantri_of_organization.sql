-- Converted from MySQL procedure `transaction_jantri_of_organization`.
DROP ROUTINE IF EXISTS "transaction_jantri_of_organization";
CREATE OR REPLACE FUNCTION "transaction_jantri_of_organization"(
    varOrganizationId bigint,
    varTransactionDate date,
    varShiftId integer,
    varLedgerId bigint,
    varAgentId bigint,
    varMode integer
)
RETURNS TABLE("NumberType" integer, "Amount" double precision, "Number" text)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT aa."NumberType"
        , sum(CASE WHEN COALESCE(l."IsDibba", 'NO') = 'YES' THEN
                    (CASE WHEN ((aa."Amount" - l."DibbaAmount") * (100 - aa."Commission") / 100) > l."DibbaAmount"
                          THEN (((aa."Amount" - l."DibbaAmount") * (100 - aa."Commission") / 100))
                          ELSE 0 END)
               ELSE
                    ((aa."Amount") * (100 - aa."Commission") / 100)
               END
          ) AS "Amount"
        , aa."Number"::text
    FROM
    (
        SELECT DISTINCT
            td."Number", td."NumberType"
            , l."LedgerId"
            , (CASE WHEN varMode = 1 THEN 0 ELSE td."Commission" END) AS "Commission"
            , sum(CASE WHEN t."EntryType" = 'Main' THEN td."FinalAmount" ELSE 0 END) AS "FinalAmount"
            , round(sum(CASE WHEN t."EntryType" = 'Main' THEN (CASE WHEN t."TransactionMode" = 1 THEN
                ((CASE WHEN varMode = 1 THEN td."FinalAmount" ELSE td."Amount" END) * (100 - COALESCE(t."SelfHissa", 0)) * (100 -
                    COALESCE(
                        (SELECT sum(h."Hissa") FROM "hissa" h
                         WHERE h."RecordStatus" != 'D' AND h."LedgerId" = t."LedgerId" AND h."LedgerId" != h."HissaLedgerId")
                    , 0)
                )) / 10000
              ELSE 0 END) ELSE 0 END)) AS "Amount"
        FROM "transaction_detail" td
        JOIN "transaction" t ON td."TransactionId" = t."TransactionId"
        JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
        WHERE t."OrganizationId" = varOrganizationId
          AND t."TransactionDate" = varTransactionDate
          AND t."ShiftId" = varShiftId
          AND td."RecordStatus" != 'D'
          AND t."RecordStatus" != 'D'
          AND (COALESCE(varLedgerId, 0) = 0 OR t."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId
               OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
          AND (COALESCE(varAgentId, 0) = 0 OR l."AgentLedgerId" = varAgentId)
        GROUP BY td."Number", td."NumberType"
            , l."LedgerId"
            , td."Commission"
    ) AS aa
    JOIN "ledger" AS l ON l."LedgerId" = aa."LedgerId"
    GROUP BY aa."NumberType", aa."Number"
    ORDER BY aa."NumberType", aa."Number" ASC;
END;
$$;
