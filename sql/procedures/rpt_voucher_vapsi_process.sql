-- Converted from MySQL procedure `rpt_voucher_vapsi_process`.
-- NOTE: vdWorking.WorkingDays was selected without being grouped (MySQL permissive GROUP BY); vdWorking has one
-- row per LedgerId and l.LedgerId is grouped, so any_value() returns the same value.
DROP ROUTINE IF EXISTS "rpt_voucher_vapsi_process";
CREATE OR REPLACE FUNCTION "rpt_voucher_vapsi_process"(
    varOrganizationId bigint,
    FromDate date,
    ToDate date,
    LedgerIds bigint,
    varGroupAgentId bigint,
    varIsHPAdded integer
)
RETURNS TABLE(
    "LedgerId" bigint,
    "FromDate" date,
    "LedgerName" text,
    "vapsi" double precision,
    "Mobile" text,
    "AgentName" text,
    "TelegramId" bigint,
    "LedgerTelegramId" bigint,
    "AccessHash" text,
    "TotalSale" numeric,
    "DaraSale" numeric,
    "BaharKaAkharSale" numeric,
    "AnderKaAkharSale" numeric,
    "TotalCommission" numeric,
    "DaraProfit" numeric,
    "AkharProfit" numeric,
    "TotalProfit" numeric,
    "DaraOpen" numeric,
    "BaharKaAkharOpen" numeric,
    "AnderKaAkharOpen" numeric,
    "HPAmount" numeric,
    "OtherHissa" double precision,
    "OtherHissaAmount" double precision,
    "Payment" double precision,
    "ProfitAndLoss" double precision,
    "FinalProfitAndLoss" double precision,
    "vapsiAmount" double precision,
    "vapsiAmountOnProfit" double precision,
    "vapsiAmountOnPayment" double precision,
    "WorkingDays" bigint,
    "IsTPV" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varVapsiWorkingDays integer := 0;
BEGIN
    SELECT o."VapsiWorkingDays" INTO varVapsiWorkingDays FROM "organization" o
    WHERE o."OrganizationId" = varOrganizationId;

    RETURN QUERY
    SELECT DISTINCT l."LedgerId", FromDate AS "FromDate", l."LedgerName"::text, l."Vapsi" AS "vapsi"
        , login."Mobile"::text, COALESCE(agent."CommanMasterName", 'NA')::text AS "AgentName"
        , COALESCE(ledger_telegram."TelegramId", 0) AS "TelegramId"
        , COALESCE(ledger_telegram."LedgerTelegramId", 0) AS "LedgerTelegramId"
        , COALESCE(ledger_telegram."AccessHash", '')::text AS "AccessHash"
        , COALESCE(sum(vd."TotalSale"), 0) AS "TotalSale",
        COALESCE(sum(vd."DaraSale"), 0) AS "DaraSale",
        COALESCE(sum(vd."BaharKaAkharSale"), 0) AS "BaharKaAkharSale",
        COALESCE(sum(vd."AnderKaAkharSale"), 0) AS "AnderKaAkharSale",
        COALESCE(sum(vd."TotalCommission"), 0) AS "TotalCommission",
        COALESCE(sum(vd."DaraProfit"), 0) AS "DaraProfit",
        COALESCE(sum(vd."AkharProfit"), 0) AS "AkharProfit",
        COALESCE(sum(vd."TotalProfit"), 0) AS "TotalProfit",
        COALESCE(sum(vd."DaraOpen"), 0) AS "DaraOpen",
        COALESCE(sum(vd."BaharKaAkharOpen"), 0) AS "BaharKaAkharOpen",
        COALESCE(sum(vd."AnderKaAkharOpen"), 0) AS "AnderKaAkharOpen",
        COALESCE(sum(vd."HPAmount"), 0) AS "HPAmount",
        COALESCE(hissa."Hissa", 0) AS "OtherHissa",
        (COALESCE((CASE WHEN sum(vd."ProfitAndLoss") > 0 THEN sum(vd."ProfitAndLoss") ELSE 0 END), 0) * COALESCE(hissa."Hissa", 0)) / 100 AS "OtherHissaAmount",
        -COALESCE((CASE WHEN sum(vd."Payment") < 0 THEN sum(vd."Payment") ELSE 0 END), 0) AS "Payment",
        COALESCE((CASE WHEN sum(vd."ProfitAndLoss") > 0 THEN sum(vd."ProfitAndLoss") ELSE 0 END), 0) AS "ProfitAndLoss",
        (COALESCE((CASE WHEN sum(vd."ProfitAndLoss") > 0 THEN sum(vd."ProfitAndLoss") ELSE 0 END), 0) * (100 - COALESCE(hissa."Hissa", 0))) / 100
            AS "FinalProfitAndLoss",
        ((COALESCE((CASE WHEN sum(vd."ProfitAndLoss") > 0 THEN sum(vd."ProfitAndLoss") ELSE 0 END), 0) * (100 - COALESCE(hissa."Hissa", 0))) / 100
            * COALESCE(l."Vapsi", 0)) / 100 AS "vapsiAmount"
        ,
        ((COALESCE((CASE WHEN sum(vd."ProfitAndLoss") > 0 THEN sum(vd."ProfitAndLoss") ELSE 0 END), 0))
            * COALESCE(l."Vapsi", 0)) / 100 AS "vapsiAmountOnProfit"
        , -(COALESCE((CASE WHEN sum(vd."Payment") < 0 THEN sum(vd."Payment") ELSE 0 END), 0) * COALESCE(l."Vapsi", 0)) / 100 AS "vapsiAmountOnPayment"
        , COALESCE(any_value(vdWorking."WorkingDays"), 0) AS "WorkingDays"
        , (CASE WHEN COALESCE((SELECT sum(tpv."Vapsi") FROM "third_party_vapsi" tpv WHERE tpv."LedgerId" = l."LedgerId" AND tpv."RecordStatus" != 'D'), 0) > 0 THEN 'Yes' ELSE 'No' END)::text AS "IsTPV"
    FROM (SELECT ledger."LedgerId", ledger."LedgerName", ledger."AddedDate", ledger."Vapsi", ledger."AgentLedgerId"
          FROM "ledger"
          WHERE ledger."GroupId" IN (3, 4, 5)
            AND COALESCE(ledger."Vapsi", 0) != 0 AND ledger."RecordStatus" != 'D'
            AND COALESCE(ledger."ParentLedgerId", 0) = 0
            AND ledger."OrganizationId" = varOrganizationId
            AND (COALESCE(LedgerIds, 0) = 0 OR ledger."LedgerId" = LedgerIds)
            AND (COALESCE(varGroupAgentId, 0) = 0 OR ledger."AgentLedgerId" = varGroupAgentId)
            AND (COALESCE(varIsHPAdded, 0) = 0 OR COALESCE(ledger."HPLedgerId", 0) = 0)
            /* (MySQL source had a commented-out varVapsiWorkingDays filter on transaction_declare here) */
         ) AS l
    LEFT JOIN (SELECT
            (sum(CASE WHEN vd."VoucherType" = 22 OR vd."VoucherType" = 23 OR vd."VoucherType" = 24 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalSale",
            (sum(CASE WHEN vd."VoucherType" = 22 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "DaraSale",
            (sum(CASE WHEN vd."VoucherType" = 23 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "BaharKaAkharSale",
            (sum(CASE WHEN vd."VoucherType" = 24 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "AnderKaAkharSale",
            (sum(CASE WHEN vd."VoucherType" = 25 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalCommission",
            (sum(CASE WHEN vd."VoucherType" = 26 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "DaraProfit",
            (sum(CASE WHEN vd."VoucherType" = 27 OR vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "AkharProfit",
            (sum(CASE WHEN vd."VoucherType" = 26 OR vd."VoucherType" = 27 OR vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END))::numeric(16,2) AS "TotalProfit",
            (sum(CASE WHEN vd."VoucherType" = 26 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "DaraOpen",
            (sum(CASE WHEN vd."VoucherType" = 27 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpen",
            (sum(CASE WHEN vd."VoucherType" = 28 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpen",
            (sum(CASE WHEN vd."VoucherType" = 5 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END) ELSE 0 END))::numeric(16,2) AS "HPAmount",

            sum(CASE WHEN vd."VoucherType" = 1 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END) AS "Payment",
            (CASE WHEN ledger."ParentLedgerId" = 0 THEN vd."LedgerId" WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
                  ELSE ledgerBaap."ParentLedgerId" END) AS "LedgerId", FromDate AS "FromDate",
            sum(CASE WHEN vd."ShiftId" != 0 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END) AS "ProfitAndLoss"
        FROM "voucher_detail" AS vd
        INNER JOIN "shift" ON vd."ShiftId" = shift."ShiftId" AND COALESCE(shift."IsCreateVapsi", 1) = 1
        LEFT JOIN (SELECT lx."LedgerId", lx."ParentLedgerId" FROM "ledger" lx
                   WHERE (lx."RecordStatus" != 'D')
                     AND lx."OrganizationId" = varOrganizationId
                     AND lx."GroupId" IN (3, 4, 5)
                  ) AS ledger ON vd."LedgerId" = ledger."LedgerId"
        LEFT JOIN (SELECT lx."LedgerId", lx."ParentLedgerId" FROM "ledger" lx
                   WHERE (lx."RecordStatus" != 'D')
                     AND lx."OrganizationId" = varOrganizationId
                     AND lx."GroupId" IN (3, 4, 5)
                  ) AS ledgerBaap ON ledger."ParentLedgerId" = ledgerBaap."LedgerId"
        /* (MySQL source had a commented-out join on vapsi max(VapsiToDate) here) */
        WHERE vd."VoucherDate" BETWEEN FromDate AND ToDate
          AND (vd."RecordStatus" != 'D')
          AND FromDate NOT IN (SELECT v."VapsiFromDate" FROM "vapsi" v WHERE v."RecordStatus" != 'D' AND v."LedgerId" = (CASE WHEN ledger."ParentLedgerId" = 0 THEN vd."LedgerId"
                                                               WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
                                                               ELSE ledgerBaap."ParentLedgerId" END))
        GROUP BY (CASE WHEN ledger."ParentLedgerId" = 0 THEN vd."LedgerId" WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
                       ELSE ledgerBaap."ParentLedgerId" END)
        ) AS vd ON vd."LedgerId" = l."LedgerId"
    LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
    LEFT JOIN "ledger_limit" ON ledger_limit."LedgerId" = l."LedgerId"
    LEFT JOIN "login" ON login."LedgerId" = l."LedgerId"
    LEFT JOIN "ledger_telegram" ON l."LedgerId" = ledger_telegram."LedgerId" AND ledger_telegram."RecordStatus" <> 'D'
    LEFT JOIN (SELECT sum(h."Hissa") AS "Hissa", h."LedgerId" FROM "hissa" h WHERE h."LedgerId" != h."HissaLedgerId" AND h."RecordStatus" != 'D' GROUP BY h."LedgerId")
        AS hissa ON hissa."LedgerId" = l."LedgerId"
    LEFT JOIN (
        SELECT w."LedgerId", count(w."WorkingDays") AS "WorkingDays"
        FROM
        (
            SELECT
                vd."LedgerId", count(1) AS "WorkingDays"
            FROM "voucher_detail" AS vd
            WHERE vd."VoucherDate" BETWEEN FromDate AND ToDate
              AND (vd."RecordStatus" != 'D')
              AND vd."VoucherType" IN (22, 23, 24)
            GROUP BY vd."LedgerId", vd."VoucherDate"
        ) AS w
        GROUP BY w."LedgerId"
        ) AS vdWorking ON vdWorking."LedgerId" = l."LedgerId"
    WHERE (COALESCE(varVapsiWorkingDays, 0) = 0 OR vdWorking."WorkingDays" >= COALESCE(varVapsiWorkingDays, 0))
    GROUP BY l."LedgerId", l."LedgerName", l."Vapsi"
        , FromDate
        , login."Mobile", agent."CommanMasterName"
        , ledger_telegram."TelegramId"
        , ledger_telegram."LedgerTelegramId"
        , ledger_telegram."AccessHash"
        , vd."FromDate", l."AddedDate", COALESCE(hissa."Hissa", 0)
    HAVING (COALESCE(sum(vd."ProfitAndLoss"), 0) > 0 OR COALESCE(sum(vd."Payment"), 0) < 0)
    ORDER BY l."LedgerName"::text;
END;
$$;
