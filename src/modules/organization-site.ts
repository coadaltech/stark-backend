import { Elysia, t } from "elysia";
import { and, count, eq, ne } from "drizzle-orm";
import { db } from "../db";
import { login, organization } from "../db/legacy";
import { organizationSiteGuard } from "../auth/guard";

/** API for organization sites; every route works on the signed-in site's organization only. */
export const organizationSite = new Elysia({ prefix: "/site", tags: ["Organization site"] })
  .use(organizationSiteGuard)
  .get(
    "/organization-info",
    async ({ organizationId, status }) => {
      const [org] = await db
        .select({ name: organization.OrganizationName })
        .from(organization)
        .where(and(eq(organization.OrganizationId, organizationId), ne(organization.RecordStatus, "D")));
      if (!org) return status(404, { message: "Organization not found" });
      // Every staff account of the organization that isn't deleted, active or not. Developers have no
      // organization, so they never count.
      const [staff] = await db
        .select({ total: count() })
        .from(login)
        .where(and(eq(login.OrganizationId, organizationId), ne(login.RecordStatus, "D")));
      return { organizationId, name: org.name, totalStaff: staff?.total ?? 0 };
    },
    {
      response: {
        200: t.Object({ organizationId: t.Number(), name: t.String(), totalStaff: t.Number() }),
        404: t.Object({ message: t.String() }),
      },
      detail: { summary: "The signed-in site's organization: name, id and total staff" },
    },
  );
