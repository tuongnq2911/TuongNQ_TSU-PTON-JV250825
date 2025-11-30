CREATE DATABASE banks;
USE banks;

CREATE TABLE Accounts (
    accountID INT PRIMARY KEY AUTO_INCREMENT,
    accountName VARCHAR(100) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL
);
SELECT * FROM Accounts;

CREATE TABLE Transactions (
    transactionID INT PRIMARY KEY AUTO_INCREMENT,
    fromAccountID INT NOT NULL,
    toAccountID INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (fromAccountID) REFERENCES Accounts(accountID),
    FOREIGN KEY (toAccountID) REFERENCES Accounts(accountID)
);
SELECT * FROM Transactions;

DELIMITER $$
CREATE PROCEDURE TransferFunds(
    IN p_fromAccountID INT,
    IN p_toAccountID INT,
    IN p_amount DECIMAL(10, 2)
)
BEGIN
    DECLARE currentBalance DECIMAL(10, 2);
    -- Kiểm tra số dư tài khoản nguồn
    SELECT balance INTO currentBalance FROM Accounts WHERE accountID = p_fromAccountID;
    IF currentBalance IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tài khoản không tồn tại.';
    ELSEIF currentBalance < p_amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Số dư tài khoản gốc không đủ.';
    ELSE
        -- Bắt đầu giao dịch
        START TRANSACTION;
        -- Cập nhật số dư tài khoản nguồn
        UPDATE Accounts
        SET balance = balance - p_amount
        WHERE accountID = p_fromAccountID;
        -- Cập nhật số dư tài khoản đích
        UPDATE Accounts
        SET balance = balance + p_amount
        WHERE accountID = p_toAccountID;
        -- Ghi lại giao dịch
        INSERT INTO Transactions (fromAccountID, toAccountID, amount)
        VALUES (p_fromAccountID, p_toAccountID, p_amount);
        COMMIT;
    END IF;
END $$
DELIMITER ;
