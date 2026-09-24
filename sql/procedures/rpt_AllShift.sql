-- Converted from MySQL procedure `rpt_AllShift`.
-- varIsLedgerAsign is fixed at 0 (the code that set it is commented out in the original),
-- so the ledger_asign filter in l is a no-op; kept for fidelity.
DROP ROUTINE IF EXISTS "rpt_AllShift";
CREATE OR REPLACE FUNCTION "rpt_AllShift"(
    FromDate date,
    ToDate date,
    varOrganizationId bigint,
    varGroupAgentId bigint,
    varLedgerId bigint,
    varLoginRoleId bigint,
    varDealingType varchar,
    varCashAgentId bigint,
    varLoginId bigint
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "DealingType" text,
    "GroupId" integer,
    "Mobile" text,
    "UserName" text,
    "AgentName" text,
    "TelegramId" bigint,
    "LedgerTelegramId" bigint,
    "AccessHash" text,
    "ParentAgentName" text,
    "HPLedgerName" text,
    "ParentParentAgentName" text,
    "IsFeedback" integer,
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
    "Hissa" numeric,
    "HPAmount" numeric,
    "OpeningBalance" double precision,
    "Kist" double precision,
    "Payment" double precision,
    "LimitValue" double precision,
    "VapsiAmount" double precision,
    "ClosingBalance" double precision,
    "MondayFinal" integer,
    "TodayProfit" numeric,
    "LedgerAsign" integer,
    "TransactionCount" bigint
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varIsLedgerAsign integer;
BEGIN
    varIsLedgerAsign := 0;
    /*
    if ifnull(varLoginId,0) = 0 then
        set varIsLedgerAsign = 0;
    else
        if not ifnull((select LoginType from login where LoginId = varLoginId),0) in (0,1,2,3,4,5,6) then
            set varIsLedgerAsign = 1;
        end if;
    end if;
    */
    RETURN QUERY
    SELECT l."LedgerId", l."LedgerName"::text, COALESCE(l."DealingType", '')::text AS "DealingType", l."GroupId",
           COALESCE(login."Mobile", '')::text AS "Mobile",
           COALESCE(login."UserName", '')::text AS "UserName", l."AgentName"::text AS "AgentName",
           COALESCE(ledger_telegram."TelegramId", 0) AS "TelegramId",
           COALESCE(ledger_telegram."LedgerTelegramId", 0) AS "LedgerTelegramId",
           COALESCE(ledger_telegram."AccessHash", '')::text AS "AccessHash",
           COALESCE(l."ParentAgentName", '')::text AS "ParentAgentName",
           COALESCE(l."HPLedgerName", '')::text AS "HPLedgerName",
           COALESCE(l."ParentParentAgentName", '')::text AS "ParentParentAgentName",
           (CASE WHEN COALESCE(ledger_feedback."FeedbackId", 0) = 0 THEN 0 ELSE 1 END) AS "IsFeedback",
           COALESCE(vd."TotalSale", 0) AS "TotalSale",
           COALESCE(vd."DaraSale", 0) AS "DaraSale",
           COALESCE(vd."BaharKaAkharSale", 0) AS "BaharKaAkharSale",
           COALESCE(vd."AnderKaAkharSale", 0) AS "AnderKaAkharSale",
           COALESCE(vd."TotalCommission", 0) AS "TotalCommission",
           COALESCE(vd."TotalSale", 0)
           + COALESCE(vd."TotalCommission", 0)
           + COALESCE(vd."TotalProfit", 0)
           + COALESCE(vd."Hissa", 0)
           + COALESCE(vd."TPC", 0) AS "TotalProfit",
           COALESCE(vd."DaraOpenProfit", 0) AS "DaraOpenProfit",
           COALESCE(vd."BaharKaAkharOpenProfit", 0) AS "BaharKaAkharOpenProfit",
           COALESCE(vd."AnderKaAkharOpenProfit", 0) AS "AnderKaAkharOpenProfit",
           COALESCE(vd."DaraOpen", 0) AS "DaraOpen",
           COALESCE(vd."BaharKaAkharOpen", 0) AS "BaharKaAkharOpen",
           COALESCE(vd."AnderKaAkharOpen", 0) AS "AnderKaAkharOpen",
           COALESCE(vd."TPC", 0) AS "TPC",
           COALESCE(vd."Hissa", 0) AS "Hissa",
           COALESCE(vd."HPAmount", 0) AS "HPAmount",
           COALESCE(vd.opening, 0) AS "OpeningBalance",
           COALESCE(vd."Kist", 0) AS "Kist",
           COALESCE(vd."Payment", 0) AS "Payment",
           ledger_limit."FinalLimit" AS "LimitValue",
           COALESCE(vd."VapsiAmount", 0) AS "VapsiAmount",
           COALESCE(vd.opening, 0) + COALESCE(vd."ClosingBalance", 0) AS "ClosingBalance",
           COALESCE(vd."MondayFinalFlag", 2) AS "MondayFinal",
           COALESCE(vd."TotalSale", 0)
           + COALESCE(vd."TotalCommission", 0)
           + COALESCE(vd."TotalProfit", 0)
           + COALESCE(vd."Hissa", 0)
           + COALESCE(vd."TPC", 0) AS "TodayProfit",
           (CASE WHEN COALESCE(ledger_asign."LedgerId", 0) = 0 THEN 0 ELSE 1 END) AS "LedgerAsign",
           COALESCE(WorkingDays."TransactionCount", 0) AS "TransactionCount"
    FROM
    (
        SELECT ledger."LedgerId", ledger."LedgerName", ledger."GroupId", ledger."AgentLedgerId",
               COALESCE(ledger."DealingType", '') AS "DealingType",
               COALESCE(agent."CommanMasterName", 'NA') AS "AgentName",
               AgentParent."LedgerName" AS "ParentAgentName",
               AgentParentParent."LedgerName" AS "ParentParentAgentName",
               HPLedger."LedgerName" AS "HPLedgerName"
        FROM "ledger" ledger
        LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = ledger."AgentLedgerId" AND agent."CommanMasterType" = 1
        LEFT JOIN "ledger" AgentParentParent ON agent."ParentAgentLedgerId" = AgentParentParent."LedgerId"
        LEFT JOIN "ledger" AgentParent ON agent."LedgerId" = AgentParent."LedgerId"
        LEFT JOIN "ledger" HPLedger ON ledger."HPLedgerId" = HPLedger."LedgerId"
        WHERE ledger."OrganizationId" = varOrganizationId
          AND (ledger."ParentLedgerId" = COALESCE(varLedgerId, 0) OR ledger."LedgerId" = COALESCE(varLedgerId, 0))
          AND (CASE COALESCE(varLoginRoleId, 0) WHEN 1 THEN ledger."GroupId" IN (2,3,4,5) WHEN 2 THEN ledger."GroupId" IN (2,3,4,5) ELSE ledger."GroupId" IN (3,4,5) END)
          AND (COALESCE(varGroupAgentId, 0) = 0 OR ledger."AgentLedgerId" = varGroupAgentId)
          /*and (ifnull(varCashAgentId,0) = 0 or ledger.AgentLedgerId in (select CommanMasterId from comman_master where LedgerId = varCashAgentId)) */
          AND (agent."LedgerId" = varCashAgentId OR agent."ParentAgentLedgerId" = varCashAgentId OR COALESCE(varCashAgentId, 0) = 0)
          AND (varDealingType = '' OR COALESCE(ledger."DealingType", '') = varDealingType)
          AND ledger."RecordStatus" != 'D'
          AND ledger."IsHide" = '0'
          AND (COALESCE(varIsLedgerAsign, 0) = 0
               OR ledger."LedgerId" IN (SELECT la."LedgerId" FROM "ledger_asign" la WHERE la."RecordStatus" != 'D'
                                        AND (la."StaffLoginId" = varLoginId OR la."StaffLoginId" = 0) AND la."AsignDate" = FromDate AND FromDate = ToDate)
               OR NOT EXISTS (SELECT la."LedgerId" FROM "ledger_asign" la WHERE la."RecordStatus" != 'D'
                              AND (la."StaffLoginId" = varLoginId OR la."StaffLoginId" = 0) AND la."AsignDate" = FromDate AND FromDate = ToDate)
              )
    ) AS l
    LEFT JOIN
    ( SELECT (CASE WHEN ledger."LedgerId" = varLedgerId THEN ledger."LedgerId"
                   WHEN ledger."ParentLedgerId" = varLedgerId THEN ledger."LedgerId"
                   ELSE ledger."ParentLedgerId" END) AS "LedgerId"
           , sum(vd."TotalSale") AS "TotalSale"
           , sum(vd."DaraSale") AS "DaraSale"
           , sum(vd."BaharKaAkharSale") AS "BaharKaAkharSale"
           , sum(vd."AnderKaAkharSale") AS "AnderKaAkharSale"
           , sum(vd."TotalCommission") AS "TotalCommission"
           , sum(vd."TotalProfit") AS "TotalProfit"
           , sum(vd."DaraOpenProfit") AS "DaraOpenProfit"
           , sum(vd."BaharKaAkharOpenProfit") AS "BaharKaAkharOpenProfit"
           , sum(vd."AnderKaAkharOpenProfit") AS "AnderKaAkharOpenProfit"
           , sum(vd."DaraOpen") AS "DaraOpen"
           , sum(vd."BaharKaAkharOpen") AS "BaharKaAkharOpen"
           , sum(vd."AnderKaAkharOpen") AS "AnderKaAkharOpen"
           , sum(vd."TPC") AS "TPC"
           , sum(vd."Hissa") AS "Hissa"
           , sum(vd."HPAmount") AS "HPAmount"
           , sum(vd."Kist") AS "Kist"
           , sum(vd."Payment") AS "Payment"
           , sum(vd."VapsiAmount") AS "VapsiAmount"
           , sum(vd."ClosingBalance") AS "ClosingBalance"
           , max(vd."MondayFinalFlag") AS "MondayFinalFlag"
           , sum(OPBal.opening) AS opening
      FROM (SELECT lg."LedgerId", lg."ParentLedgerId" FROM "ledger" lg WHERE lg."OrganizationId" = varOrganizationId) AS ledger
      LEFT JOIN
          (SELECT
              (sum(CASE WHEN vd."VoucherType" = 22 OR vd."VoucherType" = 23 OR vd."VoucherType" = 24 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "TotalSale",
              (sum(CASE WHEN vd."VoucherType" = 22 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "DaraSale",
              (sum(CASE WHEN vd."VoucherType" = 23 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "BaharKaAkharSale",
              (sum(CASE WHEN vd."VoucherType" = 24 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "AnderKaAkharSale",
              (sum(CASE WHEN vd."VoucherType" = 25 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "TotalCommission",
              (sum(CASE WHEN vd."VoucherType" = 26 OR vd."VoucherType" = 27 OR vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "TotalProfit",
              (sum(CASE WHEN vd."VoucherType" = 26 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "DaraOpenProfit",
              (sum(CASE WHEN vd."VoucherType" = 27 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpenProfit",
              (sum(CASE WHEN vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpenProfit",
              (sum(CASE WHEN vd."VoucherType" = 26 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END))::numeric(16,2) AS "DaraOpen",
              (sum(CASE WHEN vd."VoucherType" = 27 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END))::numeric(16,2) AS "BaharKaAkharOpen",
              (sum(CASE WHEN vd."VoucherType" = 28 THEN CASE WHEN vd."AmountType" = 'Dr' THEN -vd."OpenAmount" ELSE vd."OpenAmount" END ELSE 0 END))::numeric(16,2) AS "AnderKaAkharOpen",
              (sum(CASE WHEN vd."VoucherType" = 32 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "TPC",
              (sum(CASE WHEN vd."VoucherType" = 29 OR vd."VoucherType" = 30 OR vd."VoucherType" = 31 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "Hissa",
              (sum(CASE WHEN vd."VoucherType" = 5 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END))::numeric(16,2) AS "HPAmount",
              sum(CASE WHEN vd."VoucherType" = 3 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END) AS "Kist",
              sum(CASE WHEN vd."VoucherType" = 1 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END) AS "Payment",
              sum(CASE WHEN vd."VoucherType" = 4 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END) AS "VapsiAmount",
              (COALESCE(sum(CASE WHEN vd."VoucherType" <> 2 THEN CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END ELSE 0 END), 0))::numeric(16,2) AS "ClosingBalance",
              vd."LedgerId",
              max(CASE WHEN vd."MondayFinalFlag" = 'True' THEN 0 ELSE 1 END) AS "MondayFinalFlag"
           FROM "voucher_detail" AS vd
           WHERE (vd."VoucherDate" BETWEEN FromDate AND ToDate)
             AND (vd."RecordStatus" != 'D')
             AND vd."OrganizationId" = varOrganizationId
           GROUP BY vd."LedgerId"
          ) AS vd ON ledger."LedgerId" = vd."LedgerId"
      LEFT JOIN
          (SELECT aa."LedgerId",
                  sum(CASE WHEN aa."AmountType" = 'Dr' THEN COALESCE(aa."Amount", 0) ELSE -COALESCE(aa."Amount", 0) END) AS opening
           FROM "voucher_detail" aa
           WHERE aa."VoucherDate" < FromDate
             AND aa."VoucherType" != 2
             AND aa."RecordStatus" != 'D'
             AND aa."OrganizationId" = varOrganizationId
           GROUP BY aa."LedgerId"
          ) AS OPBal ON OPBal."LedgerId" = ledger."LedgerId"
      GROUP BY (CASE WHEN ledger."LedgerId" = varLedgerId THEN ledger."LedgerId"
                     WHEN ledger."ParentLedgerId" = varLedgerId THEN ledger."LedgerId"
                     ELSE ledger."ParentLedgerId" END)
    ) AS vd ON vd."LedgerId" = l."LedgerId"
    LEFT JOIN (
        SELECT WorkingDays."LedgerId",
               sum(WorkingDays."TransactionCount") AS "TransactionCount"
        FROM (SELECT vd."LedgerId",
                     max(CASE WHEN vd."ShiftId" > 0 THEN 1 ELSE 0 END) AS "TransactionCount"
              FROM "voucher_detail" AS vd
              WHERE (vd."VoucherDate" BETWEEN FromDate AND ToDate)
                AND (vd."RecordStatus" != 'D')
                AND vd."OrganizationId" = varOrganizationId
              GROUP BY vd."LedgerId", vd."VoucherDate"
             ) AS WorkingDays
        GROUP BY WorkingDays."LedgerId"
    ) AS WorkingDays ON WorkingDays."LedgerId" = l."LedgerId"
    /* left join comman_master agent on agent.CommanMasterId = l.AgentLedgerId and CommanMasterType = 1 */
    LEFT JOIN "ledger_limit" ledger_limit ON ledger_limit."LedgerId" = l."LedgerId"
    LEFT JOIN "login" login ON login."LedgerId" = l."LedgerId"
    LEFT JOIN (
        SELECT max(lf."FeedbackId") AS "FeedbackId", lf."LedgerId"
        FROM "ledger_feedback" lf
        WHERE lf."FeedbackDate" = ToDate
        GROUP BY lf."LedgerId"
    ) AS ledger_feedback ON ledger_feedback."LedgerId" = l."LedgerId"
    LEFT JOIN "ledger_asign" ledger_asign ON ledger_asign."LedgerId" = l."LedgerId"
                                          AND ledger_asign."RecordStatus" != 'D'
                                          AND ledger_asign."StaffLoginId" = 0
                                          AND ledger_asign."AsignDate" = ToDate
    LEFT JOIN "ledger_telegram" ledger_telegram ON l."LedgerId" = ledger_telegram."LedgerId" AND ledger_telegram."RecordStatus" <> 'D'
    WHERE NOT (
            COALESCE(vd."TotalSale", 0) BETWEEN -1 AND 1
        AND COALESCE(vd."TotalCommission", 0) BETWEEN -1 AND 1
        AND COALESCE(vd."TotalProfit", 0) BETWEEN -1 AND 1
        AND COALESCE(vd."DaraOpen", 0) BETWEEN -1 AND 1
        AND COALESCE(vd."BaharKaAkharOpen", 0) BETWEEN -1 AND 1
        AND COALESCE(vd."AnderKaAkharOpen", 0) BETWEEN -1 AND 1
        AND COALESCE(vd."TPC", 0) BETWEEN -1 AND 1
        AND COALESCE(vd."Hissa", 0) BETWEEN -1 AND 1
        AND COALESCE(vd."HPAmount", 0) BETWEEN -1 AND 1
        AND COALESCE(vd.opening, 0) BETWEEN -1 AND 1
        AND COALESCE(vd."Kist", 0) BETWEEN -1 AND 1
        AND COALESCE(vd."Payment", 0) BETWEEN -1 AND 1
        AND COALESCE(vd."VapsiAmount", 0) BETWEEN -1 AND 1
        AND COALESCE(vd."ClosingBalance", 0) BETWEEN -1 AND 1
    )
    ORDER BY 2 /* LedgerName */;
END;
$$;
