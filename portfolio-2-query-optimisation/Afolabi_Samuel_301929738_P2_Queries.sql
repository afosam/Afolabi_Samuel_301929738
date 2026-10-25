-- Show related inventory_batches, medicines, pharmacies records (up to 20).
SELECT t0."batch_id" AS "inventory_batches_batch_id",
       t0."batch_code" AS "inventory_batches_batch_code",
       t1."medicine_id" AS "medicines_medicine_id",
       t1."medicine_name" AS "medicines_medicine_name",
       t2."pharmacy_id" AS "pharmacies_pharmacy_id",
       t2."pharmacy_name" AS "pharmacies_pharmacy_name"
FROM portfolio."inventory_batches" t0
JOIN portfolio."medicines" t1 ON t0."medicine_id" = t1."medicine_id"
JOIN portfolio."pharmacies" t2 ON t0."pharmacy_id" = t2."pharmacy_id"
ORDER BY t0."batch_id", t1."medicine_id", t2."pharmacy_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."batch_id" AS "inventory_batches_batch_id",
       t0."batch_code" AS "inventory_batches_batch_code",
       t1."medicine_id" AS "medicines_medicine_id",
       t1."medicine_name" AS "medicines_medicine_name",
       t2."pharmacy_id" AS "pharmacies_pharmacy_id",
       t2."pharmacy_name" AS "pharmacies_pharmacy_name"
FROM portfolio."inventory_batches" t0
JOIN portfolio."medicines" t1 ON t0."medicine_id" = t1."medicine_id"
JOIN portfolio."pharmacies" t2 ON t0."pharmacy_id" = t2."pharmacy_id"
ORDER BY t0."batch_id", t1."medicine_id", t2."pharmacy_id"
LIMIT 20;

-- Find inventory_batches records where expiry_date matches "2027-06-30" (up to 20).
SELECT * FROM portfolio."inventory_batches"
WHERE "expiry_date" IS NOT DISTINCT FROM '2027-06-30'
ORDER BY "batch_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."inventory_batches"
WHERE "expiry_date" IS NOT DISTINCT FROM '2027-06-30'
ORDER BY "batch_id"
LIMIT 20;

-- Count dispensing_events records for each batch_id (up to 20 groups).
SELECT "batch_id", count(*) AS record_count
FROM portfolio."dispensing_events"
GROUP BY "batch_id"
ORDER BY record_count DESC, "batch_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "batch_id", count(*) AS record_count
FROM portfolio."dispensing_events"
GROUP BY "batch_id"
ORDER BY record_count DESC, "batch_id" NULLS LAST
LIMIT 20;
