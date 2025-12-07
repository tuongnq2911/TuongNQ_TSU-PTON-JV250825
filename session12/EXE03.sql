CREATE DATABASE ecommerce;
USE ecommerce;
-- 1. Bảng customers (Khách hàng)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng orders (Đơn hàng)
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- 3. Bảng products (Sản phẩm)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Bảng order_items (Chi tiết đơn hàng)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 5. Bảng inventory (Kho hàng)
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 6. Bảng payments (Thanh toán)
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash') NOT NULL,
    status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- 7. Bảng order_logs (Lịch sử thay đổi trạng thái)
CREATE TABLE order_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    old_status ENUM('Pending', 'Completed', 'Cancelled'),
    new_status ENUM('Pending', 'Completed', 'Cancelled'),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Tạo một Trigger có tên before_insert_check_payment. Trigger này sẽ được kích hoạt trước khi chèn dữ liệu vào bảng payments. 
-- Nó sẽ kiểm tra xem số tiền thanh toán (amount) có khớp với tổng tiền đơn hàng (total_amount) hay không. Nếu không khớp, Trigger sẽ báo lỗi SQLSTATE '45000'.

DELIMITER $$
CREATE TRIGGER before_insert_check_payment
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE order_total DECIMAL(10,2);
    -- Lấy tổng tiền của đơn hàng
    SELECT total_amount INTO order_total
    FROM orders
    WHERE order_id = NEW.order_id;
    -- Nếu không khớp thì báo lỗi
    IF NEW.amount <> order_total THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Payment amount does not match order total!';
    END IF;
END$$
DELIMITER ;

-- Tạo Trigger AFTER UPDATE:

DELIMITER $$
CREATE TRIGGER after_update_order_status
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    -- Chỉ log khi trạng thái thay đổi
    IF OLD.status <> NEW.status THEN
        INSERT INTO order_logs (order_id, old_status, new_status, log_date)
        VALUES (OLD.order_id, OLD.status, NEW.status, NOW());
    END IF;
END$$
DELIMITER ;

-- Viết Stored Procedure:

DELIMITER $$
CREATE PROCEDURE sp_update_order_status_with_payment(
    IN p_order_id INT,
    IN p_new_status ENUM('Pending','Completed','Cancelled'),
    IN p_payment_amount DECIMAL(10,2),
    IN p_payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash')
)
BEGIN
    DECLARE v_old_status ENUM('Pending','Completed','Cancelled');
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Xử lý khi lỗi xảy ra
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error occurred! Transaction rolled back.';
    END;   
    START TRANSACTION;
    -- Lấy trạng thái hiện tại của đơn hàng
    SELECT status INTO v_old_status 
    FROM orders 
    WHERE order_id = p_order_id;
    -- Nếu không tìm thấy order, báo lỗi
    IF v_old_status IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order not found!';
    END IF;
    -- Nếu trạng thái không thay đổi thì rollback + báo lỗi
    IF v_old_status = p_new_status THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order status is already the same!';
    END IF;
    -- Nếu trạng thái mới là Completed => cần ghi payment
    IF p_new_status = 'Completed' THEN
        INSERT INTO payments(order_id, amount, payment_method, status)
        VALUES (p_order_id, p_payment_amount, p_payment_method, 'Completed');
    END IF;
    -- Cập nhật trạng thái đơn hàng
    UPDATE orders
    SET status = p_new_status
    WHERE order_id = p_order_id;
    -- Nếu mọi thứ OK thì commit
    COMMIT;
END$$
DELIMITER ;

-- Thực thi và kiểm tra:

-- Thêm khách hàng
INSERT INTO customers (name, email, phone, address)
VALUES 
('Nguyen Van A', 'a@gmail.com', '012345678', 'Ha Noi'),
('Tran Thi B', 'b@gmail.com', '098765432', 'Da Nang');

-- Thêm sản phẩm
INSERT INTO products (name, price, description)
VALUES
('Laptop Gaming', 2000.00, 'Laptop cấu hình cao'),
('Chuột Logitech', 20.00, 'Chuột không dây');

-- Thêm đơn hàng
INSERT INTO orders (customer_id, total_amount, status)
VALUES
(1, 2000.00, 'Pending'),     -- Order 1
(2, 20.00, 'Pending');       -- Order 2

-- Gọi Stored Procedure để test
	-- TH thành công
CALL sp_update_order_status_with_payment(
    1, 
    'Completed', 
    2000.00, 
    'Credit Card'
);
	-- Trường hợp thất bại (sai số tiền thanh toán)
CALL sp_update_order_status_with_payment(
    2, 
    'Completed', 
    100.00,   -- Sai, total_amount = 20
    'PayPal'
);

-- Hiển thị lại bảng order_logs để quan sát lịch sử thay đổi trạng thái.
SELECT * FROM order_logs;


