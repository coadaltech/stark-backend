-- Converted from MySQL procedure `rpt_Daily_List`.
-- MySQL second branch selected l.GroupId and selfvd.IsVerify without grouping; both are
-- functionally dependent on the existing group keys (ledger row / selfvd row), so they are added to GROUP BY.
DROP ROUTINE IF EXISTS "rpt_Daily_List";
CREATE OR REPLACE FUNCTION "rpt_Daily_List"(
    VoucherDates date,
    ShiftIds bigint,
    varOrganizationId bigint,
    varGroupAgentId bigint,
    varLedgerId bigint,
    varLoginRoleId bigint,
    varCashAgentId bigint
)
RETURNS TABLE(
    "VoucherId" integer,
    "VoucherDate" date,
    "LedgerId" bigint,
    "LedgerName" text,
    "GroupId" integer,
    "AgentName" text,
    "TransactionCappingAmount" double precision,
    "Remark" text,
    "SelfHissa" double precision,
    "OtherHissa" integer,
    "TotalSale" numeric,
    "DaraSale" numeric,
    "BaharKaAkharSale" numeric,
    "AnderKaAkharSale" numeric,
    "TotalCommission" numeric,
    "TotalProfit" numeric,
    "DaraOpenProfit" numeric,
    "BaharKaAkharOpenProfit" numeric,
    "AnderKaAkharOpenProfit" numeric,
    "DaraOpen" numeric,
    "BaharKaAkharOpen" numeric,
    "AnderKaAkharOpen" numeric,
    "TPC" numeric,
    "Tax" numeric,
    "Hissa" numeric,
    "Balance" numeric,
    "IsVerify" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT 0 AS "VoucherId", VoucherDates AS "VoucherDate", l."LedgerId", l."LedgerName"::text, l."GroupId", l."AgentName"::text AS "AgentName", l."TransactionCappingAmount"
        , selfvd."Remark"::text, selfvd."SelfHissa", 0 AS "OtherHissa"
        , COALESCE(selfvd."TotalSale", 0) AS "TotalSale"
        , COALESCE(selfvd."DaraSale", 0) AS "DaraSale"
        , COALESCE(selfvd."BaharKaAkharSale", 0) AS "BaharKaAkharSale"
        , COALESCE(selfvd."AnderKaAkharSale", 0) AS "AnderKaAkharSale"
        , COALESCE(selfvd."TotalCommission", 0) AS "TotalCommission"
        , COALESCE(selfvd."TotalProfit", 0) AS "TotalProfit"
        , COALESCE(selfvd."DaraOpenProfit", 0) AS "DaraOpenProfit"
        , COALESCE(selfvd."BaharKaAkharOpenProfit", 0) AS "BaharKaAkharOpenProfit"
        , COALESCE(selfvd."AnderKaAkharOpenProfit", 0) AS "AnderKaAkharOpenProfit"
        , COALESCE(selfvd."DaraOpen", 0) AS "DaraOpen"
        , COALESCE(selfvd."BaharKaAkharOpen", 0) AS "BaharKaAkharOpen"
        , COALESCE(selfvd."AnderKaAkharOpen", 0) AS "AnderKaAkharOpen"
        , COALESCE(selfvd."TPC", 0) AS "TPC"
        , COALESCE(selfvd."Tax", 0) AS "Tax"
        , COALESCE(selfvd."Hissa", 0) AS "Hissa"
        , COALESCE(selfvd."Balance", 0) AS "Balance"
        , (CASE WHEN COALESCE(selfvd."IsVerify", 0) > 0 THEN 0 ELSE 1 END)::integer AS "IsVerify"
    FROM
    (
        SELECT ledger."LedgerId", ledger."LedgerName", ledger."AgentLedgerId", ledger."GroupId", COALESCE(agent."CommanMasterName", 'NA') AS "AgentName"
            , ledger."TransactionCappingAmount"
        FROM "ledger" ledger
        LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = ledger."AgentLedgerId" AND agent."CommanMasterType" = 1
        WHERE (ledger."OrganizationId" = varOrganizationId OR ledger."LedgerId" = 11)
          AND ledger."LedgerId" = COALESCE(varLedgerId, 0)
          AND (CASE COALESCE(varLoginRoleId, 0) WHEN 1 THEN ledger."GroupId" IN (2,3,4,5) WHEN 2 THEN ledger."GroupId" IN (2,3,4,5) ELSE ledger."GroupId" IN (3,4,5) END)
          AND (COALESCE(varGroupAgentId, 0) = 0 OR ledger."AgentLedgerId" = varGroupAgentId)
          /*
          and (ifnull(varCashAgentId,0) = 0 or ledger.AgentLedgerId in (select CommanMasterId from comman_master where LedgerId = varCashAgentId))
          */
          AND (agent."LedgerId" = varCashAgentId OR agent."ParentAgentLedgerId" = varCashAgentId OR COALESCE(varCashAgentId, 0) = 0)
          AND ledger."RecordStatus" != 'D'
    ) AS l
    LEFT JOIN (
        SELECT vd."LedgerId", vd."Remark", vd."SelfHissa"
        , (sum(CASE WHEN vd."VoucherType" = 22 OR vd."VoucherType" = 23 OR vd."VoucherType" = 24 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalSale"
        , (sum(CASE WHEN vd."VoucherType" = 22 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "DaraSale"
        , (sum(CASE WHEN vd."VoucherType" = 23 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "BaharKaAkharSale"
        , (sum(CASE WHEN vd."VoucherType" = 24 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "AnderKaAkharSale"
        , (sum(CASE WHEN vd."VoucherType" = 25 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalCommission"
        , (sum(CASE WHEN vd."VoucherType" = 26 OR vd."VoucherType" = 27 OR vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalProfit"
        , (sum(CASE WHEN vd."VoucherType" = 26 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "DaraOpenProfit"
        , (sum(CASE WHEN vd."VoucherType" = 27 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpenProfit"
        , (sum(CASE WHEN vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpenProfit"
        , (sum(CASE WHEN vd."VoucherType" = 26 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "DaraOpen"
        , (sum(CASE WHEN vd."VoucherType" = 27 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpen"
        , (sum(CASE WHEN vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpen"
        , (sum(CASE WHEN vd."VoucherType" = 32 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TPC"
        , (sum(CASE WHEN vd."VoucherType" = 35 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "Tax"
        , (sum(CASE WHEN vd."VoucherType" = 29 OR vd."VoucherType" = 30 OR vd."VoucherType" = 31 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "Hissa"
        , (sum(CASE WHEN vd."VoucherType" IN (22,23,24,25,26,27,28,29,30,31,32,35) THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "Balance"
        , sum(CASE WHEN COALESCE(vd."VerifyBy", '') = '' THEN 1 ELSE 0 END) AS "IsVerify"
        FROM "voucher_detail" vd
        JOIN "voucher" v ON vd."VoucherId" = v."VoucherId"
        WHERE (v."VoucherDate" = VoucherDates)
          AND (v."ShiftId" = ShiftIds OR COALESCE(ShiftIds, 0) = 0)
          AND (vd."RecordStatus" != 'D')
          AND (v."RecordStatus" != 'D')
          AND vd."OrganizationId" = varOrganizationId
        GROUP BY vd."LedgerId", vd."Remark", vd."SelfHissa"
    ) AS selfvd ON selfvd."LedgerId" = l."LedgerId"
    WHERE COALESCE(varLedgerId, 0) != 0

    UNION ALL

    SELECT 0 AS "VoucherId", VoucherDates AS "VoucherDate", l."LedgerId", l."LedgerName"::text, l."GroupId", l."AgentName"::text AS "AgentName", l."TransactionCappingAmount"
        , COALESCE(selfvd."Remark", '')::text AS "Remark"
        , COALESCE(selfvd."SelfHissa", 0) AS "SelfHissa"
        , 0 AS "OtherHissa"
        , COALESCE(selfvd."TotalSale", 0) + COALESCE(sum(childvd."TotalSale"), 0) AS "TotalSale"
        , COALESCE(selfvd."DaraSale", 0) + COALESCE(sum(childvd."DaraSale"), 0) AS "DaraSale"
        , COALESCE(selfvd."BaharKaAkharSale", 0) + COALESCE(sum(childvd."BaharKaAkharSale"), 0) AS "BaharKaAkharSale"
        , COALESCE(selfvd."AnderKaAkharSale", 0) + COALESCE(sum(childvd."AnderKaAkharSale"), 0) AS "AnderKaAkharSale"
        , COALESCE(selfvd."TotalCommission", 0) + COALESCE(sum(childvd."TotalCommission"), 0) AS "TotalCommission"
        , COALESCE(selfvd."TotalProfit", 0) + COALESCE(sum(childvd."TotalProfit"), 0) AS "TotalProfit"
        , COALESCE(selfvd."DaraOpenProfit", 0) + COALESCE(sum(childvd."DaraOpenProfit"), 0) AS "DaraOpenProfit"
        , COALESCE(selfvd."BaharKaAkharOpenProfit", 0) + COALESCE(sum(childvd."BaharKaAkharOpenProfit"), 0) AS "BaharKaAkharOpenProfit"
        , COALESCE(selfvd."AnderKaAkharOpenProfit", 0) + COALESCE(sum(childvd."AnderKaAkharOpenProfit"), 0) AS "AnderKaAkharOpenProfit"
        , COALESCE(selfvd."DaraOpen", 0) + COALESCE(sum(childvd."DaraOpen"), 0) AS "DaraOpen"
        , COALESCE(selfvd."BaharKaAkharOpen", 0) + COALESCE(sum(childvd."BaharKaAkharOpen"), 0) AS "BaharKaAkharOpen"
        , COALESCE(selfvd."AnderKaAkharOpen", 0) + COALESCE(sum(childvd."AnderKaAkharOpen"), 0) AS "AnderKaAkharOpen"
        , COALESCE(selfvd."TPC", 0) + COALESCE(sum(childvd."TPC"), 0) AS "TPC"
        , COALESCE(selfvd."Tax", 0) + COALESCE(sum(childvd."Tax"), 0) AS "Tax"
        , COALESCE(selfvd."Hissa", 0) + COALESCE(sum(childvd."Hissa"), 0) AS "Hissa"
        , COALESCE(selfvd."Balance", 0) + COALESCE(sum(childvd."Balance"), 0) AS "Balance"
        , (CASE WHEN COALESCE(selfvd."IsVerify", 0) + COALESCE(sum(childvd."IsVerify"), 0) > 0 THEN 0 ELSE 1 END)::integer AS "IsVerify"
    FROM
    (
        SELECT ledger."LedgerId", ledger."LedgerName", ledger."AgentLedgerId", ledger."GroupId", child."LedgerId" AS "childLedgerId", COALESCE(agent."CommanMasterName", 'NA') AS "AgentName"
            , ledger."TransactionCappingAmount"
        FROM "ledger" ledger
        LEFT JOIN "ledger" AS child ON ledger."LedgerId" = child."ParentLedgerId"
        LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = ledger."AgentLedgerId" AND agent."CommanMasterType" = 1
        WHERE (ledger."OrganizationId" = varOrganizationId OR ledger."LedgerId" = 11)
          AND ledger."ParentLedgerId" = COALESCE(varLedgerId, 0)
          AND (CASE COALESCE(varLoginRoleId, 0) WHEN 1 THEN ledger."GroupId" IN (2,3,4,5) WHEN 2 THEN ledger."GroupId" IN (2,3,4,5) ELSE ledger."GroupId" IN (3,4,5) END)
          AND (COALESCE(varGroupAgentId, 0) = 0 OR ledger."AgentLedgerId" = varGroupAgentId)
          AND (agent."LedgerId" = varCashAgentId OR agent."ParentAgentLedgerId" = varCashAgentId OR COALESCE(varCashAgentId, 0) = 0)
          /*and (ifnull(varCashAgentId,0) = 0 or ledger.AgentLedgerId in (select CommanMasterId from comman_master where LedgerId = varCashAgentId))
          */
          AND ledger."RecordStatus" != 'D'
    ) AS l
    LEFT JOIN (
        SELECT vd."LedgerId", (CASE WHEN COALESCE(ledgergroup."GroupId", 0) = 5 THEN vd."Remark" ELSE '' END) AS "Remark"
            , (CASE WHEN COALESCE(ledgergroup."GroupId", 0) = 5 THEN vd."SelfHissa" ELSE 0 END) AS "SelfHissa"
        , (sum(CASE WHEN vd."VoucherType" = 22 OR vd."VoucherType" = 23 OR vd."VoucherType" = 24 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalSale"
        , (sum(CASE WHEN vd."VoucherType" = 22 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "DaraSale"
        , (sum(CASE WHEN vd."VoucherType" = 23 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "BaharKaAkharSale"
        , (sum(CASE WHEN vd."VoucherType" = 24 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "AnderKaAkharSale"
        , (sum(CASE WHEN vd."VoucherType" = 25 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalCommission"
        , (sum(CASE WHEN vd."VoucherType" = 26 OR vd."VoucherType" = 27 OR vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalProfit"
        , (sum(CASE WHEN vd."VoucherType" = 26 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "DaraOpenProfit"
        , (sum(CASE WHEN vd."VoucherType" = 27 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpenProfit"
        , (sum(CASE WHEN vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpenProfit"
        , (sum(CASE WHEN vd."VoucherType" = 26 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "DaraOpen"
        , (sum(CASE WHEN vd."VoucherType" = 27 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpen"
        , (sum(CASE WHEN vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpen"
        , (sum(CASE WHEN vd."VoucherType" = 32 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TPC"
        , (sum(CASE WHEN vd."VoucherType" = 35 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "Tax"
        , (sum(CASE WHEN vd."VoucherType" = 29 OR vd."VoucherType" = 30 OR vd."VoucherType" = 31 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "Hissa"
        , (sum(CASE WHEN vd."VoucherType" IN (22,23,24,25,26,27,28,29,30,31,32,35) THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "Balance"
        , sum(CASE WHEN COALESCE(vd."VerifyBy", '') = '' THEN 1 ELSE 0 END) AS "IsVerify"
        FROM "voucher_detail" vd
        JOIN "voucher" v ON vd."VoucherId" = v."VoucherId"
        JOIN (SELECT lgg."GroupId", lgg."LedgerId" FROM "ledger" lgg) AS ledgergroup ON vd."LedgerId" = ledgergroup."LedgerId"
        WHERE (v."VoucherDate" = VoucherDates)
          AND (v."ShiftId" = ShiftIds OR COALESCE(ShiftIds, 0) = 0)
          AND (vd."RecordStatus" != 'D')
          AND (v."RecordStatus" != 'D')
          AND vd."OrganizationId" = varOrganizationId
        GROUP BY vd."LedgerId", (CASE WHEN COALESCE(ledgergroup."GroupId", 0) = 5 THEN vd."Remark" ELSE '' END)
            , (CASE WHEN COALESCE(ledgergroup."GroupId", 0) = 5 THEN vd."SelfHissa" ELSE 0 END)
    ) AS selfvd ON selfvd."LedgerId" = l."LedgerId"
    LEFT JOIN (
        SELECT vd."LedgerId"
        , (sum(CASE WHEN vd."VoucherType" = 22 OR vd."VoucherType" = 23 OR vd."VoucherType" = 24 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalSale"
        , (sum(CASE WHEN vd."VoucherType" = 22 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "DaraSale"
        , (sum(CASE WHEN vd."VoucherType" = 23 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "BaharKaAkharSale"
        , (sum(CASE WHEN vd."VoucherType" = 24 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "AnderKaAkharSale"
        , (sum(CASE WHEN vd."VoucherType" = 25 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalCommission"
        , (sum(CASE WHEN vd."VoucherType" = 26 OR vd."VoucherType" = 27 OR vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalProfit"
        , (sum(CASE WHEN vd."VoucherType" = 26 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "DaraOpenProfit"
        , (sum(CASE WHEN vd."VoucherType" = 27 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpenProfit"
        , (sum(CASE WHEN vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpenProfit"
        , (sum(CASE WHEN vd."VoucherType" = 26 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "DaraOpen"
        , (sum(CASE WHEN vd."VoucherType" = 27 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpen"
        , (sum(CASE WHEN vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpen"
        , (sum(CASE WHEN vd."VoucherType" = 32 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TPC"
        , (sum(CASE WHEN vd."VoucherType" = 35 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "Tax"
        , (sum(CASE WHEN vd."VoucherType" = 29 OR vd."VoucherType" = 30 OR vd."VoucherType" = 31 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "Hissa"
        , (sum(CASE WHEN vd."VoucherType" IN (22,23,24,25,26,27,28,29,30,31,32,35) THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "Balance"
        , sum(CASE WHEN COALESCE(vd."VerifyBy", '') = '' THEN 1 ELSE 0 END) AS "IsVerify"
        FROM "voucher_detail" vd
        JOIN "voucher" v ON vd."VoucherId" = v."VoucherId"
        WHERE (v."VoucherDate" = VoucherDates)
          AND (v."ShiftId" = ShiftIds OR COALESCE(ShiftIds, 0) = 0)
          AND (vd."RecordStatus" != 'D')
          AND (v."RecordStatus" != 'D')
          AND vd."OrganizationId" = varOrganizationId
        GROUP BY vd."LedgerId"
    ) AS childvd ON childvd."LedgerId" = l."childLedgerId"
    GROUP BY
        l."LedgerId",
        l."LedgerName",
        COALESCE(selfvd."Remark", ''),
        COALESCE(selfvd."SelfHissa", 0),
        l."AgentName",
        l."TransactionCappingAmount"
      , selfvd."TotalSale"
      , selfvd."DaraSale"
      , selfvd."BaharKaAkharSale"
      , selfvd."AnderKaAkharSale"
      , selfvd."TotalCommission"
      , selfvd."TotalProfit"
      , selfvd."DaraOpenProfit"
      , selfvd."BaharKaAkharOpenProfit"
      , selfvd."AnderKaAkharOpenProfit"
      , selfvd."DaraOpen"
      , selfvd."BaharKaAkharOpen"
      , selfvd."AnderKaAkharOpen"
      , selfvd."TPC"
      , selfvd."Tax"
      , selfvd."Hissa"
      , selfvd."Balance"
      , l."GroupId"
      , selfvd."IsVerify"
    HAVING
       COALESCE(selfvd."TotalSale", 0) + COALESCE(sum(childvd."TotalSale"), 0) <> 0
       OR COALESCE(selfvd."DaraSale", 0) + COALESCE(sum(childvd."DaraSale"), 0) <> 0
       OR COALESCE(selfvd."BaharKaAkharSale", 0) + COALESCE(sum(childvd."BaharKaAkharSale"), 0) <> 0
       OR COALESCE(selfvd."AnderKaAkharSale", 0) + COALESCE(sum(childvd."AnderKaAkharSale"), 0) <> 0
       OR COALESCE(selfvd."TotalCommission", 0) + COALESCE(sum(childvd."TotalCommission"), 0) <> 0
       OR COALESCE(selfvd."TotalProfit", 0) + COALESCE(sum(childvd."TotalProfit"), 0) <> 0
       OR COALESCE(selfvd."DaraOpenProfit", 0) + COALESCE(sum(childvd."DaraOpenProfit"), 0) <> 0
       OR COALESCE(selfvd."BaharKaAkharOpenProfit", 0) + COALESCE(sum(childvd."BaharKaAkharOpenProfit"), 0) <> 0
       OR COALESCE(selfvd."AnderKaAkharOpenProfit", 0) + COALESCE(sum(childvd."AnderKaAkharOpenProfit"), 0) <> 0
       OR COALESCE(selfvd."DaraOpen", 0) + COALESCE(sum(childvd."DaraOpen"), 0) <> 0
       OR COALESCE(selfvd."BaharKaAkharOpen", 0) + COALESCE(sum(childvd."BaharKaAkharOpen"), 0) <> 0
       OR COALESCE(selfvd."AnderKaAkharOpen", 0) + COALESCE(sum(childvd."AnderKaAkharOpen"), 0) <> 0
       OR COALESCE(selfvd."TPC", 0) + COALESCE(sum(childvd."TPC"), 0) <> 0
       OR COALESCE(selfvd."Tax", 0) + COALESCE(sum(childvd."Tax"), 0) <> 0
       OR COALESCE(selfvd."Hissa", 0) + COALESCE(sum(childvd."Hissa"), 0) <> 0
       OR COALESCE(selfvd."Balance", 0) + COALESCE(sum(childvd."Balance"), 0) <> 0
    ORDER BY 4;  -- "LedgerName" (MySQL: Order By LedgerName over the whole UNION)
END;
$$;
