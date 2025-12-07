CREATE DATABASE TMDT;

USE TMDT;

create table danhMuc(
MaDM int primary key auto_increment,
TenDM varchar(100) not null unique
);

create table sanPham(
maSP int primary key auto_increment,
tenSP varchar(150) not null unique,
giaSP decimal(10,2),
check (giaSP > 0),
maDM int not null,
foreign key (maDM) references danhMuc(maDM) 
);

insert into danhMuc(TenDM) value ('Ao');
insert into danhMuc(TenDM) value ('Quan');
insert into danhMuc(TenDM) value ('Mu');

select * from danhMuc;

insert into sanPham(tenSP,giaSP,maDM) value ('Ao Khoác 01',100,1);
insert into sanPham(tenSP,giaSP,maDM) value ('Ao Khoác 02',100,1);
insert into sanPham(tenSP,giaSP,maDM) value ('Quan Kaki 01',500,2);

select * from sanPham;

select * from sanPham where maDM = 1;