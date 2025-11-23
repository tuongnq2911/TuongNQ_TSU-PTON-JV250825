CREATE DATABASE SaleDB;
USE SaleDB;

CREATE TABLE Customers (
    customerID INT AUTO_INCREMENT PRIMARY KEY,
    customerName VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    INDEX idx_email (email),  -- Thêm chỉ số cho cột Email
    phone VARCHAR(15) NOT NULL,
    createAt DATETIME DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE Products (
    productID INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Orders (
    orderID INT AUTO_INCREMENT PRIMARY KEY,
    customerID INT,
    orderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    totalAmount DECIMAL(10, 2) NOT NULL,    
    FOREIGN KEY (customerID) REFERENCES Customers(customerID),
    INDEX idx_orderDate (orderDate)  -- Thêm chỉ số cho cột OrderDate
);

CREATE TABLE OrderDetails (
    orderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    orderID INT,
    productID INT,
    quantity INT NOT NULL,
    unitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (productID) REFERENCES Products(productID)
);

CREATE VIEW CustomerOrders AS
SELECT 
	o.orderID,
    c.customerName,
    o.orderDate,
    o.totalAmount
FROM 
	Orders o
JOIN 
	Customers c ON o.customerID = c.customerID;
    
UPDATE Orders
SET totalAmount = 250.00
WHERE orderID = 1;