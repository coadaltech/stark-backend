-- Converted from MySQL procedure `chat_group_receiver_yesno_report`.
DROP ROUTINE IF EXISTS "chat_group_receiver_yesno_report";
CREATE OR REPLACE FUNCTION "chat_group_receiver_yesno_report"(
    varOrganizationId bigint,
    varChatGroupId bigint
)
RETURNS TABLE("LedgerId" bigint, "LedgerName" text, "UserName" text, "IsReceiver" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT ledger."LedgerId", ledger."LedgerName"::text, login."UserName"::text,
           (CASE WHEN COALESCE(chat_group_receiver."LedgerId", 0) = 0 THEN 0 ELSE 1 END)::integer AS "IsReceiver"
    FROM "ledger" ledger
    LEFT JOIN "chat_group_receiver" chat_group_receiver
           ON chat_group_receiver."LedgerId" = ledger."LedgerId"
          AND COALESCE(chat_group_receiver."ChatGroupId", 0) = varChatGroupId
          AND chat_group_receiver."RecordStatus" != 'D'
    LEFT JOIN "login" login ON login."LedgerId" = ledger."LedgerId"
    WHERE ledger."GroupId" IN (7, 6, 1)
      AND ledger."OrganizationId" = varOrganizationId
      AND ledger."RecordStatus" != 'D'
    ORDER BY ledger."LedgerName";
END;
$$;
