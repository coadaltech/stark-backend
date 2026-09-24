-- Converted from MySQL procedure `rpt_transaction_ASC`.
DROP ROUTINE IF EXISTS "rpt_transaction_ASC";
CREATE OR REPLACE FUNCTION "rpt_transaction_ASC"(varOrganizationId bigint, varTransactionDate date, varShiftId bigint, varAmountFrom smallint)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "Number" text,
    "SaleAmount" double precision,
    "ProfitLossAmount" numeric,
    "Rate" double precision,
    "SelfHissa" double precision,
    "OtherHissa" double precision,
    "Commission" double precision
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    -- NOTE: MySQL compared varchar "Number" with integer "Num" numerically; emulated with
    -- (Number ~ '^[0-9]+$' AND Number::integer = Num).
    RETURN QUERY
    SELECT t."LedgerId", l."LedgerName"::text,
           td."Number"::text,
           sum(td."Amount") AS "SaleAmount",
           COALESCE(round(any_value(pt."PLAmount")::numeric, 0), 0) AS "ProfitLossAmount",
           any_value(td."Rate") AS "Rate",
           any_value(t."SelfHissa") AS "SelfHissa",
           any_value(t."OtherHissa") AS "OtherHissa",
           any_value(td."Commission") AS "Commission"
    FROM "transaction_detail" td
    LEFT JOIN "transaction" t ON td."TransactionId" = t."TransactionId"
    JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
    LEFT JOIN (
        SELECT sum((COALESCE((CASE WHEN ((tdi."Number" ~ '^[0-9]+$' AND tdi."Number"::integer = mjn."Num")
                                          OR tdi."Number" = right(lpad(((mjn."Num" % 10) * 111)::text, 3, '0'), 3)
                                          OR tdi."Number" = right(lpad(((floor(mjn."Num"::numeric / 10) % 10) * 1111)::text, 4, '0'), 4))
                                         AND tr."TransactionMode" = 1
                                    THEN tdi."Amount" * tdi."Rate" ELSE 0 END), 0)
                    - COALESCE((CASE WHEN tr."TransactionMode" = 1 THEN tdi."FinalAmount" ELSE 0 END), 0))
                   * ((100 - COALESCE(lh."Hissa", 0)) / 100)
               ) AS "PLAmount", mjn."Num" AS "OpenNumber", tr."LedgerId"
        FROM "transaction" tr
        INNER JOIN "transaction_detail" tdi ON tr."TransactionId" = tdi."TransactionId"
        LEFT JOIN (SELECT sum(h."Hissa") AS "Hissa", h."LedgerId" FROM "hissa" h
                   WHERE h."RecordStatus" != 'D' AND h."HissaLedgerId" = h."LedgerId"
                   GROUP BY h."LedgerId") AS lh ON lh."LedgerId" = tr."LedgerId"
        JOIN "mainjantrinumbers" mjn ON 1 = 1
        WHERE tr."TransactionDate" = varTransactionDate
          AND tr."ShiftId" = varShiftId
          AND tr."OrganizationId" = varOrganizationId
          AND tr."TransactionMode" = 1
          AND tr."RecordStatus" != 'D'
          AND tdi."RecordStatus" != 'D'
        GROUP BY mjn."Num", tr."LedgerId"
    ) AS pt
      ON (td."Number" ~ '^[0-9]+$' AND td."Number"::integer = pt."OpenNumber") AND pt."LedgerId" = l."LedgerId"
    WHERE t."TransactionMode" = 1
      AND td."RecordStatus" != 'D'
      AND t."RecordStatus" != 'D'
      AND t."ShiftId" = varShiftId
      AND t."TransactionDate" = varTransactionDate
      AND t."OrganizationId" = varOrganizationId
    GROUP BY t."LedgerId", td."Number", l."LedgerName"
    HAVING sum(td."Amount") >= varAmountFrom
    -- ORDER by PLAmount DESC
    ORDER BY 4 DESC;
END;
$$;
