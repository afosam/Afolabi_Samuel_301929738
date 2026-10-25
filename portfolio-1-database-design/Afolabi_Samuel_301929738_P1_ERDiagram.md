# MediStock NG Hospital Pharmacy Inventory — ER diagram

```mermaid
erDiagram
    direction LR
    suppliers {
        bigint supplier_id PK
        text supplier_name UK
        text contact_email UK
        boolean active
    }
    medicines {
        bigint medicine_id PK
        bigint supplier_id FK
        text medicine_name
        text strength
        numeric unit_price
    }
    pharmacies {
        bigint pharmacy_id PK
        text pharmacy_name UK
        text ward_code UK
        boolean active
    }
    inventory_batches {
        bigint batch_id PK
        bigint medicine_id FK
        bigint pharmacy_id FK
        text batch_code UK
        date expiry_date
        integer quantity_on_hand
        timestamptz received_at
    }
    dispensing_events {
        bigint dispense_id PK
        bigint batch_id FK
        integer quantity
        text patient_reference
        timestamptz dispensed_at
    }
    suppliers ||--o{ medicines : "supplier_id"
    medicines ||--o{ inventory_batches : "medicine_id"
    pharmacies ||--o{ inventory_batches : "pharmacy_id"
    inventory_batches ||--o{ dispensing_events : "batch_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Afolabi_Samuel_301929738_ERDiagram.png)
