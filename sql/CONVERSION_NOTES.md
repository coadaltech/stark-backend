# MySQL → PostgreSQL 17 procedure conversion rules (stark project)

Rules used to convert the original MySQL dump (`stark_table_procedures.sql`) into `001_tables.sql` and `procedures/*.sql`. Follow them when editing or adding routines. Apply with `bun run db:sql`.


## File shape
```sql
-- Converted from MySQL procedure `<name>`.
DROP ROUTINE IF EXISTS "<name>";
CREATE OR REPLACE <PROCEDURE|FUNCTION> "<name>"(<params>) ... LANGUAGE plpgsql AS $$ ... $$;
```
- Routine name: EXACT original name, double-quoted (e.g. "ledger_List").
- Params: keep original names UNQUOTED (e.g. `varOrganizationId bigint`). Types: bigint(n)→bigint, int(n)→integer, smallint→smallint, tinyint→smallint, float/double→double precision, decimal→numeric, varchar(n)/char(n)→varchar/char, text→text, date→date, datetime→timestamp.

## Return shape (decide from what the MySQL proc sends to the client)
1. No result set → `CREATE PROCEDURE`.
2. Exactly one result set per call (IF/CASE branches may pick different SELECTs, but only one reaches the client, AND all branches have the same column list) → `CREATE FUNCTION ... RETURNS TABLE(...)` using `RETURN QUERY`.
   - Output column names = the MySQL result column labels, EXACT case, double-quoted (e.g. `"LedgerName" text`, `"Mobile" text`).
   - Prefer: strings → `text`, int counts → `bigint`, float/double math → `double precision`, sums of bigint / round() results → `numeric`, dates → `date`/`timestamp`. Cast in the query (`::text`, `::bigint`…) so types match exactly (RETURN QUERY requires exact type match).
   - Put `#variable_conflict use_column` as the first line of the body, and ALWAYS qualify column references with table aliases.
3. More than one result set per call, OR branches returning different column lists → `CREATE FUNCTION ... RETURNS jsonb` returning a JSON array with one element per result set IN ORDER, each element a JSON array of row objects whose keys are the exact MySQL column labels:
   `RETURN jsonb_build_array((SELECT coalesce(jsonb_agg(t), '[]'::jsonb) FROM (<select 1>) t), ...);` (build up with a `v_result jsonb := '[]'` and `v_result := v_result || jsonb_build_array(...)` when result sets are emitted conditionally).
   Put a comment line above CREATE describing each element: `-- returns jsonb: [0] ledgers, [1] totals`.
- A SELECT that only assigns (`SELECT ... INTO var`) is not a result set.
- Callers: `auto_hp_vapsi_settelment_create` calls 3 procs; `dynamic_fair_trade_sel_main_jantri` calls `dynamic_fair_trade_sel_preductiondata_allnumber`. Use `CALL "x"(...)` for procedures; for functions whose rows the MySQL caller would have forwarded to the client, forward them (RETURN QUERY SELECT * FROM "x"(...) / merge into the jsonb), otherwise `PERFORM`.

## Identifiers & semantics
- Tables/columns: EXACT names from 001_tables.sql, double-quoted (`"ledger"."LedgerId"`). MySQL was case-insensitive, so the source may write `ledgerid` / `LEDGERID` — fix to the real case.
- Local variables: MySQL variables win over columns; in PG rename ANY local variable whose name matches (case-insensitively) a column name used in that routine to `v_<name>` (e.g. `VoucherId` → `v_VoucherId`). Params already have the `var` prefix.
- `IFNULL(a,b)` → `COALESCE(a,b)` (make arg types compatible: `COALESCE(x,'NA')` needs text x; `COALESCE(num, 0)`).
- `IF(c,a,b)` → `CASE WHEN c THEN a ELSE b END`. Integer used as condition → `x <> 0`.
- `CONCAT(a,b,...)` → `(a::text || b::text ...)` (MySQL CONCAT is NULL if any arg is NULL; PG concat() is not). `CONCAT_WS` → `concat_ws`.
- Division: MySQL `/` never truncates and returns NULL on /0. Use `a::numeric / NULLIF(b, 0)` (or `::double precision`).
- `ROUND(float, n)` → `round(x::numeric, n)` (no round(double, int) in PG). `TRUNCATE(x,n)` → `trunc(x::numeric, n)`.
- `DATE_FORMAT(d,'%d-%m-%Y')` → `to_char(d,'DD-MM-YYYY')` (%Y YYYY, %y YY, %m MM, %c FMMM, %d DD, %e FMDD, %H HH24, %h HH12, %i MI, %s SS, %p AM, %b Mon, %M FMMonth, %W FMDay, %a Dy).
- `DATE_ADD(d, INTERVAL n DAY)` on a date → `(d + n)` (stays date); for month/year → `(d + make_interval(months => n))::date`. `DATE_SUB` likewise. On timestamps keep timestamp.
- `DATEDIFF(a,b)` → `(a::date - b::date)`. `CURDATE()` → `current_date`. `NOW()` → `localtimestamp`. `YEAR/MONTH/DAY(d)` → `extract(year from d)::int` etc.
- `FIND_IN_SET(x, list)` in a condition → `x::text = ANY(string_to_array(list, ','))`; as a value → `coalesce(array_position(string_to_array(list, ','), x::text), 0)`.
- `LAST_INSERT_ID()` → `INSERT ... RETURNING "<IdCol>" INTO v_x`.
- Cursors with `CONTINUE HANDLER FOR NOT FOUND` → `FOR rec IN <query> LOOP ... END LOOP`.
- `LEAVE label` → `EXIT label`; `ITERATE` → `CONTINUE`; `WHILE ... DO ... END WHILE` → `WHILE ... LOOP ... END LOOP`; `REPEAT ... UNTIL c END REPEAT` → `LOOP ... EXIT WHEN c; END LOOP`.
- `CASE x WHEN ... END CASE` statements are fine in plpgsql, but add `ELSE NULL;` when not all values are covered (PG raises CASE_NOT_FOUND otherwise, MySQL too — keep if MySQL had none? MySQL also errors, so only add ELSE if the MySQL one had it).
- Session `@vars` → declared locals. `SET x = ...` → `x := ...`. `SELECT a INTO x` fine.
- Dynamic SQL (`PREPARE/EXECUTE`) → `EXECUTE format(...)` / `RETURN QUERY EXECUTE ...`; quote identifiers with %I and literals with %L or USING.
- Temp tables → `DROP TABLE IF EXISTS tmp; CREATE TEMP TABLE tmp (...) ON COMMIT DROP;` Add `PERFORM plpgsql_check_pragma('table: tmp(col type, ...)');` before use so the checker knows its shape.
- GROUP BY with non-aggregated, non-grouped columns (MySQL allows) → add them to GROUP BY if functionally dependent, else wrap with `any_value(...)` (PG16+).
- String literals: MySQL `"text"` → `'text'`. `<=>` → `IS NOT DISTINCT FROM`. `!=` fine.
- Comparing enum-like varchar columns (e.g. '0'/'1', 'Dr'/'Cr') to numbers → compare to string literals.
- Do NOT change business logic, drop branches, or "simplify". Keep original comments where useful. If something truly cannot be expressed, keep it as close as possible and add `-- TODO(convert): <why>`.

## Done criteria per routine
`check.sh` shows it created, plpgsql_check reports no `error` rows (warnings OK if understood), and the smoke run has no error other than ones clearly caused by NULL args. Anything not fully verifiable (dynamic SQL is not statically checked) → mention in report.
