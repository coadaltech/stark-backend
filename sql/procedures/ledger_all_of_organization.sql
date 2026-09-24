-- Converted from MySQL procedure `ledger_all_of_organization`.
-- Note: MySQL returned l.* (incl. raw AddedDate/UpdatedDate) plus formatted AddedDate/UpdatedDate
-- (duplicate labels; name-based clients see the later, formatted one). Only the formatted ones are kept.
-- LIKE -> ILIKE to keep MySQL's case-insensitive collation behaviour.
DROP ROUTINE IF EXISTS "ledger_all_of_organization";
CREATE OR REPLACE FUNCTION "ledger_all_of_organization"(
    varOrganizationId integer,
    varLedgerName varchar,
    varLedgerId integer,
    varUserName varchar,
    varRoleId integer,
    varRoleType varchar,
    varIsHide integer,   -- 0 for Active , 1 For Hide , 2 for Deleted
    varAgentId integer,
    varGroupAgentId integer,
    varIsCapping integer)
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
    "UpdatedBy" text,
    "ChatGroupName" text,
    "AddedDate" text,
    "UpdatedDate" text,
    "GroupName" text,
    "AgentName" text,
    "LoginName" text,
    "UserName" text,
    "LoginType" smallint,
    "Mobile" text,
    "Address" text,
    "LoginStatus" text,
    "HPLedgerName" text,
    "TelegramId" bigint,
    "LedgerTelegramId" bigint,
    "AccessHash" text)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    -- RoleId = 2 super admin, 3 distributer,4 ressaler ,5 panter
    CASE varRoleId
    WHEN 3 THEN
        RETURN QUERY
        SELECT l."LedgerId", l."OrganizationId", l."ParentLedgerId", l."LedgerName"::text, l."RealName"::text, l."GroupId", l."AgentLedgerId", l."LimitType"::text, l."DaraRate", l."DaraCommission", l."AkharRate", l."AkharCommission", l."Vapsi", l."TPVapsi"::text, l."TPCommission"::text, l."IsHissa"::text, l."IsDibba"::text, l."DibbaAmount", l."RefLedgerId", l."HPLedgerId", l."Grantor"::text, l."DealingType"::text, l."IsReport"::text, l."TransactionMode", l."AccountStatus"::text, l."IsHide"::text, l."ChatGroupId", l."TransactionCappingAmount", l."IsApplyLedgerConfigOnTransaction", l."IsRisky", l."TransactionLock", l."IsTransactionAllow", l."RecordStatus"::text, l."AddedBy"::text, l."UpdatedBy"::text,
               cg."ChatGroupName"::text,
               to_char(l."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
               to_char(l."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
               g."GroupName"::text,
               COALESCE(agent."CommanMasterName"::text, '') AS "AgentName",
               lg."LoginName"::text, lg."UserName"::text, lg."LoginType", lg."Mobile"::text, lg."Address"::text, lg."AccountStatus"::text AS "LoginStatus",
               hpledger."LedgerName"::text AS "HPLedgerName",
               COALESCE(lt."TelegramId", 0) AS "TelegramId",
               COALESCE(lt."LedgerTelegramId", 0) AS "LedgerTelegramId",
               COALESCE(lt."AccessHash"::text, '') AS "AccessHash"
        FROM "ledger" l
        JOIN "ledger_group" g ON l."GroupId" = g."GroupId"
        LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
        LEFT JOIN "chat_group" cg ON cg."ChatGroupId" = l."ChatGroupId"
        JOIN "login" lg ON lg."LedgerId" = l."LedgerId"
        LEFT JOIN "ledger" hpledger ON l."HPLedgerId" = hpledger."LedgerId"
        LEFT JOIN "ledger_telegram" lt ON l."LedgerId" = lt."LedgerId" AND lt."RecordStatus" <> 'D'
        WHERE l."OrganizationId" = varOrganizationId
          AND (varLedgerName IS NULL OR l."LedgerName" ILIKE ('%' || varLedgerName::text || '%'))
          AND ((l."RecordStatus" != 'D' AND COALESCE(varIsHide, 0) != 2) OR (l."RecordStatus" = 'D' AND varIsHide = 2))
          AND l."GroupId" != 7
          AND (COALESCE(l."IsHide", '0') = COALESCE(varIsHide, 0)::text OR COALESCE(varIsHide, 0) = 2)
          AND (l."ParentLedgerId" = varLedgerId OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId))
          AND (varRoleType = 'ALL'
               OR l."UpdatedBy" = varUserName)
          AND (COALESCE(varIsCapping, -1) = -1 OR (CASE WHEN varIsCapping = 1 THEN l."TransactionCappingAmount" <> 0 ELSE l."TransactionCappingAmount" = 0 END))
        ORDER BY l."LedgerName" ASC;

    WHEN 4 THEN
        RETURN QUERY
        SELECT l."LedgerId", l."OrganizationId", l."ParentLedgerId", l."LedgerName"::text, l."RealName"::text, l."GroupId", l."AgentLedgerId", l."LimitType"::text, l."DaraRate", l."DaraCommission", l."AkharRate", l."AkharCommission", l."Vapsi", l."TPVapsi"::text, l."TPCommission"::text, l."IsHissa"::text, l."IsDibba"::text, l."DibbaAmount", l."RefLedgerId", l."HPLedgerId", l."Grantor"::text, l."DealingType"::text, l."IsReport"::text, l."TransactionMode", l."AccountStatus"::text, l."IsHide"::text, l."ChatGroupId", l."TransactionCappingAmount", l."IsApplyLedgerConfigOnTransaction", l."IsRisky", l."TransactionLock", l."IsTransactionAllow", l."RecordStatus"::text, l."AddedBy"::text, l."UpdatedBy"::text,
               cg."ChatGroupName"::text,
               to_char(l."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
               to_char(l."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
               g."GroupName"::text,
               COALESCE(agent."CommanMasterName"::text, '') AS "AgentName",
               lg."LoginName"::text, lg."UserName"::text, lg."LoginType", lg."Mobile"::text, lg."Address"::text, lg."AccountStatus"::text AS "LoginStatus",
               hpledger."LedgerName"::text AS "HPLedgerName",
               COALESCE(lt."TelegramId", 0) AS "TelegramId",
               COALESCE(lt."LedgerTelegramId", 0) AS "LedgerTelegramId",
               COALESCE(lt."AccessHash"::text, '') AS "AccessHash"
        FROM "ledger" l
        JOIN "ledger_group" g ON l."GroupId" = g."GroupId"
        LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
        LEFT JOIN "chat_group" cg ON cg."ChatGroupId" = l."ChatGroupId"
        JOIN "login" lg ON lg."LedgerId" = l."LedgerId"
        LEFT JOIN "ledger" hpledger ON l."HPLedgerId" = hpledger."LedgerId"
        LEFT JOIN "ledger_telegram" lt ON l."LedgerId" = lt."LedgerId" AND lt."RecordStatus" <> 'D'
        WHERE l."OrganizationId" = varOrganizationId
          AND (varLedgerName IS NULL OR l."LedgerName" ILIKE ('%' || varLedgerName::text || '%'))
          AND ((l."RecordStatus" != 'D' AND COALESCE(varIsHide, 0) != 2) OR (l."RecordStatus" = 'D' AND varIsHide = 2))
          AND l."GroupId" != 7
          AND (COALESCE(l."IsHide", '0') = COALESCE(varIsHide, 0)::text OR COALESCE(varIsHide, 0) = 2)
          AND (l."ParentLedgerId" = varLedgerId)
          AND (varRoleType = 'ALL'
               OR l."UpdatedBy" = varUserName)
          AND (COALESCE(varIsCapping, -1) = -1 OR (CASE WHEN varIsCapping = 1 THEN l."TransactionCappingAmount" <> 0 ELSE l."TransactionCappingAmount" = 0 END))
        ORDER BY l."LedgerName" ASC;

    WHEN 5 THEN
        RETURN QUERY
        SELECT l."LedgerId", l."OrganizationId", l."ParentLedgerId", l."LedgerName"::text, l."RealName"::text, l."GroupId", l."AgentLedgerId", l."LimitType"::text, l."DaraRate", l."DaraCommission", l."AkharRate", l."AkharCommission", l."Vapsi", l."TPVapsi"::text, l."TPCommission"::text, l."IsHissa"::text, l."IsDibba"::text, l."DibbaAmount", l."RefLedgerId", l."HPLedgerId", l."Grantor"::text, l."DealingType"::text, l."IsReport"::text, l."TransactionMode", l."AccountStatus"::text, l."IsHide"::text, l."ChatGroupId", l."TransactionCappingAmount", l."IsApplyLedgerConfigOnTransaction", l."IsRisky", l."TransactionLock", l."IsTransactionAllow", l."RecordStatus"::text, l."AddedBy"::text, l."UpdatedBy"::text,
               cg."ChatGroupName"::text,
               to_char(l."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
               to_char(l."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
               g."GroupName"::text,
               COALESCE(agent."CommanMasterName"::text, '') AS "AgentName",
               lg."LoginName"::text, lg."UserName"::text, lg."LoginType", lg."Mobile"::text, lg."Address"::text, lg."AccountStatus"::text AS "LoginStatus",
               hpledger."LedgerName"::text AS "HPLedgerName",
               COALESCE(lt."TelegramId", 0) AS "TelegramId",
               COALESCE(lt."LedgerTelegramId", 0) AS "LedgerTelegramId",
               COALESCE(lt."AccessHash"::text, '') AS "AccessHash"
        FROM "ledger" l
        JOIN "ledger_group" g ON l."GroupId" = g."GroupId"
        LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
        LEFT JOIN "chat_group" cg ON cg."ChatGroupId" = l."ChatGroupId"
        JOIN "login" lg ON lg."LedgerId" = l."LedgerId"
        LEFT JOIN "ledger" hpledger ON l."HPLedgerId" = hpledger."LedgerId"
        LEFT JOIN "ledger_telegram" lt ON l."LedgerId" = lt."LedgerId" AND lt."RecordStatus" <> 'D'
        WHERE l."OrganizationId" = varOrganizationId
          AND (varLedgerName IS NULL OR l."LedgerName" ILIKE ('%' || varLedgerName::text || '%'))
          AND ((l."RecordStatus" != 'D' AND COALESCE(varIsHide, 0) != 2) OR (l."RecordStatus" = 'D' AND varIsHide = 2))
          AND l."GroupId" != 7
          AND (COALESCE(l."IsHide", '0') = COALESCE(varIsHide, 0)::text OR COALESCE(varIsHide, 0) = 2)
          AND 1 <> 1 /*not show to fanter even his account not show*/
          AND (l."LedgerId" = varLedgerId)
          AND (varRoleType = 'ALL'
               OR l."UpdatedBy" = varUserName)
          AND (COALESCE(varIsCapping, -1) = -1 OR (CASE WHEN varIsCapping = 1 THEN l."TransactionCappingAmount" <> 0 ELSE l."TransactionCappingAmount" = 0 END))
        ORDER BY l."LedgerName" ASC;

    ELSE
        RETURN QUERY
        SELECT l."LedgerId", l."OrganizationId", l."ParentLedgerId", l."LedgerName"::text, l."RealName"::text, l."GroupId", l."AgentLedgerId", l."LimitType"::text, l."DaraRate", l."DaraCommission", l."AkharRate", l."AkharCommission", l."Vapsi", l."TPVapsi"::text, l."TPCommission"::text, l."IsHissa"::text, l."IsDibba"::text, l."DibbaAmount", l."RefLedgerId", l."HPLedgerId", l."Grantor"::text, l."DealingType"::text, l."IsReport"::text, l."TransactionMode", l."AccountStatus"::text, l."IsHide"::text, l."ChatGroupId", l."TransactionCappingAmount", l."IsApplyLedgerConfigOnTransaction", l."IsRisky", l."TransactionLock", l."IsTransactionAllow", l."RecordStatus"::text, l."AddedBy"::text, l."UpdatedBy"::text,
               cg."ChatGroupName"::text,
               to_char(l."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
               to_char(l."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
               g."GroupName"::text,
               COALESCE(agent."CommanMasterName"::text, '') AS "AgentName",
               lg."LoginName"::text, lg."UserName"::text, lg."LoginType", lg."Mobile"::text, lg."Address"::text, lg."AccountStatus"::text AS "LoginStatus",
               hpledger."LedgerName"::text AS "HPLedgerName",
               COALESCE(lt."TelegramId", 0) AS "TelegramId",
               COALESCE(lt."LedgerTelegramId", 0) AS "LedgerTelegramId",
               COALESCE(lt."AccessHash"::text, '') AS "AccessHash"
        FROM "ledger" l
        JOIN "ledger_group" g ON l."GroupId" = g."GroupId"
        LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
        LEFT JOIN "chat_group" cg ON cg."ChatGroupId" = l."ChatGroupId"
        LEFT JOIN "login" lg ON lg."LedgerId" = l."LedgerId"
        LEFT JOIN "ledger" hpledger ON l."HPLedgerId" = hpledger."LedgerId"
        LEFT JOIN "ledger_telegram" lt ON l."LedgerId" = lt."LedgerId" AND lt."RecordStatus" <> 'D'
        WHERE l."OrganizationId" = varOrganizationId
          AND (varLedgerName IS NULL OR l."LedgerName" ILIKE ('%' || varLedgerName::text || '%'))
          AND ((l."RecordStatus" != 'D' AND COALESCE(varIsHide, 0) != 2) OR (l."RecordStatus" = 'D' AND varIsHide = 2))
          AND l."GroupId" != 7
          AND (COALESCE(l."IsHide", '0') = COALESCE(varIsHide, 0)::text OR COALESCE(varIsHide, 0) = 2)
          AND (varRoleType = 'ALL'
               OR l."UpdatedBy" = varUserName)
          AND (agent."LedgerId" = varAgentId OR COALESCE(varAgentId, 0) = 0)
          AND (l."AgentLedgerId" = varGroupAgentId OR COALESCE(varGroupAgentId, 0) = 0)
          AND (COALESCE(varIsCapping, -1) = -1 OR (CASE WHEN varIsCapping = 1 THEN l."TransactionCappingAmount" <> 0 ELSE l."TransactionCappingAmount" = 0 END))
        ORDER BY l."LedgerName" ASC;
    END CASE;
END;
$$;
