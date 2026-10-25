-- A separate performance table using the case's inventory_batches.expiry_date type.
-- Only this field and a lab row ID are copied. Business constraints stay in Portfolio 1.
-- Generated values are for measuring a selective lookup, not complete case records.
CREATE SCHEMA query_lab;
CREATE TABLE query_lab."inventory_batches" AS
SELECT "expiry_date", 0::bigint AS "lab_row_id" FROM portfolio."inventory_batches" WITH NO DATA;
INSERT INTO query_lab."inventory_batches" ("expiry_date", "lab_row_id")
SELECT (DATE '2030-01-01' + (g % 1000)::integer), g FROM generate_series(1, 25000) AS g;
ANALYZE query_lab."inventory_batches";

-- Before: warm the lookup, then measure it three times.
SELECT "lab_row_id", "expiry_date"
FROM query_lab."inventory_batches"
WHERE "expiry_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "expiry_date"
FROM query_lab."inventory_batches"
WHERE "expiry_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "expiry_date"
FROM query_lab."inventory_batches"
WHERE "expiry_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "expiry_date"
FROM query_lab."inventory_batches"
WHERE "expiry_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";

CREATE INDEX p2_filter_idx ON query_lab."inventory_batches" USING btree ("expiry_date");

-- After: run the same lookup and repeat the measurements.
SELECT "lab_row_id", "expiry_date"
FROM query_lab."inventory_batches"
WHERE "expiry_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "expiry_date"
FROM query_lab."inventory_batches"
WHERE "expiry_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "expiry_date"
FROM query_lab."inventory_batches"
WHERE "expiry_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "expiry_date"
FROM query_lab."inventory_batches"
WHERE "expiry_date" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
