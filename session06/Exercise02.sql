CREATE DATABASE Session06;
USE Session06;

CREATE TABLE customers (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE categories (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
price FLOAT,
categoryID INT NOT NULL,
FOREIGN KEY (categoryID) REFERENCES categories(id)
);

CREATE TABLE orders (
id INT PRIMARY KEY AUTO_INCREMENT,
customerID INT NOT NULL,
orderDate DATE,
FOREIGN KEY (customerID) REFERENCES customers(id)
);

CREATE TABLE order_detail (
orderID INT NOT NULL,
productID INT NOT NULL,
quantity INT,
price FLOAT,
FOREIGN KEY (orderID) REFERENCES orders(id),
FOREIGN KEY (productID) REFERENCES products(id)
);

INSERT INTO customers(name, email) VALUES
('A', 'a@gmail.com'),
('B', 'b@gmail.com'),
('C', 'c@gmail.com');

INSERT INTO categories(name) VALUES
('Ao'), ('Quan'), ('Mu');

INSERT INTO products(name, price, categoryID) VALUES 
('Ao Kaki', 100, 1),
('Ao balo', 50, 1),
('Quan dui', 80, 2);

INSERT INTO orders(customerID, orderDate) VALUES
(1, '2025-10-10'),
(2, '2025-10-10');

INSERT INTO order_detail(orderID, productID, quantity, price) VALUES
(1, 1, 1, 100),
(2, 1, 1, 100);

-- Liệt kê những khách hàng đặt ít nhất 1 đơn hàng
SELECT DISTINCT c.id, c.name, c.email FROM customers c JOIN orders o ON c.id = o.customerID;

-- Tìm những khách hàng chưa từng đặt đơn nào
SELECT id, name, email FROM customers WHERE id NOT IN (SELECT customerID FROM orders);

-- Tính tổng doanh thu mà mỗi khách hàng đã mang lại
SELECT c.id, c.name, c.email,IFNULL(SUM(od.quantity * od.price),0) AS total_revenue
FROM customers c
LEFT JOIN orders o ON c.id = o.customerID
LEFT JOIN order_detail od ON o.id = od.orderID
GROUP BY c.id, c.name, c.email;

-- Xác định khách hàng mua sản phẩm có giá cao nhất
SELECT c.id, c.name, c.email, p.name, p.price
FROM customers c
JOIN orders o ON c.id = o.customerID
JOIN order_detail od ON o.id = od.orderID
JOIN products p ON p.id = od.productID
WHERE p.price = (SELECT MAX(price) from products);
