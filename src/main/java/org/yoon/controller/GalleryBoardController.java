package org.yoon.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.yoon.domain.GBoardAttachVO;
import org.yoon.domain.GBoardVO;
import org.yoon.service.GBoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@RequestMapping("/GBoard/*")
@Log4j
@AllArgsConstructor
public class GalleryBoardController {

	private GBoardService service;
	
	//게시글목록 조회
	@GetMapping("/list")
	public void list(Model model) {
		log.info("게시글 목록 조회");
		model.addAttribute("list", service.getList());
	}
	
	//게시글 상세보기 및 수정페이지
	@GetMapping({"/get","/modify"})
	public void get(@RequestParam("bno") Long bno, Model model) {
		log.info("글 상세보기");
		model.addAttribute("gboard",service.get(bno));
	}
	
	//게시글 등록페이지
	@GetMapping("/register")
	public void register() {}
	
	
	//게시글 등록
	@PostMapping("/register")
	public String register(GBoardVO vo, RedirectAttributes rttr) {
		log.info("=================================");
		log.info("register : "+vo);
		
		if(vo.getAttachList()!=null) {
			vo.getAttachList().forEach(attach -> log.info(attach));
		}
		
		log.info("=================================");
		
		service.register(vo);
		rttr.addFlashAttribute("result", vo.getBno());
		
		return "redirect:/GBoard/list";
	}

	//게시글 수정
	@PostMapping("/modify")
	public String modify(GBoardVO vo, RedirectAttributes rttr) {
		log.info("글 수정:"+vo);
		if(service.modify(vo)) {
			rttr.addFlashAttribute("result","msuccess");
		}
		return "redirect:/GBoard/list";
	}
	
	//게시글 삭제
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") long bno, RedirectAttributes rttr) {
		log.info("글 삭제"+bno);
		List<GBoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.delete(bno)) {
			deleteFiles(attachList);
			rttr.addFlashAttribute("result", "dsuccess");
		}
		return "redirect:/GBoard/list";
	}
	
	//파일 업로드 시점 기준 날짜 생성하는 함수
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		
		return str.replace("-",File.separator);
		
	}
	
	//첨부파일 등록
	@PostMapping(value="/uploadAjaxAction", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<GBoardAttachVO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		List<GBoardAttachVO> list = new ArrayList<>();
		String uploadFolder = "C:\\upload";

		String uploadFolderPath = getFolder();

		//make folder----------
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		
		for(MultipartFile multipartFile: uploadFile) {
			GBoardAttachVO attachVO = new GBoardAttachVO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			//IE has file path
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
			attachVO.setFileName(uploadFileName);
			
			//중복 방지를 위한 UUID 적용
			UUID uuid= UUID.randomUUID();
			uploadFileName = uuid.toString()+"_"+uploadFileName;
			
			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachVO.setUuid(uuid.toString());
				attachVO.setUploadPath(uploadFolderPath);
				
				
				//check image type
				if(checkImageType(saveFile)) {
					attachVO.setFileType(true);
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_"+uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(),thumbnail, 100, 100);
					thumbnail.close();
				}
				
				list.add(attachVO);
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	//섬네일 데이터 전송하는 함수
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		
		File file = new File("C:\\upload\\"+fileName);
		ResponseEntity<byte[]> result = null;
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type",Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);
		}catch(IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping(value="/download", produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent")String userAgent, String fileName){
		log.info("download file: "+fileName);
		Resource resource = new FileSystemResource("c:\\upload\\"+fileName);
		
		if(resource.exists()==false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		String resourceName = resource.getFilename();
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);
		HttpHeaders headers = new HttpHeaders();
		
		try {
			String downloadName = null;
			if(userAgent.contains("Trident")) {
				log.info("IE browser");
				downloadName=URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+"," ");
				
			}else if(userAgent.contains("Edge")) {
				log.info("Edge browser");
				downloadName = URLEncoder.encode(resourceOriginalName,"UTF-8");
			}else {
				log.info("chrome browser");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"),"ISO-8859-1"); 
			}
			
			headers.add("Content-Disposition", "attachment;filename="+downloadName); 
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, headers,HttpStatus.OK);
	}
	
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		File file;
		
		try {
			file = new File("c:\\upload\\"+URLDecoder.decode(fileName,"UTF-8"));
			file.delete();
			if(type.equals("image")) {
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				file = new File(largeFileName);
				file.delete();
			}
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted",HttpStatus.OK);
	}
	
	@GetMapping(value= "/getAttachList", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<GBoardAttachVO>> getAttachList(Long bno){
		log.info("getAttachList"+bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	//파일 삭제
	private void deleteFiles(List<GBoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
				Files.deleteIfExists(file);
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					Files.delete(thumbNail);
				}
			}catch(Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}
	
}
