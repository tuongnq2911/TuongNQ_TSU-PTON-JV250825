USE session05;

CREATE TABLE products01(
productID INT PRIMARY KEY AUTO_INCREMENT,
productName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE regions (
regionID INT PRIMARY KEY AUTO_INCREMENT,
regionName VARCHAR(100) NOT NULL
);

CREATE TABLE sales01 (
saleID INT PRIMARY KEY AUTO_INCREMENT,
productID INT NOT NULL,
regionID INT NOT NULL,
saleDate DATE NOT NULL,
quantity INT NOT NULL,
amount DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (productID) REFERENCES products01(productID),
FOREIGN KEY (regionID) REFERENCES regions(regionID)
);

INSERT INTO products01(productName) VALUE 
('Ao polo'),
('Quan kaki'),
('Mu Son');

INSERT INTO regions(regionName) VALUE 
('HN'),
('HP'),
('HCM');

INSERT INTO sales01(productID, regionID, saleDate, quantity, amount) value
(1, 1, '2025-11-11', 2, 200),
(1, 2, '2025-11-10', 1, 100),
(3, 3, '2025-11-11', 1, 50),
(2, 1, '2025-11-11', 2, 200);
INSERT INTO sales01(productID, regionID, saleDate, quantity, amount) value
(1, 1, '2025-11-11', 3, 200);
SELECT * FROM sales01;

SELECT r.regionName, p.productName, SUM(s.quantity) AS total_qty
FROM sales01 s
JOIN products01 p ON s.productID = p.productID
JOIN regions r ON s.regionID = r.regionID
GROUP BY  r.regionName, p.productName