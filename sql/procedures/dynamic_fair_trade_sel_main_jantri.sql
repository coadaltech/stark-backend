-- Converted from MySQL procedure `dynamic_fair_trade_sel_main_jantri`.
-- Calls "dynamic_fair_trade_sel_preductiondata_allnumber"(..., 2): with varIsNotShow = 2 the callee emits no
-- result set (it only refreshes mainjantrinumbers.profit), so it is invoked with PERFORM.
DROP ROUTINE IF EXISTS "dynamic_fair_trade_sel_main_jantri";
CREATE OR REPLACE FUNCTION "dynamic_fair_trade_sel_main_jantri"(
    TransactionDates date,
    varShiftId bigint,
    varOrganizationId bigint,
    varLedgerId bigint,
    varAgentId bigint,
    varAmountLess integer,
    varPercentLess integer,
    varMultiplyUp double precision
)
RETURNS TABLE("Number" integer, "profit" double precision, "NEW_BAL" numeric)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varRoundBy integer;
BEGIN
    SELECT o."RoundOffOnMainJantri" INTO varRoundBy
    FROM "organization" o
    WHERE o."OrganizationId" = varOrganizationId;

    PERFORM "dynamic_fair_trade_sel_preductiondata_allnumber"(TransactionDates, varShiftId, varOrganizationId, 2::smallint);

    RETURN QUERY
    WITH q AS (
        SELECT aa."Number" AS "Number"
            -- MySQL: non-grouped `profit` (any row of the group)
            , any_value(aa."Profit") AS "profit"
            , (CASE WHEN round((((sum(CASE WHEN COALESCE(aa."IsDibba", 'NO') = 'YES'
                                           THEN (CASE WHEN aa."NEW_BAL" > aa."DibbaAmount" THEN (aa."NEW_BAL" - aa."DibbaAmount") ELSE 0 END)
                                           ELSE aa."NEW_BAL" END) * varMultiplyUp)
                                 - varAmountLess) * (100 - varPercentLess) / 100)::numeric, 0) > 0
                    THEN round((((sum(CASE WHEN COALESCE(aa."IsDibba", 'NO') = 'YES'
                                           THEN (CASE WHEN aa."NEW_BAL" > aa."DibbaAmount" THEN (aa."NEW_BAL" - aa."DibbaAmount") ELSE 0 END)
                                           ELSE aa."NEW_BAL" END) * varMultiplyUp)
                                 - varAmountLess) * (100 - varPercentLess) / 100)::numeric, 0)
                    ELSE 0
               END)::numeric AS "X"
        FROM
        (
            SELECT sum(CASE WHEN t."TransactionMode" = 1 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END) AS "KhaiAmount"
                , sum(CASE WHEN t."TransactionMode" = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END) AS "LagaiAmount"
                , sum((CASE WHEN t."TransactionMode" = 1 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END)
                    - (CASE WHEN t."TransactionMode" = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END)) AS "Amount"
                , (sum(((CASE WHEN t."TransactionMode" = 1 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END)
                      - (CASE WHEN t."TransactionMode" = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) ELSE 0 END))
                      * (((100 - COALESCE(t."SelfHissa", 0)) / 100)) * (((100 - COALESCE(t."OtherHissa", 0)) / 100))
                  )) AS "NEW_BAL"
                , l."DibbaAmount", l."IsDibba"
                , mj."Num" AS "Number"
                , mj."profit" AS "Profit"
            FROM "transaction_detail" td
            JOIN "transaction" t ON td."TransactionId" = t."TransactionId"
                AND (t."TransactionMode" = 1 OR COALESCE(varLedgerId, 0) != 0)
                AND t."TransactionDate" = TransactionDates
                AND t."ShiftId" = varShiftId
                AND td."RecordStatus" != 'D'
                AND t."RecordStatus" != 'D'
                AND (COALESCE(varOrganizationId, 0) = 0 OR t."OrganizationId" = varOrganizationId)
            JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
            -- MySQL's CASE mixed int/string branches, so it evaluated as a string: text comparison.
            RIGHT JOIN "mainjantrinumbers" mj ON td."Number" = (CASE WHEN td."NumberType" = 1 THEN mj."Num"::text
                        WHEN td."NumberType" = 2 THEN right(lpad(((mj."Num" % 10) * 111)::text, 3, '0'), 3)
                        WHEN td."NumberType" = 3 THEN right(lpad(((floor(mj."Num"::numeric / 10)::bigint % 10) * 1111)::text, 4, '0'), 4)
                        ELSE '-1'
                        END)
            WHERE 1 = 1
              AND (COALESCE(varLedgerId, 0) = 0 OR t."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId
                   OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
              -- NOTE: AgentLedgerId = 31 is hard-coded in the MySQL source (varAgentId only toggles the filter).
              AND (COALESCE(varAgentId, 0) = 0 OR l."ParentLedgerId" IN (SELECT res."LedgerId" FROM "ledger" AS res
                                                        WHERE res."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."AgentLedgerId" = 31))
                  )
            GROUP BY mj."Num", mj."profit", l."DibbaAmount", l."IsDibba"
        ) AS aa
        GROUP BY aa."Number"
    )
    SELECT q."Number"
        , q."profit"
        , (CASE WHEN (SELECT o."IsMainJantriRoundOf" FROM "organization" o WHERE o."OrganizationId" = varOrganizationId) = 1 THEN
                -- (X div varRoundBy) * varRoundBy + IF(X mod varRoundBy = 0, 0, varRoundBy); MySQL DIV/MOD by 0 -> NULL
                (div(q."X", NULLIF(varRoundBy, 0)) * varRoundBy
                 + (CASE WHEN (q."X" % NULLIF(varRoundBy, 0)) = 0 THEN 0 ELSE varRoundBy END))
           ELSE
                q."X"
           END)::numeric AS "NEW_BAL"
    FROM q
    ORDER BY q."Number" ASC;
END;
$$;
