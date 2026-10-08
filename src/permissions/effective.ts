// Effective permissions on an organization site (specs/build/permissions/permission_spec.md §3.1).
import { and, asc, eq, ne } from "drizzle-orm";
import { db } from "../db";
import { login, rolePermission, staffPermission, staffPermissionPage, subMenu, sysMenu } from "../db/legacy";
import type { AuthUser } from "../auth/tokens";

const DEVELOPER_ROLE_ID = 1;

export const ACTIONS = ["view", "add", "edit", "delete", "export"] as const;
export type Action = (typeof ACTIONS)[number];
/** SELF = all users' records including mine; ALL = excluding mine. */
export type ViewType = "ALL" | "SELF";
export type PagePermission = Record<Action, boolean> & { viewType: ViewType };
/** Effective permissions by page key; pages without View are absent. */
export type PermissionMap = Record<string, PagePermission>;

/** A page permissions attach to: a PAGE menu, or a sub-menu of a GROUP menu. */
export type CatalogPage = { key: string; label: string; order: number; menuId: number; subMenuId: number | null };
export type CatalogMenu = {
  key: string;
  label: string;
  type: "PAGE" | "GROUP";
  order: number;
  menuId: number;
  /** PAGE menus: the menu itself. */
  page: CatalogPage | null;
  /** GROUP menus: the organization's active sub-menus. */
  subMenus: CatalogPage[];
};

const isDeveloper = (user: AuthUser) => user.roleId === DEVELOPER_ROLE_ID && user.organizationId === null;

/**
 * The organization's active menus and pages, in nav order. Menus are global; GROUP menus list the
 * organization's own sub-menus. Inactive menus / sub-menus are left out (unavailable to everyone).
 */
export async function loadCatalog(organizationId: number): Promise<CatalogMenu[]> {
  const [menus, subs] = await Promise.all([
    db
      .select({ menuId: sysMenu.MenuId, key: sysMenu.MenuKey, label: sysMenu.Menu, type: sysMenu.MenuType, order: sysMenu.Order })
      .from(sysMenu)
      .where(ne(sysMenu.RecordStatus, "D"))
      .orderBy(asc(sysMenu.Order), asc(sysMenu.MenuId)),
    db
      .select({ subMenuId: subMenu.SubMenuId, menuId: subMenu.MenuId, key: subMenu.SubMenuKey, label: subMenu.Label, order: subMenu.Order })
      .from(subMenu)
      .where(and(eq(subMenu.OrganizationId, organizationId), ne(subMenu.RecordStatus, "D")))
      .orderBy(asc(subMenu.Order), asc(subMenu.SubMenuId)),
  ]);
  return menus.map((m) => ({
    ...m,
    page: m.type === "PAGE" ? { key: m.key, label: m.label, order: m.order, menuId: m.menuId, subMenuId: null } : null,
    subMenus:
      m.type === "GROUP"
        ? subs.filter((s) => s.menuId === m.menuId).map((s) => ({ key: s.key, label: s.label, order: s.order, menuId: s.menuId, subMenuId: s.subMenuId }))
        : [],
  }));
}

/** Every page of the catalog. */
export const catalogPages = (catalog: CatalogMenu[]) =>
  catalog.flatMap((m) => (m.page ? [m.page] : m.subMenus));

const ALL_ACTIONS: PagePermission = { view: true, add: true, edit: true, delete: true, export: true, viewType: "SELF" };

/**
 * The user's effective permissions on the organization's pages (spec §3.1):
 * developer → everything (ViewType SELF: all records); otherwise the role's permission for each page
 * AND the person's staff permission for that page (a page the staff permission has no entry for — or no
 * staff permission at all — is decided by the role); no role permission → no access.
 * Add / Edit / Delete / Export only count with View. ViewType always comes from the role.
 */
export async function effectivePermissions(user: AuthUser, organizationId: number, catalog?: CatalogMenu[]): Promise<PermissionMap> {
  const pages = catalogPages(catalog ?? (await loadCatalog(organizationId)));
  if (isDeveloper(user)) return Object.fromEntries(pages.map((p) => [p.key, ALL_ACTIONS]));

  const [roleRows, staffRows] = await Promise.all([
    db
      .select({
        menuId: rolePermission.MenuId,
        subMenuId: rolePermission.SubMenuId,
        view: rolePermission.IsPageAllow,
        add: rolePermission.Add,
        edit: rolePermission.Edit,
        delete: rolePermission.Delete,
        export: rolePermission.Export,
        viewType: rolePermission.ViewType,
      })
      .from(rolePermission)
      .where(
        and(
          eq(rolePermission.OrganizationId, organizationId),
          eq(rolePermission.RoleId, user.roleId),
          ne(rolePermission.RecordStatus, "D"),
        ),
      ),
    // The person's staff permission pages (none when unassigned or the set was deleted).
    db
      .select({
        menuId: staffPermissionPage.MenuId,
        subMenuId: staffPermissionPage.SubMenuId,
        view: staffPermissionPage.IsPageAllow,
        add: staffPermissionPage.Add,
        edit: staffPermissionPage.Edit,
        delete: staffPermissionPage.Delete,
        export: staffPermissionPage.Export,
      })
      .from(login)
      .innerJoin(
        staffPermission,
        and(eq(staffPermission.StaffPermissionId, login.StaffPermissionId), ne(staffPermission.RecordStatus, "D")),
      )
      .innerJoin(staffPermissionPage, eq(staffPermissionPage.StaffPermissionId, staffPermission.StaffPermissionId))
      .where(eq(login.LoginId, user.loginId)),
  ]);

  const map: PermissionMap = {};
  for (const page of pages) {
    const samePage = (r: { menuId: number; subMenuId: number | null }) => r.menuId === page.menuId && (r.subMenuId ?? null) === page.subMenuId;
    const role = roleRows.find(samePage);
    if (!role) continue;
    const staff = staffRows.find(samePage);
    // Role flag AND staff permission flag (no staff entry for the page = no extra limit).
    const on = (roleFlag: string, staffFlag: string | undefined) => roleFlag === "1" && (staffFlag ?? "1") === "1";
    const view = on(role.view, staff?.view);
    if (!view) continue;
    map[page.key] = {
      view,
      add: on(role.add, staff?.add),
      edit: on(role.edit, staff?.edit),
      delete: on(role.delete, staff?.delete),
      export: on(role.export, staff?.export),
      viewType: role.viewType,
    };
  }
  return map;
}

/** Whether `permissions` allow `action` on `pageKey` (anything besides View needs View too). */
export const allows = (permissions: PermissionMap, pageKey: string, action: Action) => {
  const page = permissions[pageKey];
  return Boolean(page && page.view && page[action]);
};
