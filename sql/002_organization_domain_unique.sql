-- A domain can belong to only one (non-deleted) organization, ignoring case.
-- Blank domains are not constrained. The API checks this too; the index closes races between saves.
CREATE UNIQUE INDEX IF NOT EXISTS "organization_domain_url_key"
  ON "organization" (lower("OrganizationDomainURL"))
  WHERE "OrganizationDomainURL" <> '' AND "RecordStatus" <> 'D';
