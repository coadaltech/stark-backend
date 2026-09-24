import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import { env } from "../env";
import * as schema from "./schema";

export const client = postgres(env.DATABASE_URL, { connection: { TimeZone: env.DB_TIMEZONE } });
export const db = drizzle(client, { schema });
