import { Elysia, t } from "elysia";
import { and, asc, desc, eq, gt, ne, sql } from "drizzle-orm";
import { db } from "../db";
import { login, role, sysRole } from "../db/legacy";
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
              LoginName: upper(body.LoginName) + NAME_SUFFIX,
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
  );
