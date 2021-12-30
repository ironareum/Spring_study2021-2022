package org.zerock.controller;

import java.util.ArrayList;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/sample/*")
@Log4j
public class SampleController {
	
	@GetMapping("/ex02")
	public String ex02(@RequestParam("age") int age) { 
		log.info("age :" +age);
		
		return "ex02";
	}
	
	@GetMapping("exUpload")
	public void exUpload() {
		log.info(" jex01: /exUpload....");
	}

	@PostMapping("exUploadPost")
	public void exUploadPost(ArrayList<MultipartFile>files) {
		log.info(" jex01: /exUploadPost....");
		files.forEach(file ->{
			log.info("--------------");
			log.info("name : " + file.getOriginalFilename());
			log.info("size : " + file.getSize());
		});
	}
	
	
}
