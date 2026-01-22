USE [LearningDB];
GO

------------------------------------------------------------
-- STEP 1: INSTEAD OF UPDATE TRIGGER
-- Purpose: Prevent updating Primary Key (EmpId)
------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_Block_EmpId_Update
ON dbo.Employees
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- If EmpId is being updated, block it
    IF UPDATE(EmpId)
    BEGIN
        RAISERROR 50001, 'Updating EmpId (Primary Key) is not allowed.', 1;
        RETURN;
    END

    -- Allow updates for other columns
    UPDATE e
    SET
        e.EmpName     = i.EmpName,
        e.Department  = i.Department,
        e.BasicSalary = i.BasicSalary,
        e.IsActive    = i.IsActive
    FROM dbo.Employees e
    INNER JOIN inserted i
        ON e.EmpId = i.EmpId;
END;
GO

------------------------------------------------------------
-- STEP 2: TEST CASES FOR INSTEAD OF TRIGGER
------------------------------------------------------------

-- ❌ FAIL: Attempt to update primary key
UPDATE dbo.Employees
SET EmpId = 200
WHERE EmpId = 101;

-- ✅ PASS: Update allowed column
UPDATE dbo.Employees
SET BasicSalary = 8500000
WHERE EmpId = 101;
GO

------------------------------------------------------------
-- STEP 3: AUDIT TABLE (Must exist before AFTER trigger)
------------------------------------------------------------
CREATE TABLE dbo.EmployeeSalaryAudit
(
    AuditId   INT IDENTITY PRIMARY KEY,
    EmpId     INT,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    UpdatedOn DATETIME DEFAULT GETDATE()
);
GO

------------------------------------------------------------
-- STEP 4: AFTER UPDATE TRIGGER
-- Purpose: Log salary changes
------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_After_Salary_Update
ON dbo.Employees
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Log only if salary was updated
    IF UPDATE(BasicSalary)
    BEGIN
        INSERT INTO dbo.EmployeeSalaryAudit (EmpId, OldSalary, NewSalary)
        SELECT
            d.EmpId,
            d.BasicSalary AS OldSalary,
            i.BasicSalary AS NewSalary
        FROM deleted d
        INNER JOIN inserted i
            ON d.EmpId = i.EmpId;
    END
END;
GO

------------------------------------------------------------
-- STEP 5: TEST AFTER TRIGGER
------------------------------------------------------------
UPDATE dbo.Employees
SET BasicSalary = 9000000
WHERE EmpId = 101;

SELECT * FROM dbo.EmployeeSalaryAudit;
GO
