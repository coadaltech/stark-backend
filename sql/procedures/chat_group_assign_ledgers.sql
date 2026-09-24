-- Converted from MySQL procedure `chat_group_assign_ledgers`.
DROP ROUTINE IF EXISTS "chat_group_assign_ledgers";
CREATE OR REPLACE FUNCTION "chat_group_assign_ledgers"(varOrganizationId bigint, varLedgerId bigint, varChatGroupId bigint)
RETURNS TABLE("LedgerId" bigint, "LedgerName" text, "ChatGroupId" bigint, "ChatGroupName" text,
              "IsAllow" integer, "RecordStatus" text)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT l."LedgerId", l."LedgerName"::text,
           l."ChatGroupId",
           cg."ChatGroupName"::text,
           cg."IsAllow",
           l."RecordStatus"::text
    FROM "ledger" l
    LEFT JOIN "chat_group" cg ON l."ChatGroupId" = cg."ChatGroupId"
    WHERE l."OrganizationId" = varOrganizationId
      AND (l."LedgerId" = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
      AND COALESCE(l."ChatGroupId", 0) != 0
      AND (l."ChatGroupId" = varChatGroupId OR COALESCE(varChatGroupId, 0) = 0)
      AND l."RecordStatus" != 'D'
    ORDER BY l."LedgerName";
END;
$$;
