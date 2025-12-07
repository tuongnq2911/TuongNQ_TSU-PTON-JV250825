USE	banks;

-- 1) Bảng Accounts
CREATE TABLE accounts (
  accountID INTEGER PRIMARY KEY,
  balance DECIMAL(10,2),
  transactionDate DATETIME
);

-- 2) Bảng Recurring Transactions
CREATE TABLE recurringTransactions (
  recurringID INTEGER PRIMARY KEY,
  fromAccountID INTEGER NOT NULL,
  toAccountID INTEGER NOT NULL,
  amount DECIMAL(10,2),
  startDate DATETIME,
  frequency VARCHAR(50),
  nextTransactionDate DATETIME,
  FOREIGN KEY (fromAccountID) REFERENCES accounts(accountID),
  FOREIGN KEY (toAccountID) REFERENCES accounts(accountID)
);

-- 3) Bảng Transactions
CREATE TABLE transactions (
  transactionID INTEGER PRIMARY KEY,
  fromAccountID INTEGER NOT NULL,
  toAccountID INTEGER NOT NULL,
  amount DECIMAL(10,2),
  transactionDate DATETIME,
  FOREIGN KEY (fromAccountID) REFERENCES accounts(accountID),
  FOREIGN KEY (toAccountID) REFERENCES accounts(accountID)
);

-- 4) Transaction History
CREATE TABLE transactionHistory (
  historyID INTEGER PRIMARY KEY,
  transactionID INTEGER NOT NULL,
  accountID INTEGER NOT NULL,
  amount DECIMAL(10,2),
  transactionDate DATETIME,
  type VARCHAR(50),
  FOREIGN KEY (transactionID) REFERENCES transactions(transactionID),
  FOREIGN KEY (accountID) REFERENCES accounts(accountID)
);

-- 5) Budgets
CREATE TABLE budgets (
  budgetID INTEGER PRIMARY KEY,
  accountID INTEGER NOT NULL,
  amount DECIMAL(10,2),
  month VARCHAR(20),
  FOREIGN KEY (accountID) REFERENCES accounts(accountID)
);

-- 6) Expenses
CREATE TABLE expenses (
  expenseID INTEGER PRIMARY KEY,
  accountID INTEGER NOT NULL,
  amount DECIMAL(10,2),
  expenseDate DATETIME,
  description VARCHAR(255),
  FOREIGN KEY (accountID) REFERENCES accounts(accountID)
);

-- Tự động chuyển tiền từ tài khoản nguồn đến tài khoản đích theo tần suất đã định.
-- Cập nhật trường NextTransactionDate trong bảng RecurringTransactions sau mỗi lần giao dịch.

DELIMITER $$
CREATE PROCEDURE sp_ProcessRecurringTransactions()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_recurringID INT;
    DECLARE v_fromAccount INT;
    DECLARE v_toAccount INT;
    DECLARE v_amount DECIMAL(10,2);
    DECLARE v_frequency VARCHAR(50);
    
    -- Cursor để duyệt các giao dịch cần thực hiện
    DECLARE cur CURSOR FOR
        SELECT recurringID, fromAccountID, toAccountID, amount, frequency
        FROM recurringTransactions
        WHERE nextTransactionDate <= NOW();

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    recurring_loop: LOOP
        FETCH cur INTO v_recurringID, v_fromAccount, v_toAccount, v_amount, v_frequency;

        IF done = 1 THEN
            LEAVE recurring_loop;
        END IF;
        
        -- Bắt đầu giao dịch
        START TRANSACTION;
        
        -- 1) Trừ tiền từ tài khoản nguồn
        UPDATE accounts
        SET balance = balance - v_amount
        WHERE accountID = v_fromAccount;
        
        -- 2) Cộng tiền vào tài khoản đích
        UPDATE accounts
        SET balance = balance + v_amount
        WHERE accountID = v_toAccount;
        
        -- 3) Ghi vào bảng Transactions
        INSERT INTO transactions (transactionID, fromAccountID, toAccountID, amount, transactionDate)
        VALUES (NULL, v_fromAccount, v_toAccount, v_amount, NOW());
        
        -- 4) Cập nhật ngày giao dịch tiếp theo
        UPDATE recurringTransactions
        SET nextTransactionDate =
            CASE 
                WHEN v_frequency = 'DAILY' THEN DATE_ADD(nextTransactionDate, INTERVAL 1 DAY)
                WHEN v_frequency = 'WEEKLY' THEN DATE_ADD(nextTransactionDate, INTERVAL 1 WEEK)
                WHEN v_frequency = 'MONTHLY' THEN DATE_ADD(nextTransactionDate, INTERVAL 1 MONTH)
                ELSE DATE_ADD(nextTransactionDate, INTERVAL 1 DAY) -- fallback
            END
        WHERE recurringID = v_recurringID;

        -- Kết thúc giao dịch
        COMMIT;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;
