package org.yoon.controller;

import org.springframework.stereotype.Controller; 
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.yoon.domain.BoardVO;
import org.yoon.domain.Criteria;
import org.yoon.domain.PageDTO;
import org.yoon.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor // 모든 필드값 생성자 주입
public class BoardController {

	private BoardService service;
	
	//글 리스트 출력
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("글 목록 생성(list)");
		log.info("======[list]: ");
		//글 정보 넘기기
		model.addAttribute("list", service.getList(cri));
		
		int total = service.getTotal(cri);
		//페이징 정보
		model.addAttribute("pageMaker", new PageDTO(cri,total));
	}
	
	//글 등록 페이지로 이동
	@GetMapping("/register")
	public void register() {
	
		}

	//글 등록
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("글 등록: " + board);
		
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno()); // 화면단에서 oo번째 글이 등록됬는지 정보 전송
		
		log.info(board.getBno());
		return "redirect:/board/list";
	}
	
	//글 조회 페이지로 이동
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, Model model) {
		log.info("/get");
		//조회수 증가
		service.visit(bno);
		model.addAttribute("board",service.get(bno));
		
	}
	
	//글 수정
	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri,RedirectAttributes rttr) {
		log.info("/modify");
		
		if(service.modify(board)==1) {
			rttr.addFlashAttribute("result","success"); // 화면단으로 성공 메시지 전송
		}
		
		return "redirect:/board/list";
	}
	
	//글 삭제
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		
		if(service.remove(bno)==1) {
			rttr.addFlashAttribute("result","success"); // 화면단으로 성공 메시지 전송
		}
		
		return "redirect:/board/list";
	}

	
	
}
