-- Converted from MySQL procedure `transaction_today_not_working_ledger`.
DROP ROUTINE IF EXISTS "transaction_today_not_working_ledger";
CREATE OR REPLACE FUNCTION "transaction_today_not_working_ledger"(
    varOrganizationId bigint,
    varShiftId bigint,
    TransactionDates date
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "LastWorkingDays" bigint,
    "Mobile" text,
    "AgentName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT t."LedgerId", l."LedgerName"::text, t."LastWorkingDays" AS "LastWorkingDays"
        , login."Mobile"::text, COALESCE(agent."CommanMasterName", 'NA')::text AS "AgentName"
    FROM
    (
        SELECT t."LedgerId", count(1) AS "LastWorkingDays"
        FROM
            (SELECT t."TransactionDate", t."OrganizationId", t."LedgerId"
             FROM "transaction_declare" t
             WHERE t."TransactionDate" BETWEEN (TransactionDates - 3) AND (TransactionDates - 1)
               AND (t."ShiftId" = varShiftId OR COALESCE(varShiftId, 0) = 0)
               AND t."RecordStatus" != 'D'
               AND (COALESCE(varOrganizationId, 0) = 0 OR t."OrganizationId" = varOrganizationId)
               AND t."LedgerId" NOT IN (SELECT tr."LedgerId" FROM "transaction" tr
                    WHERE tr."TransactionDate" = TransactionDates
                      AND (tr."ShiftId" = varShiftId OR COALESCE(varShiftId, 0) = 0)
                      AND tr."RecordStatus" != 'D'
                      AND (COALESCE(varOrganizationId, 0) = 0 OR tr."OrganizationId" = varOrganizationId)
                    GROUP BY tr."LedgerId")
               AND t."LedgerId" NOT IN (SELECT tdc."LedgerId" FROM "transaction_declare" tdc
                    WHERE tdc."TransactionDate" = TransactionDates
                      AND (tdc."ShiftId" = varShiftId OR COALESCE(varShiftId, 0) = 0)
                      AND tdc."RecordStatus" != 'D'
                      AND (COALESCE(varOrganizationId, 0) = 0 OR tdc."OrganizationId" = varOrganizationId)
                    GROUP BY tdc."LedgerId")
             GROUP BY t."TransactionDate", t."OrganizationId", t."LedgerId"
            ) AS t
        GROUP BY t."LedgerId"
        HAVING count(1) >= 1
    ) AS t
    JOIN "ledger" l ON t."LedgerId" = l."LedgerId" AND COALESCE(l."ParentLedgerId", 0) = 0
    LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
    LEFT JOIN "login" ON login."LedgerId" = l."LedgerId"
    ORDER BY -t."LastWorkingDays", l."LedgerName" ASC;
END;
$$;
