-- Converted from MySQL procedure `hawa_patti_ledger_detail_of_organizationWithBalance`.
-- NOTES:
--  * hpTable: unqualified `FromDate` in ifnull(vd.FromDate, ifnull(vd.FromDate, FromDate)) resolved to vd.FromDate in MySQL
--    (no such variable/param exists).
--  * vdWorking.WorkingDays was selected without being grouped (MySQL permissive GROUP BY); one vdWorking row per LedgerId
--    and l.LedgerId is grouped, so any_value() is equivalent.
--  * vapsiTable filter `ledger.LedgerId in ((select ...))` is written as `IN (select ...)` (multi-row subquery semantics).
DROP ROUTINE IF EXISTS "hawa_patti_ledger_detail_of_organizationWithBalance";
CREATE OR REPLACE FUNCTION "hawa_patti_ledger_detail_of_organizationWithBalance"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date,
    varToLedgerIds bigint
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "HPLedgerId" bigint,
    "Hissa" double precision,
    "FromDate" date,
    "ProfitAndLoss" numeric,
    "HPAmount" numeric,
    "WorkingDays" bigint,
    "vapsi" double precision,
    "VapsiBaseAmount" numeric,
    "vapsiAmount" numeric,
    "IsTPV" text,
    "SettelmentAmount" numeric,
    "TotalSettelmentAmount" numeric
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varVapsiWorkingDays integer := 0;
BEGIN
    SELECT o."VapsiWorkingDays" INTO varVapsiWorkingDays FROM "organization" o
    WHERE o."OrganizationId" = varOrganizationId;

    RETURN QUERY
    SELECT
        hpTable."LedgerId" AS "LedgerId"
        , hpTable."LedgerName"::text AS "LedgerName"
        , hpTable."HPLedgerId" AS "HPLedgerId"
        , hpTable."Hissa" AS "Hissa"
        , hpTable."FromDate" AS "FromDate"
        , COALESCE(hpTable."ProfitAndLoss", 0)::numeric(16,2) AS "ProfitAndLoss"
        , COALESCE(hpTable."HPAmount", 0)::numeric(16,2) AS "HPAmount"
        , COALESCE(hpTable."WorkingDays", 0) AS "WorkingDays"

        , vapsiTable."vapsi" AS "vapsi"
        , COALESCE(vapsiTable."VapsiBaseAmount", 0)::numeric(16,2) AS "VapsiBaseAmount"
        , COALESCE(vapsiTable."vapsiAmount", 0)::numeric(16,2) AS "vapsiAmount"
        , vapsiTable."IsTPV"::text AS "IsTPV"

        , COALESCE(settTable."opening", 0)::numeric(16,2) AS "SettelmentAmount"

        , -COALESCE(hpTable."HPAmount", 0)::numeric(16,2)
          - COALESCE(vapsiTable."vapsiAmount", 0)::numeric(16,2)
          + COALESCE(settTable."opening", 0)::numeric(16,2) AS "TotalSettelmentAmount"
    FROM
    (
        SELECT l."LedgerId", l."LedgerName"
            , COALESCE(vd."FromDate", COALESCE(vd."FromDate", vd."FromDate")) AS "FromDate"
            , hissa."Hissa"
            , COALESCE(l."HPLedgerId", 0) AS "HPLedgerId"
            , COALESCE(sum(vd."ProfitAndLoss"), 0) AS "ProfitAndLoss"
            , (COALESCE(sum(vd."ProfitAndLoss"), 0) * COALESCE(hissa."Hissa", 0)) / 100 AS "HPAmount"
            , COALESCE(any_value(vdWorking."WorkingDays"), 0) AS "WorkingDays"
        FROM (SELECT ledger."LedgerId", ledger."LedgerName", ledger."AddedDate", ledger."HPLedgerId", ledger."AgentLedgerId"
              FROM "ledger" WHERE ledger."GroupId" = 5 AND ledger."RecordStatus" != 'D'
                AND (varToLedgerIds = 0 OR COALESCE(ledger."HPLedgerId", 0) = varToLedgerIds)
                AND ledger."OrganizationId" = varOrganizationId
             ) AS l
        LEFT JOIN "hissa" ON hissa."LedgerId" = l."LedgerId" AND hissa."HissaLedgerId" = 11 AND hissa."RecordStatus" != 'D' AND COALESCE(hissa."Hissa", 0) != 0
        LEFT JOIN (SELECT
                vd."LedgerId", varFromDate AS "FromDate",
                sum(CASE WHEN vd."ShiftId" != 0 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END) AS "ProfitAndLoss"
            FROM "voucher_detail" AS vd
            /* (MySQL source had a commented-out join on hp_hissa max(HPToDate) here) */
            WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
              -- (commented out in MySQL: and varFromDate not in (select HPFromDate from hp_hissa ...))
              AND vd."LedgerId" NOT IN (SELECT hh."LedgerId" FROM "hp_hissa" hh WHERE hh."RecordStatus" != 'D' AND hh."HPFromDate" = varFromDate)
              AND (vd."RecordStatus" != 'D')
            GROUP BY vd."LedgerId"
            ) AS vd ON vd."LedgerId" = l."LedgerId"
        LEFT JOIN (
            SELECT w."LedgerId", count(w."WorkingDays") AS "WorkingDays"
            FROM
            (
                SELECT
                    vd."LedgerId", count(1) AS "WorkingDays"
                FROM "voucher_detail" AS vd
                WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
                  AND (vd."RecordStatus" != 'D')
                  AND vd."VoucherType" IN (22, 23, 24)
                GROUP BY vd."LedgerId", vd."VoucherDate"
            ) AS w
            GROUP BY w."LedgerId"
            ) AS vdWorking ON vdWorking."LedgerId" = l."LedgerId"
        GROUP BY l."LedgerId", l."LedgerName", hissa."Hissa"
            , vd."FromDate", l."AddedDate"
            , COALESCE(l."HPLedgerId", 0)
    ) AS hpTable
    LEFT JOIN
    (
        SELECT DISTINCT l."LedgerId"
            , varFromDate AS "FromDate"
            , l."Vapsi" AS "vapsi"
            , (COALESCE((CASE WHEN sum(vd."ProfitAndLoss") > 0 THEN sum(vd."ProfitAndLoss") ELSE 0 END), 0) * (100 - COALESCE(hissa."Hissa", 0))) / 100 AS "VapsiBaseAmount"
            , (((COALESCE((CASE WHEN sum(vd."ProfitAndLoss") > 0 THEN sum(vd."ProfitAndLoss") ELSE 0 END), 0) * (100 - COALESCE(hissa."Hissa", 0))) / 100)
                * COALESCE(l."Vapsi", 0)) / 100 AS "vapsiAmount"
            , (CASE WHEN COALESCE((SELECT sum(tpv."Vapsi") FROM "third_party_vapsi" tpv WHERE tpv."LedgerId" = l."LedgerId" AND tpv."RecordStatus" != 'D'), 0) > 0 THEN 'Yes' ELSE 'No' END) AS "IsTPV"
        FROM (SELECT ledger."LedgerId", ledger."LedgerName", ledger."AddedDate", ledger."Vapsi", ledger."AgentLedgerId"
              FROM "ledger" WHERE ledger."GroupId" IN (3, 4, 5)
                AND COALESCE(ledger."Vapsi", 0) != 0 AND ledger."RecordStatus" != 'D'
                AND COALESCE(ledger."ParentLedgerId", 0) = 0
                AND ledger."OrganizationId" = varOrganizationId
                AND (varToLedgerIds = 0 OR COALESCE(ledger."HPLedgerId", 0) = varToLedgerIds)
                AND (COALESCE(varVapsiWorkingDays, 0) = 0
                     OR ledger."LedgerId" IN (
                            SELECT wd."LedgerId"
                            FROM (
                                SELECT
                                    vd."LedgerId", vd."VoucherDate"
                                FROM "voucher_detail" AS vd
                                WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
                                  AND (vd."RecordStatus" != 'D')
                                  AND vd."VoucherType" IN (22, 23, 24)
                                GROUP BY vd."LedgerId", vd."VoucherDate"
                            ) AS wd
                            GROUP BY wd."LedgerId"
                            HAVING count(1) >= varVapsiWorkingDays
                         )
                    )
             ) AS l
        LEFT JOIN (SELECT
                (CASE WHEN ledger."ParentLedgerId" = 0 THEN vd."LedgerId" WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
                      ELSE ledgerBaap."ParentLedgerId" END) AS "LedgerId", varFromDate AS "FromDate",
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
            /* (MySQL source had commented-out vapsi max(VapsiToDate) join / VapsiFromDate filter here) */
            WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
              AND (CASE WHEN ledger."ParentLedgerId" = 0 THEN vd."LedgerId"
                        WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
                        ELSE ledgerBaap."ParentLedgerId" END) NOT IN (SELECT v."LedgerId" FROM "vapsi" v WHERE v."RecordStatus" != 'D' AND v."VapsiFromDate" = varFromDate)
              AND (vd."RecordStatus" != 'D')
            GROUP BY (CASE WHEN ledger."ParentLedgerId" = 0 THEN vd."LedgerId" WHEN ledgerBaap."ParentLedgerId" = 0 THEN ledger."ParentLedgerId"
                           ELSE ledgerBaap."ParentLedgerId" END)
            ) AS vd ON vd."LedgerId" = l."LedgerId"
        LEFT JOIN (SELECT sum(h."Hissa") AS "Hissa", h."LedgerId" FROM "hissa" h WHERE h."LedgerId" != h."HissaLedgerId" AND h."RecordStatus" != 'D' GROUP BY h."LedgerId")
            AS hissa ON hissa."LedgerId" = l."LedgerId"
        GROUP BY l."LedgerId", l."Vapsi"
            , vd."FromDate", l."AddedDate", COALESCE(hissa."Hissa", 0)
    ) AS vapsiTable ON hpTable."LedgerId" = vapsiTable."LedgerId"
    LEFT JOIN
    (
        SELECT DISTINCT l."LedgerId"
            , (OPBal."opening") AS "opening", l."HPLedgerId"
        FROM (SELECT ledger."LedgerId", ledger."LedgerName", ledger."AddedDate", ledger."HPLedgerId", ledger."AgentLedgerId"
              FROM "ledger" WHERE ledger."GroupId" = 5 AND ledger."RecordStatus" != 'D'
                AND (varToLedgerIds = 0 OR COALESCE(ledger."HPLedgerId", 0) = varToLedgerIds)
                AND ledger."OrganizationId" = varOrganizationId
             ) AS l
        LEFT JOIN (SELECT aa."LedgerId"
                       , sum((CASE WHEN aa."AmountType" = 'Dr' THEN COALESCE(aa."Amount", 0) ELSE -COALESCE(aa."Amount", 0) END)) AS "opening"
                   FROM "voucher_detail" aa
                   WHERE aa."VoucherDate" <= varToDate
                     AND aa."VoucherType" != 2
                     AND aa."RecordStatus" != 'D'
                     AND aa."OrganizationId" = varOrganizationId
                   GROUP BY aa."LedgerId"
                  ) AS OPBal ON OPBal."LedgerId" = l."LedgerId"
        WHERE COALESCE(OPBal."opening", 0) != 0
    ) AS settTable ON settTable."LedgerId" = hpTable."LedgerId"
    WHERE 1 = 1
    ORDER BY hpTable."LedgerName";
END;
$$;
