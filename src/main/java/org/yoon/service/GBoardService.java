package org.yoon.service;

import java.util.List;

import org.yoon.domain.GBoardAttachVO;
import org.yoon.domain.GBoardVO;


public interface GBoardService {

	public void register(GBoardVO gvo);
	
	public GBoardVO get(long bno);
	
	public boolean modify(GBoardVO gvo);
	
	public boolean delete(long bno);
	
	public List<GBoardVO> getList();
	
	public List<GBoardAttachVO> getAttachList(Long bno);
}
