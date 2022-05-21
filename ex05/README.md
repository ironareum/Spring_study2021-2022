## Part6 파일 업로드 처리

### 0. 파일 업로드 방식
**첨부파일을 서버에 전송하는 방식은 크게 2가지가 있음**
- 브라우저 상에서 첨부파일에 대한 처리 
	1)  <form>태그를 이용하는 방식: 브라우저의 제한이 없어야 하는 경우에 사용
			- 일반적으로 페이지 이동과 동시에 첨부파일을 업로드 하는 방식
			- <iFrame>을 이용해서 화면의 이동없이  첨부파일을 처리하는 방식
	2) Ajax를 이용하는 방식: 첨부파일을 별도로 처리하는 방식
		- <input type='file'>을 이용하고 Ajax로 처리하는 방식
		- HTML5의 Drag And Drop 기능이나 jQuery 라이브러리를 이용해서 처리하는 방식

- 서버쪽 처리(API 사용)
	* 브라우저 상에서 첨부파일을 처리하는 방식은 다양하게 있지만, 서버 쪽에서의 처리는 거의 대부분 비슷함. 응답을 HTML 코드로 하는지 아니면 JSON 등으로 처리하는지 정도의 구분만 하면 됨. (본 예는 주로 Ajax 위주로 처리.)
	1) cos.jar: 2002년 이후에 개발종료. 사용권장 x
	2) commons-fileupload: 가장 일반적으로 많이 활용되고, 서블릿 스펙 3.0 이전에도 사용 가능
	3) 서블릿 3.0이상 - 3.0 이상부터는 자체적인 파일 없로드 처리가 API 상에서 지원
	* 첨부파일은 실제 서버가 동작하는 머신 내에 있는 폴더에 업로드 시켜야 하므로 C드라이브 밑에 upload 폴더와 임시 업로드 파일을 저장할 temp 폴더를 생성함
	*폴더구조*
	```
	upload/
	└── temp/
	```


### 1. 환경설정
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


//java 설정시 
<plugin>
	<groupId>org.apache.maven.plugins</groupId>
	<artifactId>maven-war-plugin</artifactId>
	<version>2.5.1</version>
	<configuration>
	   <failOnMissingWebXml></failOnMissingWebXml>
	</configuration>
</plugin>
```

- web.xml을 이용하는 경우 첨부파일 설정
web.xml의 설정은 WAS(Tomcat) 자체의 설정일뿐, 스프링에서 업로드 처리는 MultipartResolver라는 타입의 객체를 빈으로 등록해야만 가능함. (@servelt-context.xml)

```
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

- java 설정시
```
//WebConfig.java
@Override
protected void customizeRegistration(ServletRegistration.Dynamic registration) {
	registration.setInitParameter("throwExceptionIfNoHandlerFount", "true");
	MultipartConfigElement multipartConfig = new MultipartConfigElement("C:\\upload\\temp", 20971520, 41943040, 20971520);
	registration.setMultipartConfig(multipartConfig);
}

//ServletConfig
@Bean
public MultipartResolver multipartResolver(){
	StandardServletMultipartResolver resolver = new StandardServletMultipartResolver();
	return resolver;
}
```


### 2. <form> 방식의 파일 업로드
	- .jsp (중요: enctype="multipart/form-data 설정)
	```
	<form action="uploadFormAction" method="post" enctype="multipart/form-data">
		<input type="file" name="uploadFile" multiple> <!-- multiple: 하나의 input태그로 한꺼번에 여러 개의 파일을 업로드 할 수 있음 -->
		<button>Submit</button>
	</form>
	```
	- MultipartFile 타입 (파일처리는 MultipartFile이라는 타입을 이용)
	```
	//MultipartFile의 메서드들
	//String getName() : 파라미터의 이름 <input> 태그의 이름
	//String getOriginalFileName(): 업로드되는 파일의 이름
	//boolean isEmpty(): 파일이 존재하지 않는경우 true
	//long getSize(): 업로드 되는 파일의 크기
	//byte[] getBytes(): byte[]로 파일 데이터 반환
	//inputStream getInputStream(): 파일데이터와 연결된 InputStream을 반환
	//transferTo(File file): 파일의 저장
	
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

	
### 3. ajax를 이용한 파일 업로드 (FormData 객체 이용, IE의 경우 10 이후 버전부터 지원)
	


	//추후 커밋 합치기 해보기 