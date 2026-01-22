# Stored Procedures in SQL

## 1. Introduction

A **Stored Procedure** is a precompiled collection of one or more SQL statements stored permanently in a database. It is executed as a single unit and can accept input parameters, return output parameters, and produce result sets.

Stored procedures are widely used in database-driven applications to improve performance, enhance security, and ensure code reusability.

---

## 2. Definition

> A **Stored Procedure** is a database object that contains a set of SQL statements which can be executed repeatedly by calling its name.

---

## 3. Need for Stored Procedures

Stored procedures are used to:
- Reduce repetitive SQL code
- Improve execution performance
- Enforce business logic at the database level
- Provide controlled access to data
- Simplify application code

---

## 4. Advantages of Stored Procedures

- **Reusability**: Written once and executed multiple times
- **Performance**: Compiled once and reused
- **Security**: Users can execute procedures without direct table access
- **Maintainability**: Logic changes are centralized
- **Reduced Network Traffic**: Only procedure call is sent, not full query

---

## 5. Basic Syntax of Stored Procedure

```sql
CREATE PROCEDURE ProcedureName
AS
BEGIN
    -- SQL statements
END;
````

### Execution Syntax

```sql
EXEC ProcedureName;
```

---

## 6. Example: Stored Procedure without Parameters

### Table Creation

```sql
CREATE TABLE Employees
(
    EmpId INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary DECIMAL(10,2),
    Department VARCHAR(50)
);
```

### Stored Procedure

```sql
CREATE PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT * FROM Employees;
END;
```

### Execution

```sql
EXEC GetAllEmployees;
```

---

## 7. Stored Procedure with Input Parameters

Stored procedures can accept parameters to make them dynamic.

### Example

```sql
CREATE PROCEDURE GetEmployeesByDepartment
    @Department VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE Department = @Department;
END;
```

### Execution

```sql
EXEC GetEmployeesByDepartment 'IT';
```

---

## 8. Stored Procedure with Multiple Parameters

```sql
CREATE PROCEDURE GetEmployeesBySalary
    @MinSalary DECIMAL(10,2),
    @Department VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE Salary >= @MinSalary
      AND Department = @Department;
END;
```

---

## 9. Stored Procedure with INSERT Operation

Stored procedures are commonly used for data manipulation.

```sql
CREATE PROCEDURE AddEmployee
    @EmpId INT,
    @EmpName VARCHAR(50),
    @Salary DECIMAL(10,2),
    @Department VARCHAR(50)
AS
BEGIN
    INSERT INTO Employees
    VALUES (@EmpId, @EmpName, @Salary, @Department);
END;
```

---

## 10. Stored Procedure with OUTPUT Parameter

Output parameters are used to return values.

```sql
CREATE PROCEDURE GetEmployeeCount
    @Department VARCHAR(50),
    @TotalEmployees INT OUTPUT
AS
BEGIN
    SELECT @TotalEmployees = COUNT(*)
    FROM Employees
    WHERE Department = @Department;
END;
```

### Execution

```sql
DECLARE @Count INT;

EXEC GetEmployeeCount 'IT', @Count OUTPUT;

SELECT @Count AS TotalEmployees;
```

---

## 11. Altering and Dropping Stored Procedures

### Modify a Stored Procedure

```sql
ALTER PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT EmpName, Salary FROM Employees;
END;
```

### Delete a Stored Procedure

```sql
DROP PROCEDURE GetAllEmployees;
```

---

## 12. Difference Between Stored Procedure and Function

| Feature                         | Stored Procedure | Function |
| ------------------------------- | ---------------- | -------- |
| Can return multiple result sets | Yes              | No       |
| Supports INSERT/UPDATE/DELETE   | Yes              | Limited  |
| Called using                    | EXEC             | SELECT   |
| Output parameters               | Yes              | No       |

---

## 13. Real-World Use Case

In a **banking system**, stored procedures are used to:

* Transfer money between accounts
* Validate balances
* Maintain transaction integrity
* Ensure atomic operations

---

## 14. Conclusion

Stored procedures are an essential database feature that improves performance, security, and maintainability. They are heavily used in enterprise applications to implement business logic efficiently and consistently.

---

## 15. Exam-Oriented Definition

> A stored procedure is a precompiled set of SQL statements stored in the database that can be executed repeatedly using its name and can accept input parameters and return output results.

```