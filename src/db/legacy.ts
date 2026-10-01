// Tables owned by the raw SQL schema in sql/ (converted from the legacy MySQL dump).
// They are intentionally NOT in drizzle.config's schema, so drizzle-kit never tries to
// create or alter them; they're defined here only for typed queries.
// Only the columns the app reads or writes are listed; the rest keep their DB defaults.
import { bigint, char, date, integer, pgTable, smallint, text, timestamp, uuid, varchar } from "drizzle-orm/pg-core";

export const organization = pgTable("organization", {
  OrganizationId: bigint("OrganizationId", { mode: "number" }).primaryKey().generatedByDefaultAsIdentity(),
  OrganizationOwnerName: varchar("OrganizationOwnerName", { length: 30 }).notNull(),
  OrganizationName: varchar("OrganizationName", { length: 30 }).notNull(),
  OrganizationLogoColor: varchar("OrganizationLogoColor", { length: 20 }).notNull(),
  OrganizationTheme: varchar("OrganizationTheme", { length: 20 }).notNull(),
  OrganizationAppAccess: integer("OrganizationAppAccess").default(0),
  OrganizationMobile: varchar("OrganizationMobile", { length: 10 }).notNull(),
  OrganizationAddress: varchar("OrganizationAddress", { length: 60 }).notNull(),
  OrganizationOnDomain: integer("OrganizationOnDomain").notNull().default(0),
  OrganizationDomainURL: varchar("OrganizationDomainURL", { length: 100 }).notNull().default(""),
  // Config tab settings (legacy flags are 0/1; most columns are nullable with a default).
  IsEnableTazzaPatti: integer("IsEnableTazzaPatti").notNull().default(0),
  IsMainJantriRoundOf: integer("IsMainJantriRoundOf").default(0),
  IsCollectionJantriRoundOf: integer("IsCollectionJantriRoundOf").default(0),
  IsMultiplyUpMainJantri: integer("IsMultiplyUpMainJantri").default(0),
  IsMultiplyUpCollection: integer("IsMultiplyUpCollection").default(0),
  RoundOffOnMainJantri: integer("RoundOffOnMainJantri").default(50),
  RoundOffOnCollection: integer("RoundOffOnCollection").default(50),
  skey_Random_Old: integer("skey_Random_Old").notNull().default(1),
  skey_Crossing: integer("skey_Crossing").notNull().default(1),
  skey_FromTo: integer("skey_FromTo").notNull().default(1),
  skey_Random_New: integer("skey_Random_New").notNull().default(1),
  skey_OddEven: integer("skey_OddEven").notNull().default(0),
  skey_EkdiDukdi: integer("skey_EkdiDukdi").notNull().default(0),
  skey_Joda: integer("skey_Joda").notNull().default(0),
  skey_JodiDaane: integer("skey_JodiDaane").default(0),
  IsVoucherVerify: smallint("IsVoucherVerify").default(0),
  IsDashboardStaffGainerLooser: smallint("IsDashboardStaffGainerLooser").default(0),
  IsTransactionAlreadyExist: smallint("IsTransactionAlreadyExist").default(0),
  HissaNotApplyMode: integer("HissaNotApplyMode").default(0),
  VapsiWorkingDays: integer("VapsiWorkingDays").default(0),
  IsAutoUserNameForStaff: integer("IsAutoUserNameForStaff").default(0),
  UnPaidKistPopupForDashboard: integer("UnPaidKistPopupForDashboard").default(0),
  IsBackLimitPopup: smallint("IsBackLimitPopup").default(0),
  AbsentLedgerLockDays: integer("AbsentLedgerLockDays").default(0),
  // Salary tab settings.
  IsAutoSalaryCreate: smallint("IsAutoSalaryCreate").default(0),
  IsAutoSalaryPaid: smallint("IsAutoSalaryPaid").default(0),
  OrganizationSms: varchar("OrganizationSms", { length: 1 }).notNull(),
  OrganizationSmsUrl: varchar("OrganizationSmsUrl", { length: 100 }).notNull(),
  OrganizationSmsUsername: varchar("OrganizationSmsUsername", { length: 30 }).notNull(),
  OrganizationSmsPassword: varchar("OrganizationSmsPassword", { length: 30 }).notNull(),
  OrganizationSmsPort: varchar("OrganizationSmsPort", { length: 10 }).notNull(),
  OrganizationSmsSenderId: varchar("OrganizationSmsSenderId", { length: 10 }).notNull(),
  OrganizationSmsToken: text("OrganizationSmsToken").notNull(),
  IsTransactionEnable: varchar("IsTransactionEnable", { length: 1 }).notNull(),
  OrganizationStartDate: date("OrganizationStartDate", { mode: "string" }).notNull(),
  OrganizationEndDate: date("OrganizationEndDate", { mode: "string" }).notNull(),
  IsOrganizationAllow: varchar("IsOrganizationAllow", { length: 1 }).notNull(),
  // Telegram tab.
  TelegramAllow: smallint("TelegramAllow").default(0),
  TelegramUrl: varchar("TelegramUrl", { length: 250 }).default(""),
  TelegramSession: text("TelegramSession"),
  RecordStatus: char("RecordStatus", { length: 1 }).notNull(),
  AddedBy: varchar("AddedBy", { length: 30 }).notNull(),
  AddedDate: timestamp("AddedDate", { mode: "string" }).notNull(),
  UpdatedBy: varchar("UpdatedBy", { length: 30 }).notNull(),
  UpdatedDate: timestamp("UpdatedDate", { mode: "string" }).notNull(),
});

// Accounts: developers (OrganizationId NULL) and staff. "LoginType" holds the RoleId.
export const login = pgTable("login", {
  LoginId: bigint("LoginId", { mode: "number" }).primaryKey().generatedByDefaultAsIdentity(),
  OrganizationId: bigint("OrganizationId", { mode: "number" }),
  LedgerId: bigint("LedgerId", { mode: "number" }).notNull(),
  LoginName: varchar("LoginName", { length: 80 }).notNull(),
  UserName: varchar("UserName", { length: 30 }).notNull(),
  Password: varchar("Password", { length: 80 }).notNull(),
  LoginType: smallint("LoginType").notNull(),
  Mobile: varchar("Mobile", { length: 20 }).notNull(),
  Address: varchar("Address", { length: 50 }).default(""),
  StaffWorkMode: integer("StaffWorkMode").notNull().default(0),
  AccountStatus: varchar("AccountStatus", { length: 1 }).notNull(),
  RecordStatus: char("RecordStatus", { length: 1 }).notNull(),
  AddedBy: varchar("AddedBy", { length: 30 }).notNull(),
  AddedDate: timestamp("AddedDate", { mode: "string" }).notNull(),
  UpdatedBy: varchar("UpdatedBy", { length: 30 }).notNull(),
  UpdatedDate: timestamp("UpdatedDate", { mode: "string" }).notNull(),
});

// Global role template (sql/004_roles.sql): priority and whether staff may be given the role.
export const sysRole = pgTable("sys_role", {
  RoleId: integer("RoleId").primaryKey(),
  RoleName: varchar("RoleName", { length: 50 }).notNull(),
  RolePriority: integer("RolePriority"),
  IsStaffCreatable: smallint("IsStaffCreatable").notNull().default(0),
  RecordStatus: char("RecordStatus", { length: 1 }).notNull(),
});

// Per-organization role definitions (one row per organization and role type).
export const role = pgTable("role", {
  Id: bigint("Id", { mode: "number" }).primaryKey().generatedByDefaultAsIdentity(),
  RoleId: integer("RoleId").notNull(),
  OrganizationId: bigint("OrganizationId", { mode: "number" }).notNull(),
  RoleName: varchar("RoleName", { length: 50 }).notNull(),
  IsWebLogin: smallint("IsWebLogin").default(0),
  RecordStatus: char("RecordStatus", { length: 1 }).notNull(),
});

// Sign-in sessions (sql/006_auth_session.sql). Only refresh-token hashes are stored.
export const authSession = pgTable("auth_session", {
  SessionId: uuid("SessionId").primaryKey(),
  LoginId: bigint("LoginId", { mode: "number" }).notNull(),
  Site: varchar("Site", { length: 255 }).notNull().default("main"),
  SiteOrganizationId: bigint("SiteOrganizationId", { mode: "number" }),
  Rotation: integer("Rotation").notNull().default(0),
  RefreshTokenHash: char("RefreshTokenHash", { length: 64 }).notNull(),
  PreviousRefreshTokenHash: char("PreviousRefreshTokenHash", { length: 64 }),
  ExpiresAt: timestamp("ExpiresAt", { withTimezone: true, mode: "date" }).notNull(),
  CreatedAt: timestamp("CreatedAt", { withTimezone: true, mode: "date" }).notNull().defaultNow(),
  RotatedAt: timestamp("RotatedAt", { withTimezone: true, mode: "date" }),
  RevokedAt: timestamp("RevokedAt", { withTimezone: true, mode: "date" }),
  RevokedReason: varchar("RevokedReason", { length: 30 }),
  UserAgent: varchar("UserAgent", { length: 300 }),
  Ip: varchar("Ip", { length: 64 }),
});
