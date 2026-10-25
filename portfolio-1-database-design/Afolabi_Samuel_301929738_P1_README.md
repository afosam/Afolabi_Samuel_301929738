# Portfolio 1 — Database Design and Modelling

I organised the data into suppliers, medicines, pharmacies, inventory_batches, dispensing_events. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| suppliers | 1 |
| medicines | 1 |
| pharmacies | 1 |
| inventory_batches | 1 |
| dispensing_events | 1 |

The 19 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Afolabi_Samuel_301929738_P1_Design.md)
- [ER diagram](Afolabi_Samuel_301929738_P1_ERDiagram.md)
- [Normalisation](Afolabi_Samuel_301929738_P1_Normalisation.md)
- [Schema](Afolabi_Samuel_301929738_P1_Schema.sql)
- [Sample data](Afolabi_Samuel_301929738_P1_SampleData.sql)
- [Constraint tests](Afolabi_Samuel_301929738_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Afolabi_Samuel_301929738_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)
