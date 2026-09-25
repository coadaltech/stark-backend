// Tables owned by the raw SQL schema in sql/ (converted from the legacy MySQL dump).
// They are intentionally NOT in drizzle.config's schema, so drizzle-kit never tries to
// create or alter them; they're defined here only for typed queries.
// Only the columns the app reads or writes are listed; the rest keep their DB defaults.
import { bigint, char, date, integer, pgTable, text, timestamp, varchar } from "drizzle-orm/pg-core";

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
  RecordStatus: char("RecordStatus", { length: 1 }).notNull(),
  AddedBy: varchar("AddedBy", { length: 30 }).notNull(),
  AddedDate: timestamp("AddedDate", { mode: "string" }).notNull(),
  UpdatedBy: varchar("UpdatedBy", { length: 30 }).notNull(),
  UpdatedDate: timestamp("UpdatedDate", { mode: "string" }).notNull(),
});
