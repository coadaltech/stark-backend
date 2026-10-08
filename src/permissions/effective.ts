// Effective permissions on an organization site (specs/build/permissions/permission_spec.md §3.1).
import { and, asc, eq, ne } from "drizzle-orm";
import { db } from "../db";
import { rolePermission, staffPermission, subMenu, sysMenu } from "../db/legacy";
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
 * The user's effective permissions on the organization's pages:
 * developer → everything (ViewType SELF: all records); otherwise the role's permission for each page
 * with the person's switched-off actions removed; no role permission → no access.
 * Add / Edit / Delete / Export only count with View.
 */
export async function effectivePermissions(user: AuthUser, organizationId: number, catalog?: CatalogMenu[]): Promise<PermissionMap> {
  const pages = catalogPages(catalog ?? (await loadCatalog(organizationId)));
  if (isDeveloper(user)) return Object.fromEntries(pages.map((p) => [p.key, ALL_ACTIONS]));

  const rows = await db
    .select({
      menuId: rolePermission.MenuId,
      subMenuId: rolePermission.SubMenuId,
      view: rolePermission.IsPageAllow,
      add: rolePermission.Add,
      edit: rolePermission.Edit,
      delete: rolePermission.Delete,
      export: rolePermission.Export,
      viewType: rolePermission.ViewType,
      keepView: staffPermission.IsPageAllow,
      keepAdd: staffPermission.Add,
      keepEdit: staffPermission.Edit,
      keepDelete: staffPermission.Delete,
      keepExport: staffPermission.Export,
    })
    .from(rolePermission)
    .leftJoin(
      staffPermission,
      and(
        eq(staffPermission.RolePermissionId, rolePermission.RolePermissionId),
        eq(staffPermission.LoginId, user.loginId),
        ne(staffPermission.RecordStatus, "D"),
      ),
    )
    .where(
      and(
        eq(rolePermission.OrganizationId, organizationId),
        eq(rolePermission.RoleId, user.roleId),
        ne(rolePermission.RecordStatus, "D"),
      ),
    );

  const map: PermissionMap = {};
  for (const page of pages) {
    const row = rows.find((r) => r.menuId === page.menuId && (r.subMenuId ?? null) === page.subMenuId);
    if (!row) continue;
    // Role flag AND not switched off for this person (no staff row = nothing switched off).
    const on = (role: string, keep: string | null) => role === "1" && (keep ?? "1") === "1";
    const view = on(row.view, row.keepView);
    if (!view) continue;
    map[page.key] = {
      view,
      add: on(row.add, row.keepAdd),
      edit: on(row.edit, row.keepEdit),
      delete: on(row.delete, row.keepDelete),
      export: on(row.export, row.keepExport),
      viewType: row.viewType,
    };
  }
  return map;
}

/** Whether `permissions` allow `action` on `pageKey` (anything besides View needs View too). */
export const allows = (permissions: PermissionMap, pageKey: string, action: Action) => {
  const page = permissions[pageKey];
  return Boolean(page && page.view && page[action]);
};
