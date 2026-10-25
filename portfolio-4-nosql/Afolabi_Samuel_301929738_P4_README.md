# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection pharmacy_inventory_events for stock_received and medicine_dispensed events. These are fictional event examples based on inventory_batches, dispensing_events, medicines.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related dispensing_events, medicines details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
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
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("pharmacy_inventory_events").find({"eventType":"stock_received"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "stock_received",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "batch_id": 4001
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("pharmacy_inventory_events").find({"source.key.batch_id":4001}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "stock_received",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "batch_id": 4001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "medicine_dispensed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "batch_id": 4001
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("pharmacy_inventory_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "stock_received",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "batch_id": 4001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "medicine_dispensed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "batch_id": 4001
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("pharmacy_inventory_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| medicine_dispensed | 1 |
| stock_received | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Afolabi_Samuel_301929738_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Afolabi_Samuel_301929738_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

