-- Fictional sample records for MediStock NG Hospital Pharmacy Inventory.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."suppliers" ("supplier_id", "supplier_name", "contact_email", "active") VALUES (1001, 'Northstar Medical Supply', 'northstar@example.test', TRUE);
INSERT INTO portfolio."pharmacies" ("pharmacy_id", "pharmacy_name", "ward_code", "active") VALUES (3001, 'Central Pharmacy', 'WARD-C', TRUE);
INSERT INTO portfolio."medicines" ("medicine_id", "supplier_id", "medicine_name", "strength", "unit_price") VALUES (2001, 1001, 'Amoxicillin', '500mg', 4.25);
INSERT INTO portfolio."inventory_batches" ("batch_id", "medicine_id", "pharmacy_id", "batch_code", "expiry_date", "quantity_on_hand", "received_at") VALUES (4001, 2001, 3001, 'AMX-2026-001', '2027-06-30', 120, '2026-01-15T09:30:00Z');
INSERT INTO portfolio."dispensing_events" ("dispense_id", "batch_id", "quantity", "patient_reference", "dispensed_at") VALUES (5001, 4001, 5, 'PAT-SYN-001', '2026-02-01T10:00:00Z');
COMMIT;
