-- Converted from MySQL procedure `ledger_Info_by_ledgerId`.
DROP ROUTINE IF EXISTS "ledger_Info_by_ledgerId";
CREATE OR REPLACE FUNCTION "ledger_Info_by_ledgerId"(varOrganizationId integer, varLedgerId varchar)
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
           l."RecordStatus"::text, l."AddedBy"::text, l."AddedDate", l."UpdatedBy"::text, l."UpdatedDate",
           ll."LedgerBalance",
           ll."LedgerLimit",
           ll."TransConsum",
           ll."FinalLimit"
    FROM "ledger" l
    LEFT JOIN "ledger_limit" ll ON l."LedgerId" = ll."LedgerId"
    WHERE l."OrganizationId" = varOrganizationId
      AND l."LedgerId" = varLedgerId::bigint
      AND l."RecordStatus" != 'D'
    ORDER BY l."LedgerName" DESC;
END;
$$;
