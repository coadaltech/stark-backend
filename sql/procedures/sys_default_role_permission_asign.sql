-- Converted from MySQL procedure `sys_default_role_permission_asign`.
DROP ROUTINE IF EXISTS "sys_default_role_permission_asign";
CREATE OR REPLACE PROCEDURE "sys_default_role_permission_asign"(varOrganization integer)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO "role_permission"("OrganizationId","RoleId","MenuId","Title","Page","IsPageAllow","IsOption","Add","Edit","Delete","Export","ViewType","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
    SELECT varOrganization, srp."RoleId", srp."MenuId", srp."Title", srp."Page", srp."IsPageAllow", srp."IsOption", srp."Add", srp."Edit", srp."Delete", srp."Export", srp."ViewType", 'S', 'SYSTEM', localtimestamp, 'SYSTEM', localtimestamp
    FROM "sys_role_permission" srp;
END;
$$;
