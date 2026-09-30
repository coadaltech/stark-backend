import { Elysia, t } from "elysia";
import { and, eq, ne, sql } from "drizzle-orm";
import { db } from "../db";
import { organization } from "../db/legacy";
import { env } from "../env";
import { isValidHost, normalizeHost } from "../sites/host";

const NOT_FOUND = { message: "Site not found" } as const;

/**
 * Which site a host belongs to (spec §5.3). Public: the frontend asks before it knows who is signed in,
 * and it only reveals what that host's own site shows anyway.
 */
export const sites = new Elysia({ prefix: "/sites" }).get(
  "/resolve",
  async ({ query, status }) => {
    const host = normalizeHost(query.host);
    if (host === env.MAIN_APP_HOST) return { kind: "main" as const };
    if (!isValidHost(host)) return status(404, NOT_FOUND);

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
    if (!org) return status(404, NOT_FOUND);
    return { kind: "organization" as const, organizationId: org.organizationId, name: org.name };
  },
  {
    query: t.Object({ host: t.String({ minLength: 1, maxLength: 300, error: "Host is required" }) }),
    response: {
      200: t.Union([
        t.Object({ kind: t.Literal("main") }),
        t.Object({ kind: t.Literal("organization"), organizationId: t.Number(), name: t.String() }),
      ]),
      404: t.Object({ message: t.String() }),
    },
    detail: { summary: "Which site a host belongs to (main app, an organization, or none)" },
  },
);
