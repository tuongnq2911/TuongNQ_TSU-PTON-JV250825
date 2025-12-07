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
-- Tạo Trigger kiểm tra số lượng tồn kho trước khi thêm sản phẩm vào order_items. Nếu không đủ, báo lỗi SQLSTATE '45000'.
DELIMITER $$
	CREATE TRIGGER trg_Check_Inventory_Before_Insert
    BEFORE INSERT
    ON order_items
    FOR EACH ROW
		BEGIN
			DECLARE check_in_stock INT;
            
            SELECT stock_quantity INTO check_in_stock 
            FROM inventory
            WHERE product_id = NEW.product_id;
            
            IF check_in_stock < NEW.quantity THEN 
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ton Kho khong du';
            END IF;
        END
$$ DELIMITER ;

-- Tạo Trigger cập nhật total_amount trong bảng orders sau khi thêm một sản phẩm mới vào order_items.
DELIMITER $$
	CREATE TRIGGER trg_Check_orders_After_Insert
    AFTER INSERT
    ON order_items
    FOR EACH ROW
		BEGIN
			DECLARE new_total_amount DECIMAL(10,2);
            
            SELECT SUM(quantity * price) INTO new_total_amount
            FROM order_items
            WHERE order_id = NEW.order_id;
            
            UPDATE orders
            SET total_amount = new_total_amount
            WHERE order_id = NEW.order_id;
        END
$$ DELIMITER ;

-- Tạo Trigger kiểm tra số lượng tồn kho trước khi cập nhật số lượng sản phẩm trong order_items. Nếu không đủ, báo lỗi SQLSTATE '45000'.

DELIMITER //
CREATE TRIGGER trg_CheckInventory_Before_Update
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;
    -- Lấy số lượng tồn kho của sản phẩm
    SELECT stock_quantity INTO available_stock
    FROM inventory
    WHERE product_id = NEW.product_id;
    -- Kiểm tra xem số lượng tồn kho có đủ không
    IF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không đủ số lượng sản phẩm trong kho!';
    END IF;
END;
//
DELIMITER ;

-- Tạo Trigger cập nhật lại total_amount trong bảng orders khi số lượng hoặc giá của một sản phẩm trong order_items thay đổi.
DELIMITER //
CREATE TRIGGER trg_UpdateTotalAmount_After_OrderItem_Update
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN
    DECLARE new_total_amount DECIMAL(10, 2);
    -- Tính toán tổng số tiền mới cho đơn hàng
    SELECT SUM(quantity * price) INTO new_total_amount
    FROM order_items
    WHERE order_id = NEW.order_id;
    -- Cập nhật tổng số tiền trong bảng orders
    UPDATE orders
    SET total_amount = new_total_amount
    WHERE order_id = NEW.order_id;
END;
//
DELIMITER ;

-- Tạo Trigger ngăn chặn việc xóa một đơn hàng có trạng thái Completed trong bảng orders. Nếu cố gắng xóa, báo lỗi SQLSTATE '45000'.
DELIMITER //
CREATE TRIGGER trg_Prevent_Delete_Completed_Order
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    -- Kiểm tra trạng thái của đơn hàng
    IF OLD.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể xóa đơn hàng đã hoàn thành!';
    END IF;
END;
//
DELIMITER ;

-- Tạo Trigger hoàn trả số lượng sản phẩm vào kho (inventory) sau khi một sản phẩm trong order_items bị xóa.
DELIMITER //
CREATE TRIGGER trg_ReturnStock_After_OrderItemDelete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    -- Cập nhật số lượng tồn kho trong bảng inventory
    UPDATE inventory
    SET stock_quantity = stock_quantity + OLD.quantity
    WHERE product_id = OLD.product_id;
END;
//
DELIMITER ;

-- Sử dụng lệnh DROP TRIGGER để xóa tất cả các Trigger đã tạo.
DROP TRIGGER IF EXISTS trg_Check_Inventory_Before_Insert;
DROP TRIGGER IF EXISTS trg_Check_orders_After_Insert;
DROP TRIGGER IF EXISTS trg_CheckInventory_Before_Update;
DROP TRIGGER IF EXISTS trg_UpdateTotalAmount_After_OrderItem_Update;
DROP TRIGGER IF EXISTS trg_Prevent_Delete_Completed_Order;
DROP TRIGGER IF EXISTS trg_ReturnStock_After_OrderItemDelete;