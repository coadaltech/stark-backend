-- Converted from MySQL procedure `transaction_limit_check_of_ledger`.
-- Params stay varchar as in MySQL; MySQL compared them numerically against bigint columns,
-- so they are cast (::bigint / ::numeric) here. A non-numeric string raises in PG
-- (MySQL silently coerced it to a number).
-- Original CASE is `CASE WHEN varTransactionIdIsTmp = 0 THEN .. WHEN 1 THEN .. ELSE 0 END`:
-- the second WHEN is the constant 1 (always true), so any non-zero/NULL value takes the
-- transaction_declare branch and ELSE 0 is unreachable. Preserved as-is.
DROP ROUTINE IF EXISTS "transaction_limit_check_of_ledger";
CREATE OR REPLACE FUNCTION "transaction_limit_check_of_ledger"(
    varOrganizationId integer,
    varLedgerId varchar,
    varTransactionId varchar,
    varTransactionIdIsTmp varchar
)
RETURNS TABLE(
    "LedgerId" bigint,
    "OrganizationId" bigint,
    "ParentLedgerId" bigint,
    "LedgerName" text,
    "RealName" text,
    "GroupId" integer,
    "AgentLedgerId" bigint,
    "LimitType" text,
    "DaraRate" double precision,
    "DaraCommission" double precision,
    "AkharRate" double precision,
    "AkharCommission" double precision,
    "Vapsi" double precision,
    "TPVapsi" text,
    "TPCommission" text,
    "IsHissa" text,
    "IsDibba" text,
    "DibbaAmount" double precision,
    "RefLedgerId" bigint,
    "HPLedgerId" bigint,
    "Grantor" text,
    "DealingType" text,
    "IsReport" text,
    "TransactionMode" smallint,
    "AccountStatus" text,
    "IsHide" text,
    "ChatGroupId" bigint,
    "TransactionCappingAmount" double precision,
    "IsApplyLedgerConfigOnTransaction" integer,
    "IsRisky" smallint,
    "TransactionLock" integer,
    "IsTransactionAllow" smallint,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp,
    "LedgerBalance" double precision,
    "LedgerLimit" double precision,
    "TransConsum" double precision,
    "FinalLimit" double precision
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT l."LedgerId", l."OrganizationId", l."ParentLedgerId", l."LedgerName"::text, l."RealName"::text,
           l."GroupId", l."AgentLedgerId", l."LimitType"::text, l."DaraRate", l."DaraCommission",
           l."AkharRate", l."AkharCommission", l."Vapsi", l."TPVapsi"::text, l."TPCommission"::text,
           l."IsHissa"::text, l."IsDibba"::text, l."DibbaAmount", l."RefLedgerId", l."HPLedgerId",
           l."Grantor"::text, l."DealingType"::text, l."IsReport"::text, l."TransactionMode",
           l."AccountStatus"::text, l."IsHide"::text, l."ChatGroupId", l."TransactionCappingAmount",
           l."IsApplyLedgerConfigOnTransaction", l."IsRisky", l."TransactionLock", l."IsTransactionAllow",
           l."RecordStatus"::text, l."AddedBy"::text, l."AddedDate", l."UpdatedBy"::text, l."UpdatedDate"
         , ledger_limit."LedgerBalance"
         , ledger_limit."LedgerLimit"
         , ledger_limit."TransConsum"
           - (CASE WHEN varTransactionIdIsTmp::numeric = 0 THEN
                  COALESCE((SELECT sum(tr."TotalAmount")
                            FROM "transaction" tr
                            WHERE tr."LedgerId" = varLedgerId::bigint
                              AND tr."TransactionId" = varTransactionId::bigint
                              AND tr."RecordStatus" != 'D'), 0)
              WHEN true /* MySQL: WHEN 1 */ THEN
                  COALESCE((SELECT sum(trd."TotalAmount")
                            FROM "transaction_declare" trd
                            WHERE trd."LedgerId" = varLedgerId::bigint
                              AND trd."TransactionId" = varTransactionId::bigint
                              AND trd."RecordStatus" != 'D'), 0)
              ELSE 0
              END) AS "TransConsum"
         , ledger_limit."FinalLimit"
           - (CASE WHEN varTransactionIdIsTmp::numeric = 0 THEN
                  COALESCE((SELECT sum(tr."TotalAmount")
                            FROM "transaction" tr
                            WHERE tr."LedgerId" = varLedgerId::bigint
                              AND tr."TransactionId" = varTransactionId::bigint
                              AND tr."RecordStatus" != 'D'), 0)
              WHEN true /* MySQL: WHEN 1 */ THEN
                  COALESCE((SELECT sum(trd."TotalAmount")
                            FROM "transaction_declare" trd
                            WHERE trd."LedgerId" = varLedgerId::bigint
                              AND trd."TransactionId" = varTransactionId::bigint
                              AND trd."RecordStatus" != 'D'), 0)
              ELSE 0
              END) AS "FinalLimit"
    FROM "ledger" l
    LEFT JOIN "ledger_limit" ledger_limit ON l."LedgerId" = ledger_limit."LedgerId"
    WHERE l."OrganizationId" = varOrganizationId
      AND l."LedgerId" = varLedgerId::bigint
      AND l."RecordStatus" != 'D'
    ORDER BY l."LedgerName" DESC;
END;
$$;
