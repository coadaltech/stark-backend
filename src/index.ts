import { Elysia } from "elysia";
import { cors } from "@elysiajs/cors";
import { openapi } from "@elysiajs/openapi";
import { sql } from "drizzle-orm";
import { db } from "./db";
import { env } from "./env";

export const app = new Elysia()
  .use(cors({ origin: env.CORS_ORIGIN, credentials: true }))
  .use(openapi())
  .get("/", () => ({ name: "stark-backend" }))
  .get("/health", async () => {
    await db.execute(sql`select 1`);
    return { status: "ok", db: "up" };
  })
  .listen(env.PORT);

export type App = typeof app;

console.log(`🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`);
