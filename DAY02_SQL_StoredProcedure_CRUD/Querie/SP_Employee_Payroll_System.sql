/* ============================================================
   FILE NAME   : SP_Employee_Payroll_System.sql
   PURPOSE     : Employee Payroll Management using Stored Procedures
   DATABASE    : SQL Server
   AUTHOR      : Asad ALi
   DESCRIPTION : re-runnable SQL script
   ============================================================ */

---------------------------------------------------------------
-- STEP 1: DROP TABLE IF EXISTS (Safe Re-run)
---------------------------------------------------------------
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
    DROP TABLE dbo.Employees;
GO

---------------------------------------------------------------
-- STEP 2: CREATE EMPLOYEES TABLE
---------------------------------------------------------------
CREATE TABLE dbo.Employees
(
    EmpId        INT            PRIMARY KEY,        -- Employee ID
    EmpName      VARCHAR(50)    NOT NULL,            -- Employee Name
    Department   VARCHAR(50)    NOT NULL,            -- Department Name
    BasicSalary  DECIMAL(10,2)  NOT NULL,            -- Basic Salary
    IsActive     BIT            NOT NULL             -- Active Status
);
GO

---------------------------------------------------------------
-- STEP 3: INSERT SAMPLE DATA
---------------------------------------------------------------
INSERT INTO dbo.Employees (EmpId, EmpName, Department, BasicSalary, IsActive)
VALUES
    (101, 'Asad',   'IT',        8000000.00, 1),
    (102, 'Babu',   'HR',        7000000.00, 1),
    (103, 'Ali',    'Finance',   6500000.00, 1),
    (104, 'Sana',   'Marketing', 6000000.00, 1),
    (105, 'Tariq',  'IT',        7200000.00, 0);
GO

---------------------------------------------------------------
-- STEP 4: PROCEDURE - GET ALL EMPLOYEES
---------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetAllEmployees
AS
BEGIN
    SELECT *
    FROM dbo.Employees;
END;
GO

---------------------------------------------------------------
-- STEP 5: PROCEDURE - GET EMPLOYEES BY DEPARTMENT
---------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetEmployeesByDepartment
    @Department VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM dbo.Employees
    WHERE Department = @Department;
END;
GO

---------------------------------------------------------------
-- STEP 6: PROCEDURE - ADD NEW EMPLOYEE
---------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.AddEmployee
    @EmpId        INT,
    @EmpName      VARCHAR(50),
    @Department   VARCHAR(50),
    @BasicSalary  DECIMAL(10,2),
    @IsActive     BIT
AS
BEGIN
    INSERT INTO dbo.Employees (EmpId, EmpName, Department, BasicSalary, IsActive)
    VALUES (@EmpId, @EmpName, @Department, @BasicSalary, @IsActive);
END;
GO

---------------------------------------------------------------
-- STEP 7: PROCEDURE - GET EMPLOYEE COUNT BY DEPARTMENT (OUTPUT)
---------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetEmployeeCountByDepartment
    @Department VARCHAR(50),
    @EmpCount   INT OUTPUT
AS
BEGIN
    SELECT @EmpCount = COUNT(*)
    FROM dbo.Employees
    WHERE Department = @Department;
END;
GO

---------------------------------------------------------------
-- STEP 8: EXECUTION / TESTING
---------------------------------------------------------------

-- Get all employees
EXEC dbo.GetAllEmployees;
GO

-- Get IT department employees
EXEC dbo.GetEmployeesByDepartment 'IT';
GO

-- Add new employee
EXEC dbo.AddEmployee 
     @EmpId = 109,
     @EmpName = 'Ali',
     @Department = 'HR',
     @BasicSalary = 500000.00,
     @IsActive = 1;
GO

-- Get employee count using OUTPUT parameter
DECLARE @TotalCount INT;

EXEC dbo.GetEmployeeCountByDepartment 
     @Department = 'IT',
     @EmpCount = @TotalCount OUTPUT;

SELECT @TotalCount AS TotalEmployeesInIT;
GO
