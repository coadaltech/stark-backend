-- Converted from MySQL procedure `rpt_Trans_Productivity_Topper_Looser_insert`.
-- MySQL grouped the inner selects by (AddedBy, Mobile, Address, AccountStatus, LoginName) while
-- selecting LoginType/RoleId/RoleName non-aggregated -> any_value() here.
DROP ROUTINE IF EXISTS "rpt_Trans_Productivity_Topper_Looser_insert";
CREATE OR REPLACE PROCEDURE "rpt_Trans_Productivity_Topper_Looser_insert"(
    varOnDate date
)
LANGUAGE plpgsql AS $$
DECLARE
    varOrganizationId bigint;
    rec record;
BEGIN
    varOrganizationId := 0;

    FOR rec IN
        SELECT o."OrganizationId" FROM "organization" o
        WHERE o."RecordStatus" != 'D'
          AND o."IsOrganizationAllow" = '1'
    LOOP
        varOrganizationId := rec."OrganizationId";

        DELETE FROM "toppers_losser" tl
        WHERE tl."OrganizationId" = varOrganizationId;

        INSERT INTO "toppers_losser"("NumberCount", "TotalAmount", "AddedBy", "Mobile", "Address", "LoginStatus", "LoginName", "LoginType", "RoleId", "RoleName", "TopFlag", "NumberCountOrder", "OrganizationId")
        SELECT sum(aa."NumberCount") AS "NumberCount", sum(aa."TotalAmount") AS "TotalAmount"
            , aa."AddedBy"
            , aa."Mobile", aa."Address", aa."LoginStatus"::integer, aa."LoginName"
            , aa."LoginType", aa."RoleId", aa."RoleName", 1 AS "TopFlag"
            , sum(aa."NumberCount") AS "NumberCountOrder"
            , varOrganizationId
        FROM (
            SELECT count(*) AS "NumberCount", sum(td."Amount") AS "TotalAmount", t."AddedBy"
                , lm."Mobile", lm."Address", lm."AccountStatus" AS "LoginStatus", lm."LoginName"
                , any_value(lm."LoginType") AS "LoginType", any_value(role."RoleId") AS "RoleId", any_value(role."RoleName") AS "RoleName"
            FROM "transaction_detail" td
            JOIN "transaction" t ON td."TransactionId" = t."TransactionId"
            JOIN "login" lm ON lm."UserName" = t."AddedBy" AND lm."OrganizationId" = t."OrganizationId" AND lm."RecordStatus" != 'D'
            LEFT JOIN "role" role ON role."RoleId" = lm."LoginType" AND role."RecordStatus" != 'D' AND role."OrganizationId" = varOrganizationId
            WHERE (td."RecordStatus" != 'D')
              AND (t."RecordStatus" != 'D')
              AND t."TransactionDate" = (varOnDate - 1)
    /*        and (t.TransactionDate between varFromDate and varToDate)
              and (ifnull(varShiftId,0) = 0 or t.ShiftId = varShiftId)
    */        AND t."OrganizationId" = varOrganizationId
              AND lm."LoginType" NOT IN (3,4,5)
              AND lm."StaffWorkMode" IN (1,2)
            GROUP BY t."AddedBy", lm."Mobile", lm."Address", lm."AccountStatus", lm."LoginName"
            UNION ALL
            SELECT count(*) AS "NumberCount", sum(td."Amount") AS "TotalAmount", t."AddedBy"
                , lm."Mobile", lm."Address", lm."AccountStatus" AS "LoginStatus", lm."LoginName"
                , any_value(lm."LoginType") AS "LoginType", any_value(role."RoleId") AS "RoleId", any_value(role."RoleName") AS "RoleName"
            FROM "transaction_detail_declare" td
            JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
            JOIN "login" lm ON lm."UserName" = t."AddedBy" AND lm."OrganizationId" = t."OrganizationId" AND lm."RecordStatus" != 'D'
            LEFT JOIN "role" role ON role."RoleId" = lm."LoginType" AND role."RecordStatus" != 'D' AND role."OrganizationId" = varOrganizationId
            WHERE (td."RecordStatus" != 'D')
              AND (t."RecordStatus" != 'D')
              AND t."TransactionDate" = (varOnDate - 1)
              AND t."OrganizationId" = varOrganizationId
              AND lm."LoginType" NOT IN (3,4,5)
              AND lm."StaffWorkMode" IN (1,2)
            GROUP BY t."AddedBy", lm."Mobile", lm."Address", lm."AccountStatus", lm."LoginName"
        ) AS aa
        GROUP BY aa."AddedBy"
            , aa."Mobile", aa."Address", aa."LoginStatus", aa."LoginName"
            , aa."LoginType", aa."RoleId", aa."RoleName"
        ORDER BY sum(aa."NumberCount") ASC LIMIT 5;

        INSERT INTO "toppers_losser"("NumberCount", "TotalAmount", "AddedBy", "Mobile", "Address", "LoginStatus", "LoginName", "LoginType", "RoleId", "RoleName", "TopFlag", "NumberCountOrder", "OrganizationId")
        SELECT sum(aa."NumberCount") AS "NumberCount", sum(aa."TotalAmount") AS "TotalAmount"
            , aa."AddedBy"
            , aa."Mobile", aa."Address", aa."LoginStatus"::integer, aa."LoginName"
            , aa."LoginType", aa."RoleId", aa."RoleName", 0 AS "TopFlag"
            , -sum(aa."NumberCount") AS "NumberCountOrder"
            , varOrganizationId
        FROM (
            SELECT count(*) AS "NumberCount", sum(td."Amount") AS "TotalAmount", t."AddedBy"
                , lm."Mobile", lm."Address", lm."AccountStatus" AS "LoginStatus", lm."LoginName"
                , any_value(lm."LoginType") AS "LoginType", any_value(role."RoleId") AS "RoleId", any_value(role."RoleName") AS "RoleName"
            FROM "transaction_detail" td
            JOIN "transaction" t ON td."TransactionId" = t."TransactionId"
            JOIN "login" lm ON lm."UserName" = t."AddedBy" AND lm."OrganizationId" = t."OrganizationId" AND lm."RecordStatus" != 'D'
            LEFT JOIN "role" role ON role."RoleId" = lm."LoginType" AND role."RecordStatus" != 'D' AND role."OrganizationId" = varOrganizationId
            WHERE (td."RecordStatus" != 'D')
              AND (t."RecordStatus" != 'D')
              AND t."TransactionDate" = (varOnDate - 1)
              AND t."OrganizationId" = varOrganizationId
              AND lm."LoginType" NOT IN (3,4,5)
              AND lm."StaffWorkMode" IN (1,2)
            GROUP BY t."AddedBy", lm."Mobile", lm."Address", lm."AccountStatus", lm."LoginName"
            UNION ALL
            SELECT count(*) AS "NumberCount", sum(td."Amount") AS "TotalAmount", t."AddedBy"
                , lm."Mobile", lm."Address", lm."AccountStatus" AS "LoginStatus", lm."LoginName"
                , any_value(lm."LoginType") AS "LoginType", any_value(role."RoleId") AS "RoleId", any_value(role."RoleName") AS "RoleName"
            FROM "transaction_detail_declare" td
            JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
            JOIN "login" lm ON lm."UserName" = t."AddedBy" AND lm."OrganizationId" = t."OrganizationId" AND lm."RecordStatus" != 'D'
            LEFT JOIN "role" role ON role."RoleId" = lm."LoginType" AND role."RecordStatus" != 'D' AND role."OrganizationId" = varOrganizationId
            WHERE (td."RecordStatus" != 'D')
              AND (t."RecordStatus" != 'D')
              AND t."TransactionDate" = (varOnDate - 1)
              AND t."OrganizationId" = varOrganizationId
              AND lm."LoginType" NOT IN (3,4,5)
              AND lm."StaffWorkMode" IN (1,2)
            GROUP BY t."AddedBy", lm."Mobile", lm."Address", lm."AccountStatus", lm."LoginName"
        ) AS aa
        GROUP BY aa."AddedBy"
            , aa."Mobile", aa."Address", aa."LoginStatus", aa."LoginName"
            , aa."LoginType", aa."RoleId", aa."RoleName"
        ORDER BY sum(aa."NumberCount") DESC LIMIT 5;
    END LOOP;
END;
$$;
