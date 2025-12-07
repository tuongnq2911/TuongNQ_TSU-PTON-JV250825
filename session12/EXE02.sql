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

-- Stored Procedure sp_create_order:

DELIMITER $$
CREATE PROCEDURE sp_create_order(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_price DECIMAL(10, 2)
)
BEGIN
    DECLARE available_stock INT;
    DECLARE new_order_id INT;
    START TRANSACTION;
    -- Kiểm tra số lượng tồn kho
    SELECT stock_quantity INTO available_stock
    FROM inventory
    WHERE product_id = p_product_id;

    IF available_stock < p_quantity THEN
        -- Nếu không đủ tồn kho, rollback và thông báo lỗi
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không đủ số lượng sản phẩm trong kho!';
    ELSE
        -- Nếu đủ, thêm đơn hàng mới vào bảng orders
        INSERT INTO orders (customer_id, total_amount, status)
        VALUES (p_customer_id, p_price * p_quantity, 'Pending');
        -- Lấy order_id vừa tạo
        SET new_order_id = LAST_INSERT_ID();
        -- Thêm sản phẩm vào bảng order_items
        INSERT INTO order_items (order_id, product_id, quantity, price)
        VALUES (new_order_id, p_product_id, p_quantity, p_price);

        -- Cập nhật (giảm) số lượng tồn kho trong bảng inventory
        UPDATE inventory
        SET stock_quantity = stock_quantity - p_quantity
        WHERE product_id = p_product_id;

        -- Commit giao dịch
        COMMIT;
    END IF;
END;
$$
DELIMITER ;

-- Stored Procedure sp_pay_order:

DELIMITER $$
CREATE PROCEDURE sp_pay_order(
    IN p_order_id INT,
    IN p_payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash')
)
BEGIN
    DECLARE order_status ENUM('Pending', 'Completed', 'Cancelled');    
   
    START TRANSACTION;
    -- Kiểm tra trạng thái đơn hàng
    SELECT status INTO order_status
    FROM orders
    WHERE order_id = p_order_id;
    IF order_status IS NULL THEN
        -- Nếu không tìm thấy đơn hàng, rollback và thông báo lỗi
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Đơn hàng không tồn tại!';
    ELSEIF order_status <> 'Pending' THEN
        -- Nếu trạng thái không phải 'Pending', rollback và thông báo lỗi
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể thanh toán cho đơn hàng này!';
    ELSE
        -- Nếu trạng thái là 'Pending', thực hiện các thao tác
        -- Thêm bản ghi thanh toán vào bảng payments
        INSERT INTO payments (order_id, payment_date, amount, payment_method, status)
        VALUES (p_order_id, CURRENT_TIMESTAMP, (SELECT total_amount FROM orders WHERE order_id = p_order_id), p_payment_method, 'Completed');

        -- Cập nhật trạng thái đơn hàng thành 'Completed'
        UPDATE orders
        SET status = 'Completed'
        WHERE order_id = p_order_id;

        -- Commit giao dịch
        COMMIT;
    END IF;
END;
$$
DELIMITER ;

-- Stored Procedure sp_cancel_order:

DELIMITER $$

CREATE PROCEDURE sp_cancel_order(IN p_order_id INT)
BEGIN
    DECLARE v_status ENUM('Pending', 'Completed', 'Cancelled');
    DECLARE v_product_id INT;
    DECLARE v_quantity INT;
    DECLARE done INT DEFAULT 0;
    -- Cursor để duyệt các sản phẩm trong order_items
    DECLARE cur CURSOR FOR
        SELECT product_id, quantity
        FROM order_items
        WHERE order_id = p_order_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    START TRANSACTION;
    -- 1. Kiểm tra trạng thái đơn hàng
    SELECT status INTO v_status
    FROM orders
    WHERE order_id = p_order_id
    FOR UPDATE;
    IF v_status IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order does not exist.';
    END IF;
    IF v_status <> 'Pending' THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order can only be cancelled if status is Pending.';
    END IF;
    -- 2. Hoàn trả số lượng hàng vào kho
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_product_id, v_quantity;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        UPDATE inventory
        SET stock_quantity = stock_quantity + v_quantity
        WHERE product_id = v_product_id;
    END LOOP;
    CLOSE cur;
    -- 3. Xóa các sản phẩm trong order_items
    DELETE FROM order_items
    WHERE order_id = p_order_id;
    -- 4. Cập nhật trạng thái đơn hàng
    UPDATE orders
    SET status = 'Cancelled'
    WHERE order_id = p_order_id;
    COMMIT;
END $$
DELIMITER ;

-- Sử dụng lệnh DROP PROCEDURE để xóa tất cả các Stored Procedure đã tạo.

DROP PROCEDURE IF EXISTS sp_create_order;
DROP PROCEDURE IF EXISTS sp_pay_order;
DROP PROCEDURE IF EXISTS sp_cancel_order;

