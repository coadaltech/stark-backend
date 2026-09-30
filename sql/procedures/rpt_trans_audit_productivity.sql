-- Converted from MySQL procedure `rpt_trans_audit_productivity`.
DROP ROUTINE IF EXISTS "rpt_trans_audit_productivity";
CREATE OR REPLACE FUNCTION "rpt_trans_audit_productivity"(varOrganizationId bigint, varFromDate date, varToDate date, varShiftId integer)
RETURNS TABLE(
    "NumberCount" numeric,
    "TotalAmount" double precision,
    "AddedBy" text,
    "Mobile" text,
    "Address" text,
    "LoginStatus" text,
    "LoginName" text,
    "LoginType" smallint,
    "RoleId" integer,
    "RoleName" text,
    "ValidTrans" numeric,
    "MistakeTrans" numeric,
    "ModifyTrans" numeric,
    "TotalParty" bigint
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT sum(aa."NumberCount")::numeric AS "NumberCount", sum(aa."TotalAmount") AS "TotalAmount",
           aa."AddedBy"::text,
           aa."Mobile"::text, aa."Address"::text, aa."LoginStatus"::text, aa."LoginName"::text,
           aa."LoginType", aa."RoleId", aa."RoleName"::text,
           sum(aa."ValidTrans")::numeric AS "ValidTrans",
           sum(aa."MistakeTrans")::numeric AS "MistakeTrans",
           sum(aa."ModifyTrans")::numeric AS "ModifyTrans",
           count(1) AS "TotalParty"
    FROM (
        SELECT t."NumberCount", t."TotalAmount", t."AddedBy",
               lm."Mobile", lm."Address", lm."AccountStatus" AS "LoginStatus", lm."LoginName",
               lm."LoginType", r."RoleId", r."RoleName",
               t."MistakeTrans",
               t."ValidTrans",
               t."ModifyTrans"
        FROM (SELECT count(1) AS "NumberCount", sum(ta."Amount") AS "TotalAmount", ta."AddedBy", ta."LedgerId",
                     sum(CASE WHEN COALESCE(ta."Remark", '') = '' THEN 0 ELSE 1 END) AS "MistakeTrans",
                     sum(CASE WHEN COALESCE(ta."Remark", '') != '' THEN 0 ELSE 1 END) AS "ValidTrans",
                     sum(CASE WHEN COALESCE(ta."ModifyStatus", 0) = 0 THEN 0 ELSE 1 END) AS "ModifyTrans"
              FROM "transaction_audit" ta
              WHERE (ta."RecordStatus" != 'D')
                AND (ta."ShiftDate" BETWEEN varFromDate AND varToDate)
                AND (COALESCE(varShiftId, 0) = 0 OR ta."ShiftId" = varShiftId)
                AND ta."OrganizationId" = varOrganizationId
              GROUP BY ta."AddedBy", ta."LedgerId"
             ) AS t
        JOIN "login" lm ON lm."UserName" = t."AddedBy" AND lm."OrganizationId" = varOrganizationId AND lm."RecordStatus" != 'D'
        LEFT JOIN "role" r ON r."RoleId" = lm."LoginType" AND r."RecordStatus" != 'D' AND r."OrganizationId" = varOrganizationId
            AND lm."LoginType" NOT IN (3, 4, 5)
    ) AS aa
    GROUP BY aa."AddedBy",
             aa."Mobile", aa."Address", aa."LoginStatus", aa."LoginName",
             aa."LoginType", aa."RoleId", aa."RoleName"
    ORDER BY 1 ASC;
END;
$$;
