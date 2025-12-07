CREATE DATABASE session03;
USE session03;

CREATE TABLE sach(
ma_sach INT PRIMARY KEY AUTO_INCREMENT,
ten_sach VARCHAR(100),
nam_xuat_ban DATE
);

CREATE TABLE tac_gia(
ma_tac_gia INT PRIMARY KEY AUTO_INCREMENT,
ten_tac_gia VARCHAR(50)
);

CREATE TABLE sach_tac_gia(
	ma_sach int not null,
    ma_tg int not null,
    foreign key (ma_sach) references sach(ma_sach),
    foreign key(ma_tg) references tac_gia(ma_tac_gia)
);

-- chèn dữ liệu
INSERT INTO tac_gia(ten_tac_gia) VALUES 
('Nguyễn Du'),
('Bà Huyện');
INSERT INTO sach  (ten_sach,nam_xuat_ban) values 
('Truyeen Kieu','2024-01-10'),
('Truyeen Kieu 2','2025-01-10');


insert into sach_tac_gia(ma_tg,ma_sach) Value (1,1);
insert into sach_tac_gia(ma_tg,ma_sach) Value (1,2);
SELECT * FROM tac_gia;
SELECT * FROM sach;
select * FROM sach_tac_gia;