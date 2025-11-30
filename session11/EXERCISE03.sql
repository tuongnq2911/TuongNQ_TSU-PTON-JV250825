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

-- Tạo bảng TransactionsHistory
CREATE TABLE TransactionHistory (
    HistoryID INT PRIMARY KEY AUTO_INCREMENT,
    transactionID INT NOT NULL,
    accountID INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    type VARCHAR(50),
    FOREIGN KEY (accountID) REFERENCES Accounts(accountID),
    FOREIGN KEY (transactionID) REFERENCES Transactions(transactionID)
);
-- Thêm một bản ghi vào bảng TransactionHistory mỗi khi có giao dịch từ hoặc đến một tài khoản.
DELIMITER $$
CREATE PROCEDURE LogTransactionHistory(
    IN p_transactionID INT
)
BEGIN
    DECLARE v_fromAccountID INT;
    DECLARE v_toAccountID INT;
    DECLARE v_amount DECIMAL(10, 2);
    DECLARE v_transactionType VARCHAR(50);
    -- Lấy thông tin giao dịch từ bảng Transactions
    SELECT fromAccountID, toAccountID, amount INTO v_fromAccountID, v_toAccountID, v_amount
    FROM Transactions
    WHERE transactionID = p_transactionID;
    -- Ghi lại giao dịch cho tài khoản nguồn
    IF v_fromAccountID IS NOT NULL THEN
        SET v_transactionType = 'Transfer Out'; 
        INSERT INTO TransactionHistory (transactionID, accountID, amount, transactionDate, type)
        VALUES (p_transactionID, v_fromAccountID, v_amount, CURRENT_TIMESTAMP, v_transactionType);
    END IF;
    -- Ghi lại giao dịch cho tài khoản đích
    IF v_toAccountID IS NOT NULL THEN
        SET v_transactionType = 'Transfer In'; -- Hoặc 'Income' nếu cần
        INSERT INTO TransactionHistory (transactionID, accountID, amount, transactionDate, type)
        VALUES (p_transactionID, v_toAccountID, v_amount, CURRENT_TIMESTAMP, v_transactionType);
    END IF;
END $$
DELIMITER ;

-- Theo dõi tổng số tiền giao dịch trong một khoảng thời gian cụ thể cho mỗi tài khoản.
DELIMITER $$
CREATE PROCEDURE GetTotalTransactions(
    IN p_accountID INT,
    IN p_startDate DATETIME,
    IN p_endDate DATETIME,
    OUT p_totalAmount DECIMAL(10, 2)
)
BEGIN
    SELECT SUM(amount) INTO p_totalAmount
    FROM TransactionHistory
    WHERE accountID = p_accountID
      AND transactionDate BETWEEN p_startDate AND p_endDate;
END $$
DELIMITER ;