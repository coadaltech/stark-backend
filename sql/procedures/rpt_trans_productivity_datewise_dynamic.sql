-- Converted from MySQL procedure `rpt_trans_productivity_datewise_dynamic`.
DROP ROUTINE IF EXISTS "rpt_trans_productivity_datewise_dynamic";
-- returns jsonb: [0] rows {DataFlag, AddedBy, Mobile, Address, LoginStatus, LoginName, LoginType, RoleId, RoleName, NumberCount,
--   NumberCount0, NumberPercent0, ..., NumberCountN, NumberPercentN} (one pair per day from varFromDate to varToDate; dynamic
--   column list). First row (DataFlag = 0) is the header row carrying the dates (DD-MM-YYYY) in NumberCount<i>.
CREATE OR REPLACE FUNCTION "rpt_trans_productivity_datewise_dynamic"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date,
    varLoginName varchar
)
RETURNS jsonb
LANGUAGE plpgsql AS $$
DECLARE
    intRow integer;
    intTotalRow smallint := 0;
    v_s text;
    v_sTemp text;
    v_day date;
    v_login text;
    v_rows jsonb;
BEGIN
    intRow := 0;
    intTotalRow := (varToDate - varFromDate);
    v_login := COALESCE(varLoginName, '');

    -- NOTE: MySQL UNION coerced LoginType / NumberCount<i> / NumberPercent<i> to strings; kept as text here.
    v_s := '
        SELECT 1 AS "DataFlag", aa."AddedBy"::text AS "AddedBy"
        , lm."Mobile"::text AS "Mobile", lm."Address"::text AS "Address", lm."AccountStatus"::text AS "LoginStatus", lm."LoginName"::text AS "LoginName"
        , lm."LoginType"::text AS "LoginType", r."RoleId" AS "RoleId", r."RoleName"::text AS "RoleName"
        , sum(aa."NumberCount") AS "NumberCount"
        ';

    v_sTemp := '
        SELECT 0 AS "DataFlag", ''''::text AS "AddedBy"
        , ''''::text AS "Mobile", ''''::text AS "Address", ''''::text AS "LoginStatus", ''''::text AS "LoginName"
        , ''''::text AS "LoginType", 0 AS "RoleId", ''''::text AS "RoleName"
        , 0 AS "NumberCount"
        ';

    WHILE intRow <= intTotalRow LOOP
        v_day := varFromDate + intRow;

        v_s := v_s || format('
        , sum(CASE WHEN aa."TransactionDate" = %L::date THEN aa."NumberCount" ELSE 0 END)::text AS %I
        ', v_day, 'NumberCount' || intRow::text);
        v_s := v_s || format('
        , round(sum(CASE WHEN aa."TransactionDate" = %L::date THEN aa."NumberCount" ELSE 0 END) / (CASE WHEN lm."LoginType" = 12 THEN 0.6 ELSE 58 END))::text AS %I
        ', v_day, 'NumberPercent' || intRow::text);

        v_sTemp := v_sTemp || format(', %L::text AS %I ', to_char(v_day, 'DD-MM-YYYY'), 'NumberCount' || intRow::text);
        v_sTemp := v_sTemp || format(', ''0''::text AS %I ', 'NumberPercent' || intRow::text);

        intRow := intRow + 1;
    END LOOP;

    v_s := v_s || format('
    FROM (
        SELECT count(1) AS "NumberCount", t."AddedBy"
        , t."TransactionDate"
        FROM "transaction_detail" td
        JOIN "transaction" t ON td."TransactionId" = t."TransactionId"
        WHERE (td."RecordStatus" != ''D'')
          AND (t."RecordStatus" != ''D'')
          AND (t."TransactionDate" BETWEEN %1$L::date AND %2$L::date)
          AND t."OrganizationId" = %3$L::bigint
          AND (t."AddedBy" = %4$L OR %4$L = '''')
        GROUP BY t."AddedBy", t."TransactionDate"
        UNION ALL
        SELECT count(1) AS "NumberCount", t."AddedBy"
        , t."TransactionDate"
        FROM "transaction_detail_declare" td
        JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
        WHERE (td."RecordStatus" != ''D'')
          AND (t."RecordStatus" != ''D'')
          AND (t."TransactionDate" BETWEEN %1$L::date AND %2$L::date)
          AND t."OrganizationId" = %3$L::bigint
          AND (t."AddedBy" = %4$L OR %4$L = '''')
        GROUP BY t."AddedBy", t."TransactionDate"
        UNION ALL
        SELECT count(1) AS "NumberCount", t."AddedBy"
        , t."ShiftDate" AS "TransactionDate"
        FROM "transaction_audit" t
        WHERE (t."RecordStatus" != ''D'')
          AND (t."ShiftDate" BETWEEN %1$L::date AND %2$L::date)
          AND t."OrganizationId" = %3$L::bigint
          AND (t."AddedBy" = %4$L OR %4$L = '''')
        GROUP BY t."AddedBy", t."ShiftDate"
    ) AS aa
    JOIN "login" lm ON lm."UserName" = aa."AddedBy" AND lm."RecordStatus" != ''D''
    LEFT JOIN "role" r ON r."RoleId" = lm."LoginType" AND r."RecordStatus" != ''D'' AND r."OrganizationId" = %3$L::bigint
    WHERE lm."LoginType" NOT IN (1, 3, 4, 5)
    GROUP BY aa."AddedBy",
             lm."Mobile", lm."Address", lm."AccountStatus", lm."LoginName",
             lm."LoginType", r."RoleId", r."RoleName"
    ORDER BY "NumberCount" ASC
    ', varFromDate, varToDate, varOrganizationId, v_login);

    -- As in MySQL, the trailing ORDER BY applies to the whole UNION (header row has NumberCount = 0).
    v_s := v_sTemp || '
            UNION ALL
            ' || v_s;

    EXECUTE format('SELECT coalesce(jsonb_agg(t), ''[]''::jsonb) FROM (%s) t', v_s) INTO v_rows;

    RETURN jsonb_build_array(v_rows);
END;
$$;
