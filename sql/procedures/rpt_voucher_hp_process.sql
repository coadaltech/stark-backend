-- Converted from MySQL procedure `rpt_voucher_hp_process`.
-- Non-grouped columns MySQL allowed (login.Mobile, agent name, vdWorking.WorkingDays,
-- hpHissaTo.LedgerName under a differently-defaulted GROUP BY expr) -> any_value().
-- FromDate in the vd subquery is the procedure parameter (MySQL locals win over columns).
DROP ROUTINE IF EXISTS "rpt_voucher_hp_process";
CREATE OR REPLACE FUNCTION "rpt_voucher_hp_process"(
    varOrganizationId bigint,
    FromDate date,
    ToDate date,
    LedgerIds bigint,
    varGroupAgentId bigint
)
RETURNS TABLE(
    "LedgerId" bigint,
    "FromDate" date,
    "LedgerName" text,
    "Hissa" double precision,
    "Mobile" text,
    "AgentName" text,
    "HPLedgerId" bigint,
    "HPToName" text,
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
    "Payment" double precision,
    "ProfitAndLoss" double precision,
    "ProfitAndLossAfterVapsi" double precision,
    "HPAmountAfterVapsi" double precision,
    "HPAmount" double precision,
    "HPAmountOnPayment" double precision,
    "WorkingDays" bigint
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT DISTINCT l."LedgerId", FromDate AS "FromDate", l."LedgerName"::text, hissa."Hissa"
         , any_value(login."Mobile")::text AS "Mobile"
         , COALESCE(any_value(agent."CommanMasterName"), 'NA')::text AS "AgentName"
         , COALESCE(l."HPLedgerId", 0) AS "HPLedgerId"
         , COALESCE(any_value(hpHissaTo."LedgerName"), 'Not Avilable')::text AS "HPToName"
         , COALESCE(sum(vd."TotalSale"), 0) AS "TotalSale"
         , COALESCE(sum(vd."DaraSale"), 0) AS "DaraSale"
         , COALESCE(sum(vd."BaharKaAkharSale"), 0) AS "BaharKaAkharSale"
         , COALESCE(sum(vd."AnderKaAkharSale"), 0) AS "AnderKaAkharSale"
         , COALESCE(sum(vd."TotalCommission"), 0) AS "TotalCommission"
         , COALESCE(sum(vd."DaraProfit"), 0) AS "DaraProfit"
         , COALESCE(sum(vd."AkharProfit"), 0) AS "AkharProfit"
         , COALESCE(sum(vd."TotalProfit"), 0) AS "TotalProfit"
         , COALESCE(sum(vd."DaraOpen"), 0) AS "DaraOpen"
         , COALESCE(sum(vd."BaharKaAkharOpen"), 0) AS "BaharKaAkharOpen"
         , COALESCE(sum(vd."AnderKaAkharOpen"), 0) AS "AnderKaAkharOpen"
         , COALESCE(sum(vd."Payment"), 0) AS "Payment"
         , COALESCE(sum(vd."ProfitAndLoss"), 0) AS "ProfitAndLoss"
         , (COALESCE(sum(vd."ProfitAndLoss"), 0) * (100 - COALESCE(l."vapsi", 0))) / 100 AS "ProfitAndLossAfterVapsi"
         , (CASE WHEN COALESCE(sum(vd."ProfitAndLoss"), 0) > 0 THEN
                (COALESCE(sum(vd."ProfitAndLoss"), 0) * (100 - COALESCE(l."vapsi", 0)) * COALESCE(hissa."Hissa", 0)) / 10000
            ELSE
                (COALESCE(sum(vd."ProfitAndLoss"), 0) * COALESCE(hissa."Hissa", 0)) / 100
            END) AS "HPAmountAfterVapsi"
         , (COALESCE(sum(vd."ProfitAndLoss"), 0) * COALESCE(hissa."Hissa", 0)) / 100 AS "HPAmount"
         , (COALESCE(sum(vd."Payment"), 0) * COALESCE(hissa."Hissa", 0)) / 100 AS "HPAmountOnPayment"
         , COALESCE(any_value(vdWorking."WorkingDays"), 0) AS "WorkingDays"
    FROM (SELECT ledger."LedgerId", ledger."LedgerName", ledger."AddedDate", ledger."HPLedgerId", ledger."AgentLedgerId",
                 COALESCE(ledger."Vapsi", 0) AS "vapsi"
          FROM "ledger" ledger
          WHERE ledger."GroupId" = 5 AND ledger."RecordStatus" != 'D'
            AND ledger."OrganizationId" = varOrganizationId
            AND (COALESCE(LedgerIds, 0) = 0 OR ledger."LedgerId" = LedgerIds)
            AND (COALESCE(varGroupAgentId, 0) = 0 OR ledger."AgentLedgerId" = varGroupAgentId)
         ) AS l
    JOIN "hissa" hissa ON hissa."LedgerId" = l."LedgerId" AND hissa."HissaLedgerId" = 11 AND hissa."RecordStatus" != 'D'
                      AND COALESCE(hissa."Hissa", 0) != 0
    LEFT JOIN "ledger" AS hpHissaTo ON hpHissaTo."LedgerId" = l."HPLedgerId"
    LEFT JOIN (SELECT
            (sum(CASE WHEN vd."VoucherType" = 22 OR vd."VoucherType" = 23 OR vd."VoucherType" = 24 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "TotalSale",
            (sum(CASE WHEN vd."VoucherType" = 22 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "DaraSale",
            (sum(CASE WHEN vd."VoucherType" = 23 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "BaharKaAkharSale",
            (sum(CASE WHEN vd."VoucherType" = 24 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "AnderKaAkharSale",
            (sum(CASE WHEN vd."VoucherType" = 25 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "TotalCommission",
            (sum(CASE WHEN vd."VoucherType" = 26 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "DaraProfit",
            (sum(CASE WHEN vd."VoucherType" = 27 OR vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "AkharProfit",
            (sum(CASE WHEN vd."VoucherType" = 26 OR vd."VoucherType" = 27 OR vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "TotalProfit",
            (sum(CASE WHEN vd."VoucherType" = 26 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END))::numeric(16,2) AS "DaraOpen",
            (sum(CASE WHEN vd."VoucherType" = 27 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpen",
            (sum(CASE WHEN vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpen",
            sum(CASE WHEN vd."VoucherType" = 1 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END) AS "Payment",
            vd."LedgerId", FromDate AS "FromDate",
            sum(CASE WHEN vd."ShiftId" != 0 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END) AS "ProfitAndLoss"
        FROM "voucher_detail" AS vd
        /* left join (select hp_hissa.LedgerId,max(DATE_ADD(hp_hissa.HPToDate, INTERVAL 1 DAY)) as FromDate from hp_hissa
           where hp_hissa.RecordStatus != 'D' group by LedgerId) as hp_hissa on hp_hissa.LedgerId = vd.LedgerId */
        WHERE vd."VoucherDate" BETWEEN FromDate AND ToDate
          /* and FromDate not in (select HPFromDate from hp_hissa where hp_hissa.RecordStatus != 'D' and hp_hissa.LedgerId = vd.LedgerId) */
          AND vd."LedgerId" NOT IN (SELECT hh."LedgerId" FROM "hp_hissa" hh WHERE hh."RecordStatus" != 'D' AND hh."HPFromDate" = FromDate)
          AND (vd."RecordStatus" != 'D')
        GROUP BY vd."LedgerId"
    ) AS vd ON vd."LedgerId" = l."LedgerId"
    LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
    LEFT JOIN "ledger_limit" ledger_limit ON ledger_limit."LedgerId" = l."LedgerId"
    LEFT JOIN "login" login ON login."LedgerId" = l."LedgerId"
    LEFT JOIN (
        SELECT w."LedgerId", count(w."WorkingDays") AS "WorkingDays"
        FROM (
            SELECT vd2."LedgerId", count(1) AS "WorkingDays"
            FROM "voucher_detail" AS vd2
            WHERE vd2."VoucherDate" BETWEEN FromDate AND ToDate
              AND (vd2."RecordStatus" != 'D')
              AND vd2."VoucherType" IN (22, 23, 24)
            GROUP BY vd2."LedgerId", vd2."VoucherDate"
        ) AS w
        GROUP BY w."LedgerId"
    ) AS vdWorking ON vdWorking."LedgerId" = l."LedgerId"
    GROUP BY l."LedgerId", l."LedgerName", hissa."Hissa", l."vapsi",
             vd."FromDate", l."AddedDate",
             COALESCE(l."HPLedgerId", 0),
             COALESCE(hpHissaTo."LedgerName", '')
    HAVING COALESCE(sum(vd."ProfitAndLoss"), 0) != 0
    ORDER BY 3 /* LedgerName */;
END;
$$;
