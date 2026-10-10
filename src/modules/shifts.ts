import { Elysia, t } from "elysia";
import { and, asc, eq, inArray, ne, sql } from "drizzle-orm";
import { db } from "../db";
import { shift, shiftTiming, sysRole } from "../db/legacy";
import { organizationSiteGuard, requirePermission } from "../auth/guard";

// Shifts of the signed-in organization site (specs/build/shifts/shift_spec.md). The organization always
// comes from the session's site.

/** The Shift page (`staff` menu → `shift-list` sub-menu). */
const PAGE = "shift-list";

/**
 * Roles that get an end time, in form order (spec §4). ADMIN DATA ENTRY OPERATOR (11) and ADMIN TALLY
 * OPERATOR (13) get none.
 */
const TIMING_ROLE_IDS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14] as const;

const TIME = /^([01]\d|2[0-3]):[0-5]\d$/;
const INVALID = "Please correct the highlighted fields.";
const NAME_TAKEN = "Shift name is already used";

const toIsoLocal = (value: string) => value.replace(" ", "T").replace(/\.\d+$/, "");

const listColumns = {
  ShiftId: shift.ShiftId,
  ShiftName: shift.ShiftName,
  ShiftDate: shift.ShiftDate,
  ShiftNextDay: shift.ShiftNextDay,
  ShiftFor: shift.ShiftFor,
  IsActive: shift.IsActive,
  UpdatedBy: shift.UpdatedBy,
  UpdatedDate: shift.UpdatedDate,
};

const ShiftItem = t.Object({
  ShiftId: t.Number(),
  ShiftName: t.String(),
  /** Open Date, YYYY-MM-DD. */
  ShiftDate: t.String(),
  ShiftNextDay: t.Union([t.Literal("Yes"), t.Literal("No")]),
  ShiftFor: t.Union([t.Literal("BOTH"), t.Literal("WEB"), t.Literal("APP")]),
  /** "1" active, "0" deactive. */
  IsActive: t.String(),
  UpdatedBy: t.String(),
  UpdatedDate: t.String(),
});
const serialize = <R extends { UpdatedDate: string }>(row: R) => ({ ...row, UpdatedDate: toIsoLocal(row.UpdatedDate) });

const Message = t.Object({ message: t.String() });
const ValidationError = t.Object({ message: t.String(), fields: t.Record(t.String(), t.String()) });

const CreateShiftBody = t.Object({
  ShiftName: t.String({ minLength: 1, maxLength: 50, pattern: "\\S", error: "Shift name is required (max 50 characters)" }),
  ShiftDate: t.String({ pattern: "^[0-9]{4}-[0-9]{2}-[0-9]{2}$", error: "Open date is required (YYYY-MM-DD)" }),
  ShiftNextDay: t.Union([t.Literal("Yes"), t.Literal("No")], { error: "Next day must be Yes or No" }),
  ShiftFor: t.Union([t.Literal("BOTH"), t.Literal("WEB"), t.Literal("APP")], { error: "Shift working for must be Both, Web or App" }),
  // The time format is checked in the handler so each error can be reported under its role.
  Timings: t.Array(t.Object({ RoleId: t.Integer({ error: "Invalid role" }), EndTime: t.String({ maxLength: 10 }) }), {
    maxItems: 50,
    error: "End times are required",
  }),
});

/** "YYYY-MM-DD" that is an actual calendar day. */
function isCalendarDate(value: string) {
  const d = new Date(`${value}T00:00:00Z`);
  return !Number.isNaN(d.getTime()) && d.toISOString().slice(0, 10) === value;
}

/** True if two saves raced on the same shift name. */
function isNameTaken(error: unknown) {
  for (let e: unknown = error; e && typeof e === "object"; e = (e as { cause?: unknown }).cause) {
    const pg = e as { code?: string; constraint_name?: string };
    if (pg.code === "23505" && pg.constraint_name === "shift_org_name_key") return true;
  }
  return false;
}

export const shifts = new Elysia({ prefix: "/shifts", tags: ["Shifts"] })
  .use(organizationSiteGuard)
  .get(
    "/",
    async ({ organizationId }) => {
      const rows = await db
        .select(listColumns)
        .from(shift)
        .where(and(eq(shift.OrganizationId, organizationId), ne(shift.RecordStatus, "D")))
        .orderBy(asc(shift.ShiftId));
      return rows.map(serialize);
    },
    {
      transform: requirePermission(PAGE, "view"),
      response: { 200: t.Array(ShiftItem), 403: Message },
      detail: { summary: "Shifts of the signed-in organization site (oldest first)" },
    },
  )
  .get(
    "/roles",
    async () => {
      const rows = await db
        .select({ RoleId: sysRole.RoleId, RoleName: sysRole.RoleName })
        .from(sysRole)
        .where(inArray(sysRole.RoleId, [...TIMING_ROLE_IDS]));
      return TIMING_ROLE_IDS.flatMap((id) => rows.filter((r) => r.RoleId === id));
    },
    {
      transform: requirePermission(PAGE, "add"),
      response: { 200: t.Array(t.Object({ RoleId: t.Number(), RoleName: t.String() })), 403: Message },
      detail: { summary: "The roles that get an end time in Add Shift, in form order" },
    },
  )
  .post(
    "/",
    async ({ body, organizationId, user, status }) => {
      const name = body.ShiftName.trim().toUpperCase();
      const fields: Record<string, string> = {};

      // End times: exactly the 12 roles, each a 24-hour HH:MM.
      const timings = new Map<number, string>();
      for (const timing of body.Timings) {
        if (!(TIMING_ROLE_IDS as readonly number[]).includes(timing.RoleId)) {
          fields.Timings = "Only the shift roles can have an end time";
        } else if (timings.has(timing.RoleId)) {
          fields[`EndTime.${timing.RoleId}`] = "Listed more than once";
        } else {
          timings.set(timing.RoleId, timing.EndTime.trim());
        }
      }
      for (const roleId of TIMING_ROLE_IDS) {
        const time = timings.get(roleId);
        if (!time) fields[`EndTime.${roleId}`] ??= "End time is required";
        else if (!TIME.test(time)) fields[`EndTime.${roleId}`] ??= "Enter a time like 17:15";
      }
      if (!isCalendarDate(body.ShiftDate)) fields.ShiftDate = "Open date is not a valid date";

      try {
        const result = await db.transaction(async (tx) => {
          if (!fields.ShiftDate) {
            // "Today" in the organization's business time zone (the DB session follows DB_TIMEZONE).
            const [{ today }] = (await tx.execute(sql`select current_date::text as today`)) as unknown as [{ today: string }];
            if (body.ShiftDate < today) fields.ShiftDate = "Open date can't be before today";
          }
          const [taken] = await tx
            .select({ ShiftId: shift.ShiftId })
            .from(shift)
            .where(and(eq(shift.OrganizationId, organizationId), ne(shift.RecordStatus, "D"), sql`lower(${shift.ShiftName}) = lower(${name})`))
            .limit(1);
          if (taken) fields.ShiftName = NAME_TAKEN;
          if (Object.keys(fields).length) return { kind: "invalid" } as const;

          const audit = { AddedBy: user.userName, AddedDate: sql`localtimestamp`, UpdatedBy: user.userName, UpdatedDate: sql`localtimestamp` };
          const [created] = await tx
            .insert(shift)
            .values({
              OrganizationId: organizationId,
              ShiftName: name,
              ShiftDate: body.ShiftDate,
              ShiftNextDay: body.ShiftNextDay,
              ShiftFor: body.ShiftFor,
              ShiftOrder: 0,
              IsActive: "1",
              RecordStatus: "A",
              ...audit,
            })
            .returning({ ShiftId: shift.ShiftId });
          await tx.insert(shiftTiming).values(
            TIMING_ROLE_IDS.map((roleId) => ({
              ShiftId: created!.ShiftId,
              OrganizationId: organizationId,
              RoleId: roleId,
              EndTime: timings.get(roleId)!,
              RecordStatus: "A",
              ...audit,
            })),
          );
          const [row] = await tx.select(listColumns).from(shift).where(eq(shift.ShiftId, created!.ShiftId));
          return { kind: "ok", row: row! } as const;
        });
        if (result.kind === "invalid") return status(422, { message: INVALID, fields });
        return status(201, serialize(result.row));
      } catch (error) {
        if (!isNameTaken(error)) throw error;
        return status(422, { message: INVALID, fields: { ShiftName: NAME_TAKEN } });
      }
    },
    {
      transform: requirePermission(PAGE, "add"),
      body: CreateShiftBody,
      response: { 201: ShiftItem, 403: Message, 422: ValidationError },
      detail: { summary: "Add a shift with an end time for each shift role" },
    },
  );
