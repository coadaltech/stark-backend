// Who may use which site (spec §5.2, §5.3): shared by sign-in (modules/auth.ts) and the guards.
import { and, eq, isNull, ne, or, sql } from "drizzle-orm";
import { db } from "../db";
import { login, organization, role, sysRole } from "../db/legacy";
import { normalizeHost } from "../sites/host";
import { resolveHost } from "../sites/resolve";
import { MAIN_SITE } from "./tokens";

export type Tx = Parameters<Parameters<typeof db.transaction>[0]>[0];

export const DEVELOPER_ROLE_ID = 1;
export const INACTIVE = "Your account is inactive. Please contact your administrator.";
export const ORGANIZATION_INACTIVE = "This organization is inactive. Please contact your administrator.";
export const ROLE_NO_WEB = "Your role can't sign in on the web.";


export type Account = {
  LoginId: number;
  UserName: string;
  LoginName: string;
  Password: string;
  LoginType: number;
  OrganizationId: number | null;
  AccountStatus: string;
  RoleName: string;
  /** The account's role in its organization allows web sign-in (staff only). */
  RoleWebLogin: boolean;
  /** The account's organization is active (staff only). */
  OrganizationActive: boolean;
};

/** The site a session is for: "main", or an organization site's host plus its organization. */
export type SessionSite = { site: string; siteOrganizationId: number | null };

/** The session site for a host, or null if the host isn't a site. */
export async function siteOfHost(host: string): Promise<SessionSite | null> {
  const resolved = await resolveHost(host);
  if (!resolved) return null;
  return resolved.kind === "main"
    ? { site: MAIN_SITE, siteOrganizationId: null }
    : { site: normalizeHost(host), siteOrganizationId: resolved.organizationId };
}

/** An organization session's host must still resolve to the same organization (Domain ON, not deleted). */
export async function siteStillValid(site: SessionSite): Promise<boolean> {
  if (site.site === MAIN_SITE) return site.siteOrganizationId === null;
  const resolved = await resolveHost(site.site);
  return resolved?.kind === "organization" && resolved.organizationId === site.siteOrganizationId;
}

export function selectAccount(executor: typeof db | Tx) {
  return executor
    .select({
      LoginId: login.LoginId,
      UserName: login.UserName,
      LoginName: login.LoginName,
      Password: login.Password,
      LoginType: login.LoginType,
      OrganizationId: login.OrganizationId,
      AccountStatus: login.AccountStatus,
      RoleName: sql<string>`coalesce(${sysRole.RoleName}, '')`,
      RoleWebLogin: sql<boolean>`coalesce(${role.IsWebLogin}, 0) = 1`,
      OrganizationActive: sql<boolean>`coalesce(${organization.IsOrganizationAllow}, '0') = '1'`,
    })
    .from(login)
    .leftJoin(sysRole, eq(sysRole.RoleId, login.LoginType))
    // The role as configured for the account's organization (IsWebLogin lives there).
    .leftJoin(
      role,
      and(
        eq(role.OrganizationId, login.OrganizationId),
        eq(role.RoleId, login.LoginType),
        ne(role.RecordStatus, "D"),
      ),
    )
    .leftJoin(organization, eq(organization.OrganizationId, login.OrganizationId))
    .$dynamic();
}

export const isDeveloperAccount = (account: Account) =>
  account.OrganizationId === null && account.LoginType === DEVELOPER_ROLE_ID;

/**
 * Why a matched account (correct password) may not use the site, or null if it may (spec §5.2).
 * Developers are always allowed (while active); staff also need a web-login role and an active
 * organization.
 */
export function denial(account: Account): { reason: string; message: string } | null {
  if (account.AccountStatus !== "1") return { reason: "inactive", message: INACTIVE };
  if (isDeveloperAccount(account)) return null;
  if (!account.OrganizationActive) return { reason: "organization", message: ORGANIZATION_INACTIVE };
  if (!account.RoleWebLogin) return { reason: "role", message: ROLE_NO_WEB };
  return null;
}

/**
 * Accounts that can sign in to a site (before the per-account checks in `denial`). Main app:
 * developers only. Organization site: developers, or that organization's accounts. Usernames are unique
 * per organization and developer usernames are reserved, so a username matches at most one of these.
 */
export function accountsOfSite(site: SessionSite) {
  const developer = and(isNull(login.OrganizationId), eq(login.LoginType, DEVELOPER_ROLE_ID));
  const scope =
    site.siteOrganizationId === null
      ? developer
      : or(developer, eq(login.OrganizationId, site.siteOrganizationId));
  return and(scope, ne(login.RecordStatus, "D"));
}
