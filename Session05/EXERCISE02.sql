CREATE TABLE Sales (
    saleID INT PRIMARY KEY,
    produceID INT,
    saleDate DATE,
    quantity INT,
    amount DECIMAL(10, 2)
);
INSERT INTO Sales (saleID, produceID, saleDate, quantity, amount) VALUES
(1, 101, '2025-11-01', 5, 100.00),
(2, 102, '2025-11-02', 3, 45.00),
(3, 101, '2025-11-03', 2, 40.00),
(4, 103, '2025-11-04', 7, 140.00),
(5, 102, '2025-11-05', 1, 15.00);

SELECT * FROM Sales;

SELECT 
    produceID,
    COUNT(saleID) AS orderCount
FROM 
    Sales
GROUP BY 
    produceID;