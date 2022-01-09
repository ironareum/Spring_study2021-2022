# Spring_study2021 
코드로 배우는 스프링 웹 프로젝트[개정판]
https://cafe.naver.com/gugucoding
<br>
<br>

## Part1 스프링 개발 환경 구축

### 1. 개발환경설정 
- 기본설정 @eclipse <br>
```java
//UTF-8 설정
Window > Preferences > General > Workspace => Text file encoding 'UTF-8'으로 변경
Window > Preferences > Web => HTML, CSS, JSP Create files 'UTF-8'으로 변경

//STS 설정
Help > Install New Software.. > Name & Location 경로는 찾아보기.

//Tomcat 설정
Tomcat 다운로드 및 설치

//스프링 프로젝트 생성
Spring Legacy Project > Spring MVC Project 생성
//프로젝트 생성시 에러나면 .m2 > repository 폴더 삭제 후 이클립스 재시작
```

- 스프링 구조
```
ex00/
│   Deployment Descriptor. ex00
│   Spring Elements
│   JAX-WS Web Services
└── Java Resource/
│   │   src/main/java       => 작성되는 코드의 경로
│   │   src/main/resource   => 실행할 때 참고하는 기본 경로(주로 설정파일)
│   │   src/test/java       => 테스트 코드 넣는 경로
│   │   src/test/resource   => 테스트 관련 설정파일 보관 경로
│   └── Libraries 
│   JavaScript Resources
│   Deployed Resources
└── src/
│   └── main/
│   │   │   java
│   │   │   resources
│   │   └── webapp 
│   │       │   resources
│   │       └── WEB-INF 
│   │           │   clases
│   │           │   spring
│   │           │   │   appServlet
│   │           │   │   └── servlet-context.xml   => 웹과 관련된 스프링 설정 파일
│   │           │   └── root-context.xml          => 스프링 설정 파일
│   │           │   views                         => 템플릿 프로젝트의 jsp 파일 경로
│   │           │   └── home.jsp
│   │           └── web.xml                       => tomcat의 web.xml 파일
│   └── test
└── target 
    └── pom.xml                                   => Maven이 사용하는 pom.xml
    
```
- Configuration: xml/java 2 versions 
*버전 변경 및 설정 추가*
```java
//pom.xml
// 스프링 프레임워크 버전은 3.1.1로 생성되므로 예제는 5.0.7 버전으로 수정
// pom.xml 변경 이후 Maven > Update Projecct & Maven Dependencies 항목 변경되었는지 체크
<name>ex00</name>
	<packaging>war</packaging>
	<version>1.0.0-BUILD-SNAPSHOT</version>
	<properties>
		<java-version>1.6</java-version>
		<org.springframework-version>5.0.7.RELEASE</org.springframework-version>
		<org.aspectj-version>1.6.10</org.aspectj-version>
		<org.slf4j-version>1.6.6</org.slf4j-version>
	</properties>
  
//java version 1.8
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.5.1</version>
    <configuration>
        <source>1.8</source>
        <target>1.8</target>
        <compilerArgument>-Xlint:all</compilerArgument>
        <showWarnings>true</showWarnings>
        <showDeprecation>true</showDeprecation>
    </configuration>
</plugin>

//Lombok 라이브러리 : getter/setter, toString(), 생성자 자동 생성해줌
//https://projectlombok.org에서 jar파일 다운로드 
//cmd: java -jar lombok.jar
//설치 완료 후 Eclipse 실행 경로에 lombok.jar 파일 추가된것 확인
```

- java Configuration의 경우
```
<!-- web.xml/spring폴더(root-context.xml,servlet-context.xml) 삭제-->
<!-- java Config 사용시 pom.xml 수정-->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-war-plugin</artifactId>
    <version>3.2.0</version>
    <configuration>
        <failOnMissingWebXml>false</failOnMissingWebXml>
    </configuration>
</plugin>

<!-- java version 변경 -->
<properties>
		<java-version>1.8</java-version>
		<org.springframework-version>5.0.7.RELEASE</org.springframework-version>

<!-- Compile 변경 -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>2.5.1</version>
    <configuration>
        <source>1.8</source>
        <target>1.8</target>
        <compilerArgument>-Xlint:all</compilerArgument>
        <showWarnings>true</showWarnings>
        <showDeprecation>true</showDeprecation>
    </configuration>
</plugin>

<!-- java 설정 패키지 생성필요 (하단 참고) -->
```
- RootConfig 클래스 (Part5 포함 버전)
```java
@Configuration
@ComponentScan(basePackages = {"org.zerock.service"})
@ComponentScan(basePackages = {"org.zerock.aop"})
@EnableAspectJAutoProxy
//@EnableAspectautoProxy(proxyTargetClass=true)
@EnableTransactionManagement
@MapperScan(basePackages = {"org.zerock.mapper"})
public class RootConfig {
	
	@Bean
	public DataSource dataSource() {
		
		HikariConfig hikariConfig = new HikariConfig();
		
		hikariConfig.setDriverClassName("net.sf.log4jdbc.sql.jdbcapi.DriverSpy");
		hikariConfig.setJdbcUrl("jdbc:log4jdbc:oracle:thin:@localhost:1521:xe");
		hikariConfig.setUsername("book_ex");
		hikariConfig.setPassword("book_ex");
		
		HikariDataSource dataSource = new HikariDataSource(hikariConfig);
		return dataSource;
	}
	
	@Bean
	public SqlSessionFactory sqlSessionFactory() throws Exception {
		SqlSessionFactoryBean sqlSessionFactory = new SqlSessionFactoryBean();
		sqlSessionFactory.setDataSource(dataSource());
		return (SqlSessionFactory)sqlSessionFactory.getObject();
	}
	
	@Bean
	public DataSourceTransactionManager txManager() {
		return new DataSourceTransactionManager(dataSource());
	}
}
```

- WebConfig 클래스 (Part5 포함 버전)
```
@Configuration
public class WebConfig extends AbstractAnnotationConfigDispatcherServletInitializer{
	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class[] {RootConfig.class};
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class[] {ServletConfig.class};
	}

	@Override
	protected String[] getServletMappings() {
		return new String[] {"/"};
	}
	
	
  @Override 
  protected void customizeRegistration(ServletRegistration.Dynamic
  registration) {
  registration.setInitParameter("throwExceptionIfNoHandlerFound", "true"); }
	 
}
```
### 2. 스프링의 특징과 의존성 주입
- 의존성 주입(DI) 방식의 기본 개념: A는 B가 필요하다는 신호만 보내고, B객체를 주입하는것은 외부에서 이루어지는 방식. 
	DI를 사용하려면 A,B외에 바깥쪽에 추가적인 하나의 존재가 필요(=Application Context)하며, 이 존재는 의존성이 필요한 객체(A)에 필요한 객체(B)를 찾아서 '주입'하는 역할을 함.
	
	

### 3. 스프링과 Orable DataBase 연동 
- 커넥션풀 설정, Hikari-CP

### 4. Mybatis와 스프링 연동 
- log4jdbc-log4j2 


## Part2 스프링 MVC 설정
### 1. 모델2와 스프링MVC

- 모델2 방식
      
  심플하게 비지니스 로직과 화면(view)를 분리.<br> 
  모델 2방식에서 사용자의 Request는 특별한 상황이 아닌 이상 먼저 Controller를 호출 => 데이터처리 => Response 할때 데이터를 View쪽으로 전달. <br>
  모델 2방식에서는 Servlet API의 RequestDispatcher 등을 이용해서 직접 처리 (불편..) 

- 스프링 MVC 방식 

  사용자의 Request는 Front-Controller인 DisplatcherServlet을 통해 처리 (일단 모든 Request는 DisparcherServelt이 받음)<br>
  이후 HandlerMapping&HanlderAdapter(=Controller) => ViewResolver(=View)를 통해 처리


*web.xml*
```java
<servlet-name>appServlet</servlet-name>
  <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
  <init-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>/WEB-INF/spring/appServlet/servlet-context.xml</param-value>
  </init-param>
  <load-on-startup>1</load-on-startup>
</servlet>

<servlet-mapping>
  <servlet-name>appServlet</servlet-name>
  <url-pattern>/</url-pattern>
</servlet-mapping>
```

**Front-Contrller :**
패턴을 이용하는 경우 모든 Request의 처리에 대한 분배가 정해진 방식대로만 동작하기 때문에 좀 더 엄격한 구조를 만들어 낼 수 있음.


## Part3 기본적인 웹 게시물 관리
- 스프링 MVC 프로젝트의 기본구성
  각 영역의 Naming Convention(명명규칙) <br>
  CRUD <br>
  화면처리 <br>
  페이징 처리 <br>
  검색 처리 <br>
  
## Part4 REST 방식과 Ajax를 이용하는 댓글처리
- REST 방식으로 전환
  @RestController <br>
- Ajax 댓글 처리
## Part5 AOP와 트랜잭션
  - AOP
  - 트랜잭션
  
