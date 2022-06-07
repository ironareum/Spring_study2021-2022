package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
//@AllArgsConstructor
public class BoardServiceImpl implements BoardService{
	
	//spring 4.3 이상에서 자동처리
	
	//게시물 mapper
	@Setter(onMethod_ =@Autowired)
	private BoardMapper mapper;
	
	//첨부파일 mapper
	@Setter(onMethod_ =@Autowired)
	private BoardAttachMapper attachMapper;
	
	
	
	@Transactional
	@Override
	public void register(BoardVO board) {
		log.info("register..... " + board);
		mapper.insertSelectKey(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get..........."+bno);
		return mapper.read(bno);
	}
	
	
	
	/*게시물 수정 
	 * 첨부파일의 경우: 
	 * 1) 해당 게시물의 모든 첨부파일 목록을 삭제하고, 다시 첨부파일 목록을 추가하는 형태로 처리 
	 * 	  => 문제점: 데이터베이스 상에는 문제가 없는데, 실제 파일이 업로드된 폴더에는 삭제된 파일이 남아있음. 
	 *    => 해결: 주기적으로 파일과 데이터베이스를 비교하는 등의 방법을 활용해서 처리. 
	 */
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify..... " + board);
		
		//모든 첨부파일 목록 삭제 @DB
		attachMapper.deleteAll(board.getBno());
		
		//게시물 업데이트
		boolean modifyResult = mapper.update(board) ==1;
		
		//첨부파일 정보 attachList에 주입
		if(modifyResult && board.getAttachList() != null 
				&& board.getAttachList().size()>0) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		//return mapper.update(board) == 1;
		return modifyResult;
	}

	
	
	@Transactional
	@Override
	public boolean remove(Long bno) {
		log.info("remove.... " + bno);
		//해당 게시물의 모든 첨부파일 삭제 
		attachMapper.deleteAll(bno);
		//게시물 삭제
		return mapper.delete(bno)==1;
	}

//	@Override
//	public List<BoardVO> getList() {
//		log.info("getList........ ");
//		return mapper.getList();
//	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("get List with criteria........ " + cri);
		return mapper.getListWithPaging(cri);
	}
	
	@Override
	public int getTotalCount(Criteria cri) {
		log.info("get total count... ");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno "+ bno);
		
		return attachMapper.findByBno(bno);
	}
	
	
	
}
