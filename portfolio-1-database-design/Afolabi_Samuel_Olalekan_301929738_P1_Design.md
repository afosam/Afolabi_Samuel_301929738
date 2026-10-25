# MediStock NG Hospital Pharmacy Inventory — database design

My case study records suppliers, medicines, pharmacies, inventory_batches, dispensing_events.

## Users

- pharmacists
- inventory officers
- hospital auditors

## Main operations

- register medicines and suppliers
- receive and monitor stock batches
- dispense medicines and record batch usage
- review low-stock and expiry reports

## Entities

| Entity | Information stored |
| --- | --- |
| suppliers | Stores synthetic medicine supplier records. |
| medicines | Stores catalog details for medicines supplied to the hospital. |
| pharmacies | Stores synthetic hospital pharmacy locations. |
| inventory_batches | Records received medicine batches held at pharmacy locations. |
| dispensing_events | Records synthetic medicine issues from inventory batches. |

## suppliers

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| supplier_id | BIGINT | PK | Yes |
| supplier_name | TEXT | Unique | Yes |
| contact_email | TEXT | Unique | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (supplier_name).
- Unique key: (contact_email).

## medicines

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| medicine_id | BIGINT | PK | Yes |
| supplier_id | BIGINT | FK | Yes |
| medicine_name | TEXT |  | Yes |
| strength | TEXT |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
- supplier_id → suppliers.supplier_id
- Unique key: (medicine_name, strength).

## pharmacies

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| pharmacy_id | BIGINT | PK | Yes |
| pharmacy_name | TEXT | Unique | Yes |
| ward_code | TEXT | Unique | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (pharmacy_name).
- Unique key: (ward_code).

## inventory_batches

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| batch_id | BIGINT | PK | Yes |
| medicine_id | BIGINT | FK | Yes |
| pharmacy_id | BIGINT | FK | Yes |
| batch_code | TEXT | Unique | Yes |
| expiry_date | DATE |  | Yes |
| quantity_on_hand | INTEGER |  | Yes |
| received_at | TIMESTAMPTZ |  | Yes |
- medicine_id → medicines.medicine_id
- pharmacy_id → pharmacies.pharmacy_id
- Unique key: (batch_code).

## dispensing_events

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| dispense_id | BIGINT | PK | Yes |
| batch_id | BIGINT | FK | Yes |
| quantity | INTEGER |  | Yes |
| patient_reference | TEXT |  | Yes |
| dispensed_at | TIMESTAMPTZ |  | Yes |
- batch_id → inventory_batches.batch_id

## Relationships and business rules

- Every supplier must have a nonempty supplier name.
- A medicine name and strength combination must be unique.
- Every inventory batch must reference an existing medicine through medicine_id.
- Every inventory batch must reference an existing pharmacy through pharmacy_id.
- Inventory batch quantity_on_hand must be zero or greater.
- Each received batch code must identify only one inventory batch.
- Every dispensing event must reference an existing inventory batch through batch_id.
- Each dispensing event quantity must be greater than zero.

## Assumptions

- Each medicine has one preferred supplier for this exercise.
- Each stock batch belongs to one medicine and one pharmacy location.
- A dispensing event references exactly one stock batch.
- Quantities are measured in package units and cannot be negative.
- Patient references are synthetic opaque values and contain no personal information.
- The worked normalization example starts with inventory_batches and separates medicine and pharmacy references into their own relations.

