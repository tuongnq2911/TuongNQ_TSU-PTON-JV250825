-- Tạo CSDL
CREATE DATABASE QUANLYDIEMTHI;
USE QUANLYDIEMTHI;

-- Tạo bảng STUDENT 
CREATE TABLE Student (
	studentID VARCHAR(4) PRIMARY KEY,
    studentName VARCHAR(100) NOT NULL,
    brithday DATE NOT NULL,
    gender BIT(1) NOT NULL,
    address TEXT NOT NULL,
    phoneNumber VARCHAR(45) UNIQUE
);

-- Tạo bảng SUBJECT
CREATE TABLE Subject (
	subjectID VARCHAR(4) PRIMARY KEY,
    subjectName VARCHAR(45) NOT NULL,
    priority INT NOT NULL
);

-- Tạo bảng MARK
CREATE TABLE mark (
	subjectID VARCHAR(4) NOT NULL,
    studentID VARCHAR(4) NOT NULL,
    point DOUBLE NOT NULL,
    FOREIGN KEY (subjectID) REFERENCES Subject(subjectID),
	FOREIGN KEY (studentID) REFERENCES Student(studentID)
);
-- Thêm dữ liệu vào bảng Student
INSERT INTO Student(studentID, studentName, brithday, gender, address, phoneNumber) VALUES
('S001', 'Nguyễn Thế Anh', '1999-01-11', 1, 'Hà Nội', 0984678082),
('S002', 'Đặng Bảo Trâm', '1998-12-22', 0, 'Lào Cai', 0904982654),
('S003', 'Trần Hà Phương', '200-05-05', 0, 'Nghệ An', 0947645363),
('S004', 'Đỗ Tiến Mạnh', '1999-03-26', 1, 'Hà Nội', 0983665353),
('S005', 'Phạm Duy Nhất', '1998-10-04', 1, 'Tuyên Quang', 0987242678),
('S006', 'Mai Văn Thái', '2002-06-22', 1, 'Nam Định', 0982654268),
('S007', 'Giang Gia Hân', '1996-11-10', 0, 'Phú Thọ', 0982364753),
('S008', 'Nguyễn Ngọc Bảo My', '1999-01-22', 0, 'Hà Nam', 0927867453),
('S009', 'Nguyễn Tiến Đạt', '1998-08-07', 1, 'Tuyên Quang', 0989274673),
('S010', 'Nguyễn Thiều Quang', '2000-09-18', 1, 'Hà Nội', 0984378291);

-- Thêm dữ liệu vào bảng Subject
INSERT INTO Subject(subjectID, subjectName, priority) VALUES 
('MH01', 'Toán', 2),
('MH02', 'Vật Lý', 2),
('MH03', 'Hoá Học', 1),
('MH04', 'Ngữ Văn', 1),
('MH05', 'Tiếng Anh', 2);


-- Thêm dữ liệu vào bảng MARK
INSERT INTO mark(subjectID, studentID, point) VALUES
('MH01', 'S001', 8.5),
('MH02', 'S001', 7),
('MH03', 'S001', 9),
('MH04', 'S001', 9),
('MH05', 'S001', 5),

('MH01', 'S002', 9),
('MH02', 'S002', 8),
('MH03', 'S002', 6.5),
('MH04', 'S002', 8),
('MH05', 'S002', 6),

('MH01', 'S003', 7.5),
('MH02', 'S003', 6.5),
('MH03', 'S003', 8),
('MH04', 'S003', 7),
('MH05', 'S003', 7),

('MH01', 'S004', 6),
('MH02', 'S004', 7),
('MH03', 'S004', 5),
('MH04', 'S004', 6.5),
('MH05', 'S004', 8),

('MH01', 'S005', 5.5),
('MH02', 'S005', 8),
('MH03', 'S005', 7.5),
('MH04', 'S005', 8.5),
('MH05', 'S005', 9),

('MH01', 'S006', 8),
('MH02', 'S006', 10),
('MH03', 'S006', 9),
('MH04', 'S006', 7.5),
('MH05', 'S006', 6.5),

('MH01', 'S007', 9.5),
('MH02', 'S007', 9),
('MH03', 'S007', 6),
('MH04', 'S007', 9),
('MH05', 'S007', 4),

('MH01', 'S008', 10),
('MH02', 'S008', 8.5),
('MH03', 'S008', 8.5),
('MH04', 'S008', 6),
('MH05', 'S008', 9.5),

('MH01', 'S009', 7.5),
('MH02', 'S009', 7),
('MH03', 'S009', 9),
('MH04', 'S009', 5),
('MH05', 'S009', 10),

('MH01', 'S010', 6.5),
('MH02', 'S010', 8),
('MH03', 'S010', 5.5),
('MH04', 'S010', 4),
('MH05', 'S010', 7);

-- 2 Cập nhật dữ liệu
	--  Sửa tên sinh viên có mã `S004` thành “Đỗ Đức Mạnh”.  
UPDATE student SET studentName = 'Đỗ Đức Mạnh'
WHERE studentID = 'S004';
	-- Sửa tên và hệ số môn học có mã `MH05` thành “Ngoại Ngữ” và hệ số là 1.  
UPDATE subject SET subjectName = 'Ngoại Ngữ', priority = 1
WHERE subjectID = 'MH05';
	-- Cập nhật lại điểm của học sinh có mã `S009`  thành (MH01 : 8.5, MH02 : 7,MH03 : 5.5, MH04 : 6, MH05 : 9).  
UPDATE mark
SET point = 8.5
WHERE studentID = 'S009' AND subjectID = 'MH01';

UPDATE mark
SET point = 7.0
WHERE studentID = 'S009' AND subjectID = 'MH02';

UPDATE mark
SET point = 5.5
WHERE studentID = 'S009' AND subjectID = 'MH03';

UPDATE mark
SET point = 6.0
WHERE studentID = 'S009' AND subjectID = 'MH04';

UPDATE mark
SET point = 9.0
WHERE studentID = 'S009' AND subjectID = 'MH05';

-- 3. Xoá dữ liệu
	-- Xoá toàn bộ thông tin của học sinh có mã `S010` bao gồm điểm thi ở bảng MARK và thông tin học sinh này ở bảng STUDENT. 
DELETE FROM mark
WHERE studentID = 'S010';

DELETE	FROM student
WHERE studentID = 'S010';

-- Bài 3: Truy vấn dữ liệu [25 điểm]: 
	-- 1. Lấy ra tất cả thông tin của sinh viên trong bảng Student . [4 điểm]  
SELECT * FROM student;
	-- 2. Hiển thị tên và mã môn học của những môn có hệ số bằng 1. [4 điểm]  
SELECT subjectName, subjectID FROM subject
WHERE priority = 1;
	-- 3. Hiển thị thông tin học sinh bào gồm: mã học sinh, tên học sinh, tuổi (bằng năm hiện tại trừ 
		-- năm sinh) , giới tính (hiển thị nam hoặc nữ) và quê quán của tất cả học sinh. [4 điểm]  
SELECT 
    studentID AS 'Mã Học Sinh',
    studentName AS 'Tên Học Sinh',
    YEAR(CURDATE()) - YEAR(brithday) AS 'Tuổi',
    CASE 
        WHEN gender = 1 THEN 'Nam'
        ELSE 'Nữ'
    END AS 'Giới Tính',
    address AS 'Quê Quán'
FROM 
    Student;
    -- Hiển thị thông tin bao gồm: tên học sinh, tên môn học , điểm thi của tất cả học sinh của môn 
		-- Toán và sắp xếp theo điểm giảm dần. [4 điểm]  
SELECT 
	st.studentName AS 'Tên Học Sinh', sb.subjectName AS 'Tên môn học', m.point AS 'Điểm Thi'
    FROM mark m
    JOIN student st ON st.studentID = m.studentID
    JOIN subject sb ON sb.subjectID = m.subjectID
    WHERE sb.subjectName = 'Toán' -- WHERE sb.subjectID = 'MH01'
    ORDER BY 
    m.point DESC;
	-- 5. Thống kê số lượng học sinh theo giới tính ở trong bảng (Gồm 2 cột: giới tính và số lượng).  [4 điểm] 
SELECT 
    CASE 
        WHEN gender = 1 THEN 'Nam'
        ELSE 'Nữ'
    END AS 'Giới Tính',
    COUNT(*) AS 'Số Lượng'
FROM 
    Student
GROUP BY 
    gender;
    
	-- Tính tổng điểm và điểm trung bình của các môn học theo từng học sinh (yêu cầu sử dụng hàm 
	-- để tính toán) , bảng gồm mã học sinh, tên hoc sinh, tổng điểm và điểm trung bình. [5 điểm] 
SELECT 
    s.studentID AS 'Mã Học Sinh',
    s.studentName AS 'Tên Học Sinh',
    SUM(m.point) AS 'Tổng Điểm',
    AVG(m.point) AS 'Điểm Trung Bình'
FROM 
    Student s
JOIN 
    mark m ON s.studentID = m.studentID
GROUP BY 
    s.studentID, s.studentName;

-- Bài 4:  Tạo View, Index, Procedure [20 điểm]:  
	-- 1. Tạo VIEW có tên STUDENT_VIEW lấy thông tin sinh viên bao gồm : mã học sinh, tên học 
	-- sinh, giới tính , quê quán . [3 điểm]  
CREATE VIEW STUDENT_VIEW
AS
SELECT * FROM student;

SELECT * FROM STUDENT_VIEW;
	-- 2. Tạo VIEW có tên AVERAGE_MARK_VIEW lấy thông tin gồm:mã học sinh, tên học sinh, 
	-- điểm trung bình các môn học . [3 điểm] 
CREATE VIEW AVERAGE_MARK_VIEW
AS
SELECT 
    s.studentID AS 'Mã Học Sinh',
    s.studentName AS 'Tên Học Sinh',
    AVG(m.point) AS 'Điểm Trung Bình'
FROM 
    Student s
JOIN 
    mark m ON s.studentID = m.studentID
GROUP BY 
    s.studentID, s.studentName;
SELECT * FROM AVERAGE_MARK_VIEW;
	-- 3. Đánh Index cho trường `phoneNumber` của bảng STUDENT. [2 điểm]  
CREATE INDEX idx_student 
ON student(phoneNumber);
	-- 4. Tạo các PROCEDURE sau: 
    -- Tạo PROC_INSERTSTUDENT dùng để thêm mới 1 học sinh bao gồm tất cả thông 
	-- tin học sinh đó. [3 điểm]  
DELIMITER $$
CREATE PROCEDURE PROC_INSERTSTUDENT (IN _studentID VARCHAR(4), _studentName varchar(100), _brithday DATE, _gender BIT(1), _address TEXT, _phoneNumber varchar(45))
BEGIN
	INSERT INTO student(studentID, studentName, brithday, gender, address, phoneNumber)
    VALUES (_studentID, _studentName, _brithday, _gender, _address, _phoneNumber);
END
$$ DELIMITER ;

	-- Tạo PROC_UPDATESUBJECT dùng để cập nhật tên môn học theo mã môn học. [3 điểm]  
DELIMITER $$
CREATE PROCEDURE PROC_UPDATESUBJECT (IN _subjectID VARCHAR(4), _subjectName varchar(45))
BEGIN
	UPDATE subject 
    SET subjectName = _subjectName 
    WHERE subjectID = _subjectID;
END
$$ DELIMITER ;

	-- Tạo PROC_DELETEMARK dùng để xoá toàn bộ điểm các môn học theo mã học sinh. 
DELIMITER $$
CREATE PROCEDURE PROC_DELETEMARK_BY_STUDENTID (IN _studentID VARCHAR(4))
BEGIN
	DELETE FROM mark WHERE studentID = _studentID;
END
$$ DELIMITER ;

CALL PROC_DELETEMARK_BY_STUDENTID('S001');
    