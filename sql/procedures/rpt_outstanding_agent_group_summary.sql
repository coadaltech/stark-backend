-- Converted from MySQL procedure `rpt_outstanding_agent_group_summary`.
-- ifnull(agent.CommanMasterId,'') was a string in MySQL -> "AgentGroupId" text.
-- main_agent.LedgerName (AgentName, ORDER BY) is not grouped in MySQL -> any_value().
DROP ROUTINE IF EXISTS "rpt_outstanding_agent_group_summary";
CREATE OR REPLACE FUNCTION "rpt_outstanding_agent_group_summary"(
    varOrganizationId bigint,
    varOnDate date,
    varAgentId bigint
)
RETURNS TABLE(
    "Remark" text,
    "Credit" double precision,
    "Debit" double precision,
    "AmountType" text,
    "Amount" double precision,
    "AgentName" text,
    "AgentGroup" text,
    "AgentGroupId" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT
        /* ledger.LedgerId, ledger.LedgerName, ledger_limit.LedgerLimit as CreditLimit, */
        max(voucher_detail."Remark")::text AS "Remark"
      , COALESCE(sum(voucher_detail."Credit"), 0) AS "Credit"
      , COALESCE(sum(voucher_detail."Debit"), 0) AS "Debit"
      , (CASE WHEN COALESCE(sum(voucher_detail."Credit"), 0) > COALESCE(sum(voucher_detail."Debit"), 0) THEN 'Cr'
              ELSE CASE WHEN COALESCE(sum(voucher_detail."Debit"), 0) > COALESCE(sum(voucher_detail."Credit"), 0) THEN 'Dr'
                        ELSE 'Dr' END END)::text AS "AmountType"
      , (CASE
            WHEN COALESCE(sum(voucher_detail."Credit"), 0) > COALESCE(sum(voucher_detail."Debit"), 0)
                THEN COALESCE(sum(voucher_detail."Credit"), 0) - COALESCE(sum(voucher_detail."Debit"), 0)
            ELSE CASE
                WHEN COALESCE(sum(voucher_detail."Debit"), 0) > COALESCE(sum(voucher_detail."Credit"), 0)
                    THEN COALESCE(sum(voucher_detail."Debit"), 0) - COALESCE(sum(voucher_detail."Credit"), 0)
                ELSE 0
            END
         END) AS "Amount"
      , any_value(main_agent."LedgerName")::text AS "AgentName"
        /* ,ledger_group.GroupName ,login.Mobile, login.AccountStatus as LoginStatus
           ,ledger.Vapsi, ledger.AccountStatus ,ifnull(agent.LedgerId,'') as AgentLedgerId */
      , COALESCE(agent."CommanMasterName", '')::text AS "AgentGroup"
      , COALESCE(agent."CommanMasterId"::text, '') AS "AgentGroupId"
    FROM (
        SELECT (CASE
                    WHEN ledger."ParentLedgerId" = 0 THEN voucher_detail."LedgerId"
                    WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
                    ELSE ledgerBaap."ParentLedgerId"
                END) AS "LedgerId",
               max(voucher_detail."Remark") AS "Remark",
               sum(voucher_detail."Credit") AS "Credit",
               sum(voucher_detail."Debit") AS "Debit",
               2 AS z
        FROM (
            SELECT vd."LedgerId",
                   max(vd."Remark") AS "Remark",
                   sum(CASE WHEN vd."AmountType" = 'Cr' THEN vd."Amount" ELSE 0 END) AS "Credit",
                   sum(CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE 0 END) AS "Debit",
                   2 AS z
            FROM "voucher_detail" vd
            JOIN "voucher" voucher ON voucher."VoucherId" = vd."VoucherId"
            WHERE (vd."VoucherDate" <= varOnDate)
              AND vd."OrganizationId" = varOrganizationId
              AND vd."RecordStatus" != 'D'
              AND voucher."VoucherType" != 2
            GROUP BY vd."LedgerId"
        ) AS voucher_detail
        LEFT JOIN (
            SELECT lg."LedgerId", lg."ParentLedgerId"
            FROM "ledger" lg
            WHERE (lg."RecordStatus" != 'D')
              AND lg."OrganizationId" = varOrganizationId
              AND lg."GroupId" IN (3, 4, 5)
        ) AS ledger ON voucher_detail."LedgerId" = ledger."LedgerId"
        LEFT JOIN (
            SELECT lg."LedgerId", lg."ParentLedgerId"
            FROM "ledger" lg
            WHERE (lg."RecordStatus" != 'D')
              AND lg."OrganizationId" = varOrganizationId
              AND lg."GroupId" IN (3, 4, 5)
        ) AS ledgerBaap ON ledger."ParentLedgerId" = ledgerBaap."LedgerId"
        GROUP BY (CASE
                    WHEN ledger."ParentLedgerId" = 0 THEN voucher_detail."LedgerId"
                    WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
                    ELSE ledgerBaap."ParentLedgerId"
                  END)
    ) voucher_detail
    JOIN "ledger" ledger ON voucher_detail."LedgerId" = ledger."LedgerId"
                        AND COALESCE(ledger."ParentLedgerId", 0) = 0
    JOIN "ledger_limit" ledger_limit ON ledger."LedgerId" = ledger_limit."LedgerId"
    LEFT JOIN "comman_master" AS agent ON agent."CommanMasterId" = ledger."AgentLedgerId"
                                      AND agent."CommanMasterType" = 1
    LEFT JOIN "ledger" AS main_agent ON main_agent."LedgerId" = agent."LedgerId"
    JOIN "ledger_group" ledger_group ON ledger."GroupId" = ledger_group."GroupId"
    JOIN "login" login ON login."LedgerId" = ledger."LedgerId"
    WHERE (agent."LedgerId" = varAgentId
           OR agent."ParentAgentLedgerId" = varAgentId
           OR COALESCE(varAgentId, 0) = 0)
    GROUP BY COALESCE(agent."CommanMasterName", ''), COALESCE(agent."CommanMasterId"::text, '')
    HAVING NOT ((COALESCE(sum(voucher_detail."Debit"), 0) - COALESCE(sum(voucher_detail."Credit"), 0)) BETWEEN -1 AND 1)
    ORDER BY any_value(main_agent."LedgerName");
END;
$$;
