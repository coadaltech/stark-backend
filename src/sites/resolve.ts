import { and, eq, ne, sql } from "drizzle-orm";
import { db } from "../db";
import { organization } from "../db/legacy";
import { env } from "../env";
import { isValidHost, normalizeHost } from "./host";

export type Site =
  | { kind: "main" }
  | { kind: "organization"; organizationId: number; name: string };

/**
 * The site a host belongs to (spec §5.3), or null ("Site not found"): the main app host, or an
 * organization whose Domain URL equals the host with Domain ON and not deleted.
 */
export async function resolveHost(rawHost: string): Promise<Site | null> {
  const host = normalizeHost(rawHost);
  if (host === env.MAIN_APP_HOST) return { kind: "main" };
  if (!isValidHost(host)) return null;
  const [org] = await db
    .select({ organizationId: organization.OrganizationId, name: organization.OrganizationName })
    .from(organization)
    .where(
      and(
        sql`lower(${organization.OrganizationDomainURL}) = ${host}`,
        eq(organization.OrganizationOnDomain, 1),
        ne(organization.RecordStatus, "D"),
      ),
    )
    .limit(1);
  return org ? { kind: "organization", ...org } : null;
}
