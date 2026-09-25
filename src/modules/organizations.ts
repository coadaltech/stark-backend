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
  OrganizationSms: organization.OrganizationSms,
  OrganizationSmsUrl: organization.OrganizationSmsUrl,
  OrganizationSmsUsername: organization.OrganizationSmsUsername,
  OrganizationSmsPassword: organization.OrganizationSmsPassword,
  OrganizationSmsSenderId: organization.OrganizationSmsSenderId,
  OrganizationSmsPort: organization.OrganizationSmsPort,
};

// SMS settings are validated together: when SMS is on, every connection field is needed.
const smsFields = {
  OrganizationSmsUrl: "SMS URL",
  OrganizationSmsUsername: "SMS username",
  OrganizationSmsPassword: "SMS password",
  OrganizationSmsSenderId: "SMS sender id",
  OrganizationSmsPort: "SMS port",
} as const;
type SmsSettings = { OrganizationSms: string } & Record<keyof typeof smsFields, string>;

function validateSms(sms: SmsSettings) {
  const errors: Record<string, string> = {};
  if (sms.OrganizationSms !== "1") return errors;
  for (const [key, label] of Object.entries(smsFields) as [keyof typeof smsFields, string][]) {
    if (!sms[key].trim()) errors[key] = `${label} is required when SMS is on`;
  }
  if (!errors.OrganizationSmsUrl && !/^https?:\/\/\S+$/i.test(sms.OrganizationSmsUrl)) {
    errors.OrganizationSmsUrl = "SMS URL must start with http:// or https://";
  }
  const port = Number(sms.OrganizationSmsPort);
  if (!errors.OrganizationSmsPort && !(/^\d+$/.test(sms.OrganizationSmsPort) && port >= 1 && port <= 65535)) {
    errors.OrganizationSmsPort = "SMS port must be a number from 1 to 65535";
  }
  return errors;
}

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
  OrganizationSms: t.Union([t.Literal("0"), t.Literal("1")], { error: "SMS must be on (1) or off (0)" }),
  OrganizationSmsUrl: t.String({ maxLength: 100, error: "SMS URL can be at most 100 characters" }),
  OrganizationSmsUsername: t.String({ maxLength: 30, error: "SMS username can be at most 30 characters" }),
  OrganizationSmsPassword: t.String({ maxLength: 30, error: "SMS password can be at most 30 characters" }),
  OrganizationSmsSenderId: t.String({ maxLength: 10, error: "SMS sender id can be at most 10 characters" }),
  OrganizationSmsPort: t.String({ maxLength: 10, error: "SMS port can be at most 10 characters" }),
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
  t.Object({
    OrganizationTheme: t.String(),
    OrganizationAppAccess: t.Number(),
    OrganizationSms: t.String(),
    OrganizationSmsUrl: t.String(),
    OrganizationSmsUsername: t.String(),
    OrganizationSmsPassword: t.String(),
    OrganizationSmsSenderId: t.String(),
    OrganizationSmsPort: t.String(),
  }),
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
      if (body.OrganizationSms !== undefined) changes.OrganizationSms = body.OrganizationSms;
      for (const key of Object.keys(smsFields) as (keyof typeof smsFields)[]) {
        const value = body[key];
        // The password is stored exactly as typed; the other SMS fields are trimmed.
        if (value !== undefined) changes[key] = key === "OrganizationSmsPassword" ? value : value.trim();
      }
      if (Object.keys(changes).length === 0) {
        return status(422, { message: "Provide at least one field to update.", fields: {} });
      }
      const touchesSms = "OrganizationSms" in changes || Object.keys(smsFields).some((key) => key in changes);
      const where = and(eq(organization.OrganizationId, params.id), notDeleted);

      const result = await db.transaction(async (tx) => {
        if (touchesSms) {
          // Validate the SMS settings as they will be after this update (saved values + changes).
          const [current] = await tx
            .select({
              OrganizationSms: organization.OrganizationSms,
              OrganizationSmsUrl: organization.OrganizationSmsUrl,
              OrganizationSmsUsername: organization.OrganizationSmsUsername,
              OrganizationSmsPassword: organization.OrganizationSmsPassword,
              OrganizationSmsSenderId: organization.OrganizationSmsSenderId,
              OrganizationSmsPort: organization.OrganizationSmsPort,
            })
            .from(organization)
            .where(where)
            .for("update");
          if (!current) return { kind: "not-found" } as const;
          const smsErrors = validateSms({ ...current, ...changes } as SmsSettings);
          if (Object.keys(smsErrors).length > 0) return { kind: "invalid", fields: smsErrors } as const;
        }
        const [row] = await tx
          .update(organization)
          .set({ ...changes, UpdatedBy: SYSTEM_USER, UpdatedDate: sql`localtimestamp` })
          .where(where)
          .returning(detailColumns);
        return row ? ({ kind: "ok", row } as const) : ({ kind: "not-found" } as const);
      });

      if (result.kind === "not-found") return status(404, notFound);
      if (result.kind === "invalid") {
        return status(422, { message: "Please correct the highlighted fields.", fields: result.fields });
      }
      return serialize(result.row);
    },
    {
      params: IdParams,
      body: UpdateOrganizationBody,
      response: { 200: OrganizationDetail, 404: NotFound, 422: Unprocessable },
      detail: { summary: "Update an organization (partial)" },
    },
  );
