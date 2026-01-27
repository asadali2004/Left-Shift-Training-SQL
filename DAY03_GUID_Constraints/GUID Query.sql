-- =============================================
-- SQL Learning File: Using Sequential GUIDs
-- For Beginners – Clean, Commented & Organized
-- =============================================

-- 1. Create table with NEWID() – Random GUID
-- Generates a random unique identifier (GUID) for each row
CREATE TABLE Product2 (
    ID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ProductName VARCHAR(255)
);

-- 2. Insert sample records
-- ID is auto-generated; no need to specify
INSERT INTO Product2 (ProductName) VALUES ('Oreo');
INSERT INTO Product2 (ProductName) VALUES ('RENEE');

-- 3. View all data
SELECT * FROM Product2;

-- 4. Cleanup: Drop table if needed
DROP TABLE Product2;

-- ==================================================
-- NEWSEQUENTIALID() Example – Sequential GUID
-- Better for performance (reduces index fragmentation)
-- Can ONLY be used in DEFAULT constraints
-- ==================================================

-- 5. Create table with NEWSEQUENTIALID()
-- Generates a sequential GUID (higher than previous one)
CREATE TABLE Product2_Sequential (
    ID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
    ProductName VARCHAR(255)
);

-- 6. Insert sample records
-- IDs will be in sequential order
INSERT INTO Product2_Sequential (ProductName) VALUES ('Oreo');
INSERT INTO Product2_Sequential (ProductName) VALUES ('RENEE');

-- 7. View results – notice the sequential GUIDs
SELECT * FROM Product2_Sequential;

-- 8. Cleanup
DROP TABLE Product2_Sequential;

-- 💡 Key Differences:
-- • NEWID()       → Random GUID, secure, but causes index fragmentation
-- • NEWSEQUENTIALID() → Sequential GUID, better performance, but predictable
-- • Both are unique, but NEWSEQUENTIALID() is faster for inserts
-- • You CANNOT use NEWSEQUENTIALID() in SELECT or INSERT statements directly
--   It only works as a DEFAULT in table definition   