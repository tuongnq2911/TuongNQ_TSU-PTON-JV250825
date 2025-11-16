CREATE TABLE EmployeeSalaries (
    employeeID INT PRIMARY KEY,
    departmentID INT,
    salary DECIMAL(10, 2)
);

INSERT INTO EmployeeSalaries (employeeID, departmentID, salary) VALUES
(1, 101, 50000.00),
(2, 102, 60000.00),
(3, 101, 55000.00),
(4, 103, 70000.00),
(5, 102, 65000.00);

SELECT * FROM EmployeeSalaries;

SELECT 
    departmentID,
    SUM(salary) AS totalSalary,
    AVG(salary) AS averageSalary
FROM 
    EmployeeSalaries
GROUP BY 
    departmentID;