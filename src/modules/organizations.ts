import { Elysia, t } from "elysia";
import { asc, ne, sql } from "drizzle-orm";
import { db } from "../db";
import { organization } from "../db/legacy";

// Until auth exists, records are attributed to the system user.
const SYSTEM_USER = "SYSTEM";

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

type OrganizationRow = { [K in keyof typeof listColumns]: (typeof listColumns)[K]["_"]["data"] };

// "2020-09-22 10:44:18.123" -> "2020-09-22T10:44:18" (local time, no zone, as stored)
const toIsoLocal = (value: string) => value.replace(" ", "T").replace(/\.\d+$/, "");
const serialize = (row: OrganizationRow) => ({ ...row, AddedDate: toIsoLocal(row.AddedDate) });

const upper = (value: string) => value.trim().toUpperCase();

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

const CreateOrganizationBody = t.Object({
  OrganizationName: t.String({ minLength: 1, maxLength: 30, error: "Organization name is required (max 30 characters)" }),
  OrganizationOwnerName: t.String({ minLength: 1, maxLength: 30, error: "Owner name is required (max 30 characters)" }),
  OrganizationMobile: t.String({ pattern: "^[0-9]{10}$", error: "Mobile must be 10 digits" }),
  OrganizationAddress: t.String({ minLength: 1, maxLength: 60, error: "Address is required (max 60 characters)" }),
  OrganizationTheme: t.String({ minLength: 1, maxLength: 20, error: "Theme is required" }),
});

export const organizations = new Elysia({ prefix: "/organizations", tags: ["Organizations"] })
  .get(
    "/",
    async () => {
      const rows = await db
        .select(listColumns)
        .from(organization)
        .where(ne(organization.RecordStatus, "D"))
        .orderBy(asc(organization.OrganizationId));
      return rows.map(serialize);
    },
    { response: t.Array(OrganizationListItem), detail: { summary: "List organizations" } },
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
  );
