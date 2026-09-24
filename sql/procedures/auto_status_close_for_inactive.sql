-- Converted from MySQL procedure `auto_status_close_for_inactive`.
DROP ROUTINE IF EXISTS "auto_status_close_for_inactive";
CREATE OR REPLACE PROCEDURE "auto_status_close_for_inactive"(varOrganizationId bigint, varTransactionDate date, varForDayas integer)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE "ledger" SET "AccountStatus" = '0'
    WHERE "ledger"."LedgerId" IN (
        SELECT l."LedgerId"
        FROM (SELECT lg."LedgerId", lg."LedgerName"
              FROM "ledger" lg WHERE lg."GroupId" = 5 AND lg."RecordStatus" != 'D'
                AND COALESCE(lg."ParentLedgerId", 0) = 0
                AND lg."OrganizationId" = varOrganizationId) AS l
        LEFT JOIN (
            SELECT t."LedgerId"
            FROM (SELECT td."LedgerId" FROM "transaction_declare" td
                  WHERE td."TransactionDate" BETWEEN (varTransactionDate - varForDayas) AND varTransactionDate
                    AND td."RecordStatus" != 'D'
                  UNION ALL
                  SELECT tr."LedgerId" FROM "transaction" tr
                  WHERE tr."TransactionDate" BETWEEN (varTransactionDate - varForDayas) AND varTransactionDate
                    AND tr."RecordStatus" != 'D'
                 ) AS t
            GROUP BY t."LedgerId"
        ) AS t ON t."LedgerId" = l."LedgerId"
        /*	inner JOIN (Select LedgerId
                    ,sum((case when aa.AmountType = 'Dr' then ifnull(aa.Amount,0) else - ifnull(aa.Amount,0) end)) opening
                    from voucher_detail aa
                            Where aa.VoucherType = 2
                            and aa.RecordStatus != 'D'
                            and aa.OrganizationId = varOrganizationId
                            group by aa.LedgerId
                ) as OPBal on OPBal.LedgerId = l.LedgerId
        */
        WHERE t."LedgerId" IS NULL
    )
      AND "ledger"."OrganizationId" = varOrganizationId
      AND "ledger"."AccountStatus" = '1';

    UPDATE "login" SET "AccountStatus" = '0'
    WHERE "login"."LedgerId" IN (
        SELECT l."LedgerId"
        FROM (SELECT lg."LedgerId", lg."LedgerName"
              FROM "ledger" lg WHERE lg."GroupId" = 5 AND lg."RecordStatus" != 'D'
                AND COALESCE(lg."ParentLedgerId", 0) = 0
                AND lg."OrganizationId" = varOrganizationId) AS l
        LEFT JOIN (
            SELECT t."LedgerId"
            FROM (SELECT td."LedgerId" FROM "transaction_declare" td
                  WHERE td."TransactionDate" BETWEEN (varTransactionDate - varForDayas) AND varTransactionDate
                    AND td."RecordStatus" != 'D'
                  UNION ALL
                  SELECT tr."LedgerId" FROM "transaction" tr
                  WHERE tr."TransactionDate" BETWEEN (varTransactionDate - varForDayas) AND varTransactionDate
                    AND tr."RecordStatus" != 'D'
                 ) AS t
            GROUP BY t."LedgerId"
        ) AS t ON t."LedgerId" = l."LedgerId"
        WHERE t."LedgerId" IS NULL
    )
      AND "login"."OrganizationId" = varOrganizationId
      AND "login"."AccountStatus" = '1';
END;
$$;
