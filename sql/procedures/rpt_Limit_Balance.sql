-- Converted from MySQL procedure `rpt_Limit_Balance`.
DROP ROUTINE IF EXISTS "rpt_Limit_Balance";
CREATE OR REPLACE FUNCTION "rpt_Limit_Balance"(
    varOrganizationId bigint,
    varLedgerId bigint
)
RETURNS TABLE(
    "LedgerName" text,
    "LedgerBalance" numeric,
    "LedgerLimit" numeric,
    "TransConsum" numeric,
    "FinalLimit" numeric,
    "GroupId" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT ledger."LedgerName"::text
        , round(ledger_limit."LedgerBalance"::numeric, 0) AS "LedgerBalance"
        , round(ledger_limit."LedgerLimit"::numeric, 0) AS "LedgerLimit"
        , round(ledger_limit."TransConsum"::numeric, 0) AS "TransConsum"
        , round(ledger_limit."FinalLimit"::numeric, 0) AS "FinalLimit"
        , ledger."GroupId"
    FROM "ledger"
    LEFT JOIN "ledger_limit" ON ledger_limit."LedgerId" = ledger."LedgerId"
    WHERE (ledger."LedgerId" = varLedgerId OR (COALESCE(varLedgerId, 0) = 0 AND ledger."GroupId" NOT IN (3, 4, 5)))
      AND (ledger."OrganizationId" = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
      AND ledger."GroupId" <> 7
    UNION
    -- MySQL grouped only by Child.LedgerName with non-aggregated columns; any_value() keeps that permissive behaviour.
    SELECT Child."LedgerName"::text
        , any_value(round((COALESCE(ledger_limit."LedgerBalance", 0) + COALESCE(ChildsChild_Limit."LedgerBalance", 0) + COALESCE(ChildsChildsChild_Limit."LedgerBalance", 0))::numeric, 0)) AS "LedgerBalance"
        , any_value(round((COALESCE(ledger_limit."LedgerLimit", 0) + COALESCE(ChildsChild_Limit."LedgerLimit", 0) + COALESCE(ChildsChildsChild_Limit."LedgerLimit", 0))::numeric, 0)) AS "LedgerLimit"
        , any_value(round((COALESCE(ledger_limit."TransConsum", 0) + COALESCE(ChildsChild_Limit."TransConsum", 0) + COALESCE(ChildsChildsChild_Limit."TransConsum", 0))::numeric, 0)) AS "TransConsum"
        , any_value(round((COALESCE(ledger_limit."FinalLimit", 0) + COALESCE(ChildsChild_Limit."FinalLimit", 0) + COALESCE(ChildsChildsChild_Limit."FinalLimit", 0))::numeric, 0)) AS "FinalLimit"
        , any_value(Child."GroupId")
    FROM "ledger" AS Child
    LEFT JOIN "ledger" AS ChildsChild ON ChildsChild."ParentLedgerId" = Child."LedgerId"
    LEFT JOIN "ledger" AS ChildsChildsChild ON ChildsChildsChild."ParentLedgerId" = ChildsChild."LedgerId"
    LEFT JOIN "ledger_limit" ON Child."LedgerId" = ledger_limit."LedgerId"
    LEFT JOIN (SELECT sum(ll."LedgerBalance") AS "LedgerBalance", sum(ll."LedgerLimit") AS "LedgerLimit", sum(ll."TransConsum") AS "TransConsum", sum(ll."FinalLimit") AS "FinalLimit", ll."LedgerId"
               FROM "ledger_limit" ll GROUP BY ll."LedgerId") AS ChildsChild_Limit ON ChildsChild_Limit."LedgerId" = ChildsChild."LedgerId"
    LEFT JOIN (SELECT sum(ll."LedgerBalance") AS "LedgerBalance", sum(ll."LedgerLimit") AS "LedgerLimit", sum(ll."TransConsum") AS "TransConsum", sum(ll."FinalLimit") AS "FinalLimit", ll."LedgerId"
               FROM "ledger_limit" ll GROUP BY ll."LedgerId") AS ChildsChildsChild_Limit ON ChildsChildsChild_Limit."LedgerId" = ChildsChildsChild."LedgerId"
    WHERE (Child."ParentLedgerId" = varLedgerId)
      AND (Child."OrganizationId" = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
      AND Child."GroupId" IN (3, 4, 5)
    GROUP BY Child."LedgerName";
END;
$$;
