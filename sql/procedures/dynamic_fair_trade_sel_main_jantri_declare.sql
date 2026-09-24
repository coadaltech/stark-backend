-- Converted from MySQL procedure `dynamic_fair_trade_sel_main_jantri_declare`.
-- Reads mainjantrinumbers as it currently is (the call that would refill it is commented out
-- in the original too).
-- The right-join key `CASE ... THEN Num ... THEN right(lpad(..)) ... ELSE -1 END` had a VARCHAR
-- result type in MySQL (mixed int/string branches), so it is compared as text here.
-- The outer per-Number sum S is computed in subquery g; NEW_BAL is then derived from it with
-- the original expression (round(x,0) -> round(x::numeric,0); DIV/MOD -> div()/mod(), NULL on 0).
-- Note: `dis.AgentLedgerId = 31` is hard-coded in the original and kept.
DROP ROUTINE IF EXISTS "dynamic_fair_trade_sel_main_jantri_declare";
CREATE OR REPLACE FUNCTION "dynamic_fair_trade_sel_main_jantri_declare"(
    TransactionDates date,
    varShiftId bigint,
    varOrganizationId bigint,
    varLedgerId bigint,
    varAgentId bigint,
    varAmountLess integer,
    varPercentLess integer,
    varMultiplyUp double precision
)
RETURNS TABLE(
    "Number" integer,
    "profit" double precision,
    "NEW_BAL" numeric
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varRoundBy integer;
BEGIN
    SELECT o."RoundOffOnMainJantri" INTO varRoundBy
    FROM "organization" o
    WHERE o."OrganizationId" = varOrganizationId;

    -- call dynamic_fair_trade_sel_preductiondata_allnumber_declare(TransactionDates,varShiftId,varOrganizationId,2);

    RETURN QUERY
    SELECT g."Number" AS "Number"
         , g."profit"
         , (CASE WHEN (SELECT o."IsMainJantriRoundOf" FROM "organization" o WHERE o."OrganizationId" = varOrganizationId) = 1 THEN
                div((CASE WHEN round(((((g.s * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100))::numeric, 0) > 0
                          THEN round((((g.s * varMultiplyUp - varAmountLess) * (100 - varPercentLess) / 100))::numeric, 0)
                          ELSE 0 END),
                    NULLIF(varRoundBy, 0)) * varRoundBy
                + (CASE WHEN mod((CASE WHEN round(((((g.s * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100))::numeric, 0) > 0
                                       THEN round((((g.s * varMultiplyUp - varAmountLess) * (100 - varPercentLess) / 100))::numeric, 0)
                                       ELSE 0 END),
                                 NULLIF(varRoundBy, 0)) = 0
                        THEN 0 ELSE varRoundBy END)
            ELSE
                (CASE WHEN round(((((g.s * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100))::numeric, 0) > 0
                      THEN round((((g.s * varMultiplyUp - varAmountLess) * (100 - varPercentLess) / 100))::numeric, 0)
                      ELSE 0 END)
            END) AS "NEW_BAL"
    FROM (
        SELECT AA."Number"
             , any_value(AA."Profit") AS "profit"
             , sum(CASE WHEN COALESCE(AA."IsDibba", 'NO') = 'YES'
                        THEN (CASE WHEN AA."NEW_BAL" > AA."DibbaAmount" THEN (AA."NEW_BAL" - AA."DibbaAmount") ELSE 0 END)
                        ELSE AA."NEW_BAL" END) AS s
        FROM (
            SELECT sum(CASE WHEN t."TransactionMode" = 1 THEN CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END ELSE 0 END) AS "KhaiAmount"
                 , sum(CASE WHEN t."TransactionMode" = 0 THEN CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END ELSE 0 END) AS "LagaiAmount"
                 , sum((CASE WHEN t."TransactionMode" = 1 THEN CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END ELSE 0 END)
                     - (CASE WHEN t."TransactionMode" = 0 THEN CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END ELSE 0 END)) AS "Amount"
                 , sum(((CASE WHEN t."TransactionMode" = 1 THEN CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END ELSE 0 END)
                      - (CASE WHEN t."TransactionMode" = 0 THEN CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END ELSE 0 END))
                       * ((100 - COALESCE(t."SelfHissa", 0)) / 100) * ((100 - COALESCE(t."OtherHissa", 0)) / 100)
                      ) AS "NEW_BAL"
                 , l."DibbaAmount", l."IsDibba"
                 , mjn."Num" AS "Number"
                 , mjn."profit" AS "Profit"
            FROM "transaction_detail_declare" td
            JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
                 AND (t."TransactionMode" = 1 OR COALESCE(varLedgerId, 0) != 0)
                 AND t."TransactionDate" = TransactionDates
                 AND t."ShiftId" = varShiftId
                 AND td."RecordStatus" != 'D'
                 AND t."RecordStatus" != 'D'
                 AND (COALESCE(varOrganizationId, 0) = 0 OR t."OrganizationId" = varOrganizationId)
            JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
            RIGHT JOIN "mainjantrinumbers" mjn ON td."Number" = (CASE WHEN td."NumberType" = 1 THEN mjn."Num"::text
                         WHEN td."NumberType" = 2 THEN right(lpad(((mjn."Num" % 10) * 111)::text, 3, '0'), 3)
                         WHEN td."NumberType" = 3 THEN right(lpad(((floor(mjn."Num"::numeric / 10)::bigint % 10) * 1111)::text, 4, '0'), 4)
                         ELSE '-1'
                         END)
            WHERE 1 = 1
              AND (COALESCE(varLedgerId, 0) = 0 OR t."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId
                   OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
              AND (COALESCE(varAgentId, 0) = 0
                   OR l."ParentLedgerId" IN (SELECT Res."LedgerId" FROM "ledger" AS Res
                                             WHERE Res."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."AgentLedgerId" = 31)))
            GROUP BY mjn."Num", mjn."profit", l."DibbaAmount", l."IsDibba"
        ) AS AA
        GROUP BY AA."Number"
    ) AS g
    ORDER BY g."Number" ASC;
END;
$$;
