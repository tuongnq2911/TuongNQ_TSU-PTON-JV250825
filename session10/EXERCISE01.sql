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
CREATE TRIGGER AfterProductUpdate
AFTER UPDATE ON Products
FOR EACH ROW
	BEGIN
		INSERT INTO InventoryChanges (productID, oldQuantity, newQuantity)
        VALUES(old.productID, old.quantity, NEW.quantity);
    END $$ 
DELIMITER ;
-- Ví dụ cập nhật
INSERT INTO Products (productName, quantity) VALUES ('Sản phẩm A', 100);

UPDATE Products SET quantity = 150 WHERE productID = 1;

SELECT * FROM InventoryChanges;