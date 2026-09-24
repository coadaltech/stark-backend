-- Converted from MySQL procedure `transaction_collection_of_organization_new`.
-- Notes: MySQL `x DIV n` -> trunc(x::numeric / NULLIF(n,0)) (x > 0 there), `x MOD n` -> mod(x::numeric, NULLIF(n,0)).
-- "Number" is text in all branches (MySQL returned varchar td.Number, or int mainjantrinumbers.Num in mixing mode).
-- varMultiplyUp was MySQL FLOAT (single precision) -> double precision.
DROP ROUTINE IF EXISTS "transaction_collection_of_organization_new";
CREATE OR REPLACE FUNCTION "transaction_collection_of_organization_new"(
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
    varIsMixing integer,
    varAgentLedgerId bigint,
    varAgentGroupId bigint,
    varAfterDeclare integer)  -- 0 for before declare 1 for after declare
RETURNS TABLE("TransactionId" integer, "Amount" numeric, "Number" text, "TransactionDate" date, "ShiftId" bigint)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varRoundBy integer;
    varRoundByShift integer;
BEGIN
    IF varAfterDeclare = 0 THEN
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
            round(
                CASE WHEN COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0) > 0
                THEN
                    (CASE WHEN (SELECT o."IsCollectionJantriRoundOf" FROM "organization" o WHERE o."OrganizationId" = varOrganizationId) = 1 THEN
                        trunc((COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric / NULLIF(varRoundBy, 0)) * varRoundBy
                        + CASE WHEN mod((COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric, NULLIF(varRoundBy, 0)) = 0 THEN 0 ELSE varRoundBy END
                    ELSE
                        (COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric
                    END)
                ELSE
                    0
                END
            , 0)
            AS "Amount",
            t."Number", t."TransactionDate", t."ShiftId"
            FROM (
                SELECT
                    (CASE WHEN COALESCE(l."IsDibba", 'NO') = 'YES' AND varIsDibba = 1 THEN
                        (CASE WHEN
                                COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN td."Amount" ELSE td."FinalAmount" END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                                > l."DibbaAmount" THEN
                            (
                                COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN td."Amount" ELSE td."FinalAmount" END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                                - l."DibbaAmount")
                        ELSE 0 END)
                    ELSE
                        COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN td."Amount" ELSE td."FinalAmount" END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                    END) AS "Amount",
                    td."Number"::text AS "Number", tr."TransactionDate", tr."ShiftId",
                    l."AgentLedgerId"
                FROM "transaction_detail" td
                JOIN "transaction" tr ON td."TransactionId" = tr."TransactionId"
                INNER JOIN "ledger" l ON tr."LedgerId" = l."LedgerId"
                WHERE tr."OrganizationId" = varOrganizationId
                  AND tr."TransactionDate" = varTransactionDate
                  AND tr."TransactionMode" = 1
                  AND tr."ShiftId" = varShiftId
                  AND (COALESCE(varLedgerId, '') = '' OR COALESCE(varLedgerId, '') = '0' OR tr."LedgerId"::text = ANY(string_to_array(varLedgerId, ',')) OR l."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))
                         OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))))
                    AND (COALESCE(varAgentId, 0) = 0 OR l."ParentLedgerId" IN (SELECT Res."LedgerId" FROM "ledger" AS Res
                                                                              WHERE Res."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."AgentLedgerId" = 31))
                        )
                  AND td."RecordStatus" != 'D'
                GROUP BY td."Number", tr."TransactionDate", tr."ShiftId", tr."LedgerId", l."DibbaAmount", l."IsDibba", l."AgentLedgerId"
            ) AS t
            JOIN "comman_master" AS agent ON agent."CommanMasterId" = t."AgentLedgerId" AND agent."CommanMasterType" = 1
            WHERE (COALESCE(varAgentLedgerId, 0) = 0 OR COALESCE(agent."LedgerId", 0) = COALESCE(varAgentLedgerId, 0))
              AND (COALESCE(varAgentGroupId, 0) = 0 OR COALESCE(t."AgentLedgerId", 0) = COALESCE(varAgentGroupId, 0))
            GROUP BY t."Number", t."TransactionDate", t."ShiftId";
        ELSE
            RETURN QUERY
            SELECT DISTINCT 0 AS "TransactionId",
            round(
                CASE WHEN COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0) > 0
                THEN
                    (CASE WHEN (SELECT o."IsCollectionJantriRoundOf" FROM "organization" o WHERE o."OrganizationId" = varOrganizationId) = 1 THEN
                        trunc((COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric / NULLIF(varRoundBy, 0)) * varRoundBy
                        + CASE WHEN mod((COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric, NULLIF(varRoundBy, 0)) = 0 THEN 0 ELSE varRoundBy END
                    ELSE
                        (COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric
                    END)
                ELSE
                    0
                END
            , 0)
            AS "Amount",
            t."Number", t."TransactionDate", t."ShiftId"
            FROM (
                SELECT
                    (CASE WHEN COALESCE(l."IsDibba", 'NO') = 'YES' AND varIsDibba = 1 THEN
                        (CASE WHEN
                                COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."Amount" ELSE td."Amount" / 10 END) ELSE (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                                > l."DibbaAmount" THEN
                            (
                                COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."Amount" ELSE td."Amount" / 10 END) ELSE (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                                - l."DibbaAmount")
                        ELSE 0 END)
                    ELSE
                        COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."Amount" ELSE td."Amount" / 10 END) ELSE (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                    END) AS "Amount",
                    mjn."Num"::text AS "Number", tr."TransactionDate", tr."ShiftId",
                    l."AgentLedgerId"
                FROM "transaction_detail" td
                JOIN "transaction" tr ON td."TransactionId" = tr."TransactionId"
                    AND tr."OrganizationId" = varOrganizationId
                    AND tr."TransactionDate" = varTransactionDate
                    AND tr."TransactionMode" = 1
                    AND tr."ShiftId" = varShiftId
                    AND td."RecordStatus" != 'D'
                INNER JOIN "ledger" l ON tr."LedgerId" = l."LedgerId"
                    AND (COALESCE(varLedgerId, '') = '' OR COALESCE(varLedgerId, '') = '0' OR tr."LedgerId"::text = ANY(string_to_array(varLedgerId, ',')) OR l."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))
                         OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))))
                    AND (COALESCE(varAgentId, 0) = 0 OR l."ParentLedgerId" IN (SELECT Res."LedgerId" FROM "ledger" AS Res
                                                                              WHERE Res."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."AgentLedgerId" = 31))
                        )
                RIGHT JOIN "mainjantrinumbers" mjn ON td."Number" = (CASE WHEN td."NumberType" = 1 THEN mjn."Num"::text
                        WHEN td."NumberType" = 2 THEN right(lpad(((mjn."Num" % 10) * 111)::text, 3, '0'), 3)
                        WHEN td."NumberType" = 3 THEN right(lpad(((floor(mjn."Num"::numeric / 10)::bigint % 10) * 1111)::text, 4, '0'), 4)
                        ELSE '-1'
                        END)
                GROUP BY mjn."Num", tr."TransactionDate", tr."ShiftId", tr."LedgerId", l."DibbaAmount", l."IsDibba", l."AgentLedgerId"
            ) AS t
            JOIN "comman_master" AS agent ON agent."CommanMasterId" = t."AgentLedgerId" AND agent."CommanMasterType" = 1
            WHERE (COALESCE(varAgentLedgerId, 0) = 0 OR COALESCE(agent."LedgerId", 0) = COALESCE(varAgentLedgerId, 0))
              AND (COALESCE(varAgentGroupId, 0) = 0 OR COALESCE(t."AgentLedgerId", 0) = COALESCE(varAgentGroupId, 0))
            GROUP BY t."Number", t."TransactionDate", t."ShiftId";
        END IF;
    ELSE
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
            round(
                CASE WHEN COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0) > 0
                THEN
                    (CASE WHEN (SELECT o."IsCollectionJantriRoundOf" FROM "organization" o WHERE o."OrganizationId" = varOrganizationId) = 1 THEN
                        trunc((COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric / NULLIF(varRoundBy, 0)) * varRoundBy
                        + CASE WHEN mod((COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric, NULLIF(varRoundBy, 0)) = 0 THEN 0 ELSE varRoundBy END
                    ELSE
                        (COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric
                    END)
                ELSE
                    0
                END
            , 0)
            AS "Amount",
            t."Number", t."TransactionDate", t."ShiftId"
            FROM (
                SELECT
                    (CASE WHEN COALESCE(l."IsDibba", 'NO') = 'YES' AND varIsDibba = 1 THEN
                        (CASE WHEN
                                COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN td."Amount" ELSE td."FinalAmount" END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                                > l."DibbaAmount" THEN
                            (
                                COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN td."Amount" ELSE td."FinalAmount" END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                                - l."DibbaAmount")
                        ELSE 0 END)
                    ELSE
                        COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN td."Amount" ELSE td."FinalAmount" END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                    END) AS "Amount",
                    td."Number"::text AS "Number", tr."TransactionDate", tr."ShiftId",
                    l."AgentLedgerId"
                FROM "transaction_detail_declare" td
                JOIN "transaction_declare" tr ON td."TransactionId" = tr."TransactionId"
                INNER JOIN "ledger" l ON tr."LedgerId" = l."LedgerId"
                WHERE tr."OrganizationId" = varOrganizationId
                  AND tr."TransactionDate" = varTransactionDate
                  AND tr."TransactionMode" = 1
                  AND tr."ShiftId" = varShiftId
                  AND (COALESCE(varLedgerId, '') = '' OR COALESCE(varLedgerId, '') = '0' OR tr."LedgerId"::text = ANY(string_to_array(varLedgerId, ',')) OR l."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))
                         OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))))
                    AND (COALESCE(varAgentId, 0) = 0 OR l."ParentLedgerId" IN (SELECT Res."LedgerId" FROM "ledger" AS Res
                                                                              WHERE Res."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."AgentLedgerId" = 31))
                        )
                  AND td."RecordStatus" != 'D'
                GROUP BY td."Number", tr."TransactionDate", tr."ShiftId", tr."LedgerId", l."DibbaAmount", l."IsDibba", l."AgentLedgerId"
            ) AS t
            JOIN "comman_master" AS agent ON agent."CommanMasterId" = t."AgentLedgerId" AND agent."CommanMasterType" = 1
            WHERE (COALESCE(varAgentLedgerId, 0) = 0 OR COALESCE(agent."LedgerId", 0) = COALESCE(varAgentLedgerId, 0))
              AND (COALESCE(varAgentGroupId, 0) = 0 OR COALESCE(t."AgentLedgerId", 0) = COALESCE(varAgentGroupId, 0))
            GROUP BY t."Number", t."TransactionDate", t."ShiftId";
        ELSE
            RETURN QUERY
            SELECT DISTINCT 0 AS "TransactionId",
            round(
                CASE WHEN COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0) > 0
                THEN
                    (CASE WHEN (SELECT o."IsCollectionJantriRoundOf" FROM "organization" o WHERE o."OrganizationId" = varOrganizationId) = 1 THEN
                        trunc((COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric / NULLIF(varRoundBy, 0)) * varRoundBy
                        + CASE WHEN mod((COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric, NULLIF(varRoundBy, 0)) = 0 THEN 0 ELSE varRoundBy END
                    ELSE
                        (COALESCE((((sum(t."Amount") * varMultiplyUp) - varAmountLess) * (100 - varPercentLess) / 100), 0))::numeric
                    END)
                ELSE
                    0
                END
            , 0)
            AS "Amount",
            t."Number", t."TransactionDate", t."ShiftId"
            FROM (
                SELECT
                    (CASE WHEN COALESCE(l."IsDibba", 'NO') = 'YES' AND varIsDibba = 1 THEN
                        (CASE WHEN
                                COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."Amount" ELSE td."Amount" / 10 END) ELSE (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                                > l."DibbaAmount" THEN
                            (
                                COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."Amount" ELSE td."Amount" / 10 END) ELSE (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                                - l."DibbaAmount")
                        ELSE 0 END)
                    ELSE
                        COALESCE(sum((CASE WHEN tr."EntryType" = 'Main' THEN (CASE WHEN varIsCommCut = 0 THEN (CASE WHEN td."NumberType" = 1 THEN td."Amount" ELSE td."Amount" / 10 END) ELSE (CASE WHEN td."NumberType" = 1 THEN td."FinalAmount" ELSE td."FinalAmount" / 10 END) END) ELSE 0 END)
                                 * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."SelfHissa" END), 0)) / 100)) * (((100 - COALESCE((CASE WHEN varIsHissaCut = 0 THEN 0 ELSE tr."OtherHissa" END), 0)) / 100))
                                 ), 0)
                    END) AS "Amount",
                    mjn."Num"::text AS "Number", tr."TransactionDate", tr."ShiftId",
                    l."AgentLedgerId"
                FROM "transaction_detail_declare" td
                JOIN "transaction_declare" tr ON td."TransactionId" = tr."TransactionId"
                    AND tr."OrganizationId" = varOrganizationId
                    AND tr."TransactionDate" = varTransactionDate
                    AND tr."TransactionMode" = 1
                    AND tr."ShiftId" = varShiftId
                    AND td."RecordStatus" != 'D'
                INNER JOIN "ledger" l ON tr."LedgerId" = l."LedgerId"
                    AND (COALESCE(varLedgerId, '') = '' OR COALESCE(varLedgerId, '') = '0' OR tr."LedgerId"::text = ANY(string_to_array(varLedgerId, ',')) OR l."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))
                         OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId"::text = ANY(string_to_array(varLedgerId, ','))))
                    AND (COALESCE(varAgentId, 0) = 0 OR l."ParentLedgerId" IN (SELECT Res."LedgerId" FROM "ledger" AS Res
                                                                              WHERE Res."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."AgentLedgerId" = 31))
                        )
                RIGHT JOIN "mainjantrinumbers" mjn ON td."Number" = (CASE WHEN td."NumberType" = 1 THEN mjn."Num"::text
                        WHEN td."NumberType" = 2 THEN right(lpad(((mjn."Num" % 10) * 111)::text, 3, '0'), 3)
                        WHEN td."NumberType" = 3 THEN right(lpad(((floor(mjn."Num"::numeric / 10)::bigint % 10) * 1111)::text, 4, '0'), 4)
                        ELSE '-1'
                        END)
                GROUP BY mjn."Num", tr."TransactionDate", tr."ShiftId", tr."LedgerId", l."DibbaAmount", l."IsDibba", l."AgentLedgerId"
            ) AS t
            JOIN "comman_master" AS agent ON agent."CommanMasterId" = t."AgentLedgerId" AND agent."CommanMasterType" = 1
            WHERE (COALESCE(varAgentLedgerId, 0) = 0 OR COALESCE(agent."LedgerId", 0) = COALESCE(varAgentLedgerId, 0))
              AND (COALESCE(varAgentGroupId, 0) = 0 OR COALESCE(t."AgentLedgerId", 0) = COALESCE(varAgentGroupId, 0))
            GROUP BY t."Number", t."TransactionDate", t."ShiftId";
        END IF;
    END IF;
END;
$$;
