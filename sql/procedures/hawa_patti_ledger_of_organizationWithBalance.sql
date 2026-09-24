-- Converted from MySQL procedure `hawa_patti_ledger_of_organizationWithBalance`.
-- NOTES:
--  * HPVouch inner: unqualified `FromDate` in ifnull(vd.FromDate, ifnull(vd.FromDate, FromDate)) resolved to vd.FromDate in MySQL.
--  * vdWorking.WorkingDays was selected without being grouped (MySQL permissive GROUP BY); one vdWorking row per LedgerId
--    and l.LedgerId is grouped, so any_value() is equivalent.
--  * VapsiVouch filter `ledger.LedgerId in ((select ...))` is written as `IN (select ...)` (multi-row subquery semantics).
DROP ROUTINE IF EXISTS "hawa_patti_ledger_of_organizationWithBalance";
CREATE OR REPLACE FUNCTION "hawa_patti_ledger_of_organizationWithBalance"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date,
    varLedgerName varchar
)
RETURNS TABLE(
    "LedgerId" bigint,
    "OrganizationId" bigint,
    "ParentLedgerId" bigint,
    "LedgerName" text,
    "GroupId" integer,
    "AgentLedgerId" bigint,
    "AgentName" text,
    "RecordStatus" text,
    "AddedBy" text,
    "Mobile" text,
    "UserName" text,
    "ProfitAndLoss" numeric,
    "WorkingDays" numeric,
    "HPAmount" numeric,
    "VapsiBaseAmount" numeric,
    "vapsiAmount" numeric,
    "SettelmentAmount" numeric,
    "TotalSettelmentAmount" numeric
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    varVapsiWorkingDays bigint := 0;
BEGIN
    SELECT o."VapsiWorkingDays" INTO varVapsiWorkingDays FROM "organization" o
    WHERE o."OrganizationId" = varOrganizationId;

    RETURN QUERY
    SELECT ledger."LedgerId",
        ledger."OrganizationId",
        ledger."ParentLedgerId",
        ledger."LedgerName"::text,
        ledger."GroupId"
        , COALESCE(ledger."AgentLedgerId", 0) AS "AgentLedgerId"
        , COALESCE(agent."CommanMasterName", 'NA')::text AS "AgentName"
        , ledger."RecordStatus"::text
        , ledger."AddedBy"::text
        , COALESCE(login."Mobile", 'NA')::text AS "Mobile"
        , COALESCE(login."UserName", 'NA')::text AS "UserName"

        , COALESCE(HPVouch."ProfitAndLoss", 0)::numeric(16,2) AS "ProfitAndLoss"
        , COALESCE(HPVouch."WorkingDays", 0)::numeric(16,2) AS "WorkingDays"
        , COALESCE(HPVouch."HPAmount", 0)::numeric(16,2) AS "HPAmount"

        , COALESCE(VapsiVouch."VapsiBaseAmount", 0)::numeric(16,2) AS "VapsiBaseAmount"
        , COALESCE(VapsiVouch."vapsiAmount", 0)::numeric(16,2) AS "vapsiAmount"
        , COALESCE(SettVouch."opening", 0)::numeric(16,2) AS "SettelmentAmount"

        , -COALESCE(HPVouch."HPAmount", 0)::numeric(16,2)
          - COALESCE(VapsiVouch."vapsiAmount", 0)::numeric(16,2)
          + COALESCE(SettVouch."opening", 0)::numeric(16,2) AS "TotalSettelmentAmount"

    FROM (SELECT lg."LedgerId",
                 lg."OrganizationId",
                 lg."ParentLedgerId",
                 lg."LedgerName",
                 lg."AgentLedgerId",
                 lg."GroupId",
                 lg."RecordStatus"
                 , lg."AddedBy"
          FROM "ledger" lg
          WHERE lg."LedgerId" IN (SELECT hp."HPLedgerId" FROM "ledger" AS hp WHERE hp."OrganizationId" = varOrganizationId
                                   AND hp."RecordStatus" != 'D'
                                   AND hp."IsHide" = '0')
            AND lg."LedgerName" ILIKE (varLedgerName::text || '%')
         ) AS ledger
    LEFT JOIN
    (
        SELECT sum(hv."ProfitAndLoss") AS "ProfitAndLoss"
            , sum(hv."WorkingDays") AS "WorkingDays"
            , sum(hv."HPAmount") AS "HPAmount"
            , hv."HPLedgerId" AS "HPLedgerId"
        FROM
        (
            SELECT DISTINCT l."LedgerId"
                , COALESCE(vd."FromDate", COALESCE(vd."FromDate", vd."FromDate")) AS "FromDate"
                , hissa."Hissa"
                , COALESCE(l."HPLedgerId", 0) AS "HPLedgerId"
                , COALESCE(sum(vd."ProfitAndLoss"), 0) AS "ProfitAndLoss"
                , (COALESCE(sum(vd."ProfitAndLoss"), 0) * COALESCE(hissa."Hissa", 0)) / 100 AS "HPAmount"
                , COALESCE(any_value(vdWorking."WorkingDays"), 0) AS "WorkingDays"
            FROM (SELECT lx."LedgerId", lx."LedgerName", lx."AddedDate", lx."HPLedgerId", lx."AgentLedgerId"
                  FROM "ledger" lx WHERE lx."GroupId" = 5 AND lx."RecordStatus" != 'D'
                    -- (commented out in MySQL: and (varToLedgerIds = 0 or ifnull(ledger.HPLedgerId,0) = varToLedgerIds))
                    AND (COALESCE(lx."HPLedgerId", 0) != 0)
                    AND lx."OrganizationId" = varOrganizationId
                 ) AS l
            LEFT JOIN "hissa" ON hissa."LedgerId" = l."LedgerId" AND hissa."HissaLedgerId" = 11 AND hissa."RecordStatus" != 'D' AND COALESCE(hissa."Hissa", 0) != 0
            LEFT JOIN (SELECT
                    vd."LedgerId", varFromDate AS "FromDate",
                    sum(CASE WHEN vd."ShiftId" != 0 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END) AS "ProfitAndLoss"
                FROM "voucher_detail" AS vd
                /* (MySQL source had a commented-out join on hp_hissa max(HPToDate) here) */
                WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
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
        ) AS hv
        GROUP BY hv."HPLedgerId"
    ) AS HPVouch ON HPVouch."HPLedgerId" = ledger."LedgerId"

    LEFT JOIN
    (
        SELECT vv."HPLedgerId"
            , sum(vv."VapsiBaseAmount") AS "VapsiBaseAmount"
            , sum(vv."vapsiAmount") AS "vapsiAmount"
        FROM
        (
            SELECT DISTINCT l."LedgerId", l."HPLedgerId"
                , varFromDate AS "FromDate"
                , l."Vapsi" AS "vapsi"
                , (COALESCE((CASE WHEN sum(vd."ProfitAndLoss") > 0 THEN sum(vd."ProfitAndLoss") ELSE 0 END), 0) * (100 - COALESCE(hissa."Hissa", 0))) / 100 AS "VapsiBaseAmount"
                , (((COALESCE((CASE WHEN sum(vd."ProfitAndLoss") > 0 THEN sum(vd."ProfitAndLoss") ELSE 0 END), 0) * (100 - COALESCE(hissa."Hissa", 0))) / 100)
                    * COALESCE(l."Vapsi", 0)) / 100 AS "vapsiAmount"
            FROM (SELECT lx."LedgerId", lx."LedgerName", lx."AddedDate", lx."Vapsi", lx."AgentLedgerId", lx."HPLedgerId"
                  FROM "ledger" lx WHERE lx."GroupId" IN (3, 4, 5)
                    AND COALESCE(lx."Vapsi", 0) != 0 AND lx."RecordStatus" != 'D'
                    AND COALESCE(lx."ParentLedgerId", 0) = 0
                    AND lx."OrganizationId" = varOrganizationId
                    AND (COALESCE(lx."HPLedgerId", 0) != 0)
                    AND (COALESCE(varVapsiWorkingDays, 0) = 0
                         OR lx."LedgerId" IN (
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
                    (CASE WHEN lp."ParentLedgerId" = 0 THEN vd."LedgerId" WHEN ledgerBaap."ParentLedgerId" = 0 THEN lp."ParentLedgerId"
                          ELSE ledgerBaap."ParentLedgerId" END) AS "LedgerId", varFromDate AS "FromDate",
                    sum(CASE WHEN vd."ShiftId" != 0 THEN (CASE WHEN vd."AmountType" = 'Dr' THEN vd."Amount" ELSE -vd."Amount" END) ELSE 0 END) AS "ProfitAndLoss"
                FROM "voucher_detail" AS vd
                INNER JOIN "shift" ON vd."ShiftId" = shift."ShiftId" AND COALESCE(shift."IsCreateVapsi", 1) = 1
                LEFT JOIN (SELECT lx."LedgerId", lx."ParentLedgerId" FROM "ledger" lx
                           WHERE (lx."RecordStatus" != 'D')
                             AND lx."OrganizationId" = varOrganizationId
                             AND lx."GroupId" IN (3, 4, 5)
                          ) AS lp ON vd."LedgerId" = lp."LedgerId"
                LEFT JOIN (SELECT lx."LedgerId", lx."ParentLedgerId" FROM "ledger" lx
                           WHERE (lx."RecordStatus" != 'D')
                             AND lx."OrganizationId" = varOrganizationId
                             AND lx."GroupId" IN (3, 4, 5)
                          ) AS ledgerBaap ON lp."ParentLedgerId" = ledgerBaap."LedgerId"
                /* (MySQL source had a commented-out vapsi max(VapsiToDate) join here) */
                WHERE vd."VoucherDate" BETWEEN varFromDate AND varToDate
                  AND (CASE WHEN lp."ParentLedgerId" = 0 THEN vd."LedgerId"
                            WHEN ledgerBaap."ParentLedgerId" = 0 THEN lp."ParentLedgerId"
                            ELSE ledgerBaap."ParentLedgerId" END) NOT IN (SELECT v."LedgerId" FROM "vapsi" v WHERE v."RecordStatus" != 'D' AND v."VapsiFromDate" = varFromDate)
                  AND (vd."RecordStatus" != 'D')
                GROUP BY (CASE WHEN lp."ParentLedgerId" = 0 THEN vd."LedgerId" WHEN ledgerBaap."ParentLedgerId" = 0 THEN lp."ParentLedgerId"
                               ELSE ledgerBaap."ParentLedgerId" END)
                ) AS vd ON vd."LedgerId" = l."LedgerId"
            LEFT JOIN (SELECT sum(h."Hissa") AS "Hissa", h."LedgerId" FROM "hissa" h WHERE h."LedgerId" != h."HissaLedgerId" AND h."RecordStatus" != 'D' GROUP BY h."LedgerId")
                AS hissa ON hissa."LedgerId" = l."LedgerId"
            GROUP BY l."LedgerId", l."Vapsi"
                , vd."FromDate", l."AddedDate", COALESCE(hissa."Hissa", 0), l."HPLedgerId"
        ) AS vv
        GROUP BY vv."HPLedgerId"
    ) AS VapsiVouch ON VapsiVouch."HPLedgerId" = ledger."LedgerId"
    LEFT JOIN
    (
        SELECT sum(OPBal."opening") AS "opening", l."HPLedgerId"
        FROM (SELECT lx."LedgerId", lx."LedgerName", lx."AddedDate", lx."HPLedgerId", lx."AgentLedgerId"
              FROM "ledger" lx WHERE lx."GroupId" = 5 AND lx."RecordStatus" != 'D'
                AND (COALESCE(lx."HPLedgerId", 0) != 0)
                AND lx."OrganizationId" = varOrganizationId
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
        GROUP BY l."HPLedgerId"
    ) AS SettVouch ON SettVouch."HPLedgerId" = ledger."LedgerId"
    LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = ledger."AgentLedgerId" AND agent."CommanMasterType" = 1
    LEFT JOIN "login" ON ledger."LedgerId" = login."LedgerId"
    WHERE
        (COALESCE(HPVouch."ProfitAndLoss", 0)::numeric(16,2) != 0
         OR COALESCE(HPVouch."HPAmount", 0)::numeric(16,2) != 0
         OR COALESCE(VapsiVouch."vapsiAmount", 0)::numeric(16,2) != 0
         OR COALESCE(SettVouch."opening", 0)::numeric(16,2) != 0)
    ORDER BY ledger."LedgerName" ASC;
END;
$$;
