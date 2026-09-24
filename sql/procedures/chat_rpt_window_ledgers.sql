-- Converted from MySQL procedure `chat_rpt_window_ledgers`.
DROP ROUTINE IF EXISTS "chat_rpt_window_ledgers";
CREATE OR REPLACE FUNCTION "chat_rpt_window_ledgers"(varOrganizationId bigint, varLedgerId bigint, varChatGroupId bigint)
RETURNS TABLE("LedgerId" bigint, "LedgerName" text, "ChatGroupId" bigint, "DeviceId" text, "RoleId" integer, "UserName" text)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT l."LedgerId",
           (CASE WHEN l."GroupId" = 7 THEN lg."UserName" ELSE l."LedgerName" END)::text AS "LedgerName",
           l."ChatGroupId", lg."DeviceId"::text, lg."LoginType"::integer AS "RoleId", lg."UserName"::text
    FROM (
        SELECT ledger."LedgerId" AS "LedgerId", ledger."LedgerName" AS "LedgerName",
               COALESCE(ledger."ChatGroupId", 0) AS "ChatGroupId", ledger."GroupId"
        FROM "ledger" ledger
        WHERE (ledger."LedgerId" IN (SELECT cgr."LedgerId" FROM "chat_group_receiver" cgr
                                     WHERE cgr."RecordStatus" != 'D'
                                       AND (cgr."ChatGroupId" IN
                                              (SELECT led."ChatGroupId" FROM "ledger" AS led
                                               WHERE led."OrganizationId" = varOrganizationId AND led."LedgerId" = varLedgerId AND led."RecordStatus" != 'D')
                                            OR cgr."ChatGroupId" = COALESCE(varChatGroupId, 0)
                                            OR (COALESCE(varChatGroupId, 0) = 0 OR COALESCE(varLedgerId, 0) = 0)
                                               AND cgr."OrganizationId" = varOrganizationId
                                           )
                                       AND cgr."ChatGroupId" IN (SELECT cg."ChatGroupId" FROM "chat_group" cg WHERE COALESCE(cg."IsAllow", 1) = 1)
                                    )
               OR ledger."LedgerId" = varLedgerId
              )
          AND (CASE WHEN COALESCE((SELECT lGroup."GroupId" FROM "ledger" AS lGroup WHERE lGroup."LedgerId" = varLedgerId), 0) = 5 THEN
                        ledger."GroupId" != 6 OR ledger."LedgerId" = COALESCE((SELECT cm."LedgerId"
                                                                               FROM "ledger" AS lAgent
                                                                               LEFT JOIN "comman_master" cm ON cm."CommanMasterId" = lAgent."AgentLedgerId"
                                                                               WHERE lAgent."LedgerId" = varLedgerId), 0)
                    ELSE true END)
          AND ledger."RecordStatus" != 'D'
          AND ledger."OrganizationId" = varOrganizationId
    ) AS l
    LEFT JOIN "login" lg ON lg."LedgerId" = l."LedgerId" AND lg."RecordStatus" != 'D'
    -- MySQL: ifnull(login.AccountStatus,0) != 0 (varchar compared numerically)
    WHERE COALESCE(lg."AccountStatus", '0') != '0';
END;
$$;
