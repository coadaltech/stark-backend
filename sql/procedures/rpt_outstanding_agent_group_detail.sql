-- Converted from MySQL procedure `rpt_outstanding_agent_group_detail`.
DROP ROUTINE IF EXISTS "rpt_outstanding_agent_group_detail";
CREATE OR REPLACE FUNCTION "rpt_outstanding_agent_group_detail"(
    varOrganizationId bigint,
    varOnDate date,
    varAgentId bigint,
    varAgentGroupId bigint
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "CreditLimit" double precision,
    "Remark" text,
    "Credit" double precision,
    "Debit" double precision,
    "AmountType" text,
    "Amount" double precision,
    "GroupName" text,
    "AgentName" text,
    "Mobile" text,
    "LoginStatus" text,
    "Vapsi" double precision,
    "AccountStatus" text,
    "AgentLedgerId" text,
    "AgentGroupId" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT
        ledger."LedgerId", ledger."LedgerName"::text, ledger_limit."LedgerLimit" AS "CreditLimit"
        , voucher_detail."Remark"::text
        , voucher_detail."Credit"
        , voucher_detail."Debit"
        , (CASE WHEN voucher_detail."Credit" > voucher_detail."Debit" THEN 'Cr' ELSE CASE WHEN voucher_detail."Debit" > voucher_detail."Credit" THEN 'Dr' ELSE 'Dr' END END)::text
          AS "AmountType",
        CASE
            WHEN voucher_detail."Credit" > voucher_detail."Debit" THEN voucher_detail."Credit" - voucher_detail."Debit"
            ELSE CASE
                WHEN voucher_detail."Debit" > voucher_detail."Credit" THEN voucher_detail."Debit" - voucher_detail."Credit"
                ELSE 0
            END
        END AS "Amount",
        ledger_group."GroupName"::text,
        COALESCE(agent."CommanMasterName", '')::text AS "AgentName",
        login."Mobile"::text,
        login."AccountStatus"::text AS "LoginStatus",
        ledger."Vapsi",
        ledger."AccountStatus"::text,
        -- MySQL IFNULL(bigint, '') yields a string
        COALESCE(agent."LedgerId"::text, '') AS "AgentLedgerId",
        COALESCE(agent."CommanMasterId"::text, '') AS "AgentGroupId"
    FROM (
            SELECT (
                    CASE
                        WHEN ledger."ParentLedgerId" = 0 THEN voucher_detail."LedgerId"
                        WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
                        ELSE ledgerBaap."ParentLedgerId"
                    END
                ) AS "LedgerId",
                max(voucher_detail."Remark") AS "Remark",
                sum(voucher_detail."Credit") AS "Credit",
                sum(voucher_detail."Debit") AS "Debit",
                2 AS z
            FROM (
                    SELECT
                        vd."LedgerId",
                        max(vd."Remark") AS "Remark",
                        sum(
                            CASE
                                WHEN vd."AmountType" = 'Cr' THEN vd."Amount"
                                ELSE 0
                            END
                        ) AS "Credit",
                        sum(
                            CASE
                                WHEN vd."AmountType" = 'Dr' THEN vd."Amount"
                                ELSE 0
                            END
                        ) AS "Debit",
                        2 AS z
                    FROM "voucher_detail" vd
                    JOIN "voucher" ON voucher."VoucherId" = vd."VoucherId"
                    WHERE (
                            vd."VoucherDate" <= varOnDate
                        )
                      AND vd."OrganizationId" = varOrganizationId
                      AND vd."RecordStatus" != 'D'
                      AND voucher."VoucherType" != 2
                    GROUP BY
                        vd."LedgerId"
                ) AS voucher_detail
                LEFT JOIN (
                    SELECT lx."LedgerId", lx."ParentLedgerId"
                    FROM "ledger" lx
                    WHERE (lx."RecordStatus" != 'D')
                      AND lx."OrganizationId" = varOrganizationId
                      AND lx."GroupId" IN (3, 4, 5)
                ) AS ledger ON voucher_detail."LedgerId" = ledger."LedgerId"
                LEFT JOIN (
                    SELECT lx."LedgerId", lx."ParentLedgerId"
                    FROM "ledger" lx
                    WHERE (lx."RecordStatus" != 'D')
                      AND lx."OrganizationId" = varOrganizationId
                      AND lx."GroupId" IN (3, 4, 5)
                ) AS ledgerBaap ON ledger."ParentLedgerId" = ledgerBaap."LedgerId"
            GROUP BY (
                    CASE
                        WHEN ledger."ParentLedgerId" = 0 THEN voucher_detail."LedgerId"
                        WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
                        ELSE ledgerBaap."ParentLedgerId"
                    END
                )
        ) voucher_detail
        JOIN "ledger" ON voucher_detail."LedgerId" = ledger."LedgerId"
            AND COALESCE(ledger."ParentLedgerId", 0) = 0
        JOIN "ledger_limit" ON ledger."LedgerId" = ledger_limit."LedgerId"
        LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = ledger."AgentLedgerId"
            AND agent."CommanMasterType" = 1
        JOIN "ledger_group" ON ledger."GroupId" = ledger_group."GroupId"
        JOIN "login" ON login."LedgerId" = ledger."LedgerId"
    WHERE (
            agent."LedgerId" = varAgentId
            OR agent."ParentAgentLedgerId" = varAgentId
            OR COALESCE(varAgentId, 0) = 0
        )
      AND (
            agent."CommanMasterId" = varAgentGroupId
            OR COALESCE(varAgentGroupId, 0) = 0
        )
      AND NOT (
            (
                voucher_detail."Debit" - voucher_detail."Credit"
            ) BETWEEN -1 AND 1
        )
    ORDER BY ledger."LedgerName";
END;
$$;
