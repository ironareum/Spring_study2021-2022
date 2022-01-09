drop table tbl_sample1;
CREATE TABLE TBL_SAMPLE1 (COL1 VARCHAR2(500));
CREATE TABLE TBL_SAMPLE2 (COL2 VARCHAR2(50));

select * from tbl_sample1;

delete from TBL_SAMPLE2;

Alter table tbl_board add (replyCnt number default 0);

update tbl_board set replyCnt = 
(select count(rno) from tbl_reply where tbl_reply.bno = tbl_board.bno);

