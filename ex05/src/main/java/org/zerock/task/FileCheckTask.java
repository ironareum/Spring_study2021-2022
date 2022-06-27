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
	
	
	//배치 실행 -1 일전 날짜로 경로생성.
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		
		String str = sdf.format(cal.getTime());
		
		Calendar today = Calendar.getInstance();
		log.info("calendar .date: " + today.get(Calendar.DATE));
		log.info("cal .getTime() : "+str); 
		
		//어제날짜 폴더경로 생성
		return str.replace("-", File.separator);
	}
	
	/*
	//schedule 정상동작 테스트
	@Scheduled(cron="0 * * * * *")
	public void checkFiles() throws Exception{
		log.warn("File Check Task run..............");
		log.warn("===================================");
	}
	*/
	
	
//	@Scheduled(cron="0 0 2 * * *") //매일 0200
	@Scheduled(cron="00 21 22 * * *") 
	public void checkFiles() throws Exception{
		
		/*stream 사용법
		 *  map : 요소들을 특정조건에 해당하는 값으로 변환해 줌 (대,소분자 변형 등)
		 *  filter : 요소들을 조건에 따라 걸러내는 작업 (길이의 제한, 특정문자포함 등)
		 *  sorted : 요소들을 정렬해주는 작업
		 *  
		 *  collect : 요소들의 가공이 끝나면 리턴해줄 결과를 collect를 통해 만들어줌 
		 */
		
		/* Paths.get() : 경로얻기 */
		
		/* File의 Path API
		 * 		getPath() : File에 입력된 경로 리턴
		 * 		getAbsolutePath() : File에 입력된 절대경로 리턴 (./ 가 포함되어 있으면 ./를 포함해서 리턴)
		 * 		getCononicalPath() : Resolved 된 절대경로 리턴 (./ , ../ 와 같은 경로를 정리하고 리턴)
		 */	
		log.info("*************************************************");
		log.info("****** 첨부파일 작업 Batch 실행          *******");
		log.info("****** 실행일 : "+ new Date() +" ******");
		log.info("*************************************************");
		
		log.warn("File Check Task run..............");
		log.warn("getOldFiles()....................");
		//log.warn(new Date());
		
		//DB에 있는 첨부파일 조회. (배치실행 1일전)
		List<BoardAttachVO> fileList = attachMapper.getOldFiles(); 
		
		//DB의 BoardAttachVO 객체를 Path로 변환
		List<Path> fileListPaths ;
		
		//삭제할 File 리스트
		File[] removeFiles ;
		
		//DB의 첨부파일 리스트와 upload 디렉토리의 파일 목록 비교. ready for check file in directory with database file list
		try {
			//DB에 있는 파일명으로 경로 list 생성
			fileListPaths = fileList.stream()
										.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid()+"_"+vo.getFileName()) )
										.collect(Collectors.toList()); //파일목록 list로 생성
			
			//이미지파일은 섬네일 경로도 얻기. image file has thumbnail file
			fileList.parallelStream().filter(vo -> vo.isFileType() == true)
									 .map(vo -> Paths.get( "C:\\upload", vo.getUploadPath(), "s_", vo.getUuid()+"_"+vo.getFileName() ))
									 .forEach(p -> fileListPaths.add(p));

			log.warn("================================================");
			log.warn("DB에 있는 파일목록 -> 파일경로로 변환 완료. ");
			log.warn("fileListPaths : " + fileListPaths);
			log.warn("================================================");
			
			fileListPaths.forEach(p -> log.warn("DB에 적재된 첨부파일 경로 : "+p));
		
		} catch (NullPointerException e) {
			log.warn(".");
			log.warn(".");
			log.warn(".");
			log.warn("================================================");
			log.info("DB에 조회 할 파일이 없습니다.");
			log.warn("================================================");
			return;
		}
		
		try {
			log.info(".");
			log.info(".");
			log.info(".");
			log.info("================================================");
			log.info("디렉토리 내 파일 조회 시작");
			log.info("================================================");
			//디렉토리에 있는 파일들 File 객체로 생성. files in yesterday directory
			File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();
			log.info("디렉토리 내 파일 조회 : " + targetDir);
			
			//DB에서 조회한 파일 목록이 있을경우
			if(fileListPaths.size() > 0) {
				//DB 내 첨부파일 경로가 포함하고 있지 않은 파일들 삭제하기
				String fileName ;
				removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
				
				log.warn("================================================");
				log.warn("해당 파일이 DB에 조회되지 않습니다.");
				for(File file : removeFiles) {
					log.info("삭제할 파일 경로 : "+file.getAbsolutePath());
					log.info("삭제할 파일명 : " + file.getName());
					file.delete();	
				}
				log.warn("================================================");
				log.warn("");
				log.warn("");
				log.warn("");
			}else {
				log.warn("");
				log.warn("");
				log.warn("");
				log.warn("================================================");
				log.info("DB에 해당날짜의 파일이 없습니다.");
				
				//해당날짜 디렉토리에 파일 존재여부 확인 
				File[] targetFile = targetDir.listFiles();
				if(targetFile.length > 0) {
					log.info("해당날짜 디렉토리 비우기......... ");
					log.warn("================================================");
					for(File f: targetFile) {
						log.info("삭제할 파일명 : " + f.getName());
						f.delete();
						//log.info(sysdate + " "+ f.getName()+" 파일 삭제 완료.");
					}
					log.warn("================================================");
					log.info("해당날짜 디렉토리 비우기 [완료]");
					log.warn("================================================");
					log.warn("");
					log.warn("");
					log.warn("");
				}
			}
			
		} catch (NullPointerException e) {
			log.warn("================================================");
			log.info("디렉토리에 조회 할 파일이 없습니다.");
			log.warn("================================================");
			return;
		}
			
	}
		
}
