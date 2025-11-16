CREATE TABLE Students(
StudentID INT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(100),
Age INT,
Major VARCHAR(100)
);

INSERT INTO Students (Name, Age, Major) VALUE 
('Alice', 20, 'Computer Science'),
('Bob', 22, 'Mathematics'),
('Charlie', 21, 'Physics');

SELECT * FROM Students;
-- Cập nhật thông tin tuổi của sinh viện có ID = 2
UPDATE Students
SET Age = 23
WHERE StudentID = 2;

-- Xoá sinh viên với ID = 1 khỏi bảng Students
DELETE FROM Students
WHERE StudentID = 1;