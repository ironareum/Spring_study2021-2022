--PART1 계정 생성
CREATE USER book_ex IDENTIFIED by book_ex
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

GRANT CONNECT, DBA TO book_ex;
==================================================
--PART3 테이블 생성
create sequence seq_board;

create table tbl_board (
	bno number(10,0),
	title varchar2(200) not null,
	content varchar2(2000) not null,
	writer varchar2(50) not null,
	regdate date default sysdate,
	updatedate date default sysdate
);

alter table tbl_board add constraint pk_board primary key (bno);

insert into tbl_board(bno, title, content, writer)
values (seq_board.nextval, '테스트 제목', '테스트 내용', 'user00');

select * from tbl_board where bno>0;

--재귀복사 (기존 row에 2배씩 증가. 동일 쿼리문 약 20번 실행)
insert into tbl_board(bno, title, content, writer)
(select seq_board.nextval, title, content, writer from tbl_board);

select count(*) from tbl_board;

select /*+ index_desc(tbl_board pk_board)*/
rownum rn, bno, title, content
from tbl_board where rownum <= 30;

SELECT * FROM
	(SELECT /* +INDEX_DESC(TBL_BOARD PK_BOARD) */
		ROWNUM RN, BNO, TITLE, CONTENT, WRITER, REGDATE, UPDATEDATE
	FROM TBL_BOARD
	WHERE TITLE LIKE '%테스트%'
	AND ROWNUM <= 20	
	)
WHERE RN > 10;

SELECT * FROM TBL_REPLY;

--댓글처리를 위한 테이블 생성과 처리
CREATE TABLE TBL_REPLY (
	RNO NUMBER(10,0), 
	BNO NUMBER(10,0) NOT NULL,
	REPLY VARCHAR2(1000) NOT NULL,
	REPLYER VARCHAR2(50) NOT NULL,
	REPLYDATE DATE DEFAULT SYSDATE,
	UPDATEDATE DATE DEFAULT SYSDATE
); 

CREATE SEQUENCE SEQ_REPLY;

ALTER TABLE TBL_REPLY ADD CONSTRAINT PK_REPLY PRIMARY KEY(RNO);
ALTER TABLE TBL_REPLY ADD CONSTRAINT FK_REPLY_BOARD
FOREIGN KEY(BNO) REFERENCES TBL_BOARD (BNO);

select * from tbl_board where rownum <10 order by bno desc;

select * from tbl_reply where bno = 3145776;

==================================================
--PART6 첨부파일 등록 


CREATE TABLE tbl_attach (
	uuid VARCHAR2(100) NOT NULL,
	uploadPath VARCHAR2(200) NOT NULL,
	fileName varchar2(100) not null,
	filetype char(1) default 'I',
	bno number(10,0)
);

alter table tbl_attach add constraint pk_attach primary key (uuid);
alter table tbl_attach add constraint fk_board_attach foreign key (bno) references tbl_board(bno);