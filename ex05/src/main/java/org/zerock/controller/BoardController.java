package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/board/*")
@Controller
@Log4j
@AllArgsConstructor
public class BoardController {
	//@Setter(onMethod_ = {@Autowired})
	private BoardService service;
	
//	@RequestMapping("/list")
//	public void list(Model model) {
//		log.info("list");
//		model.addAttribute("list",service.getList());
//	}

	@RequestMapping("/list")
	public void list(Model model, Criteria cri) {
		log.info("list: "+ cri);
		model.addAttribute("list", service.getList(cri));
		//model.addAttribute("pageMaker", new PageDTO(cri, 123));
		
		int total =service.getTotalCount(cri);
		log.info("total : " + total);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	@GetMapping("/register")
	public void register() {
		
	}
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("===============================");
		log.info("register: "+ board);
		
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}
		
		log.info("===============================");
		
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		
		return "redirect:/board/list";	
	}
	
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info(bno);
		model.addAttribute("board", service.get(bno));
	}
	
	
	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri) {
		log.info("modify (post): " + board);
		log.info("modify (post): " +cri);
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
//		rttr.addAttribute("pageNum", cri.getPageNum());
//		rttr.addAttribute("amount", cri.getAmount());
//		rttr.addAttribute("keyword", cri.getKeyword());
//		rttr.addAttribute("type", cri.getType());
		
		return "redirect:/board/list" + cri.getListLink(); 
	}
	
	/* 
	 * ????????? ??? ???????????? ?????? ?????? (??????)
	 * 1) ?????? ???????????? ???????????? ????????? ?????? ?????? 
	 * 2) ?????????????????? ????????? ???????????? ???????????? ????????? ??????
	 * 3) ???????????? ????????? ???????????? ?????? ???????????? ????????? ?????????(????????? ????????? ??????)??? ??????????????? ??????  
	 */
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri) {
		log.info("remove..." +bno);
		log.info("remove..." +cri);
		
		//???????????? ????????? ????????????
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		//???????????????????????? ???????????? ???????????? ??????  -> ?????? ?????????, ?????? ????????? ????????? ?????????. (???????????? ?????? ????????? ????????? ?????? ??????)
		if(service.remove(bno)) {
			//???????????? ?????? ??????
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result", "success");
		}
		
//		rttr.addAttribute("pageNum", cri.getPageNum());
//		rttr.addAttribute("amount", cri.getAmount());
//		rttr.addAttribute("keyword", cri.getKeyword());
//		rttr.addAttribute("type", cri.getType());
		
		return "redirect:/board/list"+ cri.getListLink(); 
	}
	
	@GetMapping(value = "/getAttachList", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		log.info("getAttachList "+bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	

	//???????????? ??????
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("delete attach files ............. ");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\"+ attach.getUploadPath()
							+"\\"+attach.getUuid()+"_"+attach.getFileName());
				
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					log.info("image file ---> thumbnail will be deleted too.");
					Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()
									 +"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					Files.delete(thumbNail);
					log.info("complete to delete thumbnail file.");
				}
			} catch (Exception e) {
				log.error("delete file error"+ e.getMessage());
			}
		});
	}
}
