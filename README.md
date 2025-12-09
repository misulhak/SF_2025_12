# SF_2025_12

## MySQL Database & User 설정 및 table_board 테이블 생성

```sql
-- 📌 1) Database & User 설정
CREATE DATABASE springdb;

CREATE USER 'springdbuser'@'%' IDENTIFIED BY '1234';

GRANT ALL PRIVILEGES ON springdb.* TO 'springdbuser'@'%';


-- 📌 2) table_board 테이블 생성
create table table_board(
    bno int auto_increment primary key,
    title varchar(500) not null,
    content varchar(2000) not null,
    writer varchar(50) not null,
    regdate timestamp default now(),
    updatedate timestamp default now(),
    delflag boolean default false
);
