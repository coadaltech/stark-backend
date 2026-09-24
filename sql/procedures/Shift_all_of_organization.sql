-- Converted from MySQL procedure `Shift_all_of_organization`.
DROP ROUTINE IF EXISTS "Shift_all_of_organization";
CREATE OR REPLACE FUNCTION "Shift_all_of_organization"(
    varOrganizationId integer,
    varShiftName varchar
)
RETURNS TABLE(
    "ShiftId" bigint,
    "ShiftName" text,
    "ShiftFor" text,
    "ShiftNextDay" text,
    "UpdatedBy" text,
    "ShiftDateDB" date,
    "IsActive" text,
    "DaraRate" double precision,
    "DaraCommission" double precision,
    "AkharRate" double precision,
    "AkharCommission" double precision,
    "Tax" double precision,
    "ShiftDate" text,
    "AddedDate" text,
    "UpdatedDate" text,
    "IsTransToCompany" integer,
    "CompanyApiUrl" text,
    "CompanyUserName" text,
    "CompanyPassword" text,
    "CompanyShiftId" bigint,
    "ApiTimeRebateForTransaction" text,
    "MainJantriTime" text,
    "IsTransactionCapping" smallint,
    "RoundOffOnCollection" smallint,
    "IsLagaiTransactionExist" smallint,
    "IsCreateVapsi" smallint,
    "IsApplyShiftConfigOnTransaction" integer,
    "ResultWebShiftId" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT s."ShiftId", s."ShiftName"::text, s."ShiftFor"::text, s."ShiftNextDay"::text, s."UpdatedBy"::text,
           s."ShiftDate" AS "ShiftDateDB", s."IsActive"::text,
           s."DaraRate", s."DaraCommission", s."AkharRate", s."AkharCommission", s."Tax",
           to_char(s."ShiftDate", 'DD-MM-YYYY') AS "ShiftDate",
           to_char(s."AddedDate", 'DD-MM-YYYY HH12:MI AM') AS "AddedDate",
           to_char(s."UpdatedDate", 'DD-MM-YYYY HH12:MI AM') AS "UpdatedDate",
           s."IsTransToCompany",
           s."CompanyApiUrl"::text,
           s."CompanyUserName"::text,
           s."CompanyPassword"::text,
           s."CompanyShiftId",
           s."ApiTimeRebateForTransaction"::text,
           s."MainJantriTime"::text,
           s."IsTransactionCapping",
           s."RoundOffOnCollection",
           s."IsLagaiTransactionExist",
           s."IsCreateVapsi",
           s."IsApplyShiftConfigOnTransaction",
           s."ResultWebShiftId"
    FROM "shift" s
    WHERE s."OrganizationId" = varOrganizationId
      AND (varShiftName IS NULL OR s."ShiftName" ILIKE ('%' || varShiftName || '%'))
      AND s."RecordStatus" != 'D'
    ORDER BY s."ShiftOrder", s."AddedDate" ASC;
END;
$$;
