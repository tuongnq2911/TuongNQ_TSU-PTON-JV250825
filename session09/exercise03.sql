DROP DATABASE IF EXISTS session_09;
CREATE DATABASE session_09;
USE session_09;
-- Bảng Branch (Chi nhánh)
CREATE TABLE Branch (
    BranchID INT PRIMARY KEY AUTO_INCREMENT,
    BranchName VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL
);
-- Bảng Employees (Nhân viên)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL,
    BranchID INT NOT NULL,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
-- Bảng Customers (Khách hàng)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Address VARCHAR(255),
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
-- Bảng Accounts (Tài khoản)
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    AccountType ENUM('Saving', 'Current', 'Fixed Deposit') NOT NULL,
    Balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    OpenDate DATE NOT NULL,
    BranchID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
-- Bảng Transactions (Giao dịch khách hàng)
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT NOT NULL,
    TransactionType ENUM('Deposit', 'Withdrawal', 'Transfer') NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
-- Bảng Loans (Khoản vay ngân hàng)
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    LoanType ENUM('Home Loan', 'Car Loan', 'Personal Loan', 'Business Loan') NOT NULL,
    LoanAmount DECIMAL(15,2) NOT NULL,
    InterestRate DECIMAL(5,2) NOT NULL,
    LoanTerm INT NOT NULL, 
    StartDate DATE NOT NULL,
    Status ENUM('Active', 'Closed') DEFAULT 'Active',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
-- Thêm mới chi nhánh
INSERT INTO Branch (BranchName, Location, PhoneNumber) VALUES
('Chi nhánh Hà Nội', '123 Trần Hưng Đạo, Hà Nội', '024-12345678'),
('Chi nhánh TP.HCM', '456 Lê Lợi, TP.HCM', '028-87654321'),
('Chi nhánh Đà Nẵng', '789 Nguyễn Văn Linh, Đà Nẵng', '026-576646598');
-- Thêm mới nhân viên
INSERT INTO Employees (EmployeeID, FullName, Position, Salary, HireDate, BranchID) VALUES
(1, 'Nguyễn Văn An', 'Giám đốc', 45000000, '2018-03-10', 1),
(2, 'Trần Thị Hạnh', 'Giao dịch viên', 15000000, '2021-06-20', 2),
(3, 'Lê Minh Tuấn', 'Kế toán', '10000000', '2022-01-05', 3),
(4, 'Phạm Hoàng Kiên', 'Sale', 18000000, '2023-05-12', 1),
(5, 'Đặng Hữu Bình', 'Quản lý', 32000000, '2023-06-12', 2);
-- Thêm mới khách hàng
INSERT INTO Customers (CustomerID, FullName, DateOfBirth, Address, PhoneNumber, Email, BranchID) VALUES
(1, 'Nguyễn Văn Hùng', '1990-07-15', 'Hà Nội', '0901234567', 'hung.nguyen@gmail.com', 1),
(2, 'Phạm Văn Dũng', '1985-09-25', NULL, '0912345678', 'dung.pham@gmail.com', 2),
(3, 'Hoàng Thanh Tùng', '1993-11-30', 'Đà Nẵng', '0922334455', 'tung@gmail.com', 3),
(4, 'Lê Minh Khoa', '1988-04-12', 'Huế', '0945124578', 'khoa.le@gmail.com', 2),
(5, 'Đỗ Hoàng Anh', '1995-07-19', 'Cần Thơ', '0978123456', 'hoanganh.do@gmail.com', 1);
-- Thêm mới tài khoản
INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, OpenDate, BranchID) VALUES
(1, 1, 'Saving', 5000000, '2023-01-01', 1),
(2, 1, 'Current', 15000000, '2023-10-12', 1), 
(3, 2, 'Current', 12000000, '2023-02-15', 2),
(4, 3, 'Saving', 7000000, '2023-05-10', 1),
(5, 4, 'Fixed Deposit', 50000000, '2023-06-20', 2),
(6, 1, 'Fixed Deposit', 80000000, '2023-11-05', 2),
(7, 3, 'Saving', 3000000, '2023-08-14', 3),
(8, 5, 'Current', 1200000, '2024-01-10', 2),
(9, 5, 'Saving', 2000000, '2024-05-20', 1);
-- Thêm mới giao dịch
INSERT INTO Transactions (TransactionID, AccountID, TransactionType, Amount, TransactionDate) VALUES
(1, 1, 'Deposit', 2000000, '2024-02-01 10:15:00'),
(2, 1, 'Withdrawal', 1000000, NULL),
(3, 2, 'Deposit', 5000000, '2024-02-03 09:00:00'),
(4, 3, 'Withdrawal', 3000000, '2024-02-04 14:30:00'),
(5, 4, 'Transfer', 2500000, '2024-02-05 09:45:00'),
(6, 5, 'Deposit', 1000000, '2024-02-06 16:20:00'),
(7, 3, 'Transfer', 2000000, NULL),
(8, 2, 'Withdrawal', 500000, '2024-02-08 11:55:00');
-- Thêm mới khoản vay
INSERT INTO Loans (CustomerID, LoanType, LoanAmount, InterestRate, LoanTerm, StartDate, Status) VALUES
(1, 'Home Loan', 500000000.00, 6.5, 240, '2023-03-01', 'Active'),
(1, 'Car Loan', 300000000.00, 7.0, 120, '2023-04-15', 'Active'),
(2, 'Personal Loan', 150000000.00, 10.0, 36, '2023-07-10', 'Active'),
(3, 'Home Loan', 600000000.00, 5.8, 180, '2023-09-05', 'Active'),
(3, 'Car Loan', 250000000.00, 3.7, 60, '2023-10-10', 'Active'),
(4, 'Personal Loan', 150000000.00, 9.5, 48, '2023-11-20', 'Active'),
(5, 'Home Loan', 700000000.00, 5.9, 42, '2023-12-01', 'Active'),
(1, 'Business Loan', 900000000.00, 8.0, 120, '2024-01-05', 'Active'),
(5, 'Car Loan', 300000000.00, 7.2, 72, '2024-07-25', 'Active');

-- Viết Stored Procedure
	-- GetCustomerByPhone: Tạo một thủ tục nhận tham số IN là số điện thoại để tìm kiếm và trả về thông tin chi tiết của khách hàng.
DELIMITER $$
	CREATE PROCEDURE GetCustomerByPhone (IN _PhoneNumber VARCHAR(15))
	BEGIN
		SELECT * 
        FROM customers
        WHERE PhoneNumber = _PhoneNumber;
    END
$$ DELIMITER ;

	-- GetTotalBalance: Tạo một thủ tục nhận tham số IN là CustomerID và sử dụng tham số OUT để trả về tổng số dư của tất cả tài khoản của khách hàng đó.
DELIMITER $$
	CREATE PROCEDURE GetTotalBalance (IN _CustomerID INT, OUT _totalBalance DECIMAL(50,2))
	BEGIN
		SELECT SUM(Balance) INTO _totalBalance
        FROM accounts
        WHERE CustomerID = _CustomerID;
    END
$$ DELIMITER ;

	-- IncreaseEmployeeSalary: Tạo một thủ tục sử dụng tham số INOUT để nhập mức lương hiện tại và trả về mức lương đã được tăng 10%. 
    -- và Thủ tục cũng nhận tham số IN là EmployeeID để cập nhật mức lương mới vào bảng Employees.

DELIMITER $$
	CREATE PROCEDURE IncreaseEmployeeSalary (INOUT _currentSalary  DECIMAL(10,2), IN _EmployeeID INT)
	BEGIN
		-- Công thức tính mức lương mới
		SET _currentSalary = _currentSalary* 1.1;
		-- Cập nhật mức lương mới vào bảng employees
        UPDATE employees
        SET Salary = _currentSalary
        WHERE EmployeeID = _EmployeeID;
    END
$$ DELIMITER ;

-- Thực thi các Stored Procedure
	-- Gọi GetCustomerByPhone: Sử dụng CALL với số điện thoại '0901234567' để xem thông tin khách hàng.
CALL GetCustomerByPhone('0901234567');
	-- Gọi GetTotalBalance: Dùng CALL với CustomerID = 1 và một biến session (@total_balance) để nhận giá trị trả về. Sau đó, sử dụng SELECT @total_balance; để hiển thị kết quả.
SET @customerID = 1; -- Thay đổi giá trị CustomerID theo nhu cầu
SET @totalBalance = 0;

CALL GetTotalBalance(@customerID, @totalBalance);

SELECT @totalBalance AS TotalBalance;

	-- Gọi IncreaseEmployeeSalary: Truy vấn mức lương hiện tại của nhân viên có EmployeeID = 4 và gán vào một biến session. 
    -- Sau đó, dùng CALL để thực thi thủ tục với biến đó và hiển thị mức lương mới.
SET @employeeID = 4;
SET @currentSalary = (SELECT Salary FROM employees WHERE EmployeeID = @employeeID);

CALL IncreaseEmployeeSalary(@currentSalary,@employeeID);

SELECT @currentSalary AS NewSalary;

-- Xóa Stored Procedure
	-- Sử dụng DROP PROCEDURE IF EXISTS để xóa tất cả các thủ tục đã tạo, đảm bảo rằng mã nguồn có thể chạy lại mà không gặp lỗi.
DROP PROCEDURE IF EXISTS GetCustomerByPhone;

DROP PROCEDURE IF EXISTS GetTotalBalance;

DROP PROCEDURE IF EXISTS IncreaseEmployeeSalary;