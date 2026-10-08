import { Elysia, t } from "elysia";
import { organizationSiteGuard } from "../auth/guard";
import { loadCatalog, effectivePermissions } from "../permissions/effective";

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

/** Permissions on organization sites; the organization always comes from the session. */
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
          menus: t.Array(
            t.Composite([NavItem, t.Object({ type: t.Union([t.Literal("PAGE"), t.Literal("GROUP")]), subMenus: t.Array(NavItem) })]),
          ),
          permissions: t.Record(t.String(), PagePermission),
        }),
      },
      detail: {
        summary:
          "The signed-in user's viewable menus (nav order, this organization's labels) and effective actions per page key",
      },
    },
  );
