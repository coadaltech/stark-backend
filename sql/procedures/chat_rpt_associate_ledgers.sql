-- Converted from MySQL procedure `chat_rpt_associate_ledgers`.
DROP ROUTINE IF EXISTS "chat_rpt_associate_ledgers";
CREATE OR REPLACE FUNCTION "chat_rpt_associate_ledgers"(
    varOrganizationId bigint,
    varLedgerId bigint,
    varAssocateLedgerId bigint
) RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "AssociateLedgerId" bigint,
    "AssociateLedgerName" text,
    "UpdatedBy" text,
    "UpdatedDate" timestamp,
    "ChatledgerassociateId" bigint
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT fromassociate."LedgerId", fromassociate."LedgerName"::text,
           toassociate."LedgerId", toassociate."LedgerName"::text,
           cla."UpdatedBy"::text, cla."UpdatedDate", cla."ChatledgerassociateId"
    FROM "chat_ledger_associate" cla
    LEFT JOIN "ledger" AS fromassociate ON fromassociate."LedgerId" = cla."LedgerId"
    LEFT JOIN "ledger" AS toassociate ON toassociate."LedgerId" = cla."AssociateLedgerId"
    WHERE cla."OrganizationId" = varOrganizationId
      AND (cla."LedgerId" = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
      AND (cla."AssociateLedgerId" = varAssocateLedgerId OR COALESCE(varAssocateLedgerId, 0) = 0)
      AND cla."RecordStatus" != 'D';
END
$$;
