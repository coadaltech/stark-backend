-- Converted from MySQL procedure `rpt_trans_productivity_shiftwise`.
-- Dynamic pivot: one Shift<n>/NumberCount<n>/TotalAmount<n> column group per shift, so the column list is not fixed.
-- returns jsonb: [0] pivot rows (DataFlag 0 = header row carrying shift names / ShiftId in TotalAmount<n>, DataFlag 1 = per-user rows)
DROP ROUTINE IF EXISTS "rpt_trans_productivity_shiftwise";
CREATE OR REPLACE FUNCTION "rpt_trans_productivity_shiftwise"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date
)
RETURNS jsonb
LANGUAGE plpgsql AS $$
DECLARE
    varShiftId bigint;
    intRow integer;
    varShiftName varchar(100);
    rec record;
    s text;
    sTemp text;
    v_rows jsonb;
BEGIN
    varShiftId := 0;
    intRow := 1;

    s := '
        SELECT 1 AS "DataFlag", aa."AddedBy"::text AS "AddedBy"
        , lm."Mobile"::text AS "Mobile", lm."Address"::text AS "Address", lm."AccountStatus"::text AS "LoginStatus", lm."LoginName"::text AS "LoginName"
        , lm."LoginType"::text AS "LoginType", role."RoleId", role."RoleName"::text AS "RoleName"
        , sum(aa."NumberCount") AS "NumberCount"
        ';

    sTemp := '
        SELECT 0 AS "DataFlag", ''''::text AS "AddedBy"
        , ''''::text AS "Mobile", ''''::text AS "Address", ''''::text AS "LoginStatus", ''''::text AS "LoginName"
        , ''''::text AS "LoginType", 0 AS "RoleId", ''''::text AS "RoleName"
        , 0 AS "NumberCount"
        ';

    FOR rec IN
        SELECT sh."ShiftId", sh."ShiftName" FROM "shift" sh
        WHERE sh."RecordStatus" != 'D'
          AND sh."OrganizationId" = varOrganizationId
        ORDER BY sh."ShiftOrder"
    LOOP
        varShiftId := rec."ShiftId";
        varShiftName := rec."ShiftName";

        s := s || format('
        , %L::text AS %I
        , sum(CASE WHEN aa."ShiftId" = %s THEN aa."NumberCount" ELSE 0 END) AS %I
        , sum(CASE WHEN aa."ShiftId" = %s THEN aa."TotalAmount" ELSE 0 END) AS %I
        ', varShiftName, 'Shift' || intRow,
           varShiftId, 'NumberCount' || intRow,
           varShiftId, 'TotalAmount' || intRow);

        sTemp := sTemp || format('
        , %L::text AS %I
        , 0 AS %I
        , %s AS %I
        ', varShiftName, 'Shift' || intRow,
           'NumberCount' || intRow,
           varShiftId, 'TotalAmount' || intRow);

        intRow := intRow + 1;
    END LOOP;

    s := s || format('
    FROM (
        SELECT count(*) AS "NumberCount", sum(td."Amount") AS "TotalAmount", t."AddedBy"
            , t."ShiftId"
        FROM "transaction_detail" td
        JOIN "transaction" t ON td."TransactionId" = t."TransactionId"
        WHERE (td."RecordStatus" != ''D'')
          AND (t."RecordStatus" != ''D'')
          AND (t."TransactionDate" BETWEEN %1$L::date AND %2$L::date)
          AND t."OrganizationId" = %3$L::bigint
        GROUP BY t."AddedBy", t."ShiftId"
        UNION ALL
        SELECT count(*) AS "NumberCount", sum(td."Amount") AS "TotalAmount", t."AddedBy"
            , t."ShiftId"
        FROM "transaction_detail_declare" td
        JOIN "transaction_declare" t ON td."TransactionId" = t."TransactionId"
        WHERE (td."RecordStatus" != ''D'')
          AND (t."RecordStatus" != ''D'')
          AND (t."TransactionDate" BETWEEN %1$L::date AND %2$L::date)
          AND t."OrganizationId" = %3$L::bigint
        GROUP BY t."AddedBy", t."ShiftId"
    ) AS aa
    JOIN "login" lm ON lm."UserName" = aa."AddedBy" AND lm."RecordStatus" != ''D''
    LEFT JOIN "role" role ON role."RoleId" = lm."LoginType" AND role."RecordStatus" != ''D'' AND role."OrganizationId" = %3$L::bigint
    WHERE lm."LoginType" NOT IN (1,3,4,5)
    GROUP BY aa."AddedBy"
        , lm."Mobile", lm."Address", lm."AccountStatus", lm."LoginName"
        , lm."LoginType", role."RoleId", role."RoleName"
    ', varFromDate, varToDate, varOrganizationId);

    s := sTemp || '
        UNION ALL
        ' || s;

    -- MySQL: trailing `order by NumberCount ASC` applied to the whole UNION
    EXECUTE format('SELECT coalesce(jsonb_agg(to_jsonb(q) ORDER BY q."NumberCount" ASC), ''[]''::jsonb) FROM (%s) q', s)
        INTO v_rows;

    RETURN jsonb_build_array(v_rows);
END;
$$;
