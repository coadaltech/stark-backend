-- Converted from MySQL procedure `CreateIndex`.
-- returns TABLE: when the index already exists, one row with the message (MySQL sent a result set only in that case);
-- when the index is created, no rows.
DROP ROUTINE IF EXISTS "CreateIndex";
CREATE OR REPLACE FUNCTION "CreateIndex"(
    given_table   varchar,
    given_index   varchar,
    given_columns varchar
) RETURNS TABLE("CreateindexErrorMessage" text)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
DECLARE
    IndexIsThere integer;
BEGIN
    -- MySQL INFORMATION_SCHEMA.STATISTICS (current schema) -> pg_indexes on the current schema.
    SELECT count(1) INTO IndexIsThere
    FROM pg_catalog.pg_indexes pi
    WHERE pi.schemaname = current_schema()
      AND pi.tablename  = given_table
      AND pi.indexname  = given_index;

    IF IndexIsThere = 0 THEN
        -- given_columns is a raw column list (e.g. 'a, b'), interpolated verbatim as in MySQL.
        EXECUTE format('CREATE INDEX IF NOT EXISTS %I ON %I (%s)', given_index, given_table, given_columns);
    ELSE
        RETURN QUERY SELECT ('Index ' || given_index::text || ' already exists on Table ' || given_table::text)::text;
    END IF;
END
$$;
