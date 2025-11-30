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
    FOREIGN KEY (productID) REFERENCES Products(productID)
);
SELECT * FROM InventoryChanges;

ALTER TABLE Products 
ADD LastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP;
SELECT * FROM Products;

DELIMITER $$

CREATE TRIGGER AfterProductUpdateSetDate
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    -- Cập nhật trường LastUpdated với thời gian hiện tại
    UPDATE Products
    SET OLD.LastUpdated = NOW()
    WHERE productID = NEW.productID;
END $$

DELIMITER ;
DROP TRIGGER AfterProductUpdateSetDate;

