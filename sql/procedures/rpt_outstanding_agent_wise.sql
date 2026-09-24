-- Converted from MySQL procedure `rpt_outstanding_agent_wise`.
DROP ROUTINE IF EXISTS "rpt_outstanding_agent_wise";
CREATE OR REPLACE FUNCTION "rpt_outstanding_agent_wise"(varOrganizationId bigint, varOnDate date, varAgentId bigint)
RETURNS TABLE(
    "LedgerId" bigint, "LedgerName" text, "CreditLimit" double precision, "Remark" text,
    "Credit" double precision, "Debit" double precision, "AmountType" text, "Amount" double precision,
    "GroupName" text, "AgentName" text, "Mobile" text, "LoginStatus" text, "Vapsi" double precision,
    "AccountStatus" text, "AgentLedgerId" text, "AgentGroupId" text)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT ledger."LedgerId", ledger."LedgerName"::text, ledger_limit."LedgerLimit" AS "CreditLimit",
           vdo."Remark"::text, vdo."Credit", vdo."Debit",
           CASE WHEN vdo."Credit" > vdo."Debit" THEN 'Cr' ELSE CASE WHEN vdo."Debit" > vdo."Credit" THEN 'Dr' ELSE 'Dr' END END
               AS "AmountType",
           CASE
               WHEN vdo."Credit" > vdo."Debit" THEN vdo."Credit" - vdo."Debit"
               ELSE CASE
                   WHEN vdo."Debit" > vdo."Credit" THEN vdo."Debit" - vdo."Credit"
                   ELSE 0
               END
           END AS "Amount",
           lgrp."GroupName"::text,
           COALESCE(agent."CommanMasterName"::text, '') AS "AgentName",
           lg."Mobile"::text,
           lg."AccountStatus"::text AS "LoginStatus",
           ledger."Vapsi",
           ledger."AccountStatus"::text,
           COALESCE(agent."LedgerId"::text, '') AS "AgentLedgerId",
           COALESCE(agent."CommanMasterId"::text, '') AS "AgentGroupId"
    FROM (
        SELECT (CASE
                    WHEN led."ParentLedgerId" = 0 THEN vdi."LedgerId"
                    WHEN ledgerBaap."ParentLedgerId" = 0 THEN led."ParentLedgerId"
                    ELSE ledgerBaap."ParentLedgerId"
                END) AS "LedgerId",
               max(vdi."Remark") AS "Remark",
               sum(vdi."Credit") AS "Credit",
               sum(vdi."Debit") AS "Debit",
               2 AS z
        FROM (
            SELECT vd."LedgerId",
                   max(vd."Remark") AS "Remark",
                   sum(CASE WHEN vd."AmountType" = 'Cr' THEN vd."Amount" ELSE 0 END) AS "Credit",
                   sum(CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE 0 END) AS "Debit",
                   2 AS z
            FROM "voucher_detail" vd
            JOIN "voucher" v ON v."VoucherId" = vd."VoucherId"
            WHERE (vd."VoucherDate" <= varOnDate)
              AND vd."OrganizationId" = varOrganizationId
              AND vd."RecordStatus" != 'D'
              AND v."VoucherType" != 2
            GROUP BY vd."LedgerId"
        ) AS vdi
        LEFT JOIN (
            SELECT l1."LedgerId", l1."ParentLedgerId"
            FROM "ledger" l1
            WHERE (l1."RecordStatus" != 'D')
              AND l1."OrganizationId" = varOrganizationId
              AND l1."GroupId" IN (3, 4, 5)
        ) AS led ON vdi."LedgerId" = led."LedgerId"
        LEFT JOIN (
            SELECT l2."LedgerId", l2."ParentLedgerId"
            FROM "ledger" l2
            WHERE (l2."RecordStatus" != 'D')
              AND l2."OrganizationId" = varOrganizationId
              AND l2."GroupId" IN (3, 4, 5)
        ) AS ledgerBaap ON led."ParentLedgerId" = ledgerBaap."LedgerId"
        GROUP BY (CASE
                      WHEN led."ParentLedgerId" = 0 THEN vdi."LedgerId"
                      WHEN ledgerBaap."ParentLedgerId" = 0 THEN led."ParentLedgerId"
                      ELSE ledgerBaap."ParentLedgerId"
                  END)
    ) AS vdo
    JOIN "ledger" ledger ON vdo."LedgerId" = ledger."LedgerId"
         AND COALESCE(ledger."ParentLedgerId", 0) = 0
    JOIN "ledger_limit" ledger_limit ON ledger."LedgerId" = ledger_limit."LedgerId"
    LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = ledger."AgentLedgerId"
         AND agent."CommanMasterType" = 1
    JOIN "ledger_group" lgrp ON ledger."GroupId" = lgrp."GroupId"
    JOIN "login" lg ON lg."LedgerId" = ledger."LedgerId"
    WHERE (agent."LedgerId" = varAgentId
           OR agent."ParentAgentLedgerId" = varAgentId
           OR COALESCE(varAgentId, 0) = 0)
      AND NOT ((vdo."Debit" - vdo."Credit") BETWEEN -1 AND 1)
    ORDER BY ledger."LedgerName";
END;
$$;
