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

