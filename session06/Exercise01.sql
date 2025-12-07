CREATE DATABASE session05Exer07;
USE session05Exer07;

CREATE TABLE products (
    productID INT PRIMARY KEY,
    productName VARCHAR(100)
);

CREATE TABLE regions (
    regionID INT PRIMARY KEY,
    regionName VARCHAR(100)
);

CREATE TABLE sales (
    saleID INT PRIMARY KEY,
    productID INT,
    regionID INT,
    saleDate DATE,
    quantity INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (productID) REFERENCES products(productID),
    FOREIGN KEY (regionID) REFERENCES regions(regionID)
);

INSERT INTO products (productID, productName) VALUES
(1, 'Sản phẩm A'),
(2, 'Sản phẩm B'),
(3, 'Sản phẩm C'),
(4, 'Sản phẩm D'),
(5, 'Sản phẩm E');

INSERT INTO regions (regionID, regionName) VALUES
(1, 'Khu vực Bắc'),
(2, 'Khu vực Trung'),
(3, 'Khu vực Nam');

INSERT INTO sales (saleID, productID, regionID, saleDate, quantity, amount) VALUES
(1, 1, 1, '2025-11-01', 10, 1500.00),
(2, 2, 1, '2025-11-02', 5, 1000.00),
(3, 3, 2, '2025-11-03', 20, 3000.00),
(4, 1, 2, '2025-11-04', 15, 2250.00),
(5, 4, 3, '2025-11-05', 8, 2400.00),
(6, 5, 3, '2025-11-06', 12, 1800.00),
(7, 2, 1, '2025-11-07', 7, 1400.00),
(8, 3, 2, '2025-11-08', 5, 750.00),
(9, 4, 3, '2025-11-09', 10, 3000.00),
(10, 5, 1, '2025-11-10', 4, 600.00);

SELECT 
    r.regionID,
    r.regionName,
    SUM(s.amount) AS totalRevenue,
    SUM(s.quantity) AS totalQuantity,
    (SELECT p.productName 
     FROM sales s2 
     JOIN products p ON s2.productID = p.productID 
     WHERE s2.regionID = r.regionID 
     GROUP BY s2.productID 
     ORDER BY SUM(s2.quantity) DESC 
     LIMIT 1) AS bestSellingProduct
FROM 
    regions r
LEFT JOIN 
    sales s ON r.regionID = s.regionID
GROUP BY 
    r.regionID, r.regionName;