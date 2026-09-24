-- Converted from MySQL procedure `sys_OrganizationDeleteData`.
DROP ROUTINE IF EXISTS "sys_OrganizationDeleteData";
CREATE OR REPLACE PROCEDURE "sys_OrganizationDeleteData"(varOrganizationId bigint)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM "transaction" t
    WHERE t."OrganizationId" = varOrganizationId;

    DELETE FROM "transaction_detail" t
    WHERE t."OrganizationId" = varOrganizationId;

    DELETE FROM "transaction_declare" t
    WHERE t."OrganizationId" = varOrganizationId;

    DELETE FROM "transaction_detail_declare" t
    WHERE t."OrganizationId" = varOrganizationId;

    DELETE FROM "transaction_narration" t
    WHERE t."OrganizationId" = varOrganizationId;

    DELETE FROM "transaction_narration_declare" t
    WHERE t."OrganizationId" = varOrganizationId;

    DELETE FROM "voucher" t
    WHERE t."OrganizationId" = varOrganizationId;

    DELETE FROM "voucher_detail" t
    WHERE t."OrganizationId" = varOrganizationId;
END;
$$;
