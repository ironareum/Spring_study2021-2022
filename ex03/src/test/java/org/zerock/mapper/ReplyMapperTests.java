package org.zerock.mapper;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {
	//테스트 전에 해당 번호의 게시무링 존재하는지 확인할것
	private Long[] bnoArr = {3145776L, 3145775L, 3145774L, 3145773L, 3145772L};
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	//@Test
	public void testCreate() {
		IntStream.rangeClosed(1, 10).forEach(i -> {
			ReplyVO vo = new ReplyVO();
			
			//게시물의 번호
			vo.setBno(bnoArr[i% 5]);
			System.out.println("num?? : "+bnoArr[i% 5]);
			vo.setReply("댓글 테스트 " +i);
			vo.setReplyer("replyer " +i);
			
			mapper.insert(vo);
		});
	}

	//@Test
	public void testMapper() {
		log.info(mapper);
	}
	
	//@Test
	public void testRead() {
		Long targetRno = 5L;
		
		ReplyVO vo = mapper.read(targetRno);
		log.info(vo);
	}
	
	//@Test
	public void testDelete() {
		Long targetRno = 1L;
		
		mapper.delete(targetRno);
		
	}

	//@Test
	public void testUpdate() {
		Long targetRno = 10L;
		ReplyVO vo =  mapper.read(targetRno);
		
		vo.setReply("Update Reply ");
		
		int count = mapper.update(vo);
		
		log.info("update count : " + count);
		
	}
	
	@Test
	public void testList() {
		Criteria cri = new Criteria();
		
		//3145776L
		List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[0]);
		
		replies.forEach(reply -> log.info(reply));
		
	}
}
