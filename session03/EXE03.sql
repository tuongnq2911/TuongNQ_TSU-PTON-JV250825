CREATE DATABASE IF NOT EXISTS QuanLyCuaHang;
USE QuanLyCuaHang;

USE QuanLyCuaHang;

CREATE TABLE SanPham (
    MaSP INT PRIMARY KEY,
    TenSP VARCHAR(100) NOT NULL,
    Gia DECIMAL(10,2),
    SoLuongTon INT DEFAULT 0
);

ALTER TABLE SanPham
ADD MoTa TEXT;

INSERT INTO SanPham (MaSP, TenSP, Gia, SoLuongTon, MoTa) VALUES
(1, 'Bánh quy', 30000.00, 50, 'Bánh quy thơm ngon'),
(2, 'Nước ngọt', 12000.00, 100, 'Nước giải khát'),
(3, 'Sữa tươi', 55000.00, 40, 'Sữa tươi nguyên chất');

SELECT * FROM SanPham
WHERE Gia > 50000;
