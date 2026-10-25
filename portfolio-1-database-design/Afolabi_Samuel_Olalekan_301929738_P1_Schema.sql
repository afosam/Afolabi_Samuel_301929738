-- MediStock NG Hospital Pharmacy Inventory: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."suppliers" (
  "supplier_id" bigint NOT NULL,
  "supplier_name" text NOT NULL,
  "contact_email" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_suppliers" PRIMARY KEY ("supplier_id"),
  CONSTRAINT "uq_suppliers_0" UNIQUE ("supplier_name"),
  CONSTRAINT "uq_suppliers_1" UNIQUE ("contact_email")
);
CREATE TABLE portfolio."medicines" (
  "medicine_id" bigint NOT NULL,
  "supplier_id" bigint NOT NULL,
  "medicine_name" text NOT NULL,
  "strength" text NOT NULL,
  "unit_price" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_medicines" PRIMARY KEY ("medicine_id"),
  CONSTRAINT "uq_medicines_0" UNIQUE ("medicine_name", "strength")
);
CREATE TABLE portfolio."pharmacies" (
  "pharmacy_id" bigint NOT NULL,
  "pharmacy_name" text NOT NULL,
  "ward_code" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_pharmacies" PRIMARY KEY ("pharmacy_id"),
  CONSTRAINT "uq_pharmacies_0" UNIQUE ("pharmacy_name"),
  CONSTRAINT "uq_pharmacies_1" UNIQUE ("ward_code")
);
CREATE TABLE portfolio."inventory_batches" (
  "batch_id" bigint NOT NULL,
  "medicine_id" bigint NOT NULL,
  "pharmacy_id" bigint NOT NULL,
  "batch_code" text NOT NULL,
  "expiry_date" date NOT NULL,
  "quantity_on_hand" bigint NOT NULL,
  "received_at" timestamptz NOT NULL,
  CONSTRAINT "pk_inventory_batches" PRIMARY KEY ("batch_id"),
  CONSTRAINT "uq_inventory_batches_0" UNIQUE ("batch_code")
);
CREATE TABLE portfolio."dispensing_events" (
  "dispense_id" bigint NOT NULL,
  "batch_id" bigint NOT NULL,
  "quantity" bigint NOT NULL,
  "patient_reference" text NOT NULL,
  "dispensed_at" timestamptz NOT NULL,
  CONSTRAINT "pk_dispensing_events" PRIMARY KEY ("dispense_id")
);
ALTER TABLE portfolio."medicines" ADD CONSTRAINT "fk_medicines_0" FOREIGN KEY ("supplier_id") REFERENCES portfolio."suppliers" ("supplier_id");
ALTER TABLE portfolio."inventory_batches" ADD CONSTRAINT "fk_inventory_batches_0" FOREIGN KEY ("medicine_id") REFERENCES portfolio."medicines" ("medicine_id");
ALTER TABLE portfolio."inventory_batches" ADD CONSTRAINT "fk_inventory_batches_1" FOREIGN KEY ("pharmacy_id") REFERENCES portfolio."pharmacies" ("pharmacy_id");
ALTER TABLE portfolio."dispensing_events" ADD CONSTRAINT "fk_dispensing_events_0" FOREIGN KEY ("batch_id") REFERENCES portfolio."inventory_batches" ("batch_id");
ALTER TABLE portfolio."inventory_batches" ADD CONSTRAINT "batch_quantity_nonnegative" CHECK ("quantity_on_hand" >= 0);
ALTER TABLE portfolio."dispensing_events" ADD CONSTRAINT "dispense_quantity_positive" CHECK ("quantity" > 0);
COMMIT;
