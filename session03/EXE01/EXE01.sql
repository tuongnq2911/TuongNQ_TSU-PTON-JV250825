CREATE DATABASE IF NOT EXISTS QuanLyCuaHang;
USE QuanLyCuaHang;

CREATE TABLE KhachHang (
    MaKH INT PRIMARY KEY,
    TenKH VARCHAR(50) NOT NULL,
    NgaySinh DATE,
    DiaChi VARCHAR(100)
);

INSERT INTO KhachHang (MaKH, TenKH, NgaySinh, DiaChi) VALUES
(1, 'Nguyen Van A', '1990-02-15', 'Ha Noi'),
(2, 'Tran Thi B', '1995-06-20', 'Da Nang'),
(3, 'Le Hoang C', '2000-12-01', 'TP. Ho Chi Minh');

SELECT * FROM KhachHang;
