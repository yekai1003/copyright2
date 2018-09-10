-- 建库脚本

drop database if exists copyright;
create database copyright character set utf8;
use copyright
create table user (
     id int primary key auto_increment,
     email varchar(100),
     password varchar(20),
     ethaccount varchar(255)
);

create table asset (
    id  int primary key auto_increment,
    lifephoto varchar(255),
    pixprice int,
    userid   int,
    contenthash varchar(255),
    tokenid   int,
    weight    int,
    voteCount int,
    createtime timestamp
);
create table auction(
    id int primary key auto_increment,
    startAddr varchar(255),
    endAddr varchar(255),
    highprice int,
    userid   int,
    assetid  int,
    status   int,
    tokenid int,
    createtime timestamp
);