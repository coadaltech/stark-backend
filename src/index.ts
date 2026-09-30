import { Elysia } from "elysia";
import { cors } from "@elysiajs/cors";
import { openapi } from "@elysiajs/openapi";
import { sql } from "drizzle-orm";
import { db } from "./db";
import { env } from "./env";
import { auth } from "./modules/auth";
import { organizations } from "./modules/organizations";
import { sites } from "./modules/sites";

export const app = new Elysia()
  .use(cors({ origin: env.CORS_ORIGIN, credentials: true }))
  .use(openapi())
  .onError({ as: "global" }, ({ code, error, status }) => {
    if (code !== "VALIDATION") return;
    // Flatten Elysia validation errors to { message, fields: { name: message } }.
    const fields: Record<string, string> = {};
    for (const issue of error.all) {
      const name = "path" in issue ? issue.path.replace(/^\//, "") : "";
      if (!name || fields[name]) continue;
      const custom = "schema" in issue ? (issue.schema as { error?: unknown }).error : undefined;
      fields[name] = typeof custom === "string" ? custom : issue.summary ?? "Invalid value";
    }
    return status(422, { message: "Please correct the highlighted fields.", fields });
  })
  .get("/", () => ({ name: "stark-backend" }))
  .get("/health", async () => {
    await db.execute(sql`select 1`);
    return { status: "ok", db: "up" };
  })
  .use(auth)
  .use(organizations)
  .use(sites)
  .listen(env.PORT);

export type App = typeof app;

console.log(`🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`);
