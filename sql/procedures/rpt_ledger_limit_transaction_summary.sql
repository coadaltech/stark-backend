-- Converted from MySQL procedure `rpt_ledger_limit_transaction_summary`.
DROP ROUTINE IF EXISTS "rpt_ledger_limit_transaction_summary";
CREATE OR REPLACE FUNCTION "rpt_ledger_limit_transaction_summary"(varOrganizationId bigint, FromDate date, ToDate date, varLedgerId bigint, varAgentId bigint, varIsBackLimitPopup integer)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "LedgerBalance" numeric,
    "LedgerLimit" numeric,
    "TransConsum" numeric,
    "FinalLimit" numeric,
    "GroupId" integer,
    "Payment" double precision,
    "LimitValue" double precision,
    "VoucherDate" date,
    "AgentName" text,
    "AgentGroup" text,
    "AgentGroupId" text,
    "Mobile" text,
    "LoginStatus" text,
    "AgentLedgerId" bigint
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT l."LedgerId", l."LedgerName"::text,
           round(ll."LedgerBalance"::numeric, 0) AS "LedgerBalance",
           round(ll."LedgerLimit"::numeric, 0) AS "LedgerLimit",
           round(ll."TransConsum"::numeric, 0) AS "TransConsum",
           round(ll."FinalLimit"::numeric, 0) AS "FinalLimit",
           l."GroupId",
           vd."Payment",
           vd."LimitValue",
           vd."VoucherDate",
           main_agent."LedgerName"::text AS "AgentName",
           COALESCE(agent."CommanMasterName"::text, '') AS "AgentGroup",
           COALESCE(agent."CommanMasterId"::text, '') AS "AgentGroupId",
           lg."Mobile"::text,
           lg."AccountStatus"::text AS "LoginStatus",
           agent."LedgerId" AS "AgentLedgerId"
    FROM "ledger" l
    JOIN (
        SELECT d."LedgerId",
               d."VoucherDate",
               sum(CASE WHEN d."VoucherType" = 1 THEN CASE WHEN d."AmountType" = 'Dr' THEN d."Amount" ELSE -d."Amount" END ELSE 0 END) AS "Payment",
               sum(CASE WHEN d."VoucherType" = 2 THEN CASE WHEN d."AmountType" = 'Dr' THEN d."Amount" ELSE -d."Amount" END ELSE 0 END) AS "LimitValue"
        FROM "voucher_detail" AS d
        WHERE (d."VoucherDate" BETWEEN FromDate AND ToDate)
          /*
          and voucher_detail.VoucherType in (1,2)
          */
          AND (d."RecordStatus" != 'D')
          AND d."OrganizationId" = varOrganizationId
          AND (d."LedgerId" = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
          AND d."LedgerId" <> 6
        GROUP BY d."LedgerId",
                 d."VoucherDate"
    ) AS vd ON l."LedgerId" = vd."LedgerId"
    LEFT JOIN "ledger_limit" ll ON ll."LedgerId" = l."LedgerId"
    LEFT JOIN "comman_master" AS agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
    LEFT JOIN "ledger" AS main_agent ON main_agent."LedgerId" = agent."LedgerId"
    JOIN "ledger_group" lgp ON l."GroupId" = lgp."GroupId"
    LEFT JOIN "login" lg ON l."LedgerId" = lg."LedgerId"
    WHERE (l."LedgerId" = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
      AND COALESCE(l."ParentLedgerId", 9) = 0
      AND (agent."LedgerId" = varAgentId OR agent."ParentAgentLedgerId" = varAgentId OR COALESCE(varAgentId, 0) = 0)
      AND (l."OrganizationId" = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
      AND (varIsBackLimitPopup = 1 OR l."HPLedgerId" = 0)
      AND vd."LimitValue" <> 0
    ORDER BY l."LedgerName",
             vd."VoucherDate";
END;
$$;
