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

--재귀복사
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

CREATE INDEX IDX_REPLY ON TBL_REPLY (BNO DESC, RNO DESC);

select * from tbl_board where rownum <10 order by bno desc;

select * from tbl_reply where bno = 3145776;

select rno, bno, reply, replyer, replyDate, updatedate
		from (
			select /*+INDEX(tbl_reply idx_reply) */ 
				rownum rn, rno, bno, reply, replyer, replyDate, updatedate
			from tbl_reply
			where bno = 3145776
				  and rno > 0
				  and rownum <= 20
		) where rn < 11;