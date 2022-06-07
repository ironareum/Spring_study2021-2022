package org.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	
	@Setter(onMethod_ = {@Autowired})
	private BoardAttachMapper attachMapper;
	
	
	private String getFolerYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);

		String str = sdf.format(cal.getTime());
		
		log.info("Calendar.DATE: " + Calendar.DATE);
		log.info("cal.getTime() : "+str); 
		
		return str.replace("-", File.pathSeparator);
	}
	
	/*
	//schedule 정상동작 테스트
	@Scheduled(cron="0 * * * * *")
	public void checkFiles() throws Exception{
		log.warn("File Check Task run..............");
		log.warn("===================================");
	}
	*/
	
	
	@Scheduled(cron="0 0 2 * * *") //매일 0200
	public void checkFiles() throws Exception{
		log.warn("File Check Task run..............");
		log.warn(new Date());
		
		//file list in database. 배치 실행 -1 일전 날짜의 첨부파일 목록을 조회함.
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		//ready for check file in directory with database file list
		List<Path> fileListPaths = fileList.stream()
									.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid()+"_"+vo.getFileName() ))
									.collect(Collectors.toList());
		
	
	}
		
}
