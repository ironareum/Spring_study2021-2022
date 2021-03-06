## Part6 파일 업로드 처리

***
java InputStream : https://lannstark.tistory.com/34
	1. Stream: 데이터가 전송되는 통로 
		* 개별 바이트나 문자열인 데이터의 원천
		* 파일을 읽거나 쓸때, 네트워크 소켓을 거쳐 통신할 때 쓰이는 추상적인 개념
	2. InputStream: 데이터가 들어오는 통로! 데이터를 읽어야 한다! (데이터가 들어오는 통로의 역할에 관해 규정하고 있는 추상 클래스)
		* 하위스트림 : 파일스트림, 바이트 스트림, 네트워크 스트림 등
		
		* InputStream은 데이터를 읽어야 한다!
		1) 주요 메소드
			** 데이터를 읽는 기능과 관련된 메소드 3개
				- int read()
					```java
					/**
					* 1byte를 읽어 그 값을 int로 반환하거나 (1byte = -128~127 또는 0~255) 
					* 더 이상 읽을 수 없는 경우는 -1을 반환한다.
					*/
					public abstract int read() throws IOException;
					
					//Main method
					byte[] data = new byte[]{1,2};
					ByteArrayInputStream inputStream = new ByteArrayInputStream(data);
					
					System.out.println(inputStream.read()); //바이트 하나를 읽었으니, 1을 읽었고 1이 출력된다.
					System.out.println(inputStream.read()); //바이트 하나를 추가로 읽었으니, 2을 읽었고 2가 출력된다.
					System.out.println(inputStream.read()); //더 이상 읽을 바이트가 없으니, -1이 출력된다.
					```
					
				- int read(byte b[])	
					```
					/**
					* 1byte씩 읽는게 아니라 파라미터로 주어진 byte 배열 크기만큼 데이터를 읽고 총 몇 byte를 읽었는지 반환한다.
					* 데이터를 읽다가 모두 읽으면, 그만큼의 크기를 반환하고 시작부터 읽을게 없으면 -1을 반환한다.
					*/
					public int read(byte b[]) throws IOException{ }
					
					//Main method
					byte[] data = new byte[]{10, 20, 30, 40, 50};
					ByteArrayInputStream inputStream = new ByteArrayInputStream(data);
					
					byte[] buffer = new byte[3];
					System.out.println(inputStream.read(buffer)); //바이트 3개(10, 20, 30)을 읽어 buffer에 넘겨주고 3을 출력한다.
					System.out.println(inputStream.read(buffer)); //바이트 2개(40, 50)을 읽어 buffer에 넘겨주고 2을 출력한다.
					System.out.println(inputStream.read(buffer)); //시작부터 읽을 바이트가 없으니, -1이 출력된다.
					
					```
				
				- int read(byte[] b, int off, int len) throws IOException { }
					```
					/**
					* len개의 byte를 읽어서 주어진 byte[] b의 b[off]부터 저장한다
					* 저장한 개수를 반환하고, 읽을게 더 이상 없다면 -1을 반환한다
					* 
					* 만약 byte[] 크기가 부족하다면 IndexOutOfBoundsException을 낸다
					*/
					public int read(byte[] b, int off, int len) throws IOException { }
					```
		* 여기서 중요한 포인트는 InputStream은 말 그대로 통로이기 때문에, (read 만 사용해서는) 한 번 읽었던 것을 다시 되돌아가 읽을 수 없다.
		
		
***

### 21. 파일 업로드 방식
**첨부파일을 서버에 전송하는 방식은 크게 2가지가 있음**
- 브라우저 상에서 첨부파일에 대한 처리 
	1  `<form>`태그를 이용하는 방식: 브라우저의 제한이 없어야 하는 경우에 사용
		- 일반적으로 페이지 이동과 동시에 첨부파일을 업로드 하는 방식
		- `<iFrame>`을 이용해서 화면의 이동없이  첨부파일을 처리하는 방식
	2) Ajax를 이용하는 방식: 첨부파일을 별도로 처리하는 방식
		- `<input type='file'>`을 이용하고 Ajax로 처리하는 방식
		- HTML5의 Drag And Drop 기능이나 jQuery 라이브러리를 이용해서 처리하는 방식

- 서버쪽 처리(API 사용)
	**브라우저 상에서 첨부파일을 처리하는 방식은 다양하게 있지만, 서버 쪽에서의 처리는 거의 대부분 비슷함. 응답을 HTML 코드로 하는지 아니면 JSON 등으로 처리하는지 정도의 구분만 하면 됨. (본 예는 주로 Ajax 위주로 처리.)**
	1) cos.jar: 2002년 이후에 개발종료. 사용권장 x
	2) commons-fileupload: 가장 일반적으로 많이 활용되고, 서블릿 스펙 3.0 이전에도 사용 가능
	3) 서블릿 3.0이상 - 3.0 이상부터는 자체적인 파일 없로드 처리가 API 상에서 지원
	** 첨부파일은 실제 서버가 동작하는 머신 내에 있는 폴더에 업로드 시켜야 하므로 C드라이브 밑에 upload 폴더와 임시 업로드 파일을 저장할 temp 폴더를 생성함**
	
	*폴더구조*
	```
	upload/
	└── temp/
	```


	#### 1. 환경설정
	- pom.xml 환경설정 추가
			```java
			//pom.xml
				//서블릿 3.0 이상을 활용하기 위해 서블릿 버전 수정 및 기본적인 사항(Lombok 등) 추가
				<properties>
					<java-version>1.8</java-version>
					<org.springframework-version>5.0.7.RELEASE</org.springframework-version>
					<org.aspectj-version>1.9.0</org.aspectj-version>
					<org.slf4j-version>1.7.25</org.slf4j-version>
				</properties>
				
				<!-- Lombok 라이브러리 : getter/setter, toString(), 생성자 메서드 자동 생성해줌 -->
				<dependency>
					<groupId>org.projectlombok</groupId>
					<artifactId>lombok</artifactId>
					<version>1.18.0</version>
					<scope>provided</scope>
				</dependency>
				
				<!-- log4j 추가. 1.2.15 -> 1.2.17 버전으로 변경 -->
				<dependency>
					<groupId>log4j</groupId>
					<artifactId>log4j</artifactId>
					<version>1.2.17</version>
					
				<!-- Servlet 버전 3.1.0으로 변경 -->
				<dependency>
					<groupId>javax.servlet</groupId>
					<artifactId>javax.servlet-api</artifactId>
					<version>3.1.0</version>
					<scope>provided</scope>
				</dependency>
				
				<dependency>
					<groupId>javax.servlet.jsp</groupId>
					<artifactId>jsp-api</artifactId>
					<version>2.1</version>
					<scope>provided</scope>
				</dependency>
				
				<dependency>
					<groupId>javax.servlet</groupId>
					<artifactId>jstl</artifactId>
					<version>1.2</version>
				</dependency>
				
				<!-- Test 4.12로 버전 변경-->
				<dependency>
					<groupId>junit</groupId>
					<artifactId>junit</artifactId>
					<version>4.12</version>
					<scope>test</scope>
				</dependency> 
				
				<!-- add test lib : 스프링 동작 테스트-->
				<dependency>
					<groupId>org.springframework</groupId>
					<artifactId>spring-test</artifactId>
					<version>${org.springframework-version}</version>
				</dependency>	
				
				
				//java 설정시 : web.xml이 없어도 문제가 생기지 않도록 plugin 추가  & java설정 클래슨는 이전 예제 참고 
				<plugin>
					<groupId>org.apache.maven.plugins</groupId>
					<artifactId>maven-war-plugin</artifactId>
					<configuration>
					   <failOnMissingWebXml>false</failOnMissingWebXml>
					</configuration>
				</plugin>
			```
	
	- web.xml을 이용하는 경우 첨부파일 설정 (java 설정의 경우 web.xml, servlet-context.xml, root-context.xml 파일 사용안함)
	web.xml의 설정은 WAS(Tomcat) 자체의 설정일뿐, 스프링에서 업로드 처리는 MultipartResolver라는 타입의 객체를 빈으로 등록해야만 가능함. (@servelt-context.xml)
	
			```xml
			//web.xml 
				//서블릿 버전 변경 
				<web-app 
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xmlns="http://xmlns.jcp.org/xml/ns/javaee"
					xsi:schemaLocation="http://java.sun.com/xml/ns/javaee https://java.sun.com/xml/ns/javaee/web-app_3_1.xsd">
				
				//<multipart-config> 태그 추가
				<servlet>
					<servlet-name>appServlet</servlet-name>
					<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
					<init-param>
						<param-name>contextConfigLocation</param-name>
						<param-value>/WEB-INF/spring/appServlet/servlet-context.xml</param-value>
					</init-param>
					<load-on-startup>1</load-on-startup>
				
					<multipart-config>
						<location>C:\\upload\\temp</location> <!-- 파일 저장위치 -->
						<max-file-size>20971520</max-file-size> <!-- 업로드되는 파일의 최대 크기 1MB * 20 -->
						<max-request-size>41943040</max-request-size> <!-- 한번에 올릴 수 있는 최대 크기 40MB -->
						<file-size-threshold>10971520</file-size-threshold> <!-- 메모리 사용 20MB -->
					</multipart-config>
				</servlet>
			```
			
			```
			//servelt-context.xml
				//첨부파일을 처리하는 빈을 설정할때 id는 반드시 'multipartResolver'라는 이름으로 지정해서 사용
				<beans:bean id="multipartResolver" 
							class="org.springframework.web.multipart.support.StandardServletMultipartResolver">
				</beans:bean>
			```
	
	
	- java 설정시
			```java
			//WebConfig.java
				//xml에서 <multipart-config>태그는 WebConfig 클래서에서는 javax.servlet.MultipartConfigElement라는 클래스 이용
				@Override
				protected void customizeRegistration(ServletRegistration.Dynamic registration) {
					registration.setInitParameter("throwExceptionIfNoHandlerFount", "true");
					MultipartConfigElement multipartConfig = new MultipartConfigElement("C:\\upload\\temp", 20971520, 41943040, 20971520);
					registration.setMultipartConfig(multipartConfig);
				}
			```
			```	java
			//ServletConfig.java
				//MultipartResolver 빈 추가
				@Bean
				public MultipartResolver multipartResolver(){
					StandardServletMultipartResolver resolver = new StandardServletMultipartResolver();
					return resolver;
				}
			```
	
	
	#### 2. `<form>` 방식의 파일 업로드
	- Controller
		1) 첨부파일을 업로드할 수 있는 화면 처리 메서드(GET방식: /uploadForm)
			매개변수: MultipartFile[] uploadFile (스프링에서 제공하는 MultipartFile 타입)
				
				```java
				MultipartFile 타입 (파일처리는 MultipartFile이라는 타입을 이용)
				
					//MultiparFile 의 메서드
					- String getName() : 파라미터의 이름 <input> 태그의 이름
					- String getOriginalFileName() : 업로드되는 파일의 이름
					- boolean isEmpty(): 파일이 존재하지 않는 경우
					- long getSize(): 업로드되는 파일의 크기
					- byte[] getBytes(): byte[]로 파일 데이터 반환
					- InputStream getInputStream(): 파일데이터와 연결된 InputStream을 반환
					- transferTo(File file): 파일의 저장(file에 지정된 파일경로 및 이름으로 ) **
				```	
					
		2) 첨부파일 업로드 처리하는 메서드(POST 방식: /uploadFormAction)
				
				```java
				File saveFile= new File(파일경로, 업로드파일.getOriginalFilename(); //파일경로: C:\\upload
				업로드파일.transferTo(saveFile); //업로드파일을 해당경로에 저장.
	
				@PostMapping("/uploadFormAction")
				public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
					
					String uploadFolder = "C:\\upload";
					
					for(MultipartFile multipartFile : uploadFile) {
						log.info("-----------------------------");
						log.info("Upload File Name: "+ multipartFile.getOriginalFilename()); //IE의 경우 경로가 표시됨
						log.info("Upload File Size: "+ multipartFile.getSize());
						
						
						File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
						
						try {
							//파일을 저장하는 방법은 간단히 transferTo()를 이용해서 처리가능 
							multipartFile.transferTo(saveFile);
						} catch (Exception e) {
							log.error(e.getMessage());
						}
					}
				}
				```
	- jsp
		1) 중요: `<form>` 태그 생성시 enctype="multipart/form-data" 설정 필수
				
				```jsp
				<form action="uploadFormAction" method="post" enctype="multipart/form-data">
					<input type="file" name="uploadFile" multiple> <!-- multiple: 하나의 input태그로 한꺼번에 여러 개의 파일을 업로드 할 수 있음 (브라우저 버전 확인 필수)-->
					<button>Submit</button>
				</form>
				```	
	
		
	#### 3. ajax(jQuery)를 이용한 파일 업로드 (FormData 객체 이용, 브라우저 제약있음. IE의 경우 10 이후 버전부터 지원)
	- Controller
		1) 첨부파일을 업로드할 수 있는 화면 처리 메서드(GET방식: /uploadAjax)
		2) 첨부파일 업로드 처리하는 메서드(POST 방식: /uploadAjaxAction)
				IE의 경우에는 전체파일 경로가 전송되므로, 마지막 '\'를 기준으로 잘라낸 문자열이 실제파일이름이므로 처리 후 저장
				
				```java
				
				for(MultipartFile multipartFile : uploadFile){
					String uploadFileName = multipartFile.getOriginalFilename();
					
					// IE has file path
					uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\"+1)); //IE의 경우 실제 파일명만 추출작업
					
					...
				```
			
	- jsp
		1) jQuery의 FormData 객체를 이용해서 script 처리.
				Ajax를 이용하는 파일 업로드는 FormData를 이용해서 필요한 파라미터를 담아서 전송하는 방식.
				
				```jsp 일부
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;
				
				...
				
				$.ajax({
					url: '/uploadAjaxAction',
					processData: false, //반드시 false 지정
					contentType: false, //반드시 false 지정
					data: formData,
					type: 'POST',
					success function(result){
						alert("Uploaded");
					}
				});
				
				```
	- 파일 업로드에서 고려해야 하는 점들 
		***
			- 동일한 이름으로 파일이 업로드 되었을 때 기존 파일이 사라지는 문제
			- 이미지 파일의 경우에는 원본 파일의 용량이 큰 경우 섬네일 이미지를 생성해야 하는 문제
			- 이미지 파일과 일반 파일을 구분해서 다운로드 혹은 페이지에서 조회하도록 처리하는 문제
			- 첨부파일 공격에 대비하기 위한 업로드 파일의 확장자 제한
		***

<br>
<br>
	
### 22. 파일 업로드 상세 처리 
	
	#### 1. 파일의 확장자나 크기의 사전 처리 (웹공격 방지)
	- 첨부파일의 확장자가 'exe', 'sh', 'zip'등 & 특정 크기 이상의 파일의 경우에는 업로드 제한하는 Js 처리 (파일 확장자의 경우 정규표현식을 이용해서 검사가능)	
			```js
			
			// 파일의 확장자와 크기를 검사하는 함수
			function checkExtension(fileName, fileSize){} 
			```
	- 중복된 이름의 첨부파일 처리 (한 폴더 내 생성파일 수 제한)
			1) 중복된 이름의 파일처리 해결방법 : 현재시간을 밀리세컨드까지 구분해서 파일 이름을 생성해서 저장하거나, UUID를 이용해서 중복발생 가능성이 거의 없는 문자열 생성하여 처리
			2) 한 폴더내에 너무 많은 파일생성 문제 해결방법: '년/월/일' 단위의 폴더를 생성해서 파일 저장 
				- java.io.File에 존재하는 mkdirs() 이용 (필요한 상위 폴더까지 한번에 생성가능)
		
	- 중복 방지를 위한 UUID 사용
			```
			//파일 이름 생성시 동일한 이름으로 업로드되면 기존 파일을 지우게 되므로 java.util.UUID의 값을 이용해서 처리
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString() + "-" + uploadFileName;
			File saveFile = new File(uploadPath, uploadFileName);
			```
		
	*File 객체 관련 참고링크: 
		- File 객체: https://xzio.tistory.com/305
		- File 생성: https://hianna.tistory.com/588
		- 특정 디렉토리 File 목록 가져오기: https://mine-it-record.tistory.com/432

	#### 2. 섬네일 이미지 생성 (일반파일과 이미지 파일 구분)
	- Thumbnailator 라이브러리 사용 (그외 JDK1.4 부터는 ImageIO, ImgScalr 등이 있음)
		1) pom.xml에 라이브러리 추가 (https://github.com/coobird/thumbnailator 참고. ver 0.4.8)
		
	- Controller
		1) 업로드된 파일이 이미지 종류의 파일인지 확인 (checkImageType() 메서드 추가 )
			**약간의 검사를 통해서 업로드 되는 파일의 확장자를 검사하기는 하지만, Ajax로 사용하는 호출은 반드시 브라우저만을 통해서 들어오는 것이 아니므로 확인할 필요가 있음**
				```java
				//UploadController 일부
				private boolean checkImageType(File file){
					...
					String contentType = Files.probeContentType(file.toPath());
					return contentType.starsWith("image"); //이미지 타입 확인
					...
					return false; //이미지 타입 아님
				}
				```
		2) 이미지 파일의 경우에는 섬네일 이미지 생성 및 저장
				```java
				//이미지 타입인 경우 섬네일 생성하도록 수정 
				//UploadController 일부 (@uploadAjaxAction)
					...
					//check image type file
					if(checkImageType(saveFile)){
						FileOutputStram thumbnail = new FileOutputStream(newFile(uploadPath, "s_"+uploadFileName));
						Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100); //
						thumbnail.close();									
					}
					...
				```
	#### 3. 업로드된 파일의 데이터 반환 (브라우저 쪽에 데이터 반환)
	- 브라우저로 전송해야 하는 데이터는 다음과 같은 정보를 포함하도록 설계 (별도의 객체를 생성해서 처리하는 방법으로 구현)
		1) 업로드된 파일의 이름과 원본 파일의 이름
		2) 파일이 저장된 경로
		3) 업로드된 파일이 이미지인지 아닌지에 대한 정보
			
	- jackson-databind 라이브러리 사용
		pom.xml에 라이브러리 추가 (jackson.core, jackson.dataformat)
		
	- AttachFileDTO 클래스 생성 (아래 변수의 정보를 하나로 묶어서 전달하는 용도로 사용) 
			```
			//AttachFileDTO 클래스
			fileName, uploadPath, uuid, image 변수 설정
			```
	- UploadController
			AttachFileDTO의 리스트를 반환하는 구조로 변경 
			```
			@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
				@ResponseBody
				public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile){
					ArrayList<AttachFileDTO> list = new ArrayList<>();
					...
					//make yyyy/MM/dd folder
					for (MultipartFile multipartFile : uploadFile){
						AttachFileDTO attachDTO = new AttachFileDTO();
						...
						//IE has file path
						attachDTO.setFileName(uploadFileName);
						...
						attachDTO.setUuid(uuid.toString());
						sttachDTO.setUploadPath(uploadFolederPath);
						...
						//check image type file
						attachDTO.setImage(true);
						...
						//add to List
						list.add(attachDTO);
					}
					
					return new ResponseEntity<>(list, HttpStatus.OK);
				}
			```
	- jsp
		uploadAjax.jsp 의 $.ajax dataType 변경(json)
			
			
### 23. 브라우저에서 섬네일 처리 
	#### 1. `<input type-'file'>`의 초기화
	- `<input type-'file'>`은 다른 DOM 요소들과 조금 다르게 readonly라 안쪽의 내용을 수정할 수 없기 때문에 별도의 방법으로 초기화 시켜서 또 다른 첨부파일을 추가할 수 있도록 만들어야함
			```jsp
			//uploadAjax.jsp 일부
			var cloneObj = $(".uploadDiv").clone(); //업로드 하기전 아무 내용이 없는 div 부분 복사 => 업로드 완료 후 복사된 객체를 div 내에 다시 추가해서 첨부파일 부분 초기화 시킴(파일 업로드 또 할수있게 화면 조정).
			
			$("#uploadBtn").on("click", function(e){
				var formData = new FormData();
			}
			...
			
			
			$.ajax({
				...
				success : function(result){
					console.log(result);
					
					$(".uploadDiv").html(cloneObj.html()); //업로드 화면 부분 초기화
				}
			});
			
			```		
			
	#### 2. 업로드된 이미지 처리
	**업로드 된 결과는 json 형태로 받아왔기 때문에 이를 이용해서 홤녀에 적절한 섬네일을 보여주거나 화면에 파일 아이콘 등을 보여주어서 결과를 피드백 해줄 필요가 있음.**
		
	- 파일 이름 출력
		1) `<ul>` 태그 내에 업로드된 파일 이름 출력
				```jsp
				//uploadAjax.jsp 일부
					<div class="uploadDiv">
						<input type="file" name="uploadFile" multiple>
					</div>
					
					<div class="uploadResult">
						<ul>
						</ul>
					</div>	
				```
			
		2) 일반 파일의 파일처리
			업로드 목록과 함께 첨부파일 이미지(attach.png)가 보이게 수정
			
		3) 섬네일 이미지 보여주기
		- 섬네일은 서버를 통해서 특정 URI를 호출하면 보여줄 수 있도록 처리하는데, 해당 파일의 경로와 uuid가 붙은 파일의 이름이 필요함 (GET 방식 처리)
		
		- 서버에 전송하는 데이터: '파일의 경로'+'s_'+'uuid가 붙은 파일이름' (이때 경로나 파일이름에 한글 혹은 공백등의 문자가 들어가면 문제가 발생할수 있으므로 encodeURIComponent() 함수를 이용)
		
					```java
					//UploadController의 일부
					@GetMapping("/display")
						@ResponseBody
						public ResponseEntity<byte[]> getFile(String fileName){ //특정한 파일 이름을 받아서 이미지 데이터를 전송하는 코드
							...
							File file = new File("c:\\upload\\" + fileName);
							...
							ResponseEntity<byte[]> result = null;
							
							//byte로 이미지 파일의 데이터를 전송할때 신경 쓰이는 것은 브라우저에 보내주는 MIME타입이 파일의 종류에 따라 달라진다는 점! 
							//이 부분을 해결하기위해 probeContentType()을 이용해서 ㅈ거절한 MIME 타입 데이터를 Http의 헤더 메시지에 포함할 수 있도록 처리.
							try{
								HttpHeaders header = new HttpHeaders();
								
								header.add("ContentType", Files.probeContentType(file.toPath()));
								result = new ResponseEntity<>(FileCopyUtills.copyToByteArray(file), header, HttpStatus.OK);
							}
							...
							return result;
						}
					```
		- jsp
			파일이름에 포함된 공백문자 및 한글이름 등 처리를 위해 JS에 encodeURIComponent() 처리 	

### 24. 첨부파일의 다운로드 혹은 원본 보여주기
	* Resource 참고: https://always-develop.tistory.com/37
	

	
