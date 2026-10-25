# MediStock NG Hospital Pharmacy Inventory — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| medicine_id | inventory_batches records (list) |
| --- | --- |
| 2001 | [4001] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| inventory_batches.batch_id | inventory_batches.medicine_id | inventory_batches.pharmacy_id | inventory_batches.batch_code | medicines.medicine_id | medicines.supplier_id | medicines.medicine_name | suppliers.supplier_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4001 | 2001 | 3001 | AMX-2026-001 | 2001 | 1001 | Amoxicillin | 1001 |

Key: batch_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## inventory_batches_example

| inventory_batches.batch_id | inventory_batches.medicine_id | inventory_batches.pharmacy_id | inventory_batches.batch_code | medicines.medicine_id | medicines.supplier_id | medicines.medicine_name | suppliers.supplier_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4001 | 2001 | 3001 | AMX-2026-001 | 2001 | 1001 | Amoxicillin | 1001 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## suppliers

| supplier_id | supplier_name | contact_email | active |
| --- | --- | --- | --- |
| 1001 | Northstar Medical Supply | northstar@example.test | true |

## medicines

| medicine_id | supplier_id | medicine_name | strength | unit_price |
| --- | --- | --- | --- | --- |
| 2001 | 1001 | Amoxicillin | 500mg | 4.25 |

## pharmacies

| pharmacy_id | pharmacy_name | ward_code | active |
| --- | --- | --- | --- |
| 3001 | Central Pharmacy | WARD-C | true |

## inventory_batches

| batch_id | medicine_id | pharmacy_id | batch_code | expiry_date | quantity_on_hand | received_at |
| --- | --- | --- | --- | --- | --- | --- |
| 4001 | 2001 | 3001 | AMX-2026-001 | 2027-06-30 | 120 | 2026-01-15T09:30:00+00:00 |

## dispensing_events

| dispense_id | batch_id | quantity | patient_reference | dispensed_at |
| --- | --- | --- | --- | --- |
| 5001 | 4001 | 5 | PAT-SYN-001 | 2026-02-01T10:00:00+00:00 |

## Dependencies

- suppliers: (supplier_id) → supplier_name, contact_email, active
- medicines: (medicine_id) → supplier_id, medicine_name, strength, unit_price
- pharmacies: (pharmacy_id) → pharmacy_name, ward_code, active
- inventory_batches: (batch_id) → medicine_id, pharmacy_id, batch_code, expiry_date, quantity_on_hand, received_at
- dispensing_events: (dispense_id) → batch_id, quantity, patient_reference, dispensed_at

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
