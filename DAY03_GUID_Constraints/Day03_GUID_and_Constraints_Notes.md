# Day 03 – GUIDs, Constraints, and SQL Server Essentials

This study guide consolidates and structures everything covered today: core database concepts, SQL Server connection/authentication, constraints, GUIDs (`NEWID` vs `NEWSEQUENTIALID`), grouping rules, and metadata exploration. Use it as a reference with examples and best practices.

---

## 1) Database Basics

- **What is a Database:** A structured collection of data designed for efficient storage, retrieval, and management. Unlike flat files (e.g., Notepad), databases enforce schema, constraints, transactions, indexing, and security.
- **Why not Notepad/Flat Files:** Lacks schema, typing, constraints, transactional safety (ACID), indexing, concurrency control, backup/restore features, and query capabilities.
- **RDBMS:** Relational Database Management Systems (e.g., SQL Server) organize data into tables with rows and columns, supporting SQL for querying and managing data.

### Suggested "7 Rules" for Sound Database Design
1. **Define clear schema:** Name tables/columns consistently; use appropriate data types.
2. **Identify keys:** Choose stable primary keys; define foreign keys for relationships.
3. **Normalize wisely:** Aim for 3NF; denormalize only for performance with care.
4. **Constrain data:** Use `NOT NULL`, `CHECK`, `UNIQUE`, `DEFAULT`, `FOREIGN KEY`, `PRIMARY KEY`.
5. **Index deliberately:** Index keys and frequent filters; avoid over-indexing.
6. **Secure access:** Use least privilege; separate login (server) from user (database).
7. **Plan operations:** Backups, restores, transaction strategy, monitoring, and auditing.

---

## 2) SQL Server Connection & Authentication

- **Server Name Examples:** `localhost\\SQLExpress`, `(localdb)\\MSSQLLocalDB`, or a named instance like `SERVERNAME\\InstanceName`.
- **Authentication Modes:**
  - **Windows Authentication:** Uses your Windows identity; simplifies password management.
  - **SQL Server Authentication:** Uses a SQL login with username and password.
  - **Microsoft Entra (Azure AD) Options:** Password, Integrated, MFA – for Azure SQL or hybrid scenarios.
- **Master Database:** A system database holding server-level metadata. Create logins at the server level, then map users inside each target database.

Example: Create a login and map a user in your learning DB.
```sql
-- Server-level (runs in master)
CREATE LOGIN LearningUser WITH PASSWORD = 'Strong_P@ssw0rd!';

-- Database-level (switch to your DB)
USE LearningDB;
CREATE USER LearningUser FOR LOGIN LearningUser;
EXEC sp_addrolemember 'db_datareader', 'LearningUser';
EXEC sp_addrolemember 'db_datawriter', 'LearningUser';
```

---

## 3) Constraints in SQL Server

- **Primary Key (`PRIMARY KEY`):** Uniquely identifies each row; often clustered by default.
- **Foreign Key (`FOREIGN KEY`):** Enforces referential integrity between tables.
- **Unique (`UNIQUE`):** Ensures all values in a column or set of columns are distinct.
- **Not Null (`NOT NULL`):** Prohibits `NULL` values.
- **Default (`DEFAULT`):** Supplies a value when none is provided.
- **Check (`CHECK`):** Validates a boolean expression over column values.

Example table with common constraints:
```sql
CREATE TABLE Customers (
    CustomerID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Email VARCHAR(320) NOT NULL UNIQUE,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Age INT NULL,
    CONSTRAINT CK_Customers_Age CHECK (Age IS NULL OR Age BETWEEN 0 AND 130)
);
```

### Enforcing Format (“Regex-like”) with CHECK
SQL Server does not have native regex in T-SQL, but you can enforce patterns using `LIKE`/`PATINDEX` in `CHECK` constraints.
```sql
-- Basic email-like pattern (illustrative; not a full RFC spec)
ALTER TABLE Customers
ADD CONSTRAINT CK_Customers_EmailPattern
CHECK (Email LIKE '%@%.%');

-- Phone format example: digits only, length 10
ALTER TABLE Customers
ADD CONSTRAINT CK_Customers_PhoneDigits
CHECK (PATINDEX('%[^0-9]%', Phone) = 0 AND LEN(Phone) = 10);
```
For true regex, consider CLR integration or enforce at the application layer.

---

## 4) GUIDs in SQL Server

- **Type:** `UNIQUEIDENTIFIER` stores 16-byte globally unique IDs.
- **`NEWID()`:** Generates random GUIDs.
- **`NEWSEQUENTIALID()`:** Generates GUIDs that increase sequentially on a host (reduces index fragmentation). Can only be used as a `DEFAULT` in `CREATE/ALTER TABLE`.

### Examples
Random GUID (from class example):
```sql
CREATE TABLE Product2 (
    ID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ProductName VARCHAR(255)
);
INSERT INTO Product2 (ProductName) VALUES ('Oreo'), ('RENEE');
SELECT * FROM Product2;
```
Sequential GUID (from class example):
```sql
CREATE TABLE Product2_Sequential (
    ID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
    ProductName VARCHAR(255)
);
INSERT INTO Product2_Sequential (ProductName) VALUES ('Oreo'), ('RENEE');
SELECT * FROM Product2_Sequential;
```

### Trade-offs
- **`NEWID()`**: More random; good for uniqueness across distributed systems; may cause page splits/fragmentation in clustered indexes.
- **`NEWSEQUENTIALID()`**: Better insert performance and index locality; slightly more predictable sequence; only usable as a `DEFAULT`.
- **Indexing Considerations:** If clustering on GUID, `NEWSEQUENTIALID()` reduces fragmentation compared to `NEWID()`.

---

## 5) Encoding vs Encryption

- **Encoding:** Transform data for representation/compatibility (e.g., Base64, UTF-8). Not meant for secrecy.
- **Encryption:** Transform data to be unreadable without a key (e.g., AES). Provides confidentiality.

SQL Server security features to explore:
- **Transparent Data Encryption (TDE):** Encrypts database and log files at rest.
- **Always Encrypted:** Protects sensitive columns; encryption handled by client drivers.
- **Column-level encryption & certificates:** Use `CREATE CERTIFICATE`, `CREATE SYMMETRIC KEY`, `EncryptByKey`, etc.

---

## 6) Grouping, Aggregation, and HAVING

- **Rule:** Columns in `SELECT` must be aggregated or appear in `GROUP BY`.
- **`WHERE` vs `HAVING`:** Use `WHERE` to filter rows before grouping; use `HAVING` to filter groups after aggregation.

Examples (from metadata exploration):
```sql
-- Count user tables using WHERE before GROUP BY
SELECT xtype, COUNT(*) AS CountOfObjects
FROM sysobjects
WHERE xtype = 'U'
GROUP BY xtype;

-- HAVING example (less ideal here; better when filtering by aggregates)
SELECT xtype, COUNT(*) AS CountOfObjects
FROM sysobjects
GROUP BY xtype
HAVING xtype = 'U';
```

---

## 7) Exploring Metadata

- **Legacy view:** `sysobjects` includes rows for tables, views, procedures, etc.
- **Modern catalog views:** Prefer `sys.tables`, `sys.views`, `sys.procedures`, `sys.schemas`, `sys.columns`.

Quick examples:
```sql
-- All objects (legacy)
SELECT * FROM sysobjects;

-- Only user tables (legacy)
SELECT * FROM sysobjects WHERE xtype = 'U';

-- Modern views: tables with schema
SELECT s.name AS SchemaName, t.name AS TableName
FROM sys.tables AS t
JOIN sys.schemas AS s ON s.schema_id = t.schema_id
ORDER BY s.name, t.name;
```

---

## 8) UNION vs UNION ALL and ORDER BY (AdventureWorks)

- **`UNION`:** Removes duplicates; incurs a distinct/sort step.
- **`UNION ALL`:** Keeps duplicates; faster.
- **`ORDER BY`:** Applies to the final combined result. To order within each query, wrap queries in subselects and apply `ORDER BY` outside.

Example based on `Person.Person`:
```sql
SELECT TOP 15 BusinessEntityID, LastName FROM [Person].[Person]
UNION ALL
SELECT TOP 15 BusinessEntityID, LastName FROM [Person].[Person]
ORDER BY BusinessEntityID DESC;  -- Orders the combined set
```

> Note: Inserts into `[Person].[Person]` may fail if required columns or constraints (e.g., identity or foreign keys) are not satisfied.

---

## 9) Tools: SQL Profiler

- Use **SQL Server Profiler** (or Extended Events) to observe queries/events for performance tuning and troubleshooting.
- Prefer **Extended Events** in newer versions for lower overhead.

---

## 10) Quick Practice Prompts

- Create a table with `CHECK` constraints enforcing a simple pattern.
- Benchmark inserts with `NEWID()` vs `NEWSEQUENTIALID()` on a clustered PK.
- Explore `sys.tables` and `sys.columns` to list table schemas.
- Practice grouping with `WHERE` vs `HAVING` and explain the difference.

---

## References to Class Files
- GUID demos: see `DAY03_GUID_Constraints/GUID Query.sql`.
- Metadata and grouping demos: see `DAY03_GUID_Constraints/Queries on MasterDB.sql`.
- AdventureWorks practice: see `DAY03_GUID_Constraints/AdventureDB Queries.sql`.
