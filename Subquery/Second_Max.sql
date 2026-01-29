Select * from Employees;

-- First Approach
Select MAX(BasicSalary) from Employees
where BasicSalary < (select MAX(BasicSalary) from Employees);

-- Second Approach
SELECT TOP 1 * 
FROM Employees
WHERE BasicSalary < (SELECT MAX(BasicSalary) FROM Employees)
ORDER BY BasicSalary DESC

-- third way
SELECT *
FROM Employees
ORDER BY BasicSalary DESC
OFFSET 1 ROWS FETCH NEXT 1 ROW ONLY;

