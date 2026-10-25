-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. supplier pk duplicate. Expected: pk_suppliers, SQLSTATE 23505.
INSERT INTO portfolio."suppliers" ("supplier_id", "supplier_name", "contact_email", "active")
VALUES (1001, 'Southridge Medical Supply', 'southridge@example.test', TRUE);

-- 2. supplier name duplicate. Expected: uq_suppliers_0, SQLSTATE 23505.
INSERT INTO portfolio."suppliers" ("supplier_id", "supplier_name", "contact_email", "active")
VALUES (1002, 'Northstar Medical Supply', 'new_supplier@example.test', TRUE);

-- 3. supplier email duplicate. Expected: uq_suppliers_1, SQLSTATE 23505.
INSERT INTO portfolio."suppliers" ("supplier_id", "supplier_name", "contact_email", "active")
VALUES (1003, 'Southridge Medical Supply', 'northstar@example.test', TRUE);

-- 4. supplier name null. Expected: supplier_name, SQLSTATE 23502.
INSERT INTO portfolio."suppliers" ("supplier_id", "supplier_name", "contact_email", "active")
VALUES (1004, NULL, 'nullname@example.test', TRUE);

-- 5. supplier name empty. Expected: supplier_name_nonempty, SQLSTATE 23514.
INSERT INTO portfolio."suppliers" ("supplier_id", "supplier_name", "contact_email", "active")
VALUES (1005, '   ', 'emptyname@example.test', TRUE);

-- 6. medicine pk duplicate. Expected: pk_medicines, SQLSTATE 23505.
INSERT INTO portfolio."medicines" ("medicine_id", "supplier_id", "medicine_name", "strength", "unit_price")
VALUES (2001, 1001, 'Ibuprofen', '200mg', 2.1);

-- 7. medicine identity duplicate. Expected: uq_medicines_0, SQLSTATE 23505.
INSERT INTO portfolio."medicines" ("medicine_id", "supplier_id", "medicine_name", "strength", "unit_price")
VALUES (2002, 1001, 'Amoxicillin', '500mg', 4.5);

-- 8. medicine supplier missing. Expected: fk_medicines_0, SQLSTATE 23503.
INSERT INTO portfolio."medicines" ("medicine_id", "supplier_id", "medicine_name", "strength", "unit_price")
VALUES (2003, 9999, 'Ibuprofen', '200mg', 2.1);

-- 9. pharmacy pk duplicate. Expected: pk_pharmacies, SQLSTATE 23505.
INSERT INTO portfolio."pharmacies" ("pharmacy_id", "pharmacy_name", "ward_code", "active")
VALUES (3001, 'North Pharmacy', 'WARD-N', TRUE);

-- 10. pharmacy name duplicate. Expected: uq_pharmacies_0, SQLSTATE 23505.
INSERT INTO portfolio."pharmacies" ("pharmacy_id", "pharmacy_name", "ward_code", "active")
VALUES (3002, 'Central Pharmacy', 'WARD-N', TRUE);

-- 11. pharmacy ward duplicate. Expected: uq_pharmacies_1, SQLSTATE 23505.
INSERT INTO portfolio."pharmacies" ("pharmacy_id", "pharmacy_name", "ward_code", "active")
VALUES (3003, 'North Pharmacy', 'WARD-C', TRUE);

-- 12. batch pk duplicate. Expected: pk_inventory_batches, SQLSTATE 23505.
INSERT INTO portfolio."inventory_batches" ("batch_id", "medicine_id", "pharmacy_id", "batch_code", "expiry_date", "quantity_on_hand", "received_at")
VALUES (4001, 2001, 3001, 'AMX-2026-002', '2027-07-31', 80, '2026-02-10T09:30:00Z');

-- 13. batch code duplicate. Expected: uq_inventory_batches_0, SQLSTATE 23505.
INSERT INTO portfolio."inventory_batches" ("batch_id", "medicine_id", "pharmacy_id", "batch_code", "expiry_date", "quantity_on_hand", "received_at")
VALUES (4002, 2001, 3001, 'AMX-2026-001', '2027-08-31', 80, '2026-02-10T09:30:00Z');

-- 14. batch medicine missing. Expected: fk_inventory_batches_0, SQLSTATE 23503.
INSERT INTO portfolio."inventory_batches" ("batch_id", "medicine_id", "pharmacy_id", "batch_code", "expiry_date", "quantity_on_hand", "received_at")
VALUES (4003, 9998, 3001, 'AMX-2026-003', '2027-09-30', 80, '2026-02-10T09:30:00Z');

-- 15. batch pharmacy missing. Expected: fk_inventory_batches_1, SQLSTATE 23503.
INSERT INTO portfolio."inventory_batches" ("batch_id", "medicine_id", "pharmacy_id", "batch_code", "expiry_date", "quantity_on_hand", "received_at")
VALUES (4004, 2001, 9997, 'AMX-2026-004', '2027-10-31', 80, '2026-02-10T09:30:00Z');

-- 16. batch quantity negative. Expected: batch_quantity_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."inventory_batches" ("batch_id", "medicine_id", "pharmacy_id", "batch_code", "expiry_date", "quantity_on_hand", "received_at")
VALUES (4005, 2001, 3001, 'AMX-2026-005', '2027-11-30', -1, '2026-02-10T09:30:00Z');

-- 17. dispense pk duplicate. Expected: pk_dispensing_events, SQLSTATE 23505.
INSERT INTO portfolio."dispensing_events" ("dispense_id", "batch_id", "quantity", "patient_reference", "dispensed_at")
VALUES (5001, 4001, 3, 'PAT-SYN-002', '2026-02-02T10:00:00Z');

-- 18. dispense batch missing. Expected: fk_dispensing_events_0, SQLSTATE 23503.
INSERT INTO portfolio."dispensing_events" ("dispense_id", "batch_id", "quantity", "patient_reference", "dispensed_at")
VALUES (5002, 9996, 3, 'PAT-SYN-003', '2026-02-02T10:00:00Z');

-- 19. dispense quantity nonpositive. Expected: dispense_quantity_positive, SQLSTATE 23514.
INSERT INTO portfolio."dispensing_events" ("dispense_id", "batch_id", "quantity", "patient_reference", "dispensed_at")
VALUES (5003, 4001, 0, 'PAT-SYN-004', '2026-02-02T10:00:00Z');
