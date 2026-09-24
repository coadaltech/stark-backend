-- Converted from MySQL procedure `chat_rpt_group_list`.
DROP ROUTINE IF EXISTS "chat_rpt_group_list";
CREATE OR REPLACE FUNCTION "chat_rpt_group_list"(
    varOrganizationId bigint,
    varLedgerId bigint
)
RETURNS TABLE(
    "ChatGroupId" bigint,
    "ChatGroupName" text,
    "ChatType" text,
    "OrgChatGroupId" bigint,
    "UnReadMessage" integer,
    "OperatorId" bigint,
    "OperatorName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT ledger."LedgerId" AS "ChatGroupId", ledger."LedgerName"::text AS "ChatGroupName", '0'::text AS "ChatType", ledger."ChatGroupId" AS "OrgChatGroupId"
        , 0 AS "UnReadMessage", ledger."LedgerId" AS "OperatorId", ledger."LedgerName"::text AS "OperatorName"
    FROM "ledger"
    WHERE COALESCE(ledger."ChatGroupId", 0) != 0
      AND ledger."ChatGroupId" IN (SELECT cg."ChatGroupId" FROM "chat_group" cg WHERE COALESCE(cg."IsAllow", 1) = 1)
      AND (ledger."LedgerId" = varLedgerId
           OR ledger."LedgerId" IN (SELECT cla."AssociateLedgerId" FROM "chat_ledger_associate" cla WHERE cla."LedgerId" = varLedgerId)
          )
      AND ledger."RecordStatus" != 'D'
    UNION ALL
    SELECT ledger."LedgerId" AS "ChatGroupId", ledger."LedgerName"::text AS "ChatGroupName", '0'::text AS "ChatType", ledger."ChatGroupId" AS "OrgChatGroupId"
        , 0 AS "UnReadMessage", varLedgerId AS "OperatorId"
        , (SELECT op."LedgerName"::text FROM "ledger" op WHERE op."LedgerId" = varLedgerId) AS "OperatorName"
    FROM "ledger"
    WHERE ledger."ChatGroupId" IN (SELECT cgr."ChatGroupId" FROM "chat_group_receiver" cgr WHERE cgr."LedgerId" = varLedgerId)
      AND ledger."ChatGroupId" IN (SELECT cg."ChatGroupId" FROM "chat_group" cg WHERE COALESCE(cg."IsAllow", 1) = 1)
      AND ledger."RecordStatus" != 'D'
      -- MySQL: CASE WHEN (subquery returning GroupId 6 or no row) THEN ... ; non-zero value = true
      AND (CASE WHEN (SELECT l."GroupId" FROM "ledger" l WHERE l."LedgerId" = varLedgerId AND l."GroupId" = 6) <> 0
                THEN ledger."AgentLedgerId" IN (SELECT cm."CommanMasterId" FROM "comman_master" cm WHERE cm."LedgerId" = varLedgerId)
                ELSE true END);
END;
$$;
