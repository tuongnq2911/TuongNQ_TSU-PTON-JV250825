-- Tạo bảng Products
CREATE TABLE Products (
    productID INT PRIMARY KEY,
    productName VARCHAR(100),
    price DECIMAL(10, 2)
);
-- Thêm 5 bản ghi lấy dữ liệu
INSERT INTO Products (productID, productName, price) VALUES
(1, 'Sản phẩm A', 150.00),
(2, 'Sản phẩm B', 200.00),
(3, 'Sản phẩm C', 100.00),
(4, 'Sản phẩm D', 250.00),
(5, 'Sản phẩm E', 175.00);
-- Tìm kiếm sản phẩm có giá cao nhất
SELECT 
    productID, 
    productName, 
    price 
FROM 
    Products 
WHERE 
    price = (SELECT MAX(price) FROM Products);
    
-- Tìm kiếm sản phẩm có giá thấp nhất
SELECT 
    productID, 
    productName, 
    price 
FROM 
    Products 
WHERE 
    price = (SELECT MIN(price) FROM Products);