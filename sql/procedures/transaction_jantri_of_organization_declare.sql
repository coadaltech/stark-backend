-- Converted from MySQL procedure `transaction_jantri_of_organization_declare`.
DROP ROUTINE IF EXISTS "transaction_jantri_of_organization_declare";
CREATE OR REPLACE FUNCTION "transaction_jantri_of_organization_declare"(
    varOrganizationId bigint,
    varTransactionDate date,
    varShiftId integer,
    varLedgerId bigint,
    varAgentId bigint,
    varMode integer)
RETURNS TABLE("NumberType" integer, "Amount" double precision, "Number" text)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT AA."NumberType",
           sum(CASE WHEN COALESCE(l."IsDibba", 'NO') = 'YES' THEN
                        (CASE WHEN ((AA."Amount" - l."DibbaAmount") * (100 - AA."Commission") / 100) > l."DibbaAmount"
                              THEN (((AA."Amount" - l."DibbaAmount") * (100 - AA."Commission") / 100))
                              ELSE 0 END)
                    ELSE
                        ((AA."Amount") * (100 - AA."Commission") / 100)
                    END)::double precision AS "Amount",
           AA."Number"::text
    FROM (
        SELECT DISTINCT
               td."Number", td."NumberType",
               l2."LedgerId",
               (CASE WHEN varMode = 1 THEN 0 ELSE td."Commission" END) AS "Commission",
               sum(CASE WHEN t."EntryType" = 'Main' THEN td."FinalAmount" ELSE 0 END) AS "FinalAmount",
               round(sum(CASE WHEN t."EntryType" = 'Main' THEN
                             CASE WHEN t."TransactionMode" = 1 THEN
                                  ((CASE WHEN varMode = 1 THEN td."FinalAmount" ELSE td."Amount" END) * (100 - COALESCE(t."SelfHissa", 0)) * (100 -
                                      COALESCE(
                                          (SELECT sum(h."Hissa") FROM "hissa" h
                                           WHERE h."RecordStatus" != 'D' AND h."LedgerId" = t."LedgerId" AND h."LedgerId" != h."HissaLedgerId"),
                                          0)
                                  )) / 10000
                             ELSE 0 END
                         ELSE 0 END)::numeric)::double precision AS "Amount"
        FROM "transaction_detail_declare" td
        JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
        JOIN "ledger" l2 ON t."LedgerId" = l2."LedgerId"
        WHERE t."OrganizationId" = varOrganizationId
          AND t."TransactionDate" = varTransactionDate
          AND t."ShiftId" = varShiftId
          AND td."RecordStatus" != 'D'
          AND t."RecordStatus" != 'D'
          AND (COALESCE(varLedgerId, 0) = 0 OR t."LedgerId" = varLedgerId OR l2."ParentLedgerId" = varLedgerId
               OR l2."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
          AND (COALESCE(varAgentId, 0) = 0 OR l2."AgentLedgerId" = varAgentId)
        GROUP BY td."Number", td."NumberType",
                 l2."LedgerId",
                 td."Commission"
    ) AS AA
    JOIN "ledger" AS l ON l."LedgerId" = AA."LedgerId"
    GROUP BY AA."NumberType", AA."Number"
    ORDER BY AA."NumberType", AA."Number" ASC;
END;
$$;
