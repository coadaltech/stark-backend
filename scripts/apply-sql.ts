// Applies the raw SQL schema (sql/001_tables.sql, ...) and every routine in sql/procedures/
// to DATABASE_URL in one transaction. Safe to re-run: tables/indexes use IF NOT EXISTS and
// each routine file drops and recreates itself.
import { Glob } from "bun";
import postgres from "postgres";

const url = process.env.DATABASE_URL;
if (!url) throw new Error("Missing required env var: DATABASE_URL");

const root = new URL("../sql/", import.meta.url).pathname;
const schemaFiles = [...new Glob("*.sql").scanSync(root)].sort();
const routineFiles = [...new Glob("procedures/*.sql").scanSync(root)].sort();

const sql = postgres(url, { onnotice: () => {} });
try {
  await sql.begin(async (tx) => {
    for (const file of [...schemaFiles, ...routineFiles]) {
      try {
        await tx.unsafe(await Bun.file(root + file).text());
      } catch (err) {
        throw new Error(`${file}: ${(err as Error).message}`);
      }
    }
  });
  console.log(`Applied ${schemaFiles.length} schema file(s) and ${routineFiles.length} routine(s).`);
} finally {
  await sql.end();
}
