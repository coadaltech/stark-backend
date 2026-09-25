import { Elysia, t } from "elysia";
import { and, asc, eq, ne, sql, type SQL } from "drizzle-orm";
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

// ---- Numeric settings (Config and Salary tabs) -------------------------------------------------------
// One entry per column: its validation schema and the value to report when the legacy
// column is NULL (the column default). Everything else (select, schemas, PATCH) derives from this.
const flag = (label: string) =>
  t.Union([t.Literal(0), t.Literal(1)], { error: `${label} must be 0 or 1` });
const choice = (label: string, values: readonly number[]) =>
  t.Union(
    values.map((v) => t.Literal(v)),
    { error: `${label} must be one of: ${values.join(", ")}` },
  );
const wholeNumber = (label: string, minimum: number, maximum: number) =>
  t.Integer({
    minimum,
    maximum,
    error: `${label} must be a whole number from ${minimum} to ${maximum}`,
  });

const configSettings = {
  IsEnableTazzaPatti: {
    schema: flag("Tazza Patti in Transaction"),
    fallback: 0,
  },
  IsMainJantriRoundOf: { schema: flag("Main Jantri Round Of"), fallback: 0 },
  IsCollectionJantriRoundOf: {
    schema: flag("Collection Jantri Round Of"),
    fallback: 0,
  },
  IsMultiplyUpMainJantri: { schema: flag("Show Up Main Jantri"), fallback: 0 },
  IsMultiplyUpCollection: {
    schema: flag("Show Up Collection Jantri"),
    fallback: 0,
  },
  IsVoucherVerify: { schema: flag("Voucher Verify"), fallback: 0 },
  IsDashboardStaffGainerLooser: {
    schema: flag("Dashboard Gainer/Looser"),
    fallback: 0,
  },
  IsTransactionAlreadyExist: {
    schema: flag("Check Transaction Exist"),
    fallback: 0,
  },
  IsAutoUserNameForStaff: { schema: flag("Staff Auto UserName"), fallback: 0 },
  UnPaidKistPopupForDashboard: {
    schema: flag("Kist On Dashboard"),
    fallback: 0,
  },
  // 0 = Disable, 1 = Ledger All, 2 = Ledger Without HPT
  IsBackLimitPopup: {
    schema: choice("Show Back Limit Popup", [0, 1, 2]),
    fallback: 0,
  },
  // 0 = All Apply, 1 = Uttar No, 2 = Jantri No
  HissaNotApplyMode: {
    schema: choice("Hissa Not Apply Mode", [0, 1, 2]),
    fallback: 0,
  },
  VapsiWorkingDays: {
    schema: wholeNumber("Vapsi Work Days", 0, 365),
    fallback: 0,
  },
  AbsentLedgerLockDays: {
    schema: wholeNumber("Absent Ledger Lock Days", 0, 365),
    fallback: 0,
  },
  // Salary tab
  IsAutoSalaryCreate: { schema: flag("Auto Salary Create"), fallback: 0 },
  IsAutoSalaryPaid: { schema: flag("Auto Salary Paid"), fallback: 0 },
  RoundOffOnMainJantri: {
    schema: wholeNumber("Main Jantri Round", 1, 10000),
    fallback: 50,
  },
  RoundOffOnCollection: {
    schema: wholeNumber("Collection Jantri Round", 1, 10000),
    fallback: 50,
  },
  skey_Random_Old: { schema: flag("Random Old"), fallback: 1 },
  skey_Crossing: { schema: flag("Crossing"), fallback: 1 },
  skey_FromTo: { schema: flag("From-To"), fallback: 1 },
  skey_Random_New: { schema: flag("Random New"), fallback: 1 },
  skey_OddEven: { schema: flag("Odd/Even"), fallback: 0 },
  skey_EkdiDukdi: { schema: flag("Ekdi/Dukdi"), fallback: 0 },
  skey_Joda: { schema: flag("Joda"), fallback: 0 },
  skey_JodiDaane: { schema: flag("JodiDaane"), fallback: 0 },
} as const;

type ConfigKey = keyof typeof configSettings;
const configKeys = Object.keys(configSettings) as ConfigKey[];

const configColumns = Object.fromEntries(
  configKeys.map((key) => [
    key,
    sql<number>`coalesce(${organization[key]}, ${configSettings[key].fallback})`.mapWith(
      Number,
    ),
  ]),
) as Record<ConfigKey, SQL<number>>;

const configSchemas = Object.fromEntries(
  configKeys.map((key) => [key, configSettings[key].schema]),
) as { [K in ConfigKey]: (typeof configSettings)[K]["schema"] };

const configResponse = Object.fromEntries(
  configKeys.map((key) => [key, t.Number()]),
) as Record<ConfigKey, ReturnType<typeof t.Number>>;
// ---------------------------------------------------------------------------------

const detailColumns = {
  ...listColumns,
  OrganizationTheme: organization.OrganizationTheme,
  OrganizationAppAccess:
    sql<number>`coalesce(${organization.OrganizationAppAccess}, 0)`.mapWith(
      Number,
    ),
  OrganizationSms: organization.OrganizationSms,
  OrganizationSmsUrl: organization.OrganizationSmsUrl,
  OrganizationSmsUsername: organization.OrganizationSmsUsername,
  OrganizationSmsPassword: organization.OrganizationSmsPassword,
  OrganizationSmsSenderId: organization.OrganizationSmsSenderId,
  OrganizationSmsPort: organization.OrganizationSmsPort,
  OrganizationOnDomain: organization.OrganizationOnDomain,
  OrganizationDomainURL: organization.OrganizationDomainURL,
  IsOrganizationAllow: organization.IsOrganizationAllow,
  TelegramAllow:
    sql<number>`coalesce(${organization.TelegramAllow}, 0)`.mapWith(Number),
  TelegramUrl: sql<string>`coalesce(${organization.TelegramUrl}, '')`,
  TelegramSession: sql<string>`coalesce(${organization.TelegramSession}, '')`,
  ...configColumns,
};

// SMS settings are validated together: when SMS is on, every connection field is needed.
const smsFields = {
  OrganizationSmsUrl: "SMS URL",
  OrganizationSmsUsername: "SMS username",
  OrganizationSmsPassword: "SMS password",
  OrganizationSmsSenderId: "SMS sender id",
  OrganizationSmsPort: "SMS port",
} as const;
type SmsSettings = { OrganizationSms: string } & Record<
  keyof typeof smsFields,
  string
>;

// Bare host name, e.g. "lgaikhai.com" or "app.lgaikhai.com" (no scheme, path or port).
// const DOMAIN_PATTERN =
//   /^(?=.{1,100}$)(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z]{2,63}$/;

type Tx = Parameters<Parameters<typeof db.transaction>[0]>[0];
type DomainSettings = {
  OrganizationOnDomain: number;
  OrganizationDomainURL: string;
};

/** Domain is required while ON, must be a bare host name, and can belong to only one organization. */
async function validateDomain(
  tx: Tx,
  organizationId: number,
  domain: DomainSettings,
): Promise<Record<string, string>> {
  const url = domain.OrganizationDomainURL;
  if (!url) {
    return domain.OrganizationOnDomain === 1
      ? { OrganizationDomainURL: "Domain URL is required when Domain is on" }
      : {};
  }
  // if (!DOMAIN_PATTERN.test(url)) {
  //   return { OrganizationDomainURL: "Enter a domain like example.com (no http://, path or port)" };
  // }
  const [taken] = await tx
    .select({ OrganizationName: organization.OrganizationName })
    .from(organization)
    .where(
      and(
        sql`lower(${organization.OrganizationDomainURL}) = ${url}`,
        ne(organization.OrganizationId, organizationId),
        notDeleted,
      ),
    )
    .limit(1);
  return taken
    ? {
        OrganizationDomainURL: `Domain already used by ${taken.OrganizationName}`,
      }
    : {};
}

/** True if the error is the unique-domain index rejecting a duplicate (e.g. two saves racing). */
function isDuplicateDomainError(error: unknown): boolean {
  for (
    let e: unknown = error;
    e && typeof e === "object";
    e = (e as { cause?: unknown }).cause
  ) {
    const pg = e as { code?: string; constraint_name?: string };
    if (
      pg.code === "23505" &&
      pg.constraint_name === "organization_domain_url_key"
    )
      return true;
  }
  return false;
}

// ---- Licence (subscription) dates --------------------------------------------
const licenceFields = {
  OrganizationStartDate: "Start date",
  OrganizationEndDate: "End date",
} as const;
type LicenceDates = Record<keyof typeof licenceFields, string>;

/** "YYYY-MM-DD" that is an actual calendar day (rejects e.g. 2025-02-30). */
function isCalendarDate(value: string) {
  const d = new Date(`${value}T00:00:00Z`);
  return !Number.isNaN(d.getTime()) && d.toISOString().slice(0, 10) === value;
}

/** Both dates must be real days, and the licence cannot end before it starts. */
function validateLicence(dates: LicenceDates) {
  const errors: Record<string, string> = {};
  for (const [key, label] of Object.entries(licenceFields) as [
    keyof LicenceDates,
    string,
  ][]) {
    if (!isCalendarDate(dates[key]))
      errors[key] = `${label} is not a valid date`;
  }
  if (
    Object.keys(errors).length === 0 &&
    dates.OrganizationEndDate < dates.OrganizationStartDate
  ) {
    errors.OrganizationEndDate = "End date cannot be before start date";
  }
  return errors;
}

// ---- Telegram ---------------------------------------------------------------------
type TelegramSettings = {
  TelegramAllow: number;
  TelegramUrl: string;
  TelegramSession: string;
};

/** While Telegram is allowed, it needs an http(s) URL and an access token. */
function validateTelegram(telegram: TelegramSettings) {
  const errors: Record<string, string> = {};
  if (telegram.TelegramAllow !== 1) return errors;
  if (!telegram.TelegramUrl)
    errors.TelegramUrl = "Telegram URL is required when Telegram is allowed";
  else if (!/^https?:\/\/\S+$/i.test(telegram.TelegramUrl)) {
    errors.TelegramUrl = "Telegram URL must start with http:// or https://";
  }
  if (!telegram.TelegramSession)
    errors.TelegramSession =
      "Access token is required when Telegram is allowed";
  return errors;
}

function validateSms(sms: SmsSettings) {
  const errors: Record<string, string> = {};
  if (sms.OrganizationSms !== "1") return errors;
  for (const [key, label] of Object.entries(smsFields) as [
    keyof typeof smsFields,
    string,
  ][]) {
    if (!sms[key].trim()) errors[key] = `${label} is required when SMS is on`;
  }
  if (
    !errors.OrganizationSmsUrl &&
    !/^https?:\/\/\S+$/i.test(sms.OrganizationSmsUrl)
  ) {
    errors.OrganizationSmsUrl = "SMS URL must start with http:// or https://";
  }
  const port = Number(sms.OrganizationSmsPort);
  if (
    !errors.OrganizationSmsPort &&
    !(/^\d+$/.test(sms.OrganizationSmsPort) && port >= 1 && port <= 65535)
  ) {
    errors.OrganizationSmsPort = "SMS port must be a number from 1 to 65535";
  }
  return errors;
}

// "2020-09-22 10:44:18.123" -> "2020-09-22T10:44:18" (local time, no zone, as stored)
const toIsoLocal = (value: string) =>
  value.replace(" ", "T").replace(/\.\d+$/, "");
const serialize = <R extends { AddedDate: string }>(row: R) => ({
  ...row,
  AddedDate: toIsoLocal(row.AddedDate),
});

const upper = (value: string) => value.trim().toUpperCase();

const notDeleted = ne(organization.RecordStatus, "D");

// Field schemas shared by create and update.
const fields = {
  ...configSchemas,
  OrganizationName: t.String({
    minLength: 1,
    maxLength: 30,
    error: "Organization name is required (max 30 characters)",
  }),
  OrganizationOwnerName: t.String({
    minLength: 1,
    maxLength: 30,
    error: "Owner name is required (max 30 characters)",
  }),
  OrganizationMobile: t.String({
    pattern: "^[0-9]{10}$",
    error: "Mobile must be 10 digits",
  }),
  OrganizationAddress: t.String({
    minLength: 1,
    maxLength: 60,
    error: "Address is required (max 60 characters)",
  }),
  // Literal unions, not t.UnionEnum: Elysia fills UnionEnum fields with a default value when
  // they are missing, which would make every partial PATCH overwrite Theme/App Access.
  OrganizationTheme: t.Union(
    THEMES.map((v) => t.Literal(v)),
    { error: `Theme must be one of: ${THEMES.join(", ")}` },
  ),
  OrganizationAppAccess: t.Union(
    APP_ACCESS.map((v) => t.Literal(v)),
    { error: "Invalid app access" },
  ),
  OrganizationSms: t.Union([t.Literal("0"), t.Literal("1")], {
    error: "SMS must be on (1) or off (0)",
  }),
  OrganizationSmsUrl: t.String({
    maxLength: 100,
    error: "SMS URL can be at most 100 characters",
  }),
  OrganizationSmsUsername: t.String({
    maxLength: 30,
    error: "SMS username can be at most 30 characters",
  }),
  OrganizationSmsPassword: t.String({
    maxLength: 30,
    error: "SMS password can be at most 30 characters",
  }),
  OrganizationSmsSenderId: t.String({
    maxLength: 10,
    error: "SMS sender id can be at most 10 characters",
  }),
  OrganizationSmsPort: t.String({
    maxLength: 10,
    error: "SMS port can be at most 10 characters",
  }),
  OrganizationOnDomain: t.Union([t.Literal(0), t.Literal(1)], {
    error: "Domain must be on (1) or off (0)",
  }),
  OrganizationDomainURL: t.String({
    maxLength: 100,
    error: "Domain URL can be at most 100 characters",
  }),
  OrganizationStartDate: t.String({
    pattern: "^[0-9]{4}-[0-9]{2}-[0-9]{2}$",
    error: "Start date must be YYYY-MM-DD",
  }),
  OrganizationEndDate: t.String({
    pattern: "^[0-9]{4}-[0-9]{2}-[0-9]{2}$",
    error: "End date must be YYYY-MM-DD",
  }),
  // Active/Deactive tab: "1" = organization allowed (active), "0" = deactivated.
  IsOrganizationAllow: t.Union([t.Literal("0"), t.Literal("1")], {
    error: "Organization status must be active (1) or deactivated (0)",
  }),
  TelegramAllow: t.Union([t.Literal(0), t.Literal(1)], {
    error: "Telegram Allow must be 0 or 1",
  }),
  TelegramUrl: t.String({
    maxLength: 250,
    error: "Telegram URL can be at most 250 characters",
  }),
  TelegramSession: t.String({
    maxLength: 10000,
    error: "Access token can be at most 10000 characters",
  }),
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
    OrganizationOnDomain: t.Number(),
    OrganizationDomainURL: t.String(),
    IsOrganizationAllow: t.String(),
    TelegramAllow: t.Number(),
    TelegramUrl: t.String(),
    TelegramSession: t.String(),
    ...configResponse,
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

const IdParams = t.Object({
  id: t.Numeric({ minimum: 1, error: "Invalid organization id" }),
});
const NotFound = t.Object({ message: t.String() });
const Unprocessable = t.Object({
  message: t.String(),
  fields: t.Record(t.String(), t.String()),
});
const notFound = { message: "Organization not found" };

export const organizations = new Elysia({
  prefix: "/organizations",
  tags: ["Organizations"],
})
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
    {
      response: t.Array(OrganizationListItem),
      detail: { summary: "List organizations" },
    },
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
      if (body.OrganizationName !== undefined)
        changes.OrganizationName = upper(body.OrganizationName);
      if (body.OrganizationOwnerName !== undefined)
        changes.OrganizationOwnerName = upper(body.OrganizationOwnerName);
      if (body.OrganizationMobile !== undefined)
        changes.OrganizationMobile = body.OrganizationMobile;
      if (body.OrganizationAddress !== undefined)
        changes.OrganizationAddress = upper(body.OrganizationAddress);
      if (body.OrganizationTheme !== undefined)
        changes.OrganizationTheme = body.OrganizationTheme;
      if (body.OrganizationAppAccess !== undefined)
        changes.OrganizationAppAccess = body.OrganizationAppAccess;
      if (body.OrganizationSms !== undefined)
        changes.OrganizationSms = body.OrganizationSms;
      for (const key of Object.keys(smsFields) as (keyof typeof smsFields)[]) {
        const value = body[key];
        // The password is stored exactly as typed; the other SMS fields are trimmed.
        if (value !== undefined)
          changes[key] =
            key === "OrganizationSmsPassword" ? value : value.trim();
      }
      if (body.OrganizationOnDomain !== undefined)
        changes.OrganizationOnDomain = body.OrganizationOnDomain;
      if (body.OrganizationDomainURL !== undefined)
        changes.OrganizationDomainURL =
          body.OrganizationDomainURL.trim().toLowerCase();
      for (const key of configKeys) {
        const value = body[key];
        if (value !== undefined) changes[key] = value;
      }
      if (body.OrganizationStartDate !== undefined)
        changes.OrganizationStartDate = body.OrganizationStartDate;
      if (body.OrganizationEndDate !== undefined)
        changes.OrganizationEndDate = body.OrganizationEndDate;
      if (body.IsOrganizationAllow !== undefined)
        changes.IsOrganizationAllow = body.IsOrganizationAllow;
      if (body.TelegramAllow !== undefined)
        changes.TelegramAllow = body.TelegramAllow;
      if (body.TelegramUrl !== undefined)
        changes.TelegramUrl = body.TelegramUrl.trim();
      // Long tokens often pick up spaces/line breaks when copied; a token never contains whitespace.
      if (body.TelegramSession !== undefined)
        changes.TelegramSession = body.TelegramSession.replace(/\s+/g, "");
      if (Object.keys(changes).length === 0) {
        return status(422, {
          message: "Provide at least one field to update.",
          fields: {},
        });
      }
      const touchesSms =
        "OrganizationSms" in changes ||
        Object.keys(smsFields).some((key) => key in changes);
      const touchesDomain =
        "OrganizationOnDomain" in changes || "OrganizationDomainURL" in changes;
      const touchesLicence = Object.keys(licenceFields).some(
        (key) => key in changes,
      );
      const touchesTelegram =
        "TelegramAllow" in changes ||
        "TelegramUrl" in changes ||
        "TelegramSession" in changes;
      const where = and(eq(organization.OrganizationId, params.id), notDeleted);

      const result = await db
        .transaction(async (tx) => {
          if (
            touchesSms ||
            touchesDomain ||
            touchesLicence ||
            touchesTelegram
          ) {
            // Validate the settings as they will be after this update (saved values + changes).
            const [current] = await tx
              .select({
                TelegramAllow:
                  sql<number>`coalesce(${organization.TelegramAllow}, 0)`.mapWith(
                    Number,
                  ),
                TelegramUrl: sql<string>`coalesce(${organization.TelegramUrl}, '')`,
                TelegramSession: sql<string>`coalesce(${organization.TelegramSession}, '')`,
                OrganizationStartDate: organization.OrganizationStartDate,
                OrganizationEndDate: organization.OrganizationEndDate,
                OrganizationOnDomain: organization.OrganizationOnDomain,
                OrganizationDomainURL: organization.OrganizationDomainURL,
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
            const next = { ...current, ...changes };
            const errors = {
              ...(touchesSms ? validateSms(next as SmsSettings) : {}),
              ...(touchesLicence ? validateLicence(next as LicenceDates) : {}),
              ...(touchesTelegram
                ? validateTelegram(next as TelegramSettings)
                : {}),
              ...(touchesDomain
                ? await validateDomain(tx, params.id, next as DomainSettings)
                : {}),
            };
            if (Object.keys(errors).length > 0)
              return { kind: "invalid", fields: errors } as const;
          }
          const [row] = await tx
            .update(organization)
            .set({
              ...changes,
              UpdatedBy: SYSTEM_USER,
              UpdatedDate: sql`localtimestamp`,
            })
            .where(where)
            .returning(detailColumns);
          return row
            ? ({ kind: "ok", row } as const)
            : ({ kind: "not-found" } as const);
        })
        .catch((error: unknown) => {
          if (!isDuplicateDomainError(error)) throw error;
          return {
            kind: "invalid",
            fields: {
              OrganizationDomainURL:
                "Domain is already used by another organization",
            },
          } as const;
        });

      if (result.kind === "not-found") return status(404, notFound);
      if (result.kind === "invalid") {
        return status(422, {
          message: "Please correct the highlighted fields.",
          fields: result.fields,
        });
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
