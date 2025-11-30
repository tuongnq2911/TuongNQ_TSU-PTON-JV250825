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

-- Thêm bảng Budgets và Expenses vào cơ sở dữ liệu đã có:
CREATE TABLE Budgets (
    budgetID INT PRIMARY KEY AUTO_INCREMENT,
    accountID INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    month VARCHAR(20),
    FOREIGN KEY (accountID) REFERENCES Accounts(accountID)
);
CREATE TABLE Expenses (
    expenseID INT PRIMARY KEY AUTO_INCREMENT,
    accountID INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    expenseDate DATE NOT NULL,
    description VARCHAR(255),
    FOREIGN KEY (accountID) REFERENCES Budgets(accountID)
);

DELIMITER $$

CREATE PROCEDURE SpendFunds(
    IN p_accountID INT,
    IN p_budgetID INT,
    IN p_amount DECIMAL(10, 2),
    IN p_description VARCHAR(255)
)
BEGIN
    DECLARE currentBalance DECIMAL(10, 2);
    DECLARE currentBudget DECIMAL(10, 2);

    -- Bắt đầu giao dịch
    START TRANSACTION;

    -- Kiểm tra số dư tài khoản
    SELECT balance INTO currentBalance FROM Accounts WHERE accountID = p_accountID FOR UPDATE;

    IF currentBalance IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tài khoản không tồn tại.';
    ELSEIF currentBalance < p_amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Số dư tài khoản không đủ để thực hiện chi tiêu.';
    ELSE
        -- Cập nhật số dư tài khoản
        UPDATE Accounts
        SET balance = balance - p_amount
        WHERE accountID = p_accountID;

        -- Thêm bản ghi chi tiêu vào bảng Expenses
        INSERT INTO Expenses (budgetID, amount, expenseDate, description)
        VALUES (p_budgetID, p_amount, CURRENT_DATE, p_description);

        -- Cập nhật ngân sách nếu cần
        SELECT amount INTO currentBudget FROM Budgets WHERE budgetID = p_budgetID FOR UPDATE;

        IF currentBudget IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ngân sách không tồn tại.';
        ELSE
            UPDATE Budgets
            SET amount = amount - p_amount
            WHERE budgetID = p_budgetID;
        END IF;
        -- Không có gì thay đổi nếu có lỗi.
		ROLLBACK;
       
    END IF;
END $$

DELIMITER ;
