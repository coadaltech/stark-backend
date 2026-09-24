-- Converted from MySQL procedure `payroll_sys_staff_salary_create`.
-- Cursors -> FOR loops. MySQL `float` locals (single precision) are double precision here, per conversion rules.
DROP ROUTINE IF EXISTS "payroll_sys_staff_salary_create";
CREATE OR REPLACE FUNCTION "payroll_sys_staff_salary_create"(
    varOrganizationId integer,
    varMonth integer,
    varYear integer,
    varLedgerId bigint
)
RETURNS TABLE("Flag" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    rec_org record;
    rec_led record;
    rec_sd record;
    rec_kist record;

    varSalaryId bigint;
    varLoopLedgerId bigint;
    varRoleId bigint;
    varAttendance integer;
    varMonthEndLeaveApplicable integer;
    varWorkingDays integer;
    varTotalDays integer;
    varAbsent integer;
    varPaidLeave integer;
    varEntryCount integer;
    varSalaryCommanMasterId integer;

    varBasicSalaryAmount double precision;
    varNetAmount double precision;
    varTotalAllowance double precision;
    varTotalDeduction double precision;

    varCommanMasterId bigint;
    varAmount double precision;
    varAmountType integer;
    varCommanOrder integer;
    varCommanType integer;
    varKistId bigint;
BEGIN
    IF EXISTS (SELECT ps."SalaryId" FROM "payroll_salary" ps
               WHERE ps."OrganizationId" = varOrganizationId
                 AND ps."SalaryMonth" = varMonth
                 AND ps."SalaryYear" = varYear
                 AND COALESCE(ps."VoucherId", 0) != 0
                 AND (COALESCE(ps."LedgerId", 0) = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
              ) THEN
        RETURN QUERY SELECT 0 AS "Flag";
    ELSE
        FOR rec_org IN
            SELECT o."OrganizationId" FROM "organization" o
            WHERE (COALESCE(o."OrganizationId", 0) = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
              AND o."RecordStatus" != 'D'
              AND (COALESCE(o."IsAutoSalaryCreate", 0) = 1 OR COALESCE(varOrganizationId, 0) <> 0)
        LOOP
            varOrganizationId := rec_org."OrganizationId";

            varSalaryCommanMasterId := 100;
            varSalaryId := 0;

            DELETE FROM "payroll_salary_detail" psd
            WHERE psd."SalaryId" IN (SELECT ps."SalaryId" FROM "payroll_salary" ps
                                     WHERE ps."OrganizationId" = varOrganizationId
                                       AND (ps."LedgerId" = varLedgerId OR varLedgerId = 0)
                                       AND ps."SalaryMonth" = varMonth
                                       AND ps."SalaryYear" = varYear);
            DELETE FROM "payroll_salary" ps
            WHERE ps."OrganizationId" = varOrganizationId
              AND (ps."LedgerId" = varLedgerId OR varLedgerId = 0)
              AND ps."SalaryMonth" = varMonth
              AND ps."SalaryYear" = varYear;

            /*
            salary not created for
            (RoleId not equal to 1,3,4,5)
            or Group Id = 2 & 7
            */
            FOR rec_led IN
                SELECT pa."LedgerId", lg."LoginType"
                    , COALESCE(pa."Present", 0) AS "Attendance"
                    , COALESCE(pa."MonthEndLeaveApplicable", 0) AS "MonthEndLeaveApplicable"
                    , pa."WorkingDays"
                    , pa."TotalDays"
                    , pa."Absent"
                    , pa."PaidLeave"
                    , pa."TotalEntryCount"
                FROM "payroll_attendance" pa
                LEFT JOIN "login" lg ON lg."LedgerId" = pa."LedgerId"
                WHERE (pa."OrganizationId" = varOrganizationId OR COALESCE(varOrganizationId, 0) = 0)
                  AND pa."AttendanceMonth" = varMonth
                  AND pa."AttendanceYear" = varYear
                  AND (pa."LedgerId" = varLedgerId OR COALESCE(varLedgerId, 0) = 0)
                ORDER BY pa."LedgerId"
            LOOP
                varLoopLedgerId := rec_led."LedgerId";
                varRoleId := rec_led."LoginType";
                varAttendance := rec_led."Attendance";
                varMonthEndLeaveApplicable := rec_led."MonthEndLeaveApplicable";
                varWorkingDays := rec_led."WorkingDays";
                varTotalDays := rec_led."TotalDays";
                varAbsent := rec_led."Absent";
                varPaidLeave := rec_led."PaidLeave";
                varEntryCount := rec_led."TotalEntryCount";

                /* Insert Salary Table */
                INSERT INTO "payroll_salary"("OrganizationId", "SalaryDate"
                    , "LedgerId", "SalaryMonth", "SalaryYear"
                    , "WorkingDays", "TotalDays", "Absent", "PaidLeave"
                    , "Present", "TotalEntryCount"
                    , "BasicSalary", "Allowances", "Deductions", "NetSalary", "Remark"
                    , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
                VALUES (varOrganizationId, current_date
                    , varLoopLedgerId, varMonth, varYear
                    , varWorkingDays, varTotalDays, varAbsent, varPaidLeave
                    , varAttendance, varEntryCount
                    , 0, 0, 0, 0, ''
                    , 'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp)
                RETURNING "SalaryId" INTO varSalaryId;

                /* Salary detail loop start from here */
                varBasicSalaryAmount := 0;
                varNetAmount := 0;
                varTotalAllowance := 0;
                varTotalDeduction := 0;
                IF varAttendance > 0 THEN
                    FOR rec_sd IN
                        SELECT pss."CommanMasterId", pss."Amount", pss."AmountType"
                            , pcm."CommanType", pcm."CommanOrder"
                        FROM "payroll_staff_structure" pss
                        JOIN "payroll_comman_master" pcm ON pcm."CommanMasterId" = pss."CommanMasterId"
                            AND pcm."RecordStatus" != 'D'
                        WHERE pss."LedgerId" = varLoopLedgerId
                          AND pss."OrganizationId" = varOrganizationId
                          -- and payroll_staff_structure.CommanMasterId <> varSalaryCommanMasterId
                          AND pss."RecordStatus" != 'D'
                        UNION ALL
                        SELECT pssd."CommanMasterId", pssd."Amount", pssd."AmountType"
                            , pcm."CommanType", pcm."CommanOrder"
                        FROM "payroll_staff_structure_default" pssd
                        JOIN "payroll_comman_master" pcm ON pcm."CommanMasterId" = pssd."CommanMasterId"
                        WHERE pssd."OrganizationId" = varOrganizationId
                          AND pssd."RoleId" = varRoleId
                          -- and payroll_staff_structure_default.CommanMasterId <> varSalaryCommanMasterId
                          AND pssd."RecordStatus" != 'D'
                        ORDER BY 1  -- CommanMasterId
                    LOOP
                        varCommanMasterId := rec_sd."CommanMasterId";
                        varAmount := rec_sd."Amount";
                        varAmountType := rec_sd."AmountType";
                        varCommanType := rec_sd."CommanType";
                        varCommanOrder := rec_sd."CommanOrder";

                        IF varCommanMasterId = 2 THEN
                            IF varRoleId = 11 OR varRoleId = 12 THEN
                                IF varMonthEndLeaveApplicable = 1 THEN
                                    varAmount := varAmount;
                                ELSE
                                    varAmount := 0;
                                END IF;
                            END IF;
                        ELSIF varCommanMasterId = 11 THEN
                            FOR rec_kist IN
                                SELECT k."Amount", k."KistId" FROM "kist" k
                                WHERE k."RecordStatus" = 'A'
                                  AND k."KistStatus" = 'UNPAID'
                                  -- and month(kist.KistDate) = varMonth
                                  AND k."KistDate" <= localtimestamp
                                  AND k."LedgerId" = varLoopLedgerId
                            LOOP
                                varAmount := rec_kist."Amount";
                                varKistId := rec_kist."KistId";

                                varTotalDeduction := varTotalDeduction + varAmount;
                                varNetAmount := varNetAmount - varAmount;

                                INSERT INTO "payroll_salary_detail"("OrganizationId", "SalaryId"
                                    , "CommanMasterId", "Amount", "KistId"
                                    , "DetailRemark"
                                    , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
                                VALUES (varOrganizationId, varSalaryId
                                    , varCommanMasterId, varAmount, varKistId
                                    , ''
                                    , 'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
                            END LOOP;
                        ELSE
                            IF varAmountType = 1 THEN
                                varAmount := varAmount;
                            ELSIF varAmountType = 2 THEN
                                varAmount := varAmount * varBasicSalaryAmount / 100;
                            ELSIF varAmountType = 3 THEN
                                varAmount := varAmount * varEntryCount;
                            END IF;
                        END IF;

                        IF varCommanMasterId != 11 THEN
                            IF varCommanMasterId = 1 THEN -- CommanMasterId of BasicSalary = 1
                                IF varTotalDays > 1 THEN
                                    varAmount := (varAmount * (varAttendance + varPaidLeave)) / (varTotalDays - 1);
                                    varBasicSalaryAmount := varAmount;
                                    varNetAmount := varNetAmount + varBasicSalaryAmount;
                                END IF;
                            ELSE
                                IF varCommanType = 2 THEN
                                    varTotalAllowance := varTotalAllowance + varAmount;
                                    varNetAmount := varNetAmount + varAmount;
                                ELSIF varCommanType = 3 THEN
                                    varTotalDeduction := varTotalDeduction + varAmount;
                                    varNetAmount := varNetAmount - varAmount;
                                END IF;
                            END IF;

                            /* Insert Salary Detail Table */
                            INSERT INTO "payroll_salary_detail"("OrganizationId", "SalaryId"
                                , "CommanMasterId", "Amount", "KistId"
                                , "DetailRemark"
                                , "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
                            VALUES (varOrganizationId, varSalaryId
                                , varCommanMasterId, varAmount, 0
                                , ''
                                , 'A', 'SERVER', localtimestamp, 'SERVER', localtimestamp);
                        END IF;
                    END LOOP;
                END IF;

                UPDATE "payroll_salary" ps SET "BasicSalary" = varBasicSalaryAmount
                    , "Allowances" = varTotalAllowance
                    , "Deductions" = varTotalDeduction
                    , "NetSalary" = varNetAmount
                WHERE ps."SalaryId" = varSalaryId;

                /* create voucher for salary */
                /*
                call payroll_sys_staff_salary_paid(varOrganizationId,varSalaryId);
                */
            END LOOP;
        END LOOP;

        RETURN QUERY SELECT 1 AS "Flag";
    END IF;
END;
$$;
