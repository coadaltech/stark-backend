import { Elysia, t } from "elysia";
import { and, asc, eq, inArray, ne, sql } from "drizzle-orm";
import { db } from "../db";
import { login, role, rolePermission, staffPermission, staffPermissionPage, subMenu, sysMenu, sysRole } from "../db/legacy";
import { DEVELOPER_ROLE_ID, isRoleBelow, type Tx } from "../auth/access";
import { organizationSiteGuard, requirePermissionManager } from "../auth/guard";
import type { AuthUser } from "../auth/tokens";
import { ACTIONS, allows, catalogPages, effectivePermissions, loadCatalog, type Action, type PermissionMap } from "../permissions/effective";

// Permissions on organization sites (specs/build/permissions/permission_spec.md); the organization
// always comes from the session.

const PagePermission = t.Object({
  view: t.Boolean(),
  add: t.Boolean(),
  edit: t.Boolean(),
  delete: t.Boolean(),
  export: t.Boolean(),
  viewType: t.Union([t.Literal("ALL"), t.Literal("SELF")]),
});
const NavItem = t.Object({ key: t.String(), label: t.String(), order: t.Number() });
type NavItem = { key: string; label: string; order: number };
type NavMenu = NavItem & { type: "PAGE" | "GROUP"; subMenus: NavItem[] };

const Message = t.Object({ message: t.String() });
const ValidationError = t.Object({ message: t.String(), fields: t.Record(t.String(), t.String()) });
const FORBIDDEN = { message: "You don't have access to this." };
const NOT_FOUND = { message: "Permission not found" };
const INVALID = "Please correct the highlighted fields.";
const CANT_GRANT = "You can't grant actions you don't have";

// API flag names ↔ action names.
const FLAGS = { IsPageAllow: "view", Add: "add", Edit: "edit", Delete: "delete", Export: "export" } as const;
type Flag = keyof typeof FLAGS;
const flagOf = (on: boolean | undefined) => (on ? "1" : "0");

/** The caller's priority as a SQL subquery (sys_role.RolePriority; 1 = highest). */
const callerPriority = (callerRoleId: number) =>
  sql`(select "RolePriority" from "sys_role" where "RoleId" = ${callerRoleId})`;

/** Roles of the organization strictly below the caller (never DEVELOPER), highest first. */
function rolesBelow(executor: typeof db | Tx, organizationId: number, callerRoleId: number) {
  return executor
    .select({ RoleId: sysRole.RoleId, RoleName: sysRole.RoleName })
    .from(sysRole)
    .innerJoin(role, and(eq(role.RoleId, sysRole.RoleId), eq(role.OrganizationId, organizationId), ne(role.RecordStatus, "D")))
    .where(
      and(
        ne(sysRole.RoleId, DEVELOPER_ROLE_ID),
        ne(sysRole.RecordStatus, "D"),
        sql`${sysRole.RolePriority} > ${callerPriority(callerRoleId)}`,
      ),
    )
    .orderBy(asc(sysRole.RolePriority));
}

const itemColumns = {
  RolePermissionId: rolePermission.RolePermissionId,
  Title: rolePermission.Title,
  RoleId: rolePermission.RoleId,
  RoleName: sql<string>`coalesce(${sysRole.RoleName}, '')`,
  MenuId: rolePermission.MenuId,
  MenuLabel: sysMenu.Menu,
  MenuType: sysMenu.MenuType,
  SubMenuId: rolePermission.SubMenuId,
  SubMenuLabel: subMenu.Label,
  PageKey: sql<string>`coalesce(${subMenu.SubMenuKey}, ${sysMenu.MenuKey})`,
  IsPageAllow: rolePermission.IsPageAllow,
  Add: rolePermission.Add,
  Edit: rolePermission.Edit,
  Delete: rolePermission.Delete,
  Export: rolePermission.Export,
  ViewType: rolePermission.ViewType,
  UpdatedBy: rolePermission.UpdatedBy,
  UpdatedDate: rolePermission.UpdatedDate,
};

/** Role permissions of the organization (not deleted) with role, menu and sub-menu names. */
function selectItems(executor: typeof db | Tx) {
  return executor
    .select(itemColumns)
    .from(rolePermission)
    .leftJoin(sysRole, eq(sysRole.RoleId, rolePermission.RoleId))
    .innerJoin(sysMenu, eq(sysMenu.MenuId, rolePermission.MenuId))
    .leftJoin(subMenu, eq(subMenu.SubMenuId, rolePermission.SubMenuId))
    .$dynamic();
}

type ItemRow = Awaited<ReturnType<ReturnType<typeof selectItems>["execute"]>>[number];
const toItem = (r: ItemRow) => ({
  ...r,
  IsPageAllow: r.IsPageAllow === "1",
  Add: r.Add === "1",
  Edit: r.Edit === "1",
  Delete: r.Delete === "1",
  Export: r.Export === "1",
  UpdatedDate: r.UpdatedDate.replace(" ", "T").replace(/\.\d+$/, ""),
});

const RolePermissionItem = t.Object({
  RolePermissionId: t.Number(),
  Title: t.String(),
  RoleId: t.Number(),
  RoleName: t.String(),
  MenuId: t.Number(),
  MenuLabel: t.String(),
  MenuType: t.Union([t.Literal("PAGE"), t.Literal("GROUP")]),
  SubMenuId: t.Nullable(t.Number()),
  SubMenuLabel: t.Nullable(t.String()),
  PageKey: t.String(),
  IsPageAllow: t.Boolean(),
  Add: t.Boolean(),
  Edit: t.Boolean(),
  Delete: t.Boolean(),
  Export: t.Boolean(),
  ViewType: t.Union([t.Literal("ALL"), t.Literal("SELF")]),
  UpdatedBy: t.String(),
  UpdatedDate: t.String(),
});

const Title = t.String({ minLength: 1, maxLength: 50, pattern: "\\S", error: "Title is required (max 50 characters)" });
const FlagSchema = (label: string) => t.Boolean({ error: `${label} must be true or false` });
const ViewTypeSchema = t.Union([t.Literal("ALL"), t.Literal("SELF")], { error: "View type must be ALL or SELF" });
const flagSchemas = {
  IsPageAllow: FlagSchema("View"),
  Add: FlagSchema("Add"),
  Edit: FlagSchema("Edit"),
  Delete: FlagSchema("Delete"),
  Export: FlagSchema("Export"),
};

const CreateBody = t.Object({
  Title,
  RoleId: t.Integer({ error: "Choose a role" }),
  MenuId: t.Integer({ error: "Choose a menu" }),
  SubMenuId: t.Optional(t.Nullable(t.Integer({ error: "Choose a sub-menu" }))),
  ...flagSchemas,
  ViewType: t.Optional(ViewTypeSchema),
});
const UpdateBody = t.Object({
  Title: t.Optional(Title),
  IsPageAllow: t.Optional(flagSchemas.IsPageAllow),
  Add: t.Optional(flagSchemas.Add),
  Edit: t.Optional(flagSchemas.Edit),
  Delete: t.Optional(flagSchemas.Delete),
  Export: t.Optional(flagSchemas.Export),
  ViewType: t.Optional(ViewTypeSchema),
});
const IdParams = t.Object({ id: t.Numeric({ minimum: 1, error: "Invalid permission id" }) });

/** Actions that need View: with View off they are stored off (permission_spec.md §2). */
function normalizeFlags(flags: Record<Flag, boolean>): Record<Flag, boolean> {
  if (flags.IsPageAllow) return flags;
  return { IsPageAllow: false, Add: false, Edit: false, Delete: false, Export: false };
}

/**
 * Grant limit (spec §3.3): every action switched on in `wanted` that wasn't on in `before` must be one
 * the caller has on the page. Developers are unlimited (their map has everything).
 */
function grantErrors(permissions: PermissionMap, pageKey: string, wanted: Record<Flag, boolean>, before?: Record<Flag, boolean>) {
  const fields: Record<string, string> = {};
  for (const flag of Object.keys(FLAGS) as Flag[]) {
    const action: Action = FLAGS[flag];
    if (wanted[flag] && !before?.[flag] && !allows(permissions, pageKey, action)) fields[flag] = CANT_GRANT;
  }
  return fields;
}

/** True if two saves raced on the same staff permission title. */
function isStaffPermissionTitleTaken(error: unknown) {
  for (let e: unknown = error; e && typeof e === "object"; e = (e as { cause?: unknown }).cause) {
    const pg = e as { code?: string; constraint_name?: string };
    if (pg.code === "23505" && pg.constraint_name === "staff_permission_title_key") return true;
  }
  return false;
}

/** Maps a unique-index violation to its field message (two saves racing). */
function uniqueViolationFields(error: unknown): Record<string, string> | null {
  for (let e: unknown = error; e && typeof e === "object"; e = (e as { cause?: unknown }).cause) {
    const pg = e as { code?: string; constraint_name?: string };
    if (pg.code === "23505" && pg.constraint_name === "role_permission_title_key") return { Title: "Title is already used" };
    if (pg.code === "23505" && pg.constraint_name === "role_permission_page_key")
      return { RoleId: "This role already has a permission for this page" };
  }
  return null;
}

/** Title used by another non-deleted role permission of the organization (any case)? */
async function titleTaken(executor: typeof db | Tx, organizationId: number, title: string, exceptId?: number) {
  const [row] = await executor
    .select({ id: rolePermission.RolePermissionId })
    .from(rolePermission)
    .where(
      and(
        eq(rolePermission.OrganizationId, organizationId),
        ne(rolePermission.RecordStatus, "D"),
        sql`lower(${rolePermission.Title}) = lower(${title})`,
        exceptId ? ne(rolePermission.RolePermissionId, exceptId) : undefined,
      ),
    )
    .limit(1);
  return Boolean(row);
}

/** A role permission of this organization the caller may manage (its role is below the caller's). */
async function managedPermission(executor: typeof db | Tx, organizationId: number, user: AuthUser, id: number) {
  const [row] = await selectItems(executor)
    .where(and(eq(rolePermission.RolePermissionId, id), eq(rolePermission.OrganizationId, organizationId), ne(rolePermission.RecordStatus, "D")))
    .limit(1);
  if (!row) return { kind: "not-found" } as const;
  if (!(await isRoleBelow(executor, user.roleId, row.RoleId))) return { kind: "forbidden" } as const;
  return { kind: "ok", row } as const;
}

const flagsOf = (r: { IsPageAllow: string; Add: string; Edit: string; Delete: string; Export: string }): Record<Flag, boolean> => ({
  IsPageAllow: r.IsPageAllow === "1",
  Add: r.Add === "1",
  Edit: r.Edit === "1",
  Delete: r.Delete === "1",
  Export: r.Export === "1",
});

// ---- Staff permissions (spec §3.1, §4.3): named sets of actions per page, assigned to staff ----

const STAFF_PERMISSION_NOT_FOUND = { message: "Staff permission not found" };
const USED_ABOVE = { message: "This staff permission is used by staff at or above your role." };

type PageInput = { MenuId: number; SubMenuId?: number | null } & Record<Flag, boolean>;
type ResolvedPage = { MenuId: number; SubMenuId: number | null; flags: Record<Flag, boolean> };

/** Checks the pages of a staff permission against the organization's pages; one entry per page. */
async function resolvePages(organizationId: number, pages: PageInput[]) {
  const catalog = await loadCatalog(organizationId);
  const fields: Record<string, string> = {};
  const resolved: ResolvedPage[] = [];
  const seen = new Set<string>();
  pages.forEach((p, i) => {
    const menu = catalog.find((m) => m.menuId === p.MenuId);
    let subMenuId: number | null = null;
    if (!menu) {
      fields[`Pages.${i}`] = "Choose a menu";
      return;
    }
    if (menu.type === "PAGE") {
      if (p.SubMenuId != null) {
        fields[`Pages.${i}`] = "This menu has no sub-menus";
        return;
      }
    } else {
      const sub = menu.subMenus.find((x) => x.subMenuId === p.SubMenuId);
      if (!sub) {
        fields[`Pages.${i}`] = "Choose a sub-menu";
        return;
      }
      subMenuId = sub.subMenuId;
    }
    const key = `${menu.menuId}:${subMenuId ?? 0}`;
    if (seen.has(key)) {
      fields[`Pages.${i}`] = "Listed more than once";
      return;
    }
    seen.add(key);
    resolved.push({
      MenuId: menu.menuId,
      SubMenuId: subMenuId,
      flags: normalizeFlags({ IsPageAllow: p.IsPageAllow, Add: p.Add, Edit: p.Edit, Delete: p.Delete, Export: p.Export }),
    });
  });
  return { fields, resolved };
}

/** Staff permission title used by another non-deleted one of the organization (any case)? */
async function staffPermissionTitleTaken(executor: typeof db | Tx, organizationId: number, title: string, exceptId?: number) {
  const [row] = await executor
    .select({ id: staffPermission.StaffPermissionId })
    .from(staffPermission)
    .where(
      and(
        eq(staffPermission.OrganizationId, organizationId),
        ne(staffPermission.RecordStatus, "D"),
        sql`lower(${staffPermission.Title}) = lower(${title})`,
        exceptId ? ne(staffPermission.StaffPermissionId, exceptId) : undefined,
      ),
    )
    .limit(1);
  return Boolean(row);
}

/**
 * The organization's staff permissions with their pages, how many staff use each, and whether the
 * caller may edit / delete it (not assigned to anyone at or above the caller's role; developer: always).
 */
async function staffPermissionItems(executor: typeof db | Tx, organizationId: number, callerRoleId: number, onlyId?: number) {
  const sets = await executor
    .select()
    .from(staffPermission)
    .where(
      and(
        eq(staffPermission.OrganizationId, organizationId),
        ne(staffPermission.RecordStatus, "D"),
        onlyId ? eq(staffPermission.StaffPermissionId, onlyId) : undefined,
      ),
    )
    .orderBy(asc(staffPermission.Title));
  if (sets.length === 0) return [];
  const ids = sets.map((x) => x.StaffPermissionId);
  const [pages, usage] = await Promise.all([
    executor
      .select({
        StaffPermissionId: staffPermissionPage.StaffPermissionId,
        MenuId: staffPermissionPage.MenuId,
        SubMenuId: staffPermissionPage.SubMenuId,
        MenuLabel: sysMenu.Menu,
        SubMenuLabel: subMenu.Label,
        PageKey: sql<string>`coalesce(${subMenu.SubMenuKey}, ${sysMenu.MenuKey})`,
        IsPageAllow: staffPermissionPage.IsPageAllow,
        Add: staffPermissionPage.Add,
        Edit: staffPermissionPage.Edit,
        Delete: staffPermissionPage.Delete,
        Export: staffPermissionPage.Export,
      })
      .from(staffPermissionPage)
      .innerJoin(sysMenu, eq(sysMenu.MenuId, staffPermissionPage.MenuId))
      .leftJoin(subMenu, eq(subMenu.SubMenuId, staffPermissionPage.SubMenuId))
      .where(inArray(staffPermissionPage.StaffPermissionId, ids))
      .orderBy(asc(sysMenu.Order), asc(sysMenu.MenuId), asc(subMenu.Order)),
    executor
      .select({
        StaffPermissionId: login.StaffPermissionId,
        total: sql<number>`count(*)::int`,
        // Assigned to someone at or above the caller (same or higher priority).
        atOrAbove: sql<number>`count(*) filter (where ${sysRole.RolePriority} <= ${callerPriority(callerRoleId)})::int`,
      })
      .from(login)
      .leftJoin(sysRole, eq(sysRole.RoleId, login.LoginType))
      .where(and(inArray(login.StaffPermissionId, ids), ne(login.RecordStatus, "D")))
      .groupBy(login.StaffPermissionId),
  ]);
  const isDeveloper = callerRoleId === DEVELOPER_ROLE_ID;
  return sets.map((x) => {
    const use = usage.find((u) => u.StaffPermissionId === x.StaffPermissionId);
    return {
      StaffPermissionId: x.StaffPermissionId,
      Title: x.Title,
      Pages: pages
        .filter((p) => p.StaffPermissionId === x.StaffPermissionId)
        .map(({ StaffPermissionId: _id, ...p }) => ({ ...p, ...flagsOf(p) })),
      AssignedCount: use?.total ?? 0,
      CanEdit: isDeveloper || (use?.atOrAbove ?? 0) === 0,
      UpdatedBy: x.UpdatedBy,
      UpdatedDate: x.UpdatedDate.replace(" ", "T").replace(/\.\d+$/, ""),
    };
  });
}

/** Replaces a staff permission's page rows. */
async function writePages(tx: Tx, staffPermissionId: number, pages: ResolvedPage[]) {
  await tx.delete(staffPermissionPage).where(eq(staffPermissionPage.StaffPermissionId, staffPermissionId));
  if (pages.length === 0) return;
  await tx.insert(staffPermissionPage).values(
    pages.map((p) => ({
      StaffPermissionId: staffPermissionId,
      MenuId: p.MenuId,
      SubMenuId: p.SubMenuId,
      IsPageAllow: flagOf(p.flags.IsPageAllow),
      Add: flagOf(p.flags.Add),
      Edit: flagOf(p.flags.Edit),
      Delete: flagOf(p.flags.Delete),
      Export: flagOf(p.flags.Export),
    })),
  );
}

const StaffPermissionItem = t.Object({
  StaffPermissionId: t.Number(),
  Title: t.String(),
  Pages: t.Array(
    t.Object({
      MenuId: t.Number(),
      SubMenuId: t.Nullable(t.Number()),
      MenuLabel: t.String(),
      SubMenuLabel: t.Nullable(t.String()),
      PageKey: t.String(),
      IsPageAllow: t.Boolean(),
      Add: t.Boolean(),
      Edit: t.Boolean(),
      Delete: t.Boolean(),
      Export: t.Boolean(),
    }),
  ),
  AssignedCount: t.Number(),
  CanEdit: t.Boolean(),
  UpdatedBy: t.String(),
  UpdatedDate: t.String(),
});
const PageBody = t.Object({
  MenuId: t.Integer({ error: "Choose a menu" }),
  SubMenuId: t.Optional(t.Nullable(t.Integer({ error: "Choose a sub-menu" }))),
  ...flagSchemas,
});
const CreateStaffPermissionBody = t.Object({ Title, Pages: t.Array(PageBody, { maxItems: 500 }) });
const UpdateStaffPermissionBody = t.Object({ Title: t.Optional(Title), Pages: t.Optional(t.Array(PageBody, { maxItems: 500 })) });

export const permissions = new Elysia({ prefix: "/site/permissions", tags: ["Permissions"] })
  .use(organizationSiteGuard)
  .get(
    "/me",
    async ({ user, organizationId }) => {
      const catalog = await loadCatalog(organizationId);
      const effective = await effectivePermissions(user, organizationId, catalog);
      // Only what the user can View: PAGE menus with View, GROUP menus with at least one viewable
      // sub-menu (listing only those).
      const menus = catalog.flatMap((m): NavMenu[] => {
        if (m.type === "PAGE") return m.page && effective[m.page.key] ? [{ key: m.key, label: m.label, type: m.type, order: m.order, subMenus: [] }] : [];
        const subMenus = m.subMenus.filter((s) => effective[s.key]).map(({ key, label, order }) => ({ key, label, order }));
        return subMenus.length ? [{ key: m.key, label: m.label, type: m.type, order: m.order, subMenus }] : [];
      });
      return { menus, permissions: effective };
    },
    {
      response: {
        200: t.Object({
          menus: t.Array(t.Composite([NavItem, t.Object({ type: t.Union([t.Literal("PAGE"), t.Literal("GROUP")]), subMenus: t.Array(NavItem) })])),
          permissions: t.Record(t.String(), PagePermission),
        }),
      },
      detail: { summary: "The signed-in user's viewable menus (nav order, this organization's labels) and effective actions per page key" },
    },
  )
  .get(
    "/options",
    async ({ user, organizationId, permissions }) => {
      const catalog = await loadCatalog(organizationId);
      const grantable = Object.fromEntries(
        catalogPages(catalog).map((p) => [p.key, Object.fromEntries(ACTIONS.map((a) => [a, allows(permissions, p.key, a)]))]),
      );
      return {
        menus: catalog
          .filter((m) => m.type === "PAGE" || m.subMenus.length > 0)
          .map((m) => ({
            MenuId: m.menuId,
            MenuKey: m.key,
            Label: m.label,
            MenuType: m.type,
            SubMenus: m.subMenus.map((s) => ({ SubMenuId: s.subMenuId!, SubMenuKey: s.key, Label: s.label })),
          })),
        roles: await rolesBelow(db, organizationId, user.roleId),
        grantable,
      };
    },
    {
      transform: requirePermissionManager,
      response: {
        200: t.Object({
          menus: t.Array(
            t.Object({
              MenuId: t.Number(),
              MenuKey: t.String(),
              Label: t.String(),
              MenuType: t.Union([t.Literal("PAGE"), t.Literal("GROUP")]),
              SubMenus: t.Array(t.Object({ SubMenuId: t.Number(), SubMenuKey: t.String(), Label: t.String() })),
            }),
          ),
          roles: t.Array(t.Object({ RoleId: t.Number(), RoleName: t.String() })),
          grantable: t.Record(t.String(), t.Record(t.String(), t.Boolean())),
        }),
        403: Message,
      },
      detail: { summary: "For the permission forms: menus / sub-menus, roles below you, and the actions you can grant per page key" },
    },
  )
  .get(
    "/roles",
    async ({ user, organizationId }) => {
      const rows = await selectItems(db)
        .where(
          and(
            eq(rolePermission.OrganizationId, organizationId),
            ne(rolePermission.RecordStatus, "D"),
            sql`${sysRole.RolePriority} > ${callerPriority(user.roleId)}`,
          ),
        )
        .orderBy(asc(sysRole.RolePriority), asc(sysMenu.Order), asc(sysMenu.MenuId), asc(subMenu.Order), asc(rolePermission.RolePermissionId));
      return rows.map(toItem);
    },
    {
      transform: requirePermissionManager,
      response: { 200: t.Array(RolePermissionItem), 403: Message },
      detail: { summary: "Role permissions of roles below you (by role priority, then menu order)" },
    },
  )
  .post(
    "/roles",
    async ({ body, user, organizationId, permissions, status }) => {
      const title = body.Title.trim();
      try {
        const result = await db.transaction(async (tx) => {
          // Role: must be a role of this organization below the caller.
          const [target] = await tx
            .select({ RoleId: role.RoleId })
            .from(role)
            .where(and(eq(role.OrganizationId, organizationId), eq(role.RoleId, body.RoleId), ne(role.RecordStatus, "D")))
            .limit(1);
          if (!target || body.RoleId === DEVELOPER_ROLE_ID) return { kind: "invalid", fields: { RoleId: "Choose a role" } } as const;
          if (!(await isRoleBelow(tx, user.roleId, body.RoleId))) return { kind: "forbidden" } as const;

          // Page: a PAGE menu, or a sub-menu of a GROUP menu in this organization (both active).
          const catalog = await loadCatalog(organizationId);
          const menu = catalog.find((m) => m.menuId === body.MenuId);
          if (!menu) return { kind: "invalid", fields: { MenuId: "Choose a menu" } } as const;
          let page;
          if (menu.type === "PAGE") {
            if (body.SubMenuId != null) return { kind: "invalid", fields: { SubMenuId: "This menu has no sub-menus" } } as const;
            page = menu.page!;
          } else {
            page = menu.subMenus.find((s) => s.subMenuId === body.SubMenuId);
            if (!page) return { kind: "invalid", fields: { SubMenuId: "Choose a sub-menu" } } as const;
          }

          const flags = normalizeFlags({ IsPageAllow: body.IsPageAllow, Add: body.Add, Edit: body.Edit, Delete: body.Delete, Export: body.Export });
          const fields: Record<string, string> = grantErrors(permissions, page.key, flags);
          if (await titleTaken(tx, organizationId, title)) fields.Title = "Title is already used";
          const [existing] = await tx
            .select({ id: rolePermission.RolePermissionId })
            .from(rolePermission)
            .where(
              and(
                eq(rolePermission.OrganizationId, organizationId),
                eq(rolePermission.RoleId, body.RoleId),
                eq(rolePermission.MenuId, page.menuId),
                page.subMenuId === null ? sql`${rolePermission.SubMenuId} is null` : eq(rolePermission.SubMenuId, page.subMenuId),
                ne(rolePermission.RecordStatus, "D"),
              ),
            )
            .limit(1);
          if (existing) fields.RoleId = "This role already has a permission for this page";
          if (Object.keys(fields).length) return { kind: "invalid", fields } as const;

          const [created] = await tx
            .insert(rolePermission)
            .values({
              OrganizationId: organizationId,
              RoleId: body.RoleId,
              MenuId: page.menuId,
              SubMenuId: page.subMenuId,
              Title: title,
              IsPageAllow: flagOf(flags.IsPageAllow),
              Add: flagOf(flags.Add),
              Edit: flagOf(flags.Edit),
              Delete: flagOf(flags.Delete),
              Export: flagOf(flags.Export),
              ViewType: body.ViewType ?? "SELF",
              RecordStatus: "A",
              AddedBy: user.userName,
              AddedDate: sql`localtimestamp`,
              UpdatedBy: user.userName,
              UpdatedDate: sql`localtimestamp`,
            })
            .returning({ id: rolePermission.RolePermissionId });
          const [row] = await selectItems(tx).where(eq(rolePermission.RolePermissionId, created!.id));
          return { kind: "ok", row: row! } as const;
        });
        if (result.kind === "forbidden") return status(403, FORBIDDEN);
        if (result.kind === "invalid") return status(422, { message: INVALID, fields: { ...result.fields } });
        return status(201, toItem(result.row));
      } catch (error) {
        const fields = uniqueViolationFields(error);
        if (!fields) throw error;
        return status(422, { message: INVALID, fields });
      }
    },
    {
      transform: requirePermissionManager,
      body: CreateBody,
      response: { 201: RolePermissionItem, 403: Message, 422: ValidationError },
      detail: { summary: "Create a role permission for a role below you on one page" },
    },
  )
  .patch(
    "/roles/:id",
    async ({ params, body, user, organizationId, permissions, status }) => {
      if (Object.values(body).every((v) => v === undefined)) {
        return status(422, { message: "Provide at least one field to update.", fields: {} });
      }
      try {
        const result = await db.transaction(async (tx) => {
          const found = await managedPermission(tx, organizationId, user, params.id);
          if (found.kind !== "ok") return found;
          const before = flagsOf(found.row);
          const flags = normalizeFlags({
            IsPageAllow: body.IsPageAllow ?? before.IsPageAllow,
            Add: body.Add ?? before.Add,
            Edit: body.Edit ?? before.Edit,
            Delete: body.Delete ?? before.Delete,
            Export: body.Export ?? before.Export,
          });
          const fields: Record<string, string> = grantErrors(permissions, found.row.PageKey, flags, before);
          const title = body.Title?.trim();
          if (title !== undefined && (await titleTaken(tx, organizationId, title, params.id))) fields.Title = "Title is already used";
          if (Object.keys(fields).length) return { kind: "invalid", fields } as const;

          await tx
            .update(rolePermission)
            .set({
              ...(title !== undefined ? { Title: title } : {}),
              IsPageAllow: flagOf(flags.IsPageAllow),
              Add: flagOf(flags.Add),
              Edit: flagOf(flags.Edit),
              Delete: flagOf(flags.Delete),
              Export: flagOf(flags.Export),
              ...(body.ViewType !== undefined ? { ViewType: body.ViewType } : {}),
              UpdatedBy: user.userName,
              UpdatedDate: sql`localtimestamp`,
            })
            .where(eq(rolePermission.RolePermissionId, params.id));
          const [row] = await selectItems(tx).where(eq(rolePermission.RolePermissionId, params.id));
          return { kind: "ok", row: row! } as const;
        });
        if (result.kind === "not-found") return status(404, NOT_FOUND);
        if (result.kind === "forbidden") return status(403, FORBIDDEN);
        if (result.kind === "invalid") return status(422, { message: INVALID, fields: { ...result.fields } });
        return toItem(result.row);
      } catch (error) {
        const fields = uniqueViolationFields(error);
        if (!fields) throw error;
        return status(422, { message: INVALID, fields });
      }
    },
    {
      transform: requirePermissionManager,
      params: IdParams,
      body: UpdateBody,
      response: { 200: RolePermissionItem, 403: Message, 404: Message, 422: ValidationError },
      detail: { summary: "Change a role permission's title, actions or view type (role and page are fixed)" },
    },
  )
  .delete(
    "/roles/:id",
    async ({ params, user, organizationId, status, set }) => {
      const result = await db.transaction(async (tx) => {
        const found = await managedPermission(tx, organizationId, user, params.id);
        if (found.kind !== "ok") return found;
        const deleted = { RecordStatus: "D", UpdatedBy: user.userName, UpdatedDate: sql`localtimestamp` };
        await tx.update(rolePermission).set(deleted).where(eq(rolePermission.RolePermissionId, params.id));
        return { kind: "ok" } as const;
      });
      if (result.kind === "not-found") return status(404, NOT_FOUND);
      if (result.kind === "forbidden") return status(403, FORBIDDEN);
      set.status = 204;
    },
    {
      transform: requirePermissionManager,
      params: IdParams,
      response: { 204: t.Void(), 403: Message, 404: Message },
      detail: { summary: "Delete a role permission" },
    },
  )
  .get(
    "/staff-permissions",
    async ({ user, organizationId }) => staffPermissionItems(db, organizationId, user.roleId),
    {
      transform: requirePermissionManager,
      response: { 200: t.Array(StaffPermissionItem), 403: Message },
      detail: { summary: "The organization's staff permissions (by title) with their pages and how many staff use each" },
    },
  )
  .post(
    "/staff-permissions",
    async ({ body, user, organizationId, status }) => {
      const title = body.Title.trim();
      const { fields, resolved } = await resolvePages(organizationId, body.Pages);
      try {
        const result = await db.transaction(async (tx) => {
          if (await staffPermissionTitleTaken(tx, organizationId, title)) fields.Title = "Title is already used";
          if (Object.keys(fields).length) return { kind: "invalid" } as const;
          const [created] = await tx
            .insert(staffPermission)
            .values({
              OrganizationId: organizationId,
              Title: title,
              RecordStatus: "A",
              AddedBy: user.userName,
              AddedDate: sql`localtimestamp`,
              UpdatedBy: user.userName,
              UpdatedDate: sql`localtimestamp`,
            })
            .returning({ id: staffPermission.StaffPermissionId });
          await writePages(tx, created!.id, resolved);
          const [item] = await staffPermissionItems(tx, organizationId, user.roleId, created!.id);
          return { kind: "ok", item: item! } as const;
        });
        if (result.kind === "invalid") return status(422, { message: INVALID, fields });
        return status(201, result.item);
      } catch (error) {
        if (!isStaffPermissionTitleTaken(error)) throw error;
        return status(422, { message: INVALID, fields: { Title: "Title is already used" } });
      }
    },
    {
      transform: requirePermissionManager,
      body: CreateStaffPermissionBody,
      response: { 201: StaffPermissionItem, 403: Message, 422: ValidationError },
      detail: { summary: "Create a staff permission (unique title, actions per page)" },
    },
  )
  .patch(
    "/staff-permissions/:id",
    async ({ params, body, user, organizationId, status }) => {
      if (body.Title === undefined && body.Pages === undefined) {
        return status(422, { message: "Provide at least one field to update.", fields: {} });
      }
      const title = body.Title?.trim();
      const { fields, resolved } = body.Pages ? await resolvePages(organizationId, body.Pages) : { fields: {} as Record<string, string>, resolved: [] };
      try {
        const result = await db.transaction(async (tx) => {
          const [current] = await staffPermissionItems(tx, organizationId, user.roleId, params.id);
          if (!current) return { kind: "not-found" } as const;
          if (!current.CanEdit) return { kind: "forbidden" } as const;
          if (title !== undefined && (await staffPermissionTitleTaken(tx, organizationId, title, params.id))) fields.Title = "Title is already used";
          if (Object.keys(fields).length) return { kind: "invalid" } as const;
          await tx
            .update(staffPermission)
            .set({ ...(title !== undefined ? { Title: title } : {}), UpdatedBy: user.userName, UpdatedDate: sql`localtimestamp` })
            .where(eq(staffPermission.StaffPermissionId, params.id));
          if (body.Pages) await writePages(tx, params.id, resolved);
          const [item] = await staffPermissionItems(tx, organizationId, user.roleId, params.id);
          return { kind: "ok", item: item! } as const;
        });
        if (result.kind === "not-found") return status(404, STAFF_PERMISSION_NOT_FOUND);
        if (result.kind === "forbidden") return status(403, USED_ABOVE);
        if (result.kind === "invalid") return status(422, { message: INVALID, fields });
        return result.item;
      } catch (error) {
        if (!isStaffPermissionTitleTaken(error)) throw error;
        return status(422, { message: INVALID, fields: { Title: "Title is already used" } });
      }
    },
    {
      transform: requirePermissionManager,
      params: IdParams,
      body: UpdateStaffPermissionBody,
      response: { 200: StaffPermissionItem, 403: Message, 404: Message, 422: ValidationError },
      detail: { summary: "Change a staff permission's title and / or pages (pages are replaced as a whole)" },
    },
  )
  .delete(
    "/staff-permissions/:id",
    async ({ params, user, organizationId, status, set }) => {
      const result = await db.transaction(async (tx) => {
        const [current] = await staffPermissionItems(tx, organizationId, user.roleId, params.id);
        if (!current) return { kind: "not-found" } as const;
        if (!current.CanEdit) return { kind: "forbidden" } as const;
        const audit = { UpdatedBy: user.userName, UpdatedDate: sql`localtimestamp` };
        await tx.update(staffPermission).set({ RecordStatus: "D", ...audit }).where(eq(staffPermission.StaffPermissionId, params.id));
        // Its staff fall back to their role's permissions.
        await tx.update(login).set({ StaffPermissionId: null, ...audit }).where(eq(login.StaffPermissionId, params.id));
        return { kind: "ok" } as const;
      });
      if (result.kind === "not-found") return status(404, STAFF_PERMISSION_NOT_FOUND);
      if (result.kind === "forbidden") return status(403, USED_ABOVE);
      set.status = 204;
    },
    {
      transform: requirePermissionManager,
      params: IdParams,
      response: { 204: t.Void(), 403: Message, 404: Message },
      detail: { summary: "Delete a staff permission (its staff fall back to their role's permissions)" },
    },
  );
