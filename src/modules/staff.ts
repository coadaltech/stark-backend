import { Elysia, t } from "elysia";
import { and, asc, desc, eq, gt, isNull, ne, sql } from "drizzle-orm";
import { db } from "../db";
import { authSession, login, role, sysRole } from "../db/legacy";
import { staffManagerGuard } from "../auth/guard";
import type { Tx } from "../auth/access";

// Staff of the signed-in organization site (spec §3, §7). The organization always comes from the session's site, never from the request.

const NAME_SUFFIX = " STAFF A/C";
const USERNAME_TAKEN = "Username is already taken";
/** The username constraints: per organization, and developer usernames reserved (sql/005). */
const USERNAME_CONSTRAINTS = [
  "login_org_username_key",
  "login_developer_username_reserved",
];

const upper = (value: string) => value.trim().toUpperCase();
const toIsoLocal = (value: string) =>
  value.replace(" ", "T").replace(/\.\d+$/, "");

/**
 * Roles the caller may give to new staff in this organization: creatable (`sys_role.IsStaffCreatable`),
 * strictly below the caller by priority, and defined for the organization. Highest first.
 */
function creatableRoles(
  executor: typeof db | Tx,
  organizationId: number,
  callerRoleId: number,
) {
  const callerPriority = sql`(select "RolePriority" from "sys_role" where "RoleId" = ${callerRoleId})`;
  return executor
    .select({ roleId: sysRole.RoleId, roleName: sysRole.RoleName })
    .from(sysRole)
    .innerJoin(
      role,
      and(
        eq(role.RoleId, sysRole.RoleId),
        eq(role.OrganizationId, organizationId),
        ne(role.RecordStatus, "D"),
      ),
    )
    .where(
      and(
        eq(sysRole.IsStaffCreatable, 1),
        ne(sysRole.RecordStatus, "D"),
        gt(sysRole.RolePriority, callerPriority),
      ),
    )
    .orderBy(asc(sysRole.RolePriority));
}

/**
 * Whether the caller may edit a staff member with role `targetRoleId`: strictly below the caller by
 * priority (the same rule as creating; so never yourself, your peers or anyone above you).
 */
async function canEditRole(executor: typeof db | Tx, callerRoleId: number, targetRoleId: number) {
  const [row] = await executor
    .select({ ok: sql<boolean>`target."RolePriority" > caller."RolePriority"` })
    .from(sql`"sys_role" caller, "sys_role" target`)
    .where(sql`caller."RoleId" = ${callerRoleId} and target."RoleId" = ${targetRoleId}`);
  return row?.ok === true;
}

/** Stored as "NAME STAFF A/C"; a name typed with the suffix already isn't suffixed twice. */
const staffName = (typed: string) => {
  const name = upper(typed);
  return name.endsWith(NAME_SUFFIX) ? name : name + NAME_SUFFIX;
};

const listColumns = {
  LoginId: login.LoginId,
  LoginName: login.LoginName,
  LoginType: login.LoginType,
  RoleName: sql<string>`coalesce(${sysRole.RoleName}, '')`,
  UserName: login.UserName,
  StaffWorkMode: login.StaffWorkMode,
  Mobile: login.Mobile,
  Address: sql<string>`coalesce(${login.Address}, '')`,
  AccountStatus: login.AccountStatus,
  UpdatedBy: login.UpdatedBy,
  UpdatedDate: login.UpdatedDate,
};

const StaffItem = t.Object({
  LoginId: t.Number(),
  LoginName: t.String(),
  LoginType: t.Number(),
  RoleName: t.String(),
  UserName: t.String(),
  StaffWorkMode: t.Number(),
  Mobile: t.String(),
  Address: t.String(),
  AccountStatus: t.String(),
  UpdatedBy: t.String(),
  UpdatedDate: t.String(),
});

const serialize = <R extends { UpdatedDate: string }>(row: R) => ({
  ...row,
  UpdatedDate: toIsoLocal(row.UpdatedDate),
});

const Message = t.Object({ message: t.String() });
const ValidationError = t.Object({
  message: t.String(),
  fields: t.Record(t.String(), t.String()),
});

const CreateStaffBody = t.Object({
  LoginName: t.String({
    minLength: 1,
    maxLength: 70,
    pattern: "\\S",
    error: "Staff name is required (max 70 characters)",
  }),
  LoginType: t.Integer({ error: "Role is required" }),
  StaffWorkMode: t.Union(
    [t.Literal(0), t.Literal(1), t.Literal(2), t.Literal(3)],
    {
      error: "W-Mode must be NONE, COMMAN, WHATSAPP or CALLING",
    },
  ),
  UserName: t.String({
    pattern: "^[A-Za-z0-9._-]{1,30}$",
    error:
      "Username is required: up to 30 letters, digits, '.', '_' or '-' (no spaces)",
  }),
  Password: t.String({
    minLength: 1,
    maxLength: 72,
    error: "Password is required (max 72 characters)",
  }),
  Mobile: t.String({
    pattern: "^[0-9]{10}$",
    error: "Mobile must be 10 digits",
  }),
  Address: t.Optional(
    t.String({ maxLength: 50, error: "Address can be at most 50 characters" }),
  ),
});

const UpdateStaffBody = t.Object({
  LoginName: t.Optional(CreateStaffBody.properties.LoginName),
  LoginType: t.Optional(CreateStaffBody.properties.LoginType),
  StaffWorkMode: t.Optional(CreateStaffBody.properties.StaffWorkMode),
  Mobile: t.Optional(CreateStaffBody.properties.Mobile),
  Address: t.Optional(t.String({ maxLength: 50, error: "Address can be at most 50 characters" })),
  AccountStatus: t.Optional(t.Union([t.Literal("1"), t.Literal("0")], { error: "Status must be active (1) or inactive (0)" })),
});

const StaffDetail = t.Composite([StaffItem, t.Object({ canEdit: t.Boolean() })]);
const IdParams = t.Object({ id: t.Numeric({ minimum: 1, error: "Invalid staff id" }) });
const NOT_FOUND = { message: "Staff member not found" };
const CANT_EDIT = { message: "You can only edit staff below your own role." };

/** True if the error is one of the username rules rejecting a duplicate (e.g. two saves racing). */
function isUsernameTaken(error: unknown): boolean {
  for (
    let e: unknown = error;
    e && typeof e === "object";
    e = (e as { cause?: unknown }).cause
  ) {
    const pg = e as { code?: string; constraint_name?: string };
    if (
      pg.code === "23505" &&
      USERNAME_CONSTRAINTS.includes(pg.constraint_name ?? "")
    )
      return true;
  }
  return false;
}

export const staff = new Elysia({ prefix: "/staff", tags: ["Staff"] })
  .use(staffManagerGuard)
  .get(
    "/",
    async ({ organizationId }) => {
      const rows = await db
        .select(listColumns)
        .from(login)
        .leftJoin(sysRole, eq(sysRole.RoleId, login.LoginType))
        .where(
          and(
            eq(login.OrganizationId, organizationId),
            ne(login.RecordStatus, "D"),
          ),
        )
        .orderBy(desc(login.LoginId));
      return rows.map(serialize);
    },
    {
      response: { 200: t.Array(StaffItem) },
      detail: {
        summary: "Staff of the signed-in organization site (newest first)",
      },
    },
  )
  .get(
    "/roles",
    async ({ organizationId, user }) =>
      creatableRoles(db, organizationId, user.roleId),
    {
      response: {
        200: t.Array(t.Object({ roleId: t.Number(), roleName: t.String() })),
      },
      detail: {
        summary:
          "Roles the signed-in user may give to new staff (highest first)",
      },
    },
  )
  .post(
    "/",
    async ({ body, organizationId, user, status }) => {
      const userName = body.UserName;
      try {
        const result = await db.transaction(async (tx) => {
          const allowed = await creatableRoles(tx, organizationId, user.roleId);
          if (!allowed.some((r) => r.roleId === body.LoginType)) {
            const fields: Record<string, string> = {
              LoginType: "You can't create staff with this role",
            };
            return { kind: "invalid", fields } as const;
          }
          // Same organization (any case), or a developer's username (reserved platform-wide).
          const [taken] = await tx
            .select({ LoginId: login.LoginId })
            .from(login)
            .where(
              and(
                sql`lower(${login.UserName}) = lower(${userName})`,
                sql`(${login.OrganizationId} = ${organizationId} or ${login.OrganizationId} is null)`,
                ne(login.RecordStatus, "D"),
              ),
            )
            .limit(1);
          if (taken) {
            const fields: Record<string, string> = { UserName: USERNAME_TAKEN };
            return { kind: "invalid", fields } as const;
          }

          const [created] = await tx
            .insert(login)
            .values({
              OrganizationId: organizationId,
              LedgerId: 0,
              LoginName: staffName(body.LoginName),
              UserName: userName,
              Password: await Bun.password.hash(body.Password, {
                algorithm: "bcrypt",
                cost: 10,
              }),
              LoginType: body.LoginType,
              Mobile: body.Mobile,
              Address: upper(body.Address ?? ""),
              StaffWorkMode: body.StaffWorkMode,
              AccountStatus: "1",
              RecordStatus: "A",
              AddedBy: user.userName,
              AddedDate: sql`localtimestamp`,
              UpdatedBy: user.userName,
              UpdatedDate: sql`localtimestamp`,
            })
            .returning({ LoginId: login.LoginId });
          const [row] = await tx
            .select(listColumns)
            .from(login)
            .leftJoin(sysRole, eq(sysRole.RoleId, login.LoginType))
            .where(eq(login.LoginId, created!.LoginId));
          return { kind: "ok", row: row! } as const;
        });
        if (result.kind === "invalid") {
          return status(422, {
            message: "Please correct the highlighted fields.",
            fields: result.fields,
          });
        }
        return status(201, serialize(result.row));
      } catch (error) {
        if (!isUsernameTaken(error)) throw error;
        return status(422, {
          message: "Please correct the highlighted fields.",
          fields: { UserName: USERNAME_TAKEN },
        });
      }
    },
    {
      body: CreateStaffBody,
      response: { 201: StaffItem, 422: ValidationError },
      detail: {
        summary: "Add a staff member to the signed-in organization site",
      },
    },
  )
  .get(
    "/:id",
    async ({ params, organizationId, user, status }) => {
      const [row] = await db
        .select(listColumns)
        .from(login)
        .leftJoin(sysRole, eq(sysRole.RoleId, login.LoginType))
        .where(and(eq(login.LoginId, params.id), eq(login.OrganizationId, organizationId), ne(login.RecordStatus, "D")));
      if (!row) return status(404, NOT_FOUND);
      return { ...serialize(row), canEdit: await canEditRole(db, user.roleId, row.LoginType) };
    },
    {
      params: IdParams,
      response: { 200: StaffDetail, 404: Message },
      detail: { summary: "One staff member of the site, and whether the signed-in user may edit them" },
    },
  )
  .patch(
    "/:id",
    async ({ params, body, organizationId, user, status }) => {
      const changes: Partial<typeof login.$inferInsert> = {};
      if (body.LoginName !== undefined) changes.LoginName = staffName(body.LoginName);
      if (body.LoginType !== undefined) changes.LoginType = body.LoginType;
      if (body.StaffWorkMode !== undefined) changes.StaffWorkMode = body.StaffWorkMode;
      if (body.Mobile !== undefined) changes.Mobile = body.Mobile;
      if (body.Address !== undefined) changes.Address = upper(body.Address);
      if (body.AccountStatus !== undefined) changes.AccountStatus = body.AccountStatus;
      if (Object.keys(changes).length === 0) {
        return status(422, { message: "Provide at least one field to update.", fields: {} });
      }

      const result = await db.transaction(async (tx) => {
        const [current] = await tx
          .select({ LoginType: login.LoginType, AccountStatus: login.AccountStatus })
          .from(login)
          .where(and(eq(login.LoginId, params.id), eq(login.OrganizationId, organizationId), ne(login.RecordStatus, "D")))
          .for("update");
        if (!current) return { kind: "not-found" } as const;
        if (!(await canEditRole(tx, user.roleId, current.LoginType))) return { kind: "forbidden" } as const;
        // A new role must be one the caller may give; keeping the current role is always fine.
        if (changes.LoginType !== undefined && changes.LoginType !== current.LoginType) {
          const allowed = await creatableRoles(tx, organizationId, user.roleId);
          if (!allowed.some((r) => r.roleId === changes.LoginType)) {
            const fields: Record<string, string> = { LoginType: "You can't give this role" };
            return { kind: "invalid", fields } as const;
          }
        }
        await tx
          .update(login)
          .set({ ...changes, UpdatedBy: user.userName, UpdatedDate: sql`localtimestamp` })
          .where(eq(login.LoginId, params.id));
        // Deactivated: sign them out everywhere at once.
        if (changes.AccountStatus === "0" && current.AccountStatus !== "0") {
          await tx
            .update(authSession)
            .set({ RevokedAt: new Date(), RevokedReason: "deactivated" })
            .where(and(eq(authSession.LoginId, params.id), isNull(authSession.RevokedAt)));
        }
        const [row] = await tx
          .select(listColumns)
          .from(login)
          .leftJoin(sysRole, eq(sysRole.RoleId, login.LoginType))
          .where(eq(login.LoginId, params.id));
        return { kind: "ok", row: row! } as const;
      });

      if (result.kind === "not-found") return status(404, NOT_FOUND);
      if (result.kind === "forbidden") return status(403, CANT_EDIT);
      if (result.kind === "invalid") {
        return status(422, { message: "Please correct the highlighted fields.", fields: result.fields });
      }
      return serialize(result.row);
    },
    {
      params: IdParams,
      body: UpdateStaffBody,
      response: { 200: StaffItem, 403: Message, 404: Message, 422: ValidationError },
      detail: { summary: "Edit a staff member below your role (profile fields or Active/Deactive)" },
    },
  );
