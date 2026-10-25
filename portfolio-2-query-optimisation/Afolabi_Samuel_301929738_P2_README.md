# MediStock NG Hospital Pharmacy Inventory — SQL queries

## 1. Show related inventory_batches, medicines, pharmacies records (up to 20).

```sql
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
```

| inventory_batches_batch_id | inventory_batches_batch_code | medicines_medicine_id | medicines_medicine_name | pharmacies_pharmacy_id | pharmacies_pharmacy_name |
| --- | --- | --- | --- | --- | --- |
| 4001 | AMX-2026-001 | 2001 | Amoxicillin | 3001 | Central Pharmacy |

## 2. Find inventory_batches records where expiry_date matches "2027-06-30" (up to 20).

```sql
SELECT * FROM portfolio."inventory_batches"
WHERE "expiry_date" IS NOT DISTINCT FROM '2027-06-30'
ORDER BY "batch_id"
LIMIT 20;
```

| batch_id | medicine_id | pharmacy_id | batch_code | expiry_date | quantity_on_hand | received_at |
| --- | --- | --- | --- | --- | --- | --- |
| 4001 | 2001 | 3001 | AMX-2026-001 | 2027-06-30 | 120 | 2026-01-15T09:30:00+00:00 |

## 3. Count dispensing_events records for each batch_id (up to 20 groups).

```sql
SELECT "batch_id", count(*) AS record_count
FROM portfolio."dispensing_events"
GROUP BY "batch_id"
ORDER BY record_count DESC, "batch_id" NULLS LAST
LIMIT 20;
```

| batch_id | record_count |
| --- | --- |
| 4001 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.147 | 2.396, 1.145, 1.147 | Sort → Seq Scan | 139 |
| After index | 0.195 | 0.186, 0.309, 0.195 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 30 |

The median execution time changed from 1.147 ms to 0.195 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.341..2.343 rows=25 loops=1)
  Seq Scan on inventory_batches (actual time=0.021..2.29 rows=25 loops=1)
Planning Time: 0.452 ms
Execution Time: 2.396 ms
```

### Before index, run 2

```text
Sort (actual time=1.104..1.106 rows=25 loops=1)
  Seq Scan on inventory_batches (actual time=0.015..1.067 rows=25 loops=1)
Planning Time: 0.35 ms
Execution Time: 1.145 ms
```

### Before index, run 3

```text
Sort (actual time=1.115..1.117 rows=25 loops=1)
  Seq Scan on inventory_batches (actual time=0.015..1.078 rows=25 loops=1)
Planning Time: 0.335 ms
Execution Time: 1.147 ms
```

### After index, run 1

```text
Sort (actual time=0.14..0.141 rows=25 loops=1)
  Bitmap Heap Scan on inventory_batches (actual time=0.029..0.103 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=25 loops=1)
Planning Time: 0.533 ms
Execution Time: 0.186 ms
```

### After index, run 2

```text
Sort (actual time=0.225..0.227 rows=25 loops=1)
  Bitmap Heap Scan on inventory_batches (actual time=0.048..0.16 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.025..0.026 rows=25 loops=1)
Planning Time: 1.054 ms
Execution Time: 0.309 ms
```

### After index, run 3

```text
Sort (actual time=0.149..0.151 rows=25 loops=1)
  Bitmap Heap Scan on inventory_batches (actual time=0.031..0.11 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.017 rows=25 loops=1)
Planning Time: 0.564 ms
Execution Time: 0.195 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Afolabi_Samuel_301929738_P2_Queries.sql, then Afolabi_Samuel_301929738_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Afolabi_Samuel_301929738_P2_QueryResults.png) · [Index comparison](screenshots/Afolabi_Samuel_301929738_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

