package org.yoon.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Select;
import org.yoon.domain.GBoardVO;


public interface GBoardMapper {

	@Select("select * from G_Board where bno > 0")
	public List<GBoardVO> getList();
	
	public void insert(GBoardVO gBoard);

	public void insertSelectKey(GBoardVO gBoard);
	
	public GBoardVO read(long bno);
	
	public int delete(long bno);
	
	public int update(GBoardVO vo);
	
	
	
}
