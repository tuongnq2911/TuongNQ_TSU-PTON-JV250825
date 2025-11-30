CREATE DATABASE InventoryManagement;
USE	 InventoryManagement;

CREATE TABLE Products(
	productID INT PRIMARY KEY AUTO_INCREMENT,
    productName VARCHAR(100) NOT NULL,
    quantity INT
);

CREATE TABLE InventoryChanges (
	changeID INT PRIMARY KEY AUTO_INCREMENT,
    productID INT NOT NULL,
    oldQuantity INT,
    newQuantity INT,
    changeDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (changeID) REFERENCES Products(productID)
);

DELIMITER $$
CREATE TRIGGER BeforeProductDelete 
BEFORE DELETE ON Products
FOR EACH ROW
	BEGIN
		IF OLD.quantity > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể xoá sản phẩm có số lượng lớn hơn 10';
        END IF;
    END $$ 
DELIMITER ;
-- Ví dụ xoá sản phẩm có số lượng lớn hơn 10
DELETE FROM Products WHERE productID = 1;