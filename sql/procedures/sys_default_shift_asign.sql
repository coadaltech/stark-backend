-- Converted from MySQL procedure `sys_default_shift_asign`.
DROP ROUTINE IF EXISTS "sys_default_shift_asign";
CREATE OR REPLACE PROCEDURE "sys_default_shift_asign"(
    varOrganization integer
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO "shift" ("OrganizationId", "ShiftName", "ShiftDate", "ShiftNextDay", "ShiftFor", "IsActive", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    VALUES (varOrganization, 'GALI', current_date, 'No', 'BOTH', '1', 'S', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp);

    INSERT INTO "shift" ("OrganizationId", "ShiftName", "ShiftDate", "ShiftNextDay", "ShiftFor", "IsActive", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    VALUES (varOrganization, 'DESHAWER', current_date, 'Yes', 'BOTH', '1', 'S', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp);

    INSERT INTO "shift" ("OrganizationId", "ShiftName", "ShiftDate", "ShiftNextDay", "ShiftFor", "IsActive", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    VALUES (varOrganization, 'GHAZIABAD', current_date, 'No', 'BOTH', '1', 'S', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp);

    INSERT INTO "shift" ("OrganizationId", "ShiftName", "ShiftDate", "ShiftNextDay", "ShiftFor", "IsActive", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    VALUES (varOrganization, 'PUNJAB DAY', current_date, 'No', 'BOTH', '1', 'S', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp);

    INSERT INTO "shift" ("OrganizationId", "ShiftName", "ShiftDate", "ShiftNextDay", "ShiftFor", "IsActive", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    VALUES (varOrganization, 'DELHI NOON', current_date, 'No', 'BOTH', '1', 'S', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp);

    INSERT INTO "shift" ("OrganizationId", "ShiftName", "ShiftDate", "ShiftNextDay", "ShiftFor", "IsActive", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    VALUES (varOrganization, 'NEW FARIDABAD', current_date, 'No', 'BOTH', '1', 'S', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp);

    INSERT INTO "shift" ("OrganizationId", "ShiftName", "ShiftDate", "ShiftNextDay", "ShiftFor", "IsActive", "RecordStatus", "AddedBy", "AddedDate", "UpdatedBy", "UpdatedDate")
    VALUES (varOrganization, 'DELHI TIME', current_date, 'No', 'BOTH', '1', 'S', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp);
END;
$$;
