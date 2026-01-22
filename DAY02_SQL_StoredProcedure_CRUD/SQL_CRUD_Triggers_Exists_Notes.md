# SQL Concepts: CRUD Operations, Triggers, and EXISTS

---

## 1. Introduction

In relational database systems, efficient data management and data safety are achieved using
**CRUD operations**, **Stored Procedures**, **Triggers**, and **conditional checks like EXISTS**.
These concepts are widely used in academic labs as well as real-world database applications.

This document explains:
- CRUD operations using Stored Procedures
- Triggers (INSTEAD OF and AFTER)
- EXISTS clause and its behavior

---

## 2. CRUD Operations in SQL

### 2.1 What is CRUD?

CRUD stands for the four basic database operations:

| Operation | Description |
|---------|-------------|
| CREATE | Insert new data |
| READ | Retrieve existing data |
| UPDATE | Modify existing data |
| DELETE | Remove data |

---

### 2.2 CRUD Using Stored Procedure

A single stored procedure can perform all CRUD operations using an action parameter.

#### Advantages:
- Reduces repetitive SQL code
- Centralized business logic
- Easy maintenance
- Secure data access

---

### 2.3 Example: CRUD Stored Procedure (Concept)

```sql
CREATE OR ALTER PROCEDURE CRUD_Operations
(
    @EmpId INT,
    @Action VARCHAR(10),
    @EmpName VARCHAR(50) = NULL,
    @Department VARCHAR(50) = NULL,
    @BasicSalary DECIMAL(10,2) = NULL,
    @IsActive BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'INSERT'
    BEGIN
        IF EXISTS (SELECT 1 FROM Employees WHERE EmpId = @EmpId)
            PRINT 'Employee already exists';
        ELSE
            INSERT INTO Employees VALUES (@EmpId, @EmpName, @Department, @BasicSalary, @IsActive);
    END

    ELSE IF @Action = 'SELECT'
    BEGIN
        SELECT * FROM Employees WHERE EmpId = @EmpId;
    END

    ELSE IF @Action = 'UPDATE'
    BEGIN
        UPDATE Employees
        SET EmpName = @EmpName,
            Department = @Department,
            BasicSalary = @BasicSalary,
            IsActive = @IsActive
        WHERE EmpId = @EmpId;
    END

    ELSE IF @Action = 'DELETE'
    BEGIN
        DELETE FROM Employees WHERE EmpId = @EmpId;
    END
END;
````

---

## 3. EXISTS Clause in SQL

### 3.1 What is EXISTS?

The `EXISTS` clause is used to **check whether a subquery returns at least one row**.

* Returns **TRUE** if one or more rows exist
* Returns **FALSE** if no rows exist
* Does NOT return data
* Does NOT throw an error if no data is found

---

### 3.2 Syntax

```sql
IF EXISTS (SELECT 1 FROM Employees WHERE EmpId = 101)
```

---

### 3.3 Why EXISTS Does Not Throw Error

```sql
SELECT * FROM Employees WHERE EmpId = 999;
```

Result:

```
(0 rows affected)
```

This is **not an error**, because:

* SQL treats "no data found" as a valid outcome
* Errors occur only for invalid syntax or schema issues

---

### 3.4 EXISTS vs COUNT(*)

| EXISTS               | COUNT(*)        |
| -------------------- | --------------- |
| Stops at first match | Scans full data |
| Faster               | Slower          |
| Returns TRUE/FALSE   | Returns number  |
| Industry standard    | Not preferred   |

---

### 3.5 Why `SELECT 1` is Used

* Column values are irrelevant
* Only row existence matters
* Improves performance
* Best practice

---

## 4. Triggers in SQL Server

### 4.1 What is a Trigger?

A **Trigger** is a special database object that automatically executes
when an **INSERT, UPDATE, or DELETE** operation occurs on a table.

Triggers cannot be called manually.

---

### 4.2 Types of Triggers in SQL Server

SQL Server supports only two types of triggers:

| Trigger Type | Purpose                      |
| ------------ | ---------------------------- |
| INSTEAD OF   | Controls or blocks operation |
| AFTER        | Logging or auditing          |

> Note: SQL Server does NOT support BEFORE triggers.

---

## 5. INSTEAD OF UPDATE Trigger

### 5.1 Purpose

* Prevent sensitive column updates (e.g., Primary Key)
* Replace default UPDATE behavior

---

### 5.2 Example: Prevent Primary Key Update

```sql
CREATE OR ALTER TRIGGER trg_Block_EmpId_Update
ON Employees
INSTEAD OF UPDATE
AS
BEGIN
    IF UPDATE(EmpId)
    BEGIN
        THROW 50001, 'Updating primary key is not allowed.', 1;
        RETURN;
    END

    UPDATE e
    SET e.EmpName = i.EmpName,
        e.Department = i.Department,
        e.BasicSalary = i.BasicSalary,
        e.IsActive = i.IsActive
    FROM Employees e
    JOIN inserted i ON e.EmpId = i.EmpId;
END;
```

---

### 5.3 inserted and deleted Tables

| Table    | Contains   |
| -------- | ---------- |
| inserted | New values |
| deleted  | Old values |

For UPDATE:

* `deleted` → old row
* `inserted` → new row

---

## 6. AFTER UPDATE Trigger

### 6.1 Purpose

* Logging
* Auditing
* Tracking changes

AFTER triggers execute **after the data is successfully updated**.

---

### 6.2 Example: Salary Audit Trigger

```sql
CREATE OR ALTER TRIGGER trg_After_Salary_Update
ON Employees
AFTER UPDATE
AS
BEGIN
    IF UPDATE(BasicSalary)
    BEGIN
        INSERT INTO EmployeeSalaryAudit (EmpId, OldSalary, NewSalary)
        SELECT d.EmpId, d.BasicSalary, i.BasicSalary
        FROM deleted d
        JOIN inserted i ON d.EmpId = i.EmpId;
    END
END;
```

---

## 7. Execution Flow of Triggers

```
UPDATE statement
↓
INSTEAD OF trigger (validation)
↓
Actual update
↓
AFTER trigger (audit/log)
```

---

## 8. Key Differences Summary

| Feature               | INSTEAD OF Trigger | AFTER Trigger |
| --------------------- | ------------------ | ------------- |
| Runs before operation | Yes                | No            |
| Can block update      | Yes                | No            |
| Used for validation   | Yes                | No            |
| Used for logging      | No                 | Yes           |

---

## 9. Exam-Oriented Key Points

* EXISTS returns TRUE/FALSE, not data
* No data found is NOT an error in SQL
* INSTEAD OF triggers are used to block or replace operations
* AFTER triggers are used for auditing
* SQL Server does not support BEFORE triggers

---

## 10. Conclusion

CRUD operations manage data,
EXISTS ensures safe conditional checks,
and triggers protect and audit data automatically.
Together, these concepts form the backbone of secure and maintainable SQL Server applications.

---

## 11. One-Line Exam Definitions

* **CRUD**: Basic database operations — Create, Read, Update, Delete
* **EXISTS**: Checks whether at least one record exists
* **Trigger**: Automatically executed SQL logic on data modification events

---