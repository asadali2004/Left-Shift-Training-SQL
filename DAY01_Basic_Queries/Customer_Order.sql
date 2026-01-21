/* =========================
   DROP EXISTING TABLES
   (Safe re-run to avoid errors)
   ========================= */

-- Drop Orders table if it already exists
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;

-- Drop Customers table if it already exists
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;


/* =========================
   CREATE CUSTOMERS TABLE
   ========================= */

-- Create Customers master table to store customer details
CREATE TABLE dbo.Customers
(
    CustomerId   INT PRIMARY KEY,             -- Unique customer identifier
    FullName     VARCHAR(100) NOT NULL,        -- Customer full name
    City         VARCHAR(50)  NOT NULL,        -- City of customer
    Segment      VARCHAR(20)  NOT NULL,        -- Retail / Corporate
    IsActive     BIT          NOT NULL,        -- Active (1) or Inactive (0)
    CreatedOn    DATE         NOT NULL         -- Account creation date
);


/* =========================
   CREATE ORDERS TABLE
   ========================= */

-- Create Orders table to store customer order information
CREATE TABLE dbo.Orders
(
    OrderId      INT PRIMARY KEY,              -- Unique order identifier
    CustomerId   INT NOT NULL,                 -- References Customers table
    OrderDate    DATE NOT NULL,                -- Date of order
    Amount       DECIMAL(10,2) NOT NULL,       -- Order amount
    Status       VARCHAR(20) NOT NULL,         -- Delivered / Cancelled / Pending
    PaymentMode  VARCHAR(20) NOT NULL,         -- UPI / Card / Cash

    -- Foreign key constraint to maintain referential integrity
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerId) REFERENCES dbo.Customers(CustomerId)
);


/* =========================
   INSERT DATA INTO CUSTOMERS
   ========================= */

-- Insert sample customer records
INSERT INTO dbo.Customers (CustomerId, FullName, City, Segment, IsActive, CreatedOn) VALUES
(101, 'Gopi Suresh',   'Coimbatore', 'Retail',    1, '2025-11-12'),
(102, 'Anita Ravi',    'Chennai',    'Corporate', 1, '2025-10-05'),
(103, 'Karthik Mohan', 'Bengaluru',  'Retail',    1, '2025-09-15'),
(104, 'Meena Kumar',   'Chennai',    'Retail',    0, '2024-12-20'),
(105, 'Suresh Babu',   'Hyderabad',  'Corporate', 1, '2025-01-10');


/* =========================
   INSERT DATA INTO ORDERS
   ========================= */

-- Insert sample order records
INSERT INTO dbo.Orders (OrderId, CustomerId, OrderDate, Amount, Status, PaymentMode) VALUES
(5001, 101, '2026-01-10', 1200.00, 'Delivered', 'UPI'),
(5002, 101, '2026-01-15',  850.00, 'Pending',   'Card'),
(5003, 102, '2026-01-05', 5000.00, 'Delivered', 'Card'),
(5004, 103, '2025-12-30',  300.00, 'Cancelled', 'Cash'),
(5005, 105, '2026-01-18', 2500.00, 'Delivered', 'UPI'),
(5006, 102, '2026-01-20', 1500.00, 'Pending',   'UPI');


/* =========================
   BASIC SELECT QUERIES
   ========================= */

-- Retrieve all columns and all records from Customers table
SELECT *
FROM dbo.Customers;

-- Retrieve only CustomerId, FullName, and City columns
SELECT CustomerId, FullName, City
FROM dbo.Customers;

-- Retrieve unique list of cities from Customers table
SELECT DISTINCT City
FROM dbo.Customers;

-- Display customer name and city using column aliases
SELECT FullName AS CustomerName, City AS CustomerCity
FROM dbo.Customers;


/* =========================
   FILTERING USING WHERE
   ========================= */

-- Retrieve customers who belong to Chennai city
SELECT *
FROM dbo.Customers
WHERE City = 'Chennai';

-- Retrieve orders that are Delivered and paid via UPI
SELECT *
FROM dbo.Orders
WHERE Status = 'Delivered' AND PaymentMode = 'UPI';

-- Retrieve customers who live in Chennai or Coimbatore
SELECT *
FROM dbo.Customers
WHERE City IN ('Chennai', 'Coimbatore');

-- Retrieve orders where amount is between 800 and 3000
SELECT *
FROM dbo.Orders
WHERE Amount BETWEEN 800 AND 3000;

-- Retrieve customers whose name starts with letter 'S'
SELECT *
FROM dbo.Customers
WHERE FullName LIKE 'S%';


/* =========================
   SORTING AND LIMITING
   ========================= */

-- Retrieve all orders sorted by amount in descending order
SELECT *
FROM dbo.Orders
ORDER BY Amount DESC;

-- Retrieve top 3 highest amount orders
SELECT TOP 3 *
FROM dbo.Orders
ORDER BY Amount DESC;


/* =========================
   ADVANCED FILTERING
   ========================= */

-- Retrieve customers whose name starts with 'S' and ends with 'a'
-- OR customers whose name contains 'Gopi'
SELECT *
FROM dbo.Customers
WHERE FullName LIKE 'S%a' 
   OR FullName LIKE '%Gopi%';


/* =========================
   SUBQUERY WITH ORDERING
   ========================= */

-- Retrieve the second highest order amount
SELECT TOP 1 *
FROM 
(
    -- Get top 2 highest orders
    SELECT TOP 2 *
    FROM dbo.Orders
    ORDER BY Amount DESC
) TT
-- From the top 2, select the smaller amount (second highest)
ORDER BY TT.Amount;
