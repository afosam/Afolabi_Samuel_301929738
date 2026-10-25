// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("pharmacy_inventory_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("pharmacy_inventory_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "stock_received",
                    "medicine_dispensed"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "inventory_batches"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "batch_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("pharmacy_inventory_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "stock_received",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "inventory_batches",
            "key": {
                "batch_id": 4001
            },
            "snapshot": {
                "batch_id": 4001,
                "medicine_id": 2001,
                "pharmacy_id": 3001,
                "batch_code": "AMX-2026-001",
                "expiry_date": "2027-06-30",
                "quantity_on_hand": 120,
                "received_at": "2026-01-15T09:30:00Z"
            }
        },
        "embedded": {
            "dispensing_events": [
                {
                    "key": {
                        "dispense_id": 5001
                    },
                    "snapshot": {
                        "dispense_id": 5001,
                        "batch_id": 4001,
                        "quantity": 5,
                        "patient_reference": "PAT-SYN-001",
                        "dispensed_at": "2026-02-01T10:00:00Z"
                    },
                    "via": [
                        "inventory_batches ← dispensing_events.batch_id"
                    ]
                }
            ],
            "medicines": [
                {
                    "key": {
                        "medicine_id": 2001
                    },
                    "snapshot": {
                        "medicine_id": 2001,
                        "supplier_id": 1001,
                        "medicine_name": "Amoxicillin",
                        "strength": "500mg",
                        "unit_price": 4.25
                    },
                    "via": [
                        "inventory_batches.medicine_id → medicines"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "medicine_dispensed",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "inventory_batches",
            "key": {
                "batch_id": 4001
            },
            "snapshot": {
                "batch_id": 4001,
                "medicine_id": 2001,
                "pharmacy_id": 3001,
                "batch_code": "AMX-2026-001",
                "expiry_date": "2027-06-30",
                "quantity_on_hand": 120,
                "received_at": "2026-01-15T09:30:00Z"
            }
        },
        "embedded": {
            "dispensing_events": [
                {
                    "key": {
                        "dispense_id": 5001
                    },
                    "snapshot": {
                        "dispense_id": 5001,
                        "batch_id": 4001,
                        "quantity": 5,
                        "patient_reference": "PAT-SYN-001",
                        "dispensed_at": "2026-02-01T10:00:00Z"
                    },
                    "via": [
                        "inventory_batches ← dispensing_events.batch_id"
                    ]
                }
            ],
            "medicines": [
                {
                    "key": {
                        "medicine_id": 2001
                    },
                    "snapshot": {
                        "medicine_id": 2001,
                        "supplier_id": 1001,
                        "medicine_name": "Amoxicillin",
                        "strength": "500mg",
                        "unit_price": 4.25
                    },
                    "via": [
                        "inventory_batches.medicine_id → medicines"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "prescriber_reference": "illustrative prescriber_reference",
                "adjustment_reason": "illustrative adjustment_reason",
                "temperature_note": "illustrative temperature_note",
                "external_reference": "illustrative external_reference"
            }
        }
    }
]));
  await db.getCollection("pharmacy_inventory_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("pharmacy_inventory_events").find({"eventType":"stock_received"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("pharmacy_inventory_events").find({"source.key.batch_id":4001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("pharmacy_inventory_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("pharmacy_inventory_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("pharmacy_inventory_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "stock_received",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "inventory_batches",
        "key": {
            "batch_id": 4001
        },
        "snapshot": {
            "batch_id": 4001,
            "medicine_id": 2001,
            "pharmacy_id": 3001,
            "batch_code": "AMX-2026-001",
            "expiry_date": "2027-06-30",
            "quantity_on_hand": 120,
            "received_at": "2026-01-15T09:30:00Z"
        }
    },
    "embedded": {
        "dispensing_events": [
            {
                "key": {
                    "dispense_id": 5001
                },
                "snapshot": {
                    "dispense_id": 5001,
                    "batch_id": 4001,
                    "quantity": 5,
                    "patient_reference": "PAT-SYN-001",
                    "dispensed_at": "2026-02-01T10:00:00Z"
                },
                "via": [
                    "inventory_batches ← dispensing_events.batch_id"
                ]
            }
        ],
        "medicines": [
            {
                "key": {
                    "medicine_id": 2001
                },
                "snapshot": {
                    "medicine_id": 2001,
                    "supplier_id": 1001,
                    "medicine_name": "Amoxicillin",
                    "strength": "500mg",
                    "unit_price": 4.25
                },
                "via": [
                    "inventory_batches.medicine_id → medicines"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("pharmacy_inventory_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "stock_received",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "inventory_batches",
        "key": {
            "batch_id": 4001
        },
        "snapshot": {
            "batch_id": 4001,
            "medicine_id": 2001,
            "pharmacy_id": 3001,
            "batch_code": "AMX-2026-001",
            "expiry_date": "2027-06-30",
            "quantity_on_hand": 120,
            "received_at": "2026-01-15T09:30:00Z"
        }
    },
    "embedded": {
        "dispensing_events": [
            {
                "key": {
                    "dispense_id": 5001
                },
                "snapshot": {
                    "dispense_id": 5001,
                    "batch_id": 4001,
                    "quantity": 5,
                    "patient_reference": "PAT-SYN-001",
                    "dispensed_at": "2026-02-01T10:00:00Z"
                },
                "via": [
                    "inventory_batches ← dispensing_events.batch_id"
                ]
            }
        ],
        "medicines": [
            {
                "key": {
                    "medicine_id": 2001
                },
                "snapshot": {
                    "medicine_id": 2001,
                    "supplier_id": 1001,
                    "medicine_name": "Amoxicillin",
                    "strength": "500mg",
                    "unit_price": 4.25
                },
                "via": [
                    "inventory_batches.medicine_id → medicines"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("pharmacy_inventory_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
