/* ============================================================
   FILE NAME   : Bank_Account_StoredProcedures.sql
   PURPOSE     : Bank Account Management using Stored Procedures
   DATABASE    : SQL Server
   AUTHOR      : Asad Ali
   DESCRIPTION : re-runnable SQL script
   ============================================================ */

---------------------------------------------------------------
-- STEP 1: DROP TABLE IF EXISTS (Safe Re-run)
---------------------------------------------------------------
IF OBJECT_ID('dbo.BankAccount', 'U') IS NOT NULL
    DROP TABLE dbo.BankAccount;
GO

---------------------------------------------------------------
-- STEP 2: CREATE BANK ACCOUNT TABLE
---------------------------------------------------------------
CREATE TABLE dbo.BankAccount
(
    AccountNo            INT            PRIMARY KEY,  -- Account Number
    AccountHolderName    VARCHAR(50)    NOT NULL,      -- Holder Name
    Balance              DECIMAL(12,2)  NOT NULL,      -- Current Balance
    AccountType          VARCHAR(20)    NOT NULL,      -- Savings / Current
    IsActive             BIT            NOT NULL       -- Account Status
);
GO

---------------------------------------------------------------
-- STEP 3: INSERT SAMPLE ACCOUNT DATA
---------------------------------------------------------------
INSERT INTO dbo.BankAccount (AccountNo, AccountHolderName, Balance, AccountType, IsActive)
VALUES
    (1001, 'Ali Ahmed',    75000.00,  'Savings',        1),
    (1002, 'Sana Khan',    120000.50, 'Current',        1),
    (1003, 'Imran Zafar',  45000.75,  'Savings',        0),
    (1004, 'Nida Ali',     200000.00, 'Fixed Deposit',  1),
    (1005, 'Usman Malik',  30000.25,  'Savings',        1);
GO

---------------------------------------------------------------
-- STEP 4: PROCEDURE - GET ACCOUNT DETAILS
---------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetAccountDetails
    @AccountNo INT
AS
BEGIN
    SELECT *
    FROM dbo.BankAccount
    WHERE AccountNo = @AccountNo;
END;
GO

---------------------------------------------------------------
-- STEP 5: PROCEDURE - DEPOSIT AMOUNT
---------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.DepositAmount
    @AccountNo     INT,
    @DepositAmount DECIMAL(12,2)
AS
BEGIN
    UPDATE dbo.BankAccount
    SET Balance = Balance + @DepositAmount
    WHERE AccountNo = @AccountNo
      AND IsActive = 1;
END;
GO

---------------------------------------------------------------
-- STEP 6: PROCEDURE - WITHDRAW AMOUNT (WITH VALIDATION)
---------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.WithdrawAmount
    @AccountNo      INT,
    @WithdrawAmount DECIMAL(12,2)
AS
BEGIN
    -- Withdraw only if sufficient balance and active account
    UPDATE dbo.BankAccount
    SET Balance = Balance - @WithdrawAmount
    WHERE AccountNo = @AccountNo
      AND IsActive = 1
      AND Balance >= @WithdrawAmount;
END;
GO

---------------------------------------------------------------
-- STEP 7: EXECUTION / TESTING
---------------------------------------------------------------

-- Get account details
EXEC dbo.GetAccountDetails 1001;
GO

-- Deposit amount
EXEC dbo.DepositAmount 
     @AccountNo = 1001,
     @DepositAmount = 5000.00;
GO

-- Withdraw amount
EXEC dbo.WithdrawAmount
     @AccountNo = 1001,
     @WithdrawAmount = 2000.00;
GO

-- Verify final balance
EXEC dbo.GetAccountDetails 1001;
GO
