package org.yoon.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.yoon.domain.GBoardAttachVO;
import org.yoon.domain.GBoardVO;
import org.yoon.mapper.GBoardAttachMapper;
import org.yoon.mapper.GBoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class GBoardServiceImpl implements GBoardService{

	@Setter(onMethod_= @Autowired)
	private GBoardMapper mapper;
	
	@Setter(onMethod_= @Autowired)
	private GBoardAttachMapper gattachMapper;
	
	@Transactional
	@Override
	public void register(GBoardVO gvo) {
		 mapper.insertSelectKey(gvo);
		 
		 if(gvo.getAttachList() == null || gvo.getAttachList().size() <= 0) {
			 return;
		 }
		 gvo.getAttachList().forEach(attach -> {
			 attach.setBno(gvo.getBno());
			 gattachMapper.insert(attach);
		 });
	}

	@Override
	public GBoardVO get(long bno) {
		return mapper.read(bno);
	}

	@Transactional
	@Override
	public boolean modify(GBoardVO gvo) {
		gattachMapper.deleteAll(gvo.getBno());
		boolean modifyResult = mapper.update(gvo) ==1;
		if(modifyResult && gvo.getAttachList().size()>0) {
			gvo.getAttachList().forEach(attach -> {
				attach.setBno(gvo.getBno());
				gattachMapper.insert(attach);
			});
		}
		return modifyResult;
	}
	
	@Transactional
	@Override
	public boolean delete(long bno) {
		gattachMapper.deleteAll(bno);
		return mapper.delete(bno)==1;
	}

	@Override
	public List<GBoardVO> getList() {
		return mapper.getList();
	}

	@Override
	public List<GBoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno"+bno);
		return gattachMapper.findByBno(bno);
	}

}
