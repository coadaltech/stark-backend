-- Converted from MySQL procedure `payroll_rpt_salary_staff_list`.
-- Note: MySQL returned both raw lg.AddedDate/lg.UpdatedDate and formatted AddedDate/UpdatedDate
-- (duplicate labels; name-based clients see the later, formatted one). Only the formatted ones are kept.
-- LIKE -> ILIKE to keep MySQL's case-insensitive collation behaviour.
DROP ROUTINE IF EXISTS "payroll_rpt_salary_staff_list";
CREATE OR REPLACE FUNCTION "payroll_rpt_salary_staff_list"(
    varOrganizationId integer,
    varLedgerName varchar,
    varLedgerId integer,
    varUserName varchar)
RETURNS TABLE(
    "LedgerName" text, "LoginId" bigint, "OrganizationId" bigint, "LedgerId" bigint, "LoginName" text,
    "UserName" text, "LoginType" integer, "Mobile" text, "Address" text, "StaffWorkMode" integer,
    "AccountStatus" text, "RecordStatus" text, "AddedBy" text, "UpdatedBy" text,
    "AddedDate" text, "UpdatedDate" text, "RoleName" text, "GroupId" integer,
    "SalaryCount" numeric, "TotalSalary" double precision, "AssetCount" numeric, "AssetAmount" double precision)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT l."LedgerName"::text,
           lg."LoginId",
           lg."OrganizationId",
           lg."LedgerId",
           lg."LoginName"::text,
           lg."UserName"::text,
           lg."LoginType"::integer,
           lg."Mobile"::text,
           lg."Address"::text,
           lg."StaffWorkMode",
           lg."AccountStatus"::text,
           lg."RecordStatus"::text,
           lg."AddedBy"::text,
           lg."UpdatedBy"::text,
           to_char(lg."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
           to_char(lg."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
           r."RoleName"::text, l."GroupId",
           COALESCE(pss."SalaryCount", 0) AS "SalaryCount",
           pss."SalaryAmount" AS "TotalSalary",
           COALESCE(pss."AssetCount", 0) AS "AssetCount",
           pss."AssetAmount" AS "AssetAmount"
    FROM "ledger" l
    INNER JOIN (SELECT StaffStu."LedgerId", sum(StaffStu."SalaryCount") AS "SalaryCount", sum(StaffStu."SalaryAmount") AS "SalaryAmount",
                       sum(StaffStu."AssetCount") AS "AssetCount", sum(StaffStu."AssetAmount") AS "AssetAmount"
                FROM (
                    SELECT ss."LedgerId", count(1) AS "SalaryCount",
                           sum(CASE WHEN ss."AmountType" = 1 THEN ss."Amount"
                                    WHEN ss."AmountType" = 2 THEN
                                        (ss."Amount" * COALESCE((SELECT sum(BS."Amount") FROM "payroll_staff_structure" AS BS
                                                                 WHERE BS."CommanMasterId" = 1 AND BS."LedgerId" = ss."LedgerId"), 0) / 100)
                                    ELSE 0 END) AS "SalaryAmount",
                           0 AS "AssetCount", 0::double precision AS "AssetAmount"
                    FROM "payroll_staff_structure" ss
                    WHERE ss."RecordStatus" != 'D' GROUP BY ss."LedgerId"
                    UNION ALL
                    SELECT st."LedgerId", 0 AS "SalaryCount", 0 AS "SalaryAmount",
                           count(1) AS "AssetCount", sum(st."Amount") AS "AssetAmount"
                    FROM "payroll_staff_stock" st
                    WHERE st."RecordStatus" != 'D' GROUP BY st."LedgerId"
                ) AS StaffStu GROUP BY StaffStu."LedgerId"
               ) AS pss ON l."LedgerId" = pss."LedgerId"
    LEFT JOIN "login" lg ON lg."LedgerId" = l."LedgerId" AND lg."RecordStatus" != 'D'
    LEFT JOIN "role" r ON lg."LoginType" = r."RoleId" AND r."OrganizationId" = l."OrganizationId" AND r."RecordStatus" != 'D'
    WHERE l."OrganizationId" = varOrganizationId
      AND l."RecordStatus" != 'D'
      AND (varLedgerName IS NULL OR l."LedgerName" ILIKE ('%' || varLedgerName::text || '%'))
      AND (l."LedgerId" = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
      AND (lg."UserName" = varUserName OR COALESCE(varUserName, '') = '')
    ORDER BY l."LedgerName" ASC;
END;
$$;
