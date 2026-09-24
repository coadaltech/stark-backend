-- Converted from MySQL procedure `transaction_declare_collection_of_organization`.
-- The repeated MySQL amount expression
--   X = IFNULL((((SUM(t.Amount) * varMultiplyUp) - varAmountLess) * (100 - varPercentLess)/100), 0)
-- is computed once in a derived table (x.v); rounding up to varRoundBy uses DIV -> trunc, MOD -> numeric %.
-- NOTE (mixing branch): the MySQL source referenced l.GroupId inside the ON clause of the
-- transaction_declare join, before `ledger l` was joined (MySQL raises "Unknown column" there).
-- That condition is moved to the ON clause of the (inner) ledger join, which is the evident intent.
DROP ROUTINE IF EXISTS "transaction_declare_collection_of_organization";
CREATE OR REPLACE FUNCTION "transaction_declare_collection_of_organization"(
    varOrganizationId bigint,
    varTransactionDate date,
    varShiftId integer,
    varLedgerId varchar,
    varAgentId bigint,
    varAmountLess integer,
    varPercentLess integer,
    varMultiplyUp double precision,
    varIsCommCut integer,
    varIsHissaCut integer,
    varIsDibba integer,
    varIsMixing integer
)
RETURNS TABLE("TransactionId" integer, "Amount" numeric, "Number" text, "TransactionDate" date, "ShiftId" bigint)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varRoundBy integer;
    varRoundByShift integer;
BEGIN
    SELECT o."RoundOffOnCollection" INTO varRoundBy
    FROM "organization" o
    WHERE o."OrganizationId" = varOrganizationId;

    SELECT s."RoundOffOnCollection" INTO varRoundByShift
    FROM "shift" s
    WHERE s."ShiftId" = varShiftId;

    varRoundBy := CASE WHEN COALESCE(varRoundByShift, 0) > 0 THEN COALESCE(varRoundByShift, 0) ELSE varRoundBy END;

    IF COALESCE(varIsMixing, 0) = 0 THEN

        RETURN QUERY
        SELECT DISTINCT 0 AS "TransactionId",
            round((CASE WHEN x.v > 0 THEN
                (CASE WHEN (SELECT o."IsCollectionJantriRoundOf" FROM "organization" o WHERE o."OrganizationId" = varOrganizationId) = 1 THEN
                    trunc((x.v / NULLIF(varRoundBy, 0))::numeric) * varRoundBy
                    + (CASE WHEN (x.v::numeric % NULLIF(varRoundBy, 0)) = 0 THEN 0 ELSE varRoundBy END)
                 ELSE
                    x.v::numeric
                 END)
             ELSE
                0
             END)::numeric, 0) AS "Amount",
            x."Number"::text, x."TransactionDate", x."ShiftId"
        FROM (
            SELECT COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0) AS v,
                   t."Number", t."TransactionDate", t."ShiftId"
            FROM (
                SELECT
                    (CASE WHEN COALESCE(l."IsDibba", 'NO') = 'YES' AND varIsDibba = 1 THEN
                        (CASE WHEN
                                COALESCE(sum((CASE WHEN t."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN td."Amount" ELSE td."FinalAmount" END) ELSE 0 END)
                                * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."SelfHissa" END, 0)) / 100)) * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."OtherHissa" END, 0)) / 100))
                                ), 0)
                                > l."DibbaAmount" THEN
                            (
                                COALESCE(sum((CASE WHEN t."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN td."Amount" ELSE td."FinalAmount" END) ELSE 0 END)
                                * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."SelfHissa" END, 0)) / 100)) * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."OtherHissa" END, 0)) / 100))
                                ), 0)
                                - l."DibbaAmount")
                         ELSE 0 END)
                     ELSE
                        COALESCE(sum((CASE WHEN t."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN td."Amount" ELSE td."FinalAmount" END) ELSE 0 END)
                        * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."SelfHissa" END, 0)) / 100)) * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."OtherHissa" END, 0)) / 100))
                        ), 0)
                     END) AS "Amount",
                    td."Number", t."TransactionDate", t."ShiftId"
                FROM "transaction_detail_declare" td
                JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
                INNER JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
                WHERE t."OrganizationId" = varOrganizationId
                  AND t."TransactionDate" = varTransactionDate
                  AND (t."TransactionMode" = 1
                       OR (CASE WHEN strpos(varLedgerId, ',') = 0 AND (COALESCE(varLedgerId, '') != '' AND COALESCE(varLedgerId, '') != '0') THEN l."GroupId" = 2 ELSE false END)
                      )
                  AND t."ShiftId" = varShiftId
                  AND (COALESCE(varLedgerId, '') = '' OR COALESCE(varLedgerId, '') = '0'
                       OR t."LedgerId"::text = ANY(string_to_array(varLedgerId, ','))
                       OR l."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))
                       OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))))
                  AND (COALESCE(varAgentId, 0) = 0 OR l."ParentLedgerId" IN (SELECT res."LedgerId" FROM "ledger" AS res
                                                          WHERE res."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."AgentLedgerId" = varAgentId))
                      )
                  AND td."RecordStatus" != 'D'
                GROUP BY td."Number", t."TransactionDate", t."ShiftId", t."LedgerId", l."DibbaAmount", l."IsDibba"
            ) AS t
            GROUP BY t."Number", t."TransactionDate", t."ShiftId"
        ) AS x;

    ELSE

        RETURN QUERY
        SELECT DISTINCT 0 AS "TransactionId",
            round((CASE WHEN x.v > 0 THEN
                (CASE WHEN (SELECT o."IsCollectionJantriRoundOf" FROM "organization" o WHERE o."OrganizationId" = varOrganizationId) = 1 THEN
                    trunc((x.v / NULLIF(varRoundBy, 0))::numeric) * varRoundBy
                    + (CASE WHEN (x.v::numeric % NULLIF(varRoundBy, 0)) = 0 THEN 0 ELSE varRoundBy END)
                 ELSE
                    x.v::numeric
                 END)
             ELSE
                0
             END)::numeric, 0) AS "Amount",
            x."Number"::text, x."TransactionDate", x."ShiftId"
        FROM (
            SELECT COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0) AS v,
                   t."Number", t."TransactionDate", t."ShiftId"
            FROM (
                SELECT
                    (CASE WHEN COALESCE(l."IsDibba", 'NO') = 'YES' AND varIsDibba = 1 THEN
                        (CASE WHEN
                                COALESCE(sum((CASE WHEN t."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."Amount" ELSE td."Amount" / 10 END) ELSE (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) END) ELSE 0 END)
                                * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."SelfHissa" END, 0)) / 100)) * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."OtherHissa" END, 0)) / 100))
                                ), 0)
                                > l."DibbaAmount" THEN
                            (
                                COALESCE(sum((CASE WHEN t."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."Amount" ELSE td."Amount" / 10 END) ELSE (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) END) ELSE 0 END)
                                * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."SelfHissa" END, 0)) / 100)) * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."OtherHissa" END, 0)) / 100))
                                ), 0)
                                - l."DibbaAmount")
                         ELSE 0 END)
                     ELSE
                        COALESCE(sum((CASE WHEN t."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."Amount" ELSE td."Amount" / 10 END) ELSE (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) END) ELSE 0 END)
                        * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."SelfHissa" END, 0)) / 100)) * (((100 - COALESCE(CASE WHEN varIsHissaCut = 0 THEN 0 ELSE t."OtherHissa" END, 0)) / 100))
                        ), 0)
                     END) AS "Amount",
                    mj."Num" AS "Number", t."TransactionDate", t."ShiftId"
                FROM "transaction_detail_declare" td
                JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
                    AND t."OrganizationId" = varOrganizationId
                    AND t."TransactionDate" = varTransactionDate
                    AND t."ShiftId" = varShiftId
                    AND td."RecordStatus" != 'D'
                INNER JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
                    -- moved here from the transaction_declare ON clause (references l)
                    AND (t."TransactionMode" = 1
                         OR (CASE WHEN strpos(varLedgerId, ',') = 0 AND (COALESCE(varLedgerId, '') != '' AND COALESCE(varLedgerId, '') != '0') THEN l."GroupId" = 2 ELSE false END)
                        )
                    AND (COALESCE(varLedgerId, '') = '' OR COALESCE(varLedgerId, '') = '0'
                         OR t."LedgerId"::text = ANY(string_to_array(varLedgerId, ','))
                         OR l."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))
                         OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))))
                    AND (COALESCE(varAgentId, 0) = 0 OR l."ParentLedgerId" IN (SELECT res."LedgerId" FROM "ledger" AS res
                                                            WHERE res."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."AgentLedgerId" = varAgentId))
                        )
                RIGHT JOIN "mainjantrinumbers" mj ON td."Number" = (CASE WHEN td."NumberType" = 1 THEN mj."Num"::text
                        WHEN td."NumberType" = 2 THEN right(lpad(((mj."Num" % 10) * 111)::text, 3, '0'), 3)
                        WHEN td."NumberType" = 3 THEN right(lpad(((floor(mj."Num"::numeric / 10)::bigint % 10) * 1111)::text, 4, '0'), 4)
                        ELSE '-1'
                        END)
                GROUP BY mj."Num", t."TransactionDate", t."ShiftId", t."LedgerId", l."DibbaAmount", l."IsDibba"
            ) AS t
            GROUP BY t."Number", t."TransactionDate", t."ShiftId"
        ) AS x;

    END IF;
END;
$$;
