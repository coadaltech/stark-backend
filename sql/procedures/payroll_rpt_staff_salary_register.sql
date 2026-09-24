-- Converted from MySQL procedure `payroll_rpt_staff_salary_register`.
-- The MySQL proc built one dynamic SELECT (header row DataFlag=0 UNION ALL staff rows DataFlag=1
-- UNION ALL totals row DataFlag=2) whose column list depends on the configured earning/deduction
-- heads (Earning<n>/EarningAmount<n>, Deduction<n>/DeductionAmount<n>), so it cannot be a
-- RETURNS TABLE; it returns jsonb instead.
-- returns jsonb: [0] salary register rows (one result set; keys = MySQL column labels;
--                    note jsonb does not keep column order), ordered by
--                    DataFlag, LedgerName, UserName, SalaryYear, SalaryMonth
-- Like MySQL (CONCAT with a NULL arg -> NULL statement -> error), a NULL varOrganizationId,
-- varMonth, varYear, varLedgerId, varFromDate or varToDate makes the statement NULL and raises.
-- Differences: comman names are embedded with quote_literal() (MySQL pasted them raw between
-- quotes); ROUND(float,0) -> round(x::numeric,0); non-grouped login/role/limit/structure
-- columns -> any_value(); date/timestamp columns are emitted as text because MySQL's UNION
-- with the '' placeholders turned them into strings.
DROP ROUTINE IF EXISTS "payroll_rpt_staff_salary_register";
CREATE OR REPLACE FUNCTION "payroll_rpt_staff_salary_register"(
    varOrganizationId integer,
    varMonth integer,
    varYear integer,
    varLedgerId bigint,
    varFromDate date,
    varToDate date,
    varAgentLedgerId bigint
)
RETURNS jsonb
LANGUAGE plpgsql AS $$
DECLARE
    v_s text;
    v_sTemp text;
    v_sBottom text;
    v_sBottomInner text;
    v_where text;
    v_rows jsonb;
    rec record;
    intRow integer;
BEGIN
    -- ---------------- earnings ----------------
    intRow := 1;

    v_s := '
        select 1 as "DataFlag",payroll_salary."SalaryId",payroll_salary."VoucherId",ledger."LedgerName",login."UserName"
            ,any_value(login."Mobile") as "Mobile",any_value(login."Address") as "Address",any_value(login."AccountStatus") as "LoginStatus",any_value(login."LoginName") as "LoginName"
            ,any_value(login."LoginType")::text as "LoginType",any_value(role."RoleId") as "RoleId",any_value(role."RoleName") as "RoleName",round(any_value(ledger_limit."LedgerBalance")::numeric,0) as "Closing"
            ,payroll_salary."SalaryDate"::text as "SalaryDate"
            ,payroll_salary."LedgerId",payroll_salary."SalaryMonth",payroll_salary."SalaryYear"
            ,payroll_salary."WorkingDays",payroll_salary."TotalDays"
            ,(coalesce(payroll_salary."WorkingDays",0) - coalesce(payroll_salary."Present",0) - coalesce(payroll_salary."PaidLeave",0)) as "Absent",payroll_salary."PaidLeave"
            ,payroll_salary."Present",payroll_salary."TotalEntryCount"
            ,round(any_value(payroll_staff_structure."Amount")::numeric,0) as "BasicSalary"
        ';

    v_sTemp := '
        SELECT 0 as "DataFlag",0 as "SalaryId",0 as "VoucherId",'''' as "LedgerName" ,'''' as "UserName"
        ,'''' as "Mobile",'''' as "Address",'''' as "LoginStatus",'''' as "LoginName"
        ,'''' as "LoginType",0 as "RoleId",'''' as "RoleName",0 as "Closing"
        ,'''' as "SalaryDate"
        ,0 as "LedgerId",0 as "SalaryMonth",0 as "SalaryYear"
        ,0 as "WorkingDays",0 as "TotalDays",0 as "Absent",0 as "PaidLeave"
        ,0 as "Present",0 as "TotalEntryCount"
        ,0 as "BasicSalary"
        ';

    v_sBottom := '
        SELECT 2 as "DataFlag",0 as "SalaryId",0 as "VoucherId",'''' as "LedgerName" ,'''' as "UserName"
        ,'''' as "Mobile",'''' as "Address",'''' as "LoginStatus",'''' as "LoginName"
        ,'''' as "LoginType",0 as "RoleId",'''' as "RoleName",0 as "Closing"
        ,'''' as "SalaryDate"
        ,0 as "LedgerId",0 as "SalaryMonth",0 as "SalaryYear"
        ,sum(coalesce(payroll_salary."WorkingDays",0)) as "WorkingDays"
        ,sum(coalesce(payroll_salary."TotalDays",0)) as "TotalDays"
        ,sum(coalesce(payroll_salary."Absent",0)) as "Absent"
        ,sum(coalesce(payroll_salary."PaidLeave",0)) as "PaidLeave"
        ,sum(coalesce(payroll_salary."Present",0)) as "Present"
        ,sum(coalesce(payroll_salary."TotalEntryCount",0)) as "TotalEntryCount"
        ,sum(round(payroll_salary."BasicSalary",0)) as "BasicSalary"
        ';

    v_sBottomInner := '
        from (
            SELECT
            (coalesce(payroll_salary."WorkingDays",0)) as "WorkingDays"
            ,(coalesce(payroll_salary."TotalDays",0)) as "TotalDays"
            ,(coalesce(payroll_salary."Absent",0)) as "Absent"
            ,(coalesce(payroll_salary."PaidLeave",0)) as "PaidLeave"
            ,(coalesce(payroll_salary."Present",0)) as "Present"
            ,(coalesce(payroll_salary."TotalEntryCount",0)) as "TotalEntryCount"
            ,(round(payroll_salary."BasicSalary"::numeric,0)) as "BasicSalary"
        ';

    FOR rec IN
        SELECT pcm."CommanMasterId" AS id, pcm."CommanName" AS name
        FROM "payroll_comman_master" pcm
        WHERE pcm."RecordStatus" != 'D'
          AND (pcm."OrganizationId" = varOrganizationId OR pcm."OrganizationId" = 0)
          AND COALESCE(pcm."IsAllow", 0) = 1
          AND COALESCE(pcm."CommanType", 0) = 2
        ORDER BY pcm."CommanOrder"
    LOOP
        v_s := v_s || '
            ,' || quote_literal(rec.name) || ' as "Earning' || intRow::text || '"
            ,round(sum(case when payroll_salary_detail."CommanMasterId" = ' || rec.id::text || ' then payroll_salary_detail."Amount" else 0 end)::numeric,0) as "EarningAmount' || intRow::text || '"
            ';
        v_sTemp := v_sTemp || '
            ,' || quote_literal(rec.name) || ' as "Earning' || intRow::text || '"
            ,' || rec.id::text || ' as "EarningAmount' || intRow::text || '"
            ';
        v_sBottom := v_sBottom || '
            ,' || quote_literal(rec.name) || ' as "Earning' || intRow::text || '"
            ,round(sum(payroll_salary."EarningAmount' || intRow::text || '"),0) as "EarningAmount' || intRow::text || '"
            ';
        v_sBottomInner := v_sBottomInner || '
            ,' || quote_literal(rec.name) || ' as "Earning' || intRow::text || '"
            ,round(sum(case when payroll_salary_detail."CommanMasterId" = ' || rec.id::text || ' then payroll_salary_detail."Amount" else 0 end)::numeric,0) as "EarningAmount' || intRow::text || '"
            ';
        intRow := intRow + 1;
    END LOOP;

    -- ---------------- deductions ----------------
    intRow := 1;

    v_s := v_s || '
            ,round((coalesce(payroll_salary."BasicSalary",0) + coalesce(payroll_salary."Allowances",0))::numeric,0) as "GrossAmount"
        ';
    v_sTemp := v_sTemp || '
            ,0 as "GrossAmount"
        ';
    v_sBottom := v_sBottom || '
            ,sum(round((coalesce(payroll_salary."GrossAmount",0)),0)) as "GrossAmount"
        ';
    v_sBottomInner := v_sBottomInner || '
            ,(round((coalesce(payroll_salary."BasicSalary",0) + coalesce(payroll_salary."Allowances",0))::numeric,0)) as "GrossAmount"
        ';

    FOR rec IN
        SELECT pcm."CommanMasterId" AS id, pcm."CommanName" AS name
        FROM "payroll_comman_master" pcm
        WHERE pcm."RecordStatus" != 'D'
          AND (pcm."OrganizationId" = varOrganizationId OR pcm."OrganizationId" = 0)
          AND COALESCE(pcm."IsAllow", 0) = 1
          AND COALESCE(pcm."CommanType", 0) = 3
        ORDER BY pcm."CommanOrder"
    LOOP
        v_s := v_s || '
            ,' || quote_literal(rec.name) || ' as "Deduction' || intRow::text || '"
            ,round(sum(case when payroll_salary_detail."CommanMasterId" = ' || rec.id::text || ' then payroll_salary_detail."Amount" else 0 end)::numeric,0) as "DeductionAmount' || intRow::text || '"
            ';
        v_sTemp := v_sTemp || '
            ,' || quote_literal(rec.name) || ' as "Deduction' || intRow::text || '"
            ,' || rec.id::text || ' as "DeductionAmount' || intRow::text || '"
            ';
        v_sBottom := v_sBottom || '
            ,' || quote_literal(rec.name) || ' as "Deduction' || intRow::text || '"
            ,round(sum(payroll_salary."DeductionAmount' || intRow::text || '"),0) as "DeductionAmount' || intRow::text || '"
            ';
        v_sBottomInner := v_sBottomInner || '
            ,' || quote_literal(rec.name) || ' as "Deduction' || intRow::text || '"
            ,round(sum(case when payroll_salary_detail."CommanMasterId" = ' || rec.id::text || ' then payroll_salary_detail."Amount" else 0 end)::numeric,0) as "DeductionAmount' || intRow::text || '"
            ';
        intRow := intRow + 1;
    END LOOP;

    v_s := v_s || '
            ,round(payroll_salary."Deductions"::numeric,0) as "Deductions",round(payroll_salary."NetSalary"::numeric,0) as "NetSalary",payroll_salary."Remark"
            ,payroll_salary."RecordStatus",payroll_salary."AddedBy"
            ,payroll_salary."AddedDate"::text as "AddedDate",payroll_salary."UpdatedBy",payroll_salary."UpdatedDate"::text as "UpdatedDate"
        ';
    v_sTemp := v_sTemp || '
            ,0 as "Deductions",0 as "NetSalary"
            ,'''' as "Remark"
            ,'''' as "RecordStatus",'''' as "AddedBy"
            ,'''' as "AddedDate",'''' as "UpdatedBy",'''' as "UpdatedDate"
        ';
    v_sBottom := v_sBottom || '
            ,sum(round(payroll_salary."Deductions",0)) as "Deductions"
            ,sum(round(payroll_salary."NetSalary",0)) as "NetSalary"
            ,'''' as "Remark"
            ,'''' as "RecordStatus",'''' as "AddedBy"
            ,'''' as "AddedDate",'''' as "UpdatedBy",'''' as "UpdatedDate"
        ';
    v_sBottomInner := v_sBottomInner || '
            ,(round(payroll_salary."Deductions"::numeric,0)) as "Deductions"
            ,(round(payroll_salary."NetSalary"::numeric,0)) as "NetSalary"
        ';

    -- shared WHERE (NULL-propagating like MySQL CONCAT)
    v_where := '
        where (payroll_salary."OrganizationId" = ' || varOrganizationId::text || ' )
        and payroll_salary."RecordStatus" != ''D''
        and (case when ' || COALESCE(varMonth, 0)::text || ' = 0 or ' || COALESCE(varYear, 0)::text || ' = 0
                then payroll_salary."SalaryDate" between ' || quote_literal(varFromDate::text) || ' and ' || quote_literal(varToDate::text) || ' else
                    payroll_salary."SalaryMonth" = ' || varMonth::text || '
                    and payroll_salary."SalaryYear" = ' || varYear::text || '
            end)
        and (payroll_salary."LedgerId" = ' || varLedgerId::text || ' or ' || COALESCE(varLedgerId, 0)::text || ' = 0 )
        and (
            (case when ledger."GroupId" in (3,4,5) then
                    (coalesce(agent."LedgerId",0) = ' || COALESCE(varAgentLedgerId, 0)::text || ' or ' || COALESCE(varAgentLedgerId, 0)::text || ' = 0)
                else
                    (coalesce(ledger."AgentLedgerId",0) = ' || COALESCE(varAgentLedgerId, 0)::text || ' or ' || COALESCE(varAgentLedgerId, 0)::text || ' = 0)
                end
            )
        )';

    v_s := v_s || '
        from "payroll_salary" payroll_salary
        left join "payroll_salary_detail" payroll_salary_detail on payroll_salary_detail."SalaryId" = payroll_salary."SalaryId"
        left join "payroll_staff_structure" payroll_staff_structure on payroll_staff_structure."LedgerId" = payroll_salary."LedgerId"
                and payroll_staff_structure."CommanMasterId" = 1 and payroll_staff_structure."RecordStatus" != ''D''
        left join "ledger" ledger on ledger."LedgerId" = payroll_salary."LedgerId"
        left join "login" login on login."LedgerId" = ledger."LedgerId"
        left join "role" role on role."RoleId" = login."LoginType" and role."RecordStatus" != ''D'' and role."OrganizationId" = ' || varOrganizationId::text || '
        left join "comman_master" agent on agent."CommanMasterId" = ledger."AgentLedgerId" and agent."CommanMasterType" = 1
        inner join "ledger_limit" ledger_limit on ledger_limit."LedgerId" = ledger."LedgerId" and ledger_limit."RecordStatus" != ''D''
        ' || v_where || '
        group by
            payroll_salary."SalaryId",ledger."LedgerName",login."UserName",login."UserName"
            ,payroll_salary."SalaryDate"
            ,payroll_salary."LedgerId",payroll_salary."SalaryMonth",payroll_salary."SalaryYear"
            ,payroll_salary."WorkingDays",payroll_salary."Present",payroll_salary."TotalEntryCount"
            ,payroll_salary."BasicSalary",payroll_salary."Allowances"
            ,payroll_salary."Deductions",payroll_salary."NetSalary",payroll_salary."Remark"
            ,payroll_salary."RecordStatus",payroll_salary."AddedBy"
            ,payroll_salary."AddedDate",payroll_salary."UpdatedBy",payroll_salary."UpdatedDate"
        ';

    v_sBottom := v_sBottom || '
            ' || v_sBottomInner || '
            from "payroll_salary" payroll_salary
            left join "payroll_salary_detail" payroll_salary_detail on payroll_salary_detail."SalaryId" = payroll_salary."SalaryId"
            left join "ledger" ledger on ledger."LedgerId" = payroll_salary."LedgerId"
            left join "comman_master" agent on agent."CommanMasterId" = ledger."AgentLedgerId" and agent."CommanMasterType" = 1
            ' || v_where || '
            group by payroll_salary."SalaryId"
            ,payroll_salary."WorkingDays"
            ,payroll_salary."TotalDays"
            ,payroll_salary."Absent"
            ,payroll_salary."PaidLeave"
            ,payroll_salary."Present"
            ,payroll_salary."TotalEntryCount"
            ,payroll_salary."BasicSalary"
            ,payroll_salary."Deductions"
            ,payroll_salary."NetSalary"
        ) as payroll_salary
        order by "DataFlag","LedgerName","UserName","SalaryYear","SalaryMonth"
        ';

    v_s := v_sTemp || '
            union all
            ' || v_s || '
            union all
            ' || v_sBottom;

    -- TODO(convert): dynamic SQL, not statically checked by plpgsql_check.
    EXECUTE 'SELECT coalesce(jsonb_agg(t ORDER BY t."DataFlag", t."LedgerName", t."UserName", t."SalaryYear", t."SalaryMonth"), ''[]''::jsonb) FROM ('
            || v_s || ') t'
    INTO v_rows;

    RETURN jsonb_build_array(v_rows);
END;
$$;
