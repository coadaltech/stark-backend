-- Converted from MySQL procedure `rpt_trans_productivity_datewise`.
-- Dynamic pivot: one column per day (NumberCount0..NumberCountN), so the column list is not fixed.
-- returns jsonb: [0] pivot rows (DataFlag 0 = header row with dd-mm-yyyy dates, DataFlag 1 = counts as text)
DROP ROUTINE IF EXISTS "rpt_trans_productivity_datewise";
CREATE OR REPLACE FUNCTION "rpt_trans_productivity_datewise"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date,
    varLoginName varchar
)
RETURNS jsonb
LANGUAGE plpgsql AS $$
DECLARE
    intRow smallint := 0;
    intTotalRow smallint := 0;
    sTemp1 text;
    sTemp2 text;
    sTemp3 text;
    sTemp4 text;
    s text;
    v_rows jsonb;
BEGIN
    intTotalRow := (varToDate - varFromDate);

    sTemp1 := '';
    sTemp2 := '';
    sTemp3 := '';
    sTemp4 := 'SELECT 0 AS "DataFlag" ';
    WHILE intRow <= intTotalRow LOOP
        sTemp1 := sTemp1 || format(', sum(%I)::text AS %I ', 'NumberCount' || intRow, 'NumberCount' || intRow);
        sTemp2 := sTemp2 || format(', sum(CASE WHEN t."TransactionDate" = %L::date THEN 1 ELSE 0 END) AS %I ',
                                   to_char(varFromDate + intRow, 'YYYY-MM-DD'), 'NumberCount' || intRow);
        sTemp3 := sTemp3 || format(', sum(CASE WHEN t."ShiftDate" = %L::date THEN 1 ELSE 0 END) AS %I ',
                                   to_char(varFromDate + intRow, 'YYYY-MM-DD'), 'NumberCount' || intRow);
        sTemp4 := sTemp4 || format(', to_char(%L::date, ''DD-MM-YYYY'') AS %I ',
                                   to_char(varFromDate + intRow, 'YYYY-MM-DD'), 'NumberCount' || intRow);
        intRow := intRow + 1;
    END LOOP;

    s := format('
    SELECT 1 AS "DataFlag" %s
    FROM (
        SELECT 1 AS "DataFlag"
        %s
        FROM "transaction_detail" td
        JOIN "transaction" t ON td."TransactionId" = t."TransactionId"
        WHERE (td."RecordStatus" != ''D'')
          AND (t."RecordStatus" != ''D'')
          AND (t."TransactionDate" BETWEEN %L::date AND %L::date)
          AND t."OrganizationId" = %L::bigint
          AND t."AddedBy" = %L

        UNION ALL

        SELECT 1 AS "DataFlag"
        %s
        FROM "transaction_detail_declare" td
        JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
        WHERE (td."RecordStatus" != ''D'')
          AND (t."RecordStatus" != ''D'')
          AND (t."TransactionDate" BETWEEN %L::date AND %L::date)
          AND t."OrganizationId" = %L::bigint
          AND t."AddedBy" = %L

        UNION ALL

        SELECT 1 AS "DataFlag"
        %s
        FROM "transaction_audit" t
        WHERE (t."RecordStatus" != ''D'')
          AND (t."ShiftDate" BETWEEN %L::date AND %L::date)
          AND t."OrganizationId" = %L::bigint
          AND t."AddedBy" = %L
    ) AS aa
    ',
        sTemp1,
        sTemp2, varFromDate, varToDate, varOrganizationId, varLoginName,
        sTemp2, varFromDate, varToDate, varOrganizationId, varLoginName,
        sTemp3, varFromDate, varToDate, varOrganizationId, varLoginName);

    s := sTemp4 || '
    UNION ALL
    ' || s;

    EXECUTE format('SELECT coalesce(jsonb_agg(to_jsonb(q) ORDER BY q."DataFlag"), ''[]''::jsonb) FROM (%s) q', s)
        INTO v_rows;

    RETURN jsonb_build_array(v_rows);
END;
$$;
