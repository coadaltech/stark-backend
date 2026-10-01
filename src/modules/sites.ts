import { Elysia, t } from "elysia";
import { resolveHost } from "../sites/resolve";

/**
 * Which site a host belongs to (spec §5.3). Public: the frontend asks before it knows who is signed in,
 * and it only reveals what that host's own site shows anyway.
 */
export const sites = new Elysia({ prefix: "/sites" }).get(
  "/resolve",
  async ({ query, status }) => (await resolveHost(query.host)) ?? status(404, { message: "Site not found" }),
  {
    query: t.Object({ host: t.String({ minLength: 1, maxLength: 300, error: "Host is required" }) }),
    response: {
      200: t.Union([
        t.Object({ kind: t.Literal("main") }),
        t.Object({ kind: t.Literal("organization"), organizationId: t.Number(), name: t.String() }),
      ]),
      404: t.Object({ message: t.String() }),
    },
    detail: { summary: "Which site a host belongs to (main app, an organization, or none)" },
  },
);
