CREATE DATABASE session05;
USE session05;

-- Tạo bảng customers
CREATE TABLE customers (
customerID INT PRIMARY KEY AUTO_INCREMENT,
customerName VARCHAR(100),
contactEmail VARCHAR(100)
);
INSERT INTO customers(customerName, contactEmail) VALUE 
('Nguyen Van A', 'a@gmail.com'),
('Nguyen Van B', 'b@gmail.com'),
('Tran Thi C', 'c@gmail.com');
-- Tạo bảng orders
CREATE TABLE orders(
orderID INT PRIMARY KEY AUTO_INCREMENT,
customerID INT,
orderDate DATE,
totalAmount DECIMAL(10, 2),
FOREIGN KEY (customerID) REFERENCES customers(customerID)
);
INSERT INTO orders(customerID, orderDate, totalAmount) VALUE
(1, '2024-10-11', 30.5),
(2, '2025-01-18', 29.3),
(1, '2024-09-13', 40.1);

-- Sử dụng câu lệnh JOIN truy vấn để lấy danh sách các đơn hàng cùng với tên khách hàng và email 
SELECT 
    Orders.orderID,
    customers.customerName,
    customers.contactEmail, 
    Orders.orderDate,
    Orders.totalAmount
FROM 
    Orders
JOIN 
    customers ON Orders.customerID = Customers.customerID;