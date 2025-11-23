CREATE DATABASE SalesDB;
USE SalesDB;

CREATE TABLE Customers (
    customerID INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    INDEX idx_email (email)  -- Thêm chỉ số cho cột Email
);

CREATE TABLE Products (
    productID INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    promotionID INT,
    FOREIGN KEY (promotionID) REFERENCES Promotions(promotionID)
);

CREATE TABLE Orders (
    orderID INT AUTO_INCREMENT PRIMARY KEY,
    customerID INT NOT NULL,
    orderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    totalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customerID) REFERENCES Customers(customerID),
    INDEX idx_orderDate (orderDate)  -- Thêm chỉ số cho cột OrderDate
);

CREATE TABLE OrderDetails (
    orderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    orderID INT NOT NULL,
    productID INT NOT NULL,
    quantity INT NOT NULL,
    unitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (productID) REFERENCES Products(productID)
);

CREATE TABLE Promotions (
    promotionID INT AUTO_INCREMENT PRIMARY KEY,
    promotionName VARCHAR(100) NOT NULL,
    discountPercentage DECIMAL(5, 2) NOT NULL
);

CREATE TABLE Sales (
    saleID INT AUTO_INCREMENT PRIMARY KEY,
    orderID INT NOT NULL,
    saleDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    saleAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

DELIMITER //
CREATE PROCEDURE GetCustomerTotalRevenue (
	IN inCustomerID  INT,
    IN inStartDate DATE,
    IN inEndDate DATE,
    OUT totalRevenue DECIMAL(10,2)
)
BEGIN
	SELECT SUM(totalAmount) INTO totalRevenue
    FROM Orders
    WHERE customerID = inCustomerID
		AND orderDate BETWEEN inStartDate AND inEndDate;
END //

DELIMITER ;
