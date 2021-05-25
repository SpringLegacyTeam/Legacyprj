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
		
		log.info("==========�� ���========:    "+ board);
		mapper.insertSelectKey(board);
		//�� ��Ͻ� ���� ����
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

		log.info("==========�� ��ȸ========:    "+ bno);
		return mapper.read(bno);
	}

	@Override
	public int remove(Long bno) {
		log.info("==========�� ����========:    "+ bno);
		return mapper.delete(bno);
	}

	@Override
	public int modify(BoardVO board) {
		log.info("==========�� ����========:    "+ board);
		return mapper.update(board);
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("==========�� ����Ʈ ���========");
		return mapper.getListPaging(cri);
	}

//	@Override
//	public List<BoardVO> getListPaging(Criteria cri) {
//		log.info("==========�� ����Ʈ ����¡ ���========");
//		return mapper.getListPaging(cri);
//	}

	@Override
	public int getTotal(Criteria cri) {
		// TODO Auto-generated method stub
		return mapper.getTotal(cri);
	}

	@Override
	public int visit(Long bno) {
		log.info("��ȸ�� ����");
		return mapper.visit(bno);
	}


	
}
