------------------------------------------------------------
-- STORED PROCEDURE: CRUD Operations on Employees Table
------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.CRUD_Operations
(
    @EmpId        INT,
    @Action       VARCHAR(10),      -- INSERT / SELECT / UPDATE / DELETE
    @EmpName      VARCHAR(50) = NULL,
    @Department   VARCHAR(50) = NULL,
    @BasicSalary  DECIMAL(10,2) = NULL,
    @IsActive     BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------------
    -- INSERT OPERATION
    --------------------------------------------------------
    IF @Action = 'INSERT'
    BEGIN
        -- Check if employee already exists
        IF EXISTS (SELECT 1 FROM dbo.Employees WHERE EmpId = @EmpId)
        BEGIN
            PRINT 'Employee already exists. Insert not allowed.';
            RETURN;
        END

        INSERT INTO dbo.Employees (EmpId, EmpName, Department, BasicSalary, IsActive)
        VALUES (@EmpId, @EmpName, @Department, @BasicSalary, @IsActive);

        PRINT 'Employee inserted successfully.';
    END

    --------------------------------------------------------
    -- SELECT OPERATION
    --------------------------------------------------------
    ELSE IF @Action = 'SELECT'
    BEGIN
        SELECT *
        FROM dbo.Employees
        WHERE EmpId = @EmpId;
    END

    --------------------------------------------------------
    -- UPDATE OPERATION
    --------------------------------------------------------
    ELSE IF @Action = 'UPDATE'
    BEGIN
        -- Check if employee exists before updating
        IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE EmpId = @EmpId)
        BEGIN
            PRINT 'Employee not found. Update not possible.';
            RETURN;
        END

        UPDATE dbo.Employees
        SET
            EmpName     = @EmpName,
            Department  = @Department,
            BasicSalary = @BasicSalary,
            IsActive    = @IsActive
        WHERE EmpId = @EmpId;

        PRINT 'Employee updated successfully.';
    END

    --------------------------------------------------------
    -- DELETE OPERATION
    --------------------------------------------------------
    ELSE IF @Action = 'DELETE'
    BEGIN
        -- Check if employee exists before deleting
        IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE EmpId = @EmpId)
        BEGIN
            PRINT 'Employee not found. Delete not possible.';
            RETURN;
        END

        DELETE FROM dbo.Employees
        WHERE EmpId = @EmpId;

        PRINT 'Employee deleted successfully.';
    END

    --------------------------------------------------------
    -- INVALID ACTION
    --------------------------------------------------------
    ELSE
    BEGIN
        PRINT 'Invalid Action. Use INSERT, SELECT, UPDATE, or DELETE.';
    END
END;
GO


EXEC dbo.CRUD_Operations
     @EmpId = 201,
     @Action = 'INSERT',
     @EmpName = 'Rahul',
     @Department = 'IT',
     @BasicSalary = 6500000,
     @IsActive = 1;


EXEC dbo.CRUD_Operations
     @EmpId = 201,
     @Action = 'SELECT';

EXEC dbo.CRUD_Operations
     @EmpId = 201,
     @Action = 'UPDATE',
     @EmpName = 'Rahul Sharma',
     @Department = 'HR',
     @BasicSalary = 7000000,
     @IsActive = 1;

EXEC dbo.CRUD_Operations
     @EmpId = 201,
     @Action = 'DELETE';


