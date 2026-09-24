-- Converted from MySQL procedure `config_page_permission_user_disable`.
DROP ROUTINE IF EXISTS "config_page_permission_user_disable";
CREATE OR REPLACE FUNCTION "config_page_permission_user_disable"(
    varOrganizationId integer,
    varRoleId integer,
    varRolePermissionId integer
)
RETURNS TABLE("LoginId" bigint, "UserName" text, "LoginName" text, "IsDisable" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT login."LoginId", login."UserName"::text, login."LoginName"::text,
           (CASE WHEN COALESCE(role_permission_denied."LoginId", 0) = 0 THEN 0 ELSE 1 END)::integer AS "IsDisable"
    FROM "login" login
    LEFT JOIN "role_permission_denied" role_permission_denied
           ON role_permission_denied."LoginId" = login."LoginId"
          AND role_permission_denied."RecordStatus" != 'D'
          AND role_permission_denied."RolePermissionId" = varRolePermissionId
    WHERE login."OrganizationId" = varOrganizationId
      AND login."LoginType" = varRoleId
      AND login."RecordStatus" != 'D';
END;
$$;
