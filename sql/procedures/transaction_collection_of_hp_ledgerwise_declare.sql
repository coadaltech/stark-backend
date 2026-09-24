-- Converted from MySQL procedure `transaction_collection_of_hp_ledgerwise_declare`.
-- NOTE: MySQL's join CASE mixed int/string branches, so it evaluated as a string; td.Number is
-- compared as text here (e.g. '5' matches Num 5, '05' does not), same as MySQL.
DROP ROUTINE IF EXISTS "transaction_collection_of_hp_ledgerwise_declare";
CREATE OR REPLACE FUNCTION "transaction_collection_of_hp_ledgerwise_declare"(
    TransactionDates date,
    varShiftId bigint,
    varOrganizationId bigint,
    varHPLedgerId bigint,
    varAmountLess integer,
    varPercentLess integer
)
RETURNS TABLE("Number" integer, "NEW_BAL" numeric)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT aa."Number" AS "Number"
        , (CASE WHEN round((((sum(aa."NEW_BAL")) - varAmountLess) * (100 - varPercentLess) / 100)::numeric, 0) > 0
                THEN round((((sum(aa."NEW_BAL")) - varAmountLess) * (100 - varPercentLess) / 100)::numeric, 0)
                ELSE 0
           END)::numeric AS "NEW_BAL"
    FROM
    (
        SELECT sum(CASE WHEN t."TransactionMode" = 1 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END) AS "KhaiAmount"
            , sum(CASE WHEN t."TransactionMode" = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END) AS "LagaiAmount"
/*          (older NEW_BAL variant that also applied OtherHissa kept commented out in the MySQL source) */
            , sum((CASE WHEN t."TransactionMode" = 1 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END)
                - (CASE WHEN t."TransactionMode" = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END)) AS "Amount"
            , (sum(((CASE WHEN t."TransactionMode" = 1 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END)
                  - (CASE WHEN t."TransactionMode" = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END))
                  * (((100 - COALESCE(t."SelfHissa", 0)) / 100))
              )) AS "NEW_BAL"
            , mj."Num" AS "Number"
        FROM "transaction_detail_declare" td
        JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
            AND t."TransactionDate" = TransactionDates
            AND t."ShiftId" = varShiftId
            AND td."RecordStatus" != 'D'
            AND t."RecordStatus" != 'D'
            AND (COALESCE(varOrganizationId, 0) = 0 OR t."OrganizationId" = varOrganizationId)
        JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
        RIGHT JOIN "mainjantrinumbers" mj ON td."Number" = (CASE WHEN td."NumberType" = 1 THEN mj."Num"::text
                    WHEN td."NumberType" = 2 THEN right(lpad(((mj."Num" % 10) * 111)::text, 3, '0'), 3)
                    WHEN td."NumberType" = 3 THEN right(lpad(((floor(mj."Num"::numeric / 10)::bigint % 10) * 1111)::text, 4, '0'), 4)
                    ELSE '-1'
                    END)
        WHERE 1 = 1
          AND (COALESCE(varHPLedgerId, 0) = 0 OR l."HPLedgerId" = varHPLedgerId)
        GROUP BY mj."Num"
    ) AS aa
    GROUP BY aa."Number"
    ORDER BY aa."Number" ASC;
END;
$$;
