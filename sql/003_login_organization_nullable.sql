-- login."OrganizationId" is NULL for platform accounts (DEVELOPER); staff rows hold their organization.
-- See stark-frontend/specs/001_Auth_Org_Sites_Staff.md §4.1.
ALTER TABLE "login" ALTER COLUMN "OrganizationId" DROP NOT NULL;
