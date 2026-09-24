-- Converted from MySQL procedure `ledger_Info`.
DROP ROUTINE IF EXISTS "ledger_Info";
CREATE OR REPLACE FUNCTION "ledger_Info"(
    varOrganizationId integer,
    varLedgerId integer,
    varGroupId varchar,
    varParentId integer,
    varDistributerId integer
)
RETURNS TABLE(
    "LedgerId" bigint,
    "OrganizationId" bigint,
    "ParentLedgerId" bigint,
    "LedgerName" text,
    "RealName" text,
    "Grantor" text,
    "GroupId" integer,
    "AgentLedgerId" bigint,
    "AgentLedgerName" text,
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
    "RefLedgerName" text,
    "IsReport" text,
    "TransactionMode" smallint,
    "TransactionCappingAmount" double precision,
    "IsTransactionAllow" smallint,
    "AccountStatus" text,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp,
    "DealingType" text,
    "LedgerBalance" double precision,
    "LedgerLimit" double precision,
    "TransConsum" double precision,
    "FinalLimit" double precision,
    "TelegramId" bigint,
    "LedgerTelegramId" bigint,
    "AccessHash" text,
    "RetailerName" text,
    "DistributorName" text,
    "LoginId" bigint,
    "Mobile" text,
    "Address" text,
    "UserName" text,
    "LoginStatus" text,
    "HPLedgerId" bigint,
    "HPLedgerName" text,
    "SelfHissa" double precision,
    "OtherHissa" double precision,
    "IsApplyLedgerConfigOnTransaction" integer,
    "IsRisky" smallint,
    "TransactionLock" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT ledger."LedgerId",
        ledger."OrganizationId",
        ledger."ParentLedgerId",
        ledger."LedgerName"::text,
        ledger."RealName"::text,
        ledger."Grantor"::text,
        ledger."GroupId",
        ledger."AgentLedgerId",
        (SELECT agent."CommanMasterName" FROM "comman_master" AS agent
            WHERE agent."CommanMasterId" = ledger."AgentLedgerId" AND agent."CommanMasterType" = 1)::text
            AS "AgentLedgerName",
        ledger."LimitType"::text,
        ledger."DaraRate",
        ledger."DaraCommission",
        ledger."AkharRate",
        ledger."AkharCommission",
        ledger."Vapsi",
        ledger."TPVapsi"::text,
        ledger."TPCommission"::text,
        ledger."IsHissa"::text,
        ledger."IsDibba"::text,
        ledger."DibbaAmount",
        ledger."RefLedgerId",
        (SELECT refledger."LedgerName" FROM "ledger" AS refledger WHERE refledger."LedgerId" = ledger."RefLedgerId")::text AS "RefLedgerName",
        ledger."IsReport"::text,
        ledger."TransactionMode",
        (CASE WHEN ledger."ParentLedgerId" = 0 THEN ledger."TransactionCappingAmount" ELSE parentledger."TransactionCappingAmount" END) AS "TransactionCappingAmount",
        ledger."IsTransactionAllow",
        ledger."AccountStatus"::text,
        ledger."RecordStatus"::text,
        ledger."AddedBy"::text,
        ledger."AddedDate",
        ledger."UpdatedBy"::text,
        ledger."UpdatedDate"
        , ledger."DealingType"::text
        , ledger_limit."LedgerBalance"
        , ledger_limit."LedgerLimit"
        , ledger_limit."TransConsum"
        , ledger_limit."FinalLimit"
        , COALESCE(ledger_telegram."TelegramId", 0)::bigint AS "TelegramId"
        , COALESCE(ledger_telegram."LedgerTelegramId", 0)::bigint AS "LedgerTelegramId"
        , COALESCE(ledger_telegram."AccessHash", '')::text AS "AccessHash"
        , COALESCE((SELECT ret."LedgerName" FROM "ledger" AS ret WHERE ret."GroupId" = 4 AND ret."LedgerId" = ledger."ParentLedgerId"), 'Self')::text AS "RetailerName"
        , COALESCE((SELECT distrib."LedgerName" FROM "ledger" AS distrib WHERE distrib."GroupId" = 3 AND distrib."LedgerId" = ledger."ParentLedgerId"
                    UNION
                    SELECT (SELECT distrib2."LedgerName" FROM "ledger" AS distrib2 WHERE distrib2."GroupId" = 3 AND distrib2."LedgerId" = ret2."ParentLedgerId")
                    FROM "ledger" AS ret2 WHERE ret2."GroupId" = 4 AND ret2."LedgerId" = ledger."ParentLedgerId"), 'Self')::text AS "DistributorName"
        , login."LoginId"
        , login."Mobile"::text
        , login."Address"::text
        , login."UserName"::text
        , login."AccountStatus"::text AS "LoginStatus"
        , ledger."HPLedgerId"
        , hpledger."LedgerName"::text AS "HPLedgerName"
        , COALESCE((SELECT sum(h."Hissa") FROM "hissa" h
                    WHERE h."RecordStatus" != 'D'
                      AND h."LedgerId" = ledger."LedgerId"
                      AND h."LedgerId" = h."HissaLedgerId"), 0) AS "SelfHissa"
        , COALESCE((SELECT sum(h."Hissa") FROM "hissa" h
                    WHERE h."RecordStatus" != 'D'
                      AND h."LedgerId" = ledger."LedgerId"
                      AND h."LedgerId" != h."HissaLedgerId"), 0) AS "OtherHissa"
        , COALESCE(ledger."IsApplyLedgerConfigOnTransaction", 0)::integer AS "IsApplyLedgerConfigOnTransaction"
        , ledger."IsRisky"
        , ledger."TransactionLock"
    FROM "ledger" ledger
    LEFT JOIN "ledger_limit" ledger_limit ON ledger."LedgerId" = ledger_limit."LedgerId"
    LEFT JOIN "login" login ON ledger."LedgerId" = login."LedgerId"
    LEFT JOIN "ledger" hpledger ON ledger."HPLedgerId" = hpledger."LedgerId"
    LEFT JOIN "ledger" parentledger ON ledger."ParentLedgerId" = parentledger."LedgerId"
    LEFT JOIN "ledger_telegram" ledger_telegram ON ledger."LedgerId" = ledger_telegram."LedgerId" AND ledger_telegram."RecordStatus" <> 'D'
    WHERE (ledger."OrganizationId" = varOrganizationId OR ledger."OrganizationId" = 0 OR COALESCE(varOrganizationId, 0) = 0)
      AND (ledger."LedgerId" = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
      AND (ledger."GroupId"::text = ANY(string_to_array(varGroupId, ',')) OR COALESCE(varGroupId, '') = '')
      AND (ledger."ParentLedgerId" = varParentId OR COALESCE(varParentId, 0) = 0)
      AND ledger."RecordStatus" != 'D'
      AND ledger."IsHide" = '0'
      AND (ledger."LedgerId" IN (SELECT retailer."LedgerId" FROM "ledger" AS retailer
                WHERE retailer."ParentLedgerId" IN (SELECT distributer."LedgerId" FROM "ledger" AS distributer WHERE distributer."ParentLedgerId" = varDistributerId))
           OR COALESCE(varDistributerId, 0) = 0
           OR (ledger."LedgerId" IN (SELECT fantar."LedgerId" FROM "ledger" AS fantar WHERE fantar."ParentLedgerId" = varDistributerId))
          )
    ORDER BY ledger."LedgerName" DESC;
END;
$$;
