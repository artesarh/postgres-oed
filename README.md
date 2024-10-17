# Postgres-oed

## Description
This is a postgres data schema consistent with the Open Data Standards for insurance exposure data.

1. An extension to this database with improved efficiencies, 3NF normalization is on the way.

## Changes / modifications
These changes were required to create a viable database structure. Often they were not specified in the original ODS schema.

### Surrogate Keys: 
Added SERIAL PRIMARY KEY (auto-incrementing) columns like AccountFinancialsID to tables that lacked a clear, single-column primary key.

### Foreign Keys: 
Implemented foreign key constraints (REFERENCES) to enforce relationships between tables. The AccNumber is linked at multiple levels to create a clear hierarchy.

### Data Types: 
Corrected data types for better PostgreSQL compatibility (e.g., using DATE instead of smalldatetime, VARCHAR instead of nvarchar, SMALLINT for codes).

### Column Renaming: 
Renamed columns like Limit to LimitValue, Attachment to AttachmentPoint, and MinDed to MinDeductibleValue to avoid conflicts with PostgreSQL reserved keywords.

### Constraints: 
Added CHECK constraints to enforce valid value ranges as specified in your specification file. Examples include percentages between 0 and 1, minimum values of 0, etc.

### Unique Constraints: 
Added UNIQUE constraints where needed, especially on composite keys, to prevent duplicate entries of financial terms within a particular scope (e.g. AccNumber and PerilCode).

### Flexible Fields: 
The FlexiAcc, FlexiLoc, and FlexiPol tables use ModifierName and ModifierValue to accommodate your flexible fields, which allows for future extension without schema changes.

### Data Integrity: 
The schema now includes several data integrity checks via the CHECK and UNIQUE constraints, ensuring data validity during insert and update operations.

