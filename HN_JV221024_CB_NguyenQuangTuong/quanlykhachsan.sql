CREATE DATABASE quanlykhachsan;
USE quanlykhachsan;

CREATE TABLE Customer (
	customer_id VARCHAR(5) PRIMARY KEY,
    customer_full_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL UNIQUE,
    customer_phone VARCHAR(15) NOT NULL,
    customer_address VARCHAR(255) NOT NULL
);

CREATE TABLE Room (
	room_id VARCHAR(5) PRIMARY KEY,
    room_type VARCHAR(50) NOT NULL,
    room_price DECIMAL(10,2),
    room_status VARCHAR(20),
    room_area INT NOT NULL
);

CREATE TABLE Booking(
	booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id VARCHAR(5) NOT NULL,
    room_id VARCHAR(5) NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

CREATE TABLE Payment(
	payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- Chèn dữ liệu
INSERT INTO Customer(customer_id, customer_full_name, customer_email, customer_phone, customer_address) VALUES
('C001', 'Nguyen Anh Tu', 'tu.nguyen@example.com', 0912345678, 'Hanoi, Vietnam'),
('C002', 'Tran Thi Mai', 'mai.tran@example.com', 0923456789, 'Ho Chi Minh, Vietnam'),
('C003','Le Minh Hoang','hoang.le@example.com',0934567890,'Danang, Vietnam'),
('C004','Pham Hoang Nam','nam.pham@example.com',945678901,'Hue, Vietnam'),
('C005','Vu Minh Thu','thu.vu@example.com',0956789012,'Hai Phong, Vietnam');

INSERT INTO Room(room_id, room_type, room_price, room_status, room_area) VALUES
('R001','Single',100.0,'Available',25),
('R002','Double', 150.0, 'Booked',40),
('R003','​Suite', 250.0,'Available',60),
('​R004','Single', 120.0,'Booked',30),
('R005','Double', 160.0,'Available',35);

INSERT INTO Booking(customer_id, room_id, check_in_date, check_out_date, total_amount) VALUES
('C001', 'R001', '2025-03-01', '2025-03-05', 400.0),
('C002', 'R002', '2025-03-02', '2025-03-06', 600.0),
('C001', 'R003', '2025-03-03', '2025-03-07', 1000.0),
('C001', 'R004', '2025-03-04', '2025-03-08', 480.0),
('C001', 'R005', '2025-03-05', '2025-03-09', 800.0);

INSERT INTO Payment(booking_id, payment_method, payment_date, payment_amount) VALUES
(1, 'Cash', '2025-03-05', 400.0),
(2, 'Credit Card', '2025-03-06', 600.0),
(3, 'Bank Transfer', '2025-03-07', 1000.0),
(4, 'Cash', '2025-03-08', 480.0),
(5, 'Credit Card', '2025-03-09', 800.0);

-- 3.Cập nhật dữ liệu
UPDATE Booking b
JOIN room r ON b.room_id = r.room_id
SET b.total_amount = r.room_price * (day(b.check_out_date) - day(b.check_in_date))
WHERE r.room_status = 'Booked' AND b.check_in_date < current_date();

-- 4.Xóa dữ liệu
DELETE FROM Payment
WHERE payment_method = 'Cash' AND payment_amount < 500;

-- PHẦN 2: Truy vấn dữ liệu
-- Lấy thông tin khách hàng gồm mã khách hàng, họ tên, email, số điện thoại và địa chỉ được sắp xếp theo họ tên khách hàng tăng dần.
SELECT * FROM Customer
ORDER BY customer_full_name ASC;

-- Lấy thông tin các phòng khách sạn gồm mã phòng, loại phòng, giá phòng và diện tích phòng, sắp xếp theo giá phòng giảm dần.
SELECT r.room_id, r.room_type,r.room_price,r.room_area
FROM Room r
JOIN Booking b ON b.room_id = r.room_id 
ORDER BY b.total_amount DESC;

--  Lấy thông tin khách hàng và phòng khách sạn đã đặt, gồm mã khách hàng, họ tên khách hàng, mã phòng, ngày nhận phòng và ngày trả phòng.
SELECT 
	c.customer_id, 
    c.customer_full_name, 
    b.room_id, 
    b.check_in_date, 
    b.check_out_date
FROM Customer c
JOIN Booking b ON b.customer_id = c.customer_id;

-- Lấy danh sách khách hàng và tổng tiền đã thanh toán khi đặt phòng, gồm mã khách hàng, họ tên khách hàng, 
-- phương thức thanh toán và số tiền thanh toán, sắp xếp theo số tiền thanh toán giảm dần.
SELECT 
	c.customer_id, 
    c.customer_full_name, 
    p.payment_method, 
    SUM(p.payment_amount) AS total_payment
FROM Customer c
JOIN Booking b ON b.customer_id = c.customer_id
JOIN Payment p ON p.booking_id = b.booking_id
GROUP BY  c.customer_id, c.customer_full_name, p.payment_method
ORDER BY total_payment DESC; -- Sắp xếp theo số tiền thanh toán giảm dần

-- Lấy thông tin khách hàng từ vị trí thứ 2 đến thứ 4 trong bảng Customer được sắp xếp theo tên khách hàng.
SELECT * FROM Customer
ORDER BY customer_full_name LIMIT 3 OFFSET 1; -- OFFSET 1: Bỏ khách ở vị trí số 1 và LIMIT 3 là lấy 3 bản ghi tiếp theo

--  Lấy danh sách khách hàng đã đặt ít nhất 2 phòng và có tổng số tiền thanh toán trên 1000, 
-- gồm mã khách hàng, họ tên khách hàng và số lượng phòng đã đặt.
SELECT 
	c.customer_id, 
    c.customer_full_name, 
    COUNT(DISTINCT r.room_id) AS so_phong_dat, 
    SUM(p.payment_amount) AS total_money
FROM Customer c
JOIN Booking b ON b.customer_id = c.customer_id
JOIN Room r ON  b.room_id = r.room_id 
JOIN Payment p ON p.booking_id = b.booking_id
GROUP BY c.customer_id, c.customer_full_name
HAVING so_phong_dat >= 2 AND total_money > 1000;

-- Lấy danh sách các phòng có tổng số tiền thanh toán dưới 1000 và có ít nhất 3 khách hàng đặt, 
-- gồm mã phòng, loại phòng, giá phòng và tổng số tiền thanh toán.
SELECT 
	r.room_id, 
    r.room_type, 
    r.room_price, 
    SUM(p.payment_amount) AS total_payment, 
    COUNT(DISTINCT b.customer_id) AS so_khac_dat
FROM Booking b
JOIN Customer c ON c.customer_id = b.customer_id
JOIN Room r ON r.room_id = b.room_id
JOIN Payment p ON p.booking_id = b.booking_id
GROUP BY 
	r.room_id, 
    r.room_type, 
    r.room_price
HAVING 
	total_payment < 1000 AND so_khac_dat >= 3;
    
-- Lấy danh sách các khách hàng có tổng số tiền thanh toán lớn hơn 1000, gồm mã khách hàng, họ tên khách hàng, mã phòng, tổng số tiền thanh toán.
SELECT 
	c.customer_id, 
    c.customer_full_name, 
    r.room_id, 
    SUM(p.payment_amount) AS total_money
FROM Customer c
JOIN Booking b ON b.customer_id = c.customer_id
JOIN Room r ON  b.room_id = r.room_id 
JOIN Payment p ON p.booking_id = b.booking_id
GROUP BY c.customer_id, c.customer_full_name,r.room_id
HAVING total_money > 1000;

--  Lấy danh sách các khách hàng Mmã KH, Họ tên, Email, SĐT) có họ tên chứa chữ "Minh" 
-- hoặc địa chỉ (address) ở "Hanoi". Sắp xếp kết quả theo họ tên tăng dần.
SELECT 
	customer_id, 
    customer_full_name, 
    customer_email, 
    customer_phone
FROM customer
WHERE customer_full_name LIKE '%Minh%' OR customer_address LIKE '%Ha Noi%'
ORDER BY customer_full_name ASC;

-- Lấy danh sách tất cả các phòng (Mã phòng, Loại phòng, Giá), sắp xếp theo giá phòng giảm dần. 
-- Hiển thị 5 phòng tiếp theo sau 5 phòng đầu tiên (tức là lấy kết quả của trang thứ 2, biết mỗi trang có 5 phòng).
SELECT room_id, room_type, room_price
FROM room
ORDER BY room_price DESC LIMIT 5 OFFSET 5; -- Tương tự như trên thì OFFSET 5 là bỏ đi 5 bản ghi đầu(trang đầu tiên) và lấy 5 bản ghi tiếp theo tức là trang thứ 2

-- PHẦN 3: Tạo View
-- Hãy tạo một view để lấy thông tin các phòng và khách hàng đã đặt, với điều kiện ngày nhận phòng nhỏ hơn ngày 2025-03-10. 
-- Cần hiển thị các thông tin sau: Mã phòng, Loại phòng, Mã khách hàng, họ tên khách hàng
CREATE VIEW v_room_customer_booking AS
SELECT 
	r.room_id,
    r.room_type,
    c.customer_id,
    c.customer_full_name
FROM Room r
JOIN booking b ON b.room_id = r.room_id
JOIN customer c ON c.customer_id = b.customer_id
WHERE b.check_in_date < '2025-03-10';

SELECT * FROM v_room_customer_booking;

-- Hãy tạo một view để lấy thông tin khách hàng và phòng đã đặt, với điều kiện diện tích phòng lớn hơn 30 m². 
-- Cần hiển thị các thông tin sau: Mã khách hàng, Họ tên khách hàng, Mã phòng, Diện tích phòng
CREATE VIEW v_customer_room AS
SELECT 
	c.customer_id,
    c.customer_full_name,
    r.room_id,
    r.room_area
FROM customer c
JOIN booking b ON b.customer_id = c.customer_id
JOIN room r ON r.room_id = b.room_id
WHERE r.room_area > 30;

SELECT * FROM v_customer_room;

-- PHẦN 4: Tạo Trigger
-- Hãy tạo một trigger check_insert_booking để kiểm tra dữ liệu mối khi chèn vào bảng Booking. 
-- Kiểm tra nếu ngày đặt phòng mà sau ngày trả phòng thì thông báo lỗi với nội dung “Ngày đặt phòng không thể sau ngày trả phòng được !” và hủy thao tác chèn dữ liệu vào bảng.
DELIMITER $$
CREATE TRIGGER trg_check_insert_booking 
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
	IF NEW.check_in_date > NEW.check_out_date THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Ngày đặt phòng không thể sau ngày trả phòng được !';
	END IF;
END $$
DELIMITER ;

-- TEST
INSERT INTO Booking(customer_id, room_id, check_in_date, check_out_date, total_amount) VALUES
('C001', 'R001', '2025-03-06', '2025-03-05', 400.0);
-- Thanh cong

-- Hãy tạo một trigger có tên là update_room_status_on_booking để tự động cập nhật trạng thái phòng thành "Booked" 
-- khi một phòng được đặt (khi có bản ghi được INSERT vào bảng Booking).
DELIMITER $$
CREATE TRIGGER trg_update_room_status_on_booking 
AFTER INSERT ON Booking
FOR EACH ROW
BEGIN
	UPDATE Room
    SET room_status = 'Booked'
    WHERE room_id = NEW.room_id;
END $$
DELIMITER ;

-- TEST
SELECT * FROM Room;

INSERT INTO Booking(customer_id, room_id, check_in_date, check_out_date, total_amount) VALUES
('C002', 'R001', '2025-03-01', '2025-03-05', 400.0);
-- Thanh Cong

-- PHẦN 5: Tạo Store Procedure
-- Viết store procedure có tên add_customer để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.
DELIMITER $$
CREATE PROCEDURE pro_add_customer(
	IN p_customer_id VARCHAR(5),
    IN p_customer_full_name VARCHAR(100),
    IN p_customer_email VARCHAR(100),
    IN p_customer_phone VARCHAR(15),
    IN p_customer_address VARCHAR(255)
	)
BEGIN
	INSERT INTO customer(customer_id, customer_full_name, customer_email, customer_phone, customer_address)
    VALUES(p_customer_id, p_customer_full_name, p_customer_email, p_customer_phone, p_customer_address);
END $$
DELIMITER ;

-- TEST
SELECT * FROM Customer;
CALL pro_add_customer('C006','Nguyen Nhu Vu', 'nguyenvu@gmail.com', 0901234567, 'Bac Ninh, VietNam');
-- Thanh Cong

-- Hãy tạo một Stored Procedure  có tên là add_payment để thực hiện việc thêm một thanh toán mới cho một lần đặt phòng.
DELIMITER $$
CREATE PROCEDURE pro_add_payment(
	IN p_booking_id INT,
	IN p_payment_method VARCHAR(50),
	IN p_payment_date DATE,
    IN p_payment_amount DECIMAL(10,2)
	)
BEGIN
	INSERT INTO payment(booking_id, payment_method, payment_date, payment_amount)
    VALUES(p_booking_id, p_payment_method, p_payment_date, p_payment_amount);
END $$
DELIMITER ;

-- TEST
SELECT * FROM payment;
CALL pro_add_payment(2, 'Cash', '2025-03-05', 400.0);
-- Thanh Cong