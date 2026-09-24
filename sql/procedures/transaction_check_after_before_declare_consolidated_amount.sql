-- Converted from MySQL procedure `transaction_check_after_before_declare_consolidated_amount`.
-- `Number = declare_result.DeclareNumber` compared varchar to int in MySQL (numeric
-- comparison, so '05' = 5); reproduced by casting purely-numeric Number strings to numeric.
DROP ROUTINE IF EXISTS "transaction_check_after_before_declare_consolidated_amount";
CREATE OR REPLACE FUNCTION "transaction_check_after_before_declare_consolidated_amount"(
    varOrganizationId integer,
    varShiftId integer,
    varShiftFromDate date,
    varShiftToDate date
)
RETURNS TABLE(
    "TotSale" double precision,
    "Amount" double precision,
    "TotSaleBeforeTransaction" double precision,
    "AmountBeforeTransaction" double precision,
    "DeclareNumber" integer,
    "TransactionDate" date,
    "ShiftId" bigint,
    "ShiftName" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT t."TotSale", t."Amount", t."TotSaleBeforeTransaction",
           t."AmountBeforeTransaction", t."DeclareNumber", t."TransactionDate", t."ShiftId",
           shift."ShiftName"::text
    FROM (
        SELECT sum(t."Amount") AS "TotSale"
             , -sum((COALESCE((CASE WHEN ((CASE WHEN t."Number" ~ '^[0-9]+$' THEN t."Number"::numeric = declare_result."DeclareNumber" ELSE false END)
                                         OR t."Number" = right(lpad(((declare_result."DeclareNumber" % 10) * 111)::text, 3, '0'), 3)
                                         OR t."Number" = right(lpad(((floor(declare_result."DeclareNumber"::numeric / 10)::bigint % 10) * 1111)::text, 4, '0'), 4))
                                        AND t."TransactionMode" = 1
                                   THEN t."Amount" * t."Rate" ELSE 0 END), 0)
                     - COALESCE((CASE WHEN t."TransactionMode" = 1 THEN t."FinalAmount" ELSE 0 END), 0)
                    )
                    * ((100 - COALESCE(t."SelfHissa", 0)) / 100) * ((100 - COALESCE(t."OtherHissa", 0)) / 100)
                   ) AS "Amount"
             , sum(CASE WHEN t."UpdatedDate" > declare_result."AddedDate" THEN 0 ELSE t."Amount" END) AS "TotSaleBeforeTransaction"
             , -sum(CASE WHEN t."UpdatedDate" > declare_result."AddedDate" THEN 0 ELSE
                   (COALESCE((CASE WHEN ((CASE WHEN t."Number" ~ '^[0-9]+$' THEN t."Number"::numeric = declare_result."DeclareNumber" ELSE false END)
                                         OR t."Number" = right(lpad(((declare_result."DeclareNumber" % 10) * 111)::text, 3, '0'), 3)
                                         OR t."Number" = right(lpad(((floor(declare_result."DeclareNumber"::numeric / 10)::bigint % 10) * 1111)::text, 4, '0'), 4))
                                        AND t."TransactionMode" = 1
                                   THEN t."Amount" * t."Rate" ELSE 0 END), 0)
                    - COALESCE((CASE WHEN t."TransactionMode" = 1 THEN t."FinalAmount" ELSE 0 END), 0)
                   )
                   * ((100 - COALESCE(t."SelfHissa", 0)) / 100) * ((100 - COALESCE(t."OtherHissa", 0)) / 100)
                   END
                  ) AS "AmountBeforeTransaction"
             , declare_result."DeclareNumber" AS "DeclareNumber"
             , t."TransactionDate"
             , t."ShiftId"
        FROM (
            SELECT tdd."Number", tdd."Amount", tdd."Rate", tdd."FinalAmount"
                 , trd."SelfHissa"
                 , trd."OtherHissa"
                 , trd."TransactionMode"
                 , trd."UpdatedDate"
                 , trd."TransactionDate"
                 , trd."ShiftId"
            FROM "transaction_declare" trd
            INNER JOIN "transaction_detail_declare" tdd ON trd."TransactionId" = tdd."TransactionId"
            WHERE trd."TransactionDate" BETWEEN varShiftFromDate AND varShiftToDate
              AND (trd."ShiftId" = varShiftId OR COALESCE(varShiftId, 0) = 0)
              AND trd."OrganizationId" = varOrganizationId
              AND trd."TransactionMode" = 1
              AND trd."RecordStatus" != 'D'
              AND tdd."RecordStatus" != 'D'
        ) AS t
        INNER JOIN "declare_result" declare_result ON declare_result."DeclareDate" = t."TransactionDate"
                   AND declare_result."ShiftId" = t."ShiftId"
                   AND declare_result."RecordStatus" != 'D'
        GROUP BY declare_result."DeclareNumber", t."TransactionDate", t."ShiftId"
    ) AS t
    INNER JOIN "shift" shift ON shift."ShiftId" = t."ShiftId"
    ORDER BY t."TransactionDate", shift."ShiftOrder";
END;
$$;
