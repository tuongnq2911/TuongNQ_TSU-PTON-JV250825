CREATE DATABASE InventoryManagement;
USE	 InventoryManagement;

CREATE TABLE Products(
	productID INT PRIMARY KEY AUTO_INCREMENT,
    productName VARCHAR(100) NOT NULL,
    quantity INT,
    LastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
SELECT * FROM Products;

CREATE TABLE InventoryChanges (
	changeID INT PRIMARY KEY AUTO_INCREMENT,
    productID INT NOT NULL,
    oldQuantity INT,
    newQuantity INT,
    changeDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (productID) REFERENCES Products(productID)
);
SELECT * FROM InventoryChanges;

CREATE TABLE ProductSummary (
    SummaryID INT PRIMARY KEY AUTO_INCREMENT,
    TotalQuantity INT NOT NULL
);
SELECT * FROM ProductSummary;
-- Thêm bản ghi
INSERT INTO ProductSummary(TotalQuantity) VALUES (0);

-- Tạo Trigger AfterProductUpdateSummary để cập nhật tổng số lượng hàng trong ProductSummary mỗi khi có thay đổi số lượng hàng trong Products

DELIMITER $$
CREATE TRIGGER AfterProductUpdateSummary
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    DECLARE currentTotal INT;

    -- Lấy tổng số lượng hàng hiện tại
    SELECT TotalQuantity INTO currentTotal FROM ProductSummary WHERE SummaryID = 1;

    -- Cập nhật tổng số lượng hàng
    SET currentTotal = currentTotal - OLD.quantity + NEW.quantity;

    UPDATE ProductSummary
    SET TotalQuantity = currentTotal
    WHERE SummaryID = 1;
END $$
DELIMITER ;


