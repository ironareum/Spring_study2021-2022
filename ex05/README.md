## Part6 파일 업로드 처리

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
	- 1) pom.xml 환경설정 추가
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
	
	- 2) web.xml을 이용하는 경우 첨부파일 설정 (java 설정의 경우 web.xml, servlet-context.xml, root-context.xml 파일 사용안함)
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
				- transferTo(File file): 파일의 저장 **
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
			1)중요: `<form>` 태그 생성시 enctype="multipart/form-data" 설정 필수
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
	####1.
	####2.