package org.yoon.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.yoon.domain.BoardVO;
import org.yoon.domain.Criteria;
import org.yoon.mapper.AttachMapper;
import org.yoon.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {

	
	private BoardMapper mapper;
	
	private AttachMapper attachMapper;

	@Override
	public void register(BoardVO board) {
		
		log.info("==========글 등록========:    "+ board);
		mapper.insertSelectKey(board);
		//글 등록시 파일 정보
		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}

		board.getAttachList().forEach(attach -> {

			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	
	}

	@Override
	public BoardVO get(Long bno) {

		log.info("==========글 조회========:    "+ bno);
		return mapper.read(bno);
	}

	@Override
	public int remove(Long bno) {
		log.info("==========글 삭제========:    "+ bno);
		return mapper.delete(bno);
	}

	@Override
	public int modify(BoardVO board) {
		log.info("==========글 수정========:    "+ board);
		return mapper.update(board);
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("==========글 리스트 출력========");
		return mapper.getListPaging(cri);
	}

//	@Override
//	public List<BoardVO> getListPaging(Criteria cri) {
//		log.info("==========글 리스트 페이징 출력========");
//		return mapper.getListPaging(cri);
//	}

	@Override
	public int getTotal(Criteria cri) {
		// TODO Auto-generated method stub
		return mapper.getTotal(cri);
	}

	@Override
	public int visit(Long bno) {
		log.info("조회수 증가");
		return mapper.visit(bno);
	}


	
}
