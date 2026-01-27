-- =============================================
-- SQL Learning File: Understanding sysobjects
-- For Beginners – Clean, Commented & Organized
-- =============================================

-- 1. View all system objects in the current database
-- sysobjects contains metadata about tables, views, procedures, etc.
SELECT * FROM sysobjects;

-- 2. Get distinct object types (xtype values)
-- This helps you understand what kinds of objects exist
SELECT DISTINCT xtype FROM sysobjects;

-- 3. Filter: Show only user tables (xtype = 'U')
-- 'U' = User Table (as opposed to system tables, views, etc.)
SELECT * FROM sysobjects WHERE xtype = 'U';

-- 4. Count objects by type, but only show count for user tables ('U')
-- Note: Use HAVING with GROUP BY when filtering aggregated results
-- But here, filtering by xtype doesn't need aggregation, so WHERE is better
SELECT 
    xtype,
    COUNT(xtype) AS CountOfObjects
FROM sysobjects 
GROUP BY xtype
HAVING xtype = 'U';  -- Works, but not ideal

-- 5. Better approach: Use WHERE before GROUP BY
-- More efficient and clearer intent
SELECT 
    xtype,
    COUNT(xtype) AS CountOfObjects
FROM sysobjects 
WHERE xtype = 'U'  -- Filter first, then group
GROUP BY xtype;

-- 6. Alternative: Use subquery with WHERE (useful for complex logic)
-- Shows same result but uses WHERE on grouped data via derived table
SELECT *
FROM (
    SELECT 
        xtype,
        COUNT(xtype) AS CountOfObjects
    FROM sysobjects 
    GROUP BY xtype
) AS g1
WHERE g1.xtype = 'U';

-- 7. Create temporary table A1: Count objects by xtype and name
-- Stores result for reuse (e.g., in joins)
SELECT 
    xtype, 
    name,
    COUNT(xtype) AS CountOfObjects
INTO A1  -- Creates new table A1
FROM sysobjects 
WHERE xtype = 'U'  -- Only user tables
GROUP BY xtype, name;

-- 8. INNER JOIN: Join A1 with a derived table (A2) of distinct xtypes
-- Demonstrates joining with inline subquery
SELECT A1.name, A1.CountOfObjects
FROM A1
INNER JOIN (
    SELECT DISTINCT xtype FROM sysobjects
) AS A2 ON A1.xtype = A2.xtype
WHERE A1.xtype = 'U';  -- Filter after join

-- 9. Create A2: Summary of object counts by xtype
-- Prepares data for joining with A1
SELECT 
    xtype, 
    COUNT(*) AS CountOfA2 
INTO A2 
FROM sysobjects 
WHERE xtype = 'U'
GROUP BY xtype;

-- 10. Join A1 and A2 on xtype
-- Shows how to combine two aggregated datasets
SELECT 
    A1.xtype, 
    A1.CountOfObjects, 
    A2.CountOfA2
FROM A1
INNER JOIN A2 ON A1.xtype = A2.xtype;

-- 11. Cleanup: Drop temporary tables
-- Good practice to clean up after testing
DROP TABLE A1, A2;

-- 💡 Tips for Learning SQL:
-- • Use meaningful aliases and consistent formatting
-- • Prefer WHERE over HAVING when filtering raw rows
-- • Use CTEs (WITH) instead of INTO for reusable logic
-- • Avoid SELECT * in production; specify columns
-- • Always comment your code!   