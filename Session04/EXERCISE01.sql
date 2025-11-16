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