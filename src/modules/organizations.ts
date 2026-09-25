import { Elysia, t } from "elysia";
import { and, asc, eq, ne, sql } from "drizzle-orm";
import { db } from "../db";
import { organization } from "../db/legacy";

// Until auth exists, records are attributed to the system user.
const SYSTEM_USER = "SYSTEM";

// Allowed values; keep in sync with the frontend select options.
const THEMES = ["Green"] as const;
const APP_ACCESS = [0] as const; // 0 = DYNAMIC

const listColumns = {
  OrganizationId: organization.OrganizationId,
  OrganizationName: organization.OrganizationName,
  OrganizationOwnerName: organization.OrganizationOwnerName,
  OrganizationMobile: organization.OrganizationMobile,
  OrganizationAddress: organization.OrganizationAddress,
  OrganizationStartDate: organization.OrganizationStartDate,
  OrganizationEndDate: organization.OrganizationEndDate,
  AddedBy: organization.AddedBy,
  AddedDate: organization.AddedDate,
};

const detailColumns = {
  ...listColumns,
  OrganizationTheme: organization.OrganizationTheme,
  OrganizationAppAccess: sql<number>`coalesce(${organization.OrganizationAppAccess}, 0)`.mapWith(Number),
};

// "2020-09-22 10:44:18.123" -> "2020-09-22T10:44:18" (local time, no zone, as stored)
const toIsoLocal = (value: string) => value.replace(" ", "T").replace(/\.\d+$/, "");
const serialize = <R extends { AddedDate: string }>(row: R) => ({ ...row, AddedDate: toIsoLocal(row.AddedDate) });

const upper = (value: string) => value.trim().toUpperCase();

const notDeleted = ne(organization.RecordStatus, "D");

// Field schemas shared by create and update.
const fields = {
  OrganizationName: t.String({ minLength: 1, maxLength: 30, error: "Organization name is required (max 30 characters)" }),
  OrganizationOwnerName: t.String({ minLength: 1, maxLength: 30, error: "Owner name is required (max 30 characters)" }),
  OrganizationMobile: t.String({ pattern: "^[0-9]{10}$", error: "Mobile must be 10 digits" }),
  OrganizationAddress: t.String({ minLength: 1, maxLength: 60, error: "Address is required (max 60 characters)" }),
  // Literal unions, not t.UnionEnum: Elysia fills UnionEnum fields with a default value when
  // they are missing, which would make every partial PATCH overwrite Theme/App Access.
  OrganizationTheme: t.Union(THEMES.map((v) => t.Literal(v)), { error: `Theme must be one of: ${THEMES.join(", ")}` }),
  OrganizationAppAccess: t.Union(APP_ACCESS.map((v) => t.Literal(v)), { error: "Invalid app access" }),
};

const OrganizationListItem = t.Object({
  OrganizationId: t.Number(),
  OrganizationName: t.String(),
  OrganizationOwnerName: t.String(),
  OrganizationMobile: t.String(),
  OrganizationAddress: t.String(),
  OrganizationStartDate: t.String({ format: "date" }),
  OrganizationEndDate: t.String({ format: "date" }),
  AddedBy: t.String(),
  AddedDate: t.String(),
});

const OrganizationDetail = t.Composite([
  OrganizationListItem,
  t.Object({ OrganizationTheme: t.String(), OrganizationAppAccess: t.Number() }),
]);

const CreateOrganizationBody = t.Object({
  OrganizationName: fields.OrganizationName,
  OrganizationOwnerName: fields.OrganizationOwnerName,
  OrganizationMobile: fields.OrganizationMobile,
  OrganizationAddress: fields.OrganizationAddress,
  OrganizationTheme: fields.OrganizationTheme,
});

// Each Edit tab sends only its own fields; add later tabs' fields here.
const UpdateOrganizationBody = t.Partial(t.Object(fields));

const IdParams = t.Object({ id: t.Numeric({ minimum: 1, error: "Invalid organization id" }) });
const NotFound = t.Object({ message: t.String() });
const Unprocessable = t.Object({ message: t.String(), fields: t.Record(t.String(), t.String()) });
const notFound = { message: "Organization not found" };

export const organizations = new Elysia({ prefix: "/organizations", tags: ["Organizations"] })
  .get(
    "/",
    async () => {
      const rows = await db
        .select(listColumns)
        .from(organization)
        .where(notDeleted)
        .orderBy(asc(organization.OrganizationId));
      return rows.map(serialize);
    },
    { response: t.Array(OrganizationListItem), detail: { summary: "List organizations" } },
  )
  .get(
    "/:id",
    async ({ params, status }) => {
      const [row] = await db
        .select(detailColumns)
        .from(organization)
        .where(and(eq(organization.OrganizationId, params.id), notDeleted));
      return row ? serialize(row) : status(404, notFound);
    },
    {
      params: IdParams,
      response: { 200: OrganizationDetail, 404: NotFound },
      detail: { summary: "Get an organization" },
    },
  )
  .post(
    "/",
    async ({ body, status }) => {
      const [row] = await db
        .insert(organization)
        .values({
          OrganizationName: upper(body.OrganizationName),
          OrganizationOwnerName: upper(body.OrganizationOwnerName),
          OrganizationMobile: body.OrganizationMobile,
          OrganizationAddress: upper(body.OrganizationAddress),
          OrganizationTheme: body.OrganizationTheme,
          // Not captured by the add form yet; legacy columns are NOT NULL.
          OrganizationLogoColor: "",
          OrganizationSms: "0",
          OrganizationSmsUrl: "",
          OrganizationSmsUsername: "",
          OrganizationSmsPassword: "",
          OrganizationSmsPort: "",
          OrganizationSmsSenderId: "",
          OrganizationSmsToken: "",
          IsTransactionEnable: "1",
          IsOrganizationAllow: "1",
          // One-year subscription from today, as in the legacy data.
          OrganizationStartDate: sql`current_date`,
          OrganizationEndDate: sql`(current_date + interval '1 year')::date`,
          RecordStatus: "A",
          AddedBy: SYSTEM_USER,
          AddedDate: sql`localtimestamp`,
          UpdatedBy: SYSTEM_USER,
          UpdatedDate: sql`localtimestamp`,
        })
        .returning(listColumns);
      return status(201, serialize(row!));
    },
    {
      body: CreateOrganizationBody,
      response: { 201: OrganizationListItem },
      detail: { summary: "Create an organization" },
    },
  )
  .patch(
    "/:id",
    async ({ params, body, status }) => {
      const changes: Partial<typeof organization.$inferInsert> = {};
      if (body.OrganizationName !== undefined) changes.OrganizationName = upper(body.OrganizationName);
      if (body.OrganizationOwnerName !== undefined) changes.OrganizationOwnerName = upper(body.OrganizationOwnerName);
      if (body.OrganizationMobile !== undefined) changes.OrganizationMobile = body.OrganizationMobile;
      if (body.OrganizationAddress !== undefined) changes.OrganizationAddress = upper(body.OrganizationAddress);
      if (body.OrganizationTheme !== undefined) changes.OrganizationTheme = body.OrganizationTheme;
      if (body.OrganizationAppAccess !== undefined) changes.OrganizationAppAccess = body.OrganizationAppAccess;
      if (Object.keys(changes).length === 0) {
        return status(422, { message: "Provide at least one field to update.", fields: {} });
      }

      const [row] = await db
        .update(organization)
        .set({ ...changes, UpdatedBy: SYSTEM_USER, UpdatedDate: sql`localtimestamp` })
        .where(and(eq(organization.OrganizationId, params.id), notDeleted))
        .returning(detailColumns);
      return row ? serialize(row) : status(404, notFound);
    },
    {
      params: IdParams,
      body: UpdateOrganizationBody,
      response: { 200: OrganizationDetail, 404: NotFound, 422: Unprocessable },
      detail: { summary: "Update an organization (partial)" },
    },
  );
