-- Converted from MySQL procedure `transaction_agent_agentgroup_list`.
-- varListType: 0 for Agents, 1 for Agent Groups.
-- In the agent-group branch MySQL's ifnull(agent.CommanMasterId,'') produced a string; here
-- both branches return "ListLedgerId" as bigint (CommanMasterId is never NULL there: inner join).
DROP ROUTINE IF EXISTS "transaction_agent_agentgroup_list";
CREATE OR REPLACE FUNCTION "transaction_agent_agentgroup_list"(
    varOrganizationId bigint,
    varTransactionDate date,
    varShiftId integer,
    varAgentId bigint,
    varListType integer
)
RETURNS TABLE(
    "ListName" text,
    "ListLedgerId" bigint,
    "ListType" integer,
    "TotalSale" double precision,
    "AgentName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    IF COALESCE(varListType, 0) = 0 THEN
        RETURN QUERY
        SELECT main_agent."LedgerName"::text AS "ListName"
             , agent."LedgerId" AS "ListLedgerId"
             , varListType AS "ListType"
             , sum(t."TotalSale") AS "TotalSale"
             , ''::text AS "AgentName"
        FROM "ledger" ledger
        JOIN (
            SELECT tr."LedgerId", sum(tr."TotalAmount") AS "TotalSale"
            FROM "transaction" tr
            WHERE tr."OrganizationId" = varOrganizationId
              AND tr."TransactionDate" = varTransactionDate
              AND tr."TransactionMode" = 1
              AND tr."ShiftId" = varShiftId
            GROUP BY tr."LedgerId"
            UNION
            SELECT trd."LedgerId", sum(trd."TotalAmount") AS "TotalSale"
            FROM "transaction_declare" trd
            WHERE trd."OrganizationId" = varOrganizationId
              AND trd."TransactionDate" = varTransactionDate
              AND trd."TransactionMode" = 1
              AND trd."ShiftId" = varShiftId
            GROUP BY trd."LedgerId"
        ) AS t ON ledger."LedgerId" = t."LedgerId"
        JOIN "comman_master" AS agent ON agent."CommanMasterId" = ledger."AgentLedgerId" AND agent."CommanMasterType" = 1
        JOIN "ledger" AS main_agent ON main_agent."LedgerId" = agent."LedgerId"
        WHERE (COALESCE(varAgentId, 0) = 0 OR COALESCE(agent."LedgerId", 0) = COALESCE(varAgentId, 0))
        -- and ifnull(ledger.ParentLedgerId ,9) = 0
        GROUP BY main_agent."LedgerName", agent."LedgerId"
        ORDER BY main_agent."LedgerName";
    ELSE
        RETURN QUERY
        SELECT COALESCE(agent."CommanMasterName", '')::text AS "ListName"
             , agent."CommanMasterId" AS "ListLedgerId"
             , varListType AS "ListType"
             , sum(t."TotalSale") AS "TotalSale"
             , main_agent."LedgerName"::text AS "AgentName"
        FROM "ledger" ledger
        JOIN (
            SELECT tr."LedgerId", sum(tr."TotalAmount") AS "TotalSale"
            FROM "transaction" tr
            WHERE tr."OrganizationId" = varOrganizationId
              AND tr."TransactionDate" = varTransactionDate
              AND tr."TransactionMode" = 1
              AND tr."ShiftId" = varShiftId
            GROUP BY tr."LedgerId"
            UNION
            SELECT trd."LedgerId", sum(trd."TotalAmount") AS "TotalSale"
            FROM "transaction_declare" trd
            WHERE trd."OrganizationId" = varOrganizationId
              AND trd."TransactionDate" = varTransactionDate
              AND trd."TransactionMode" = 1
              AND trd."ShiftId" = varShiftId
            GROUP BY trd."LedgerId"
        ) AS t ON ledger."LedgerId" = t."LedgerId"
        JOIN "comman_master" AS agent ON agent."CommanMasterId" = ledger."AgentLedgerId" AND agent."CommanMasterType" = 1
        LEFT JOIN "ledger" AS main_agent ON main_agent."LedgerId" = agent."LedgerId"
        WHERE (COALESCE(varAgentId, 0) = 0 OR COALESCE(agent."LedgerId", 0) = COALESCE(varAgentId, 0))
        -- and ifnull(ledger.ParentLedgerId ,9) = 0
        GROUP BY agent."CommanMasterName", agent."CommanMasterId", main_agent."LedgerName"
        ORDER BY agent."CommanMasterName";
    END IF;
END;
$$;
