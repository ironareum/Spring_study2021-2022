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
- **Configuration 버전 변경 및 설정 추가** 2 version(xml/java) 

	*pom.xml*
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
  
<!-- Compile : java version 1.8 변경 -->
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

<!-- Servlet : 3.1.0 이상 버전으로 변경-->
<dependency>
	<groupId>javax.servlet</groupId>
	<artifactId>javax.servlet-api</artifactId>
	<version>3.1.0</version>
	<scope>provided</scope>
</dependency>

//https://projectlombok.org에서 jar파일 다운로드 (cmd: java -jar lombok.jar)
//설치 완료 후 Eclipse 실행 경로에 lombok.jar 파일 추가된것 확인
<!-- Lombok 라이브러리 : getter/setter, toString(), 생성자 메서드 자동 생성해줌 -->
<dependency>
	<groupId>org.projectlombok</groupId>
	<artifactId>lombok</artifactId>
	<version>1.18.0</version>
	<scope>provided</scope>
</dependency>

<!-- add test lib : 스프링 동작 테스트-->
<dependency>
	<groupId>org.springframework</groupId>
	<artifactId>spring-test</artifactId>
	<version>${org.springframework-version}</version>
</dependency>

<!-- log4j 추가. 1.2.15 -> 1.2.17 버전으로 변경 -->
<dependency>
	<groupId>log4j</groupId>
	<artifactId>log4j</artifactId>
	<version>1.2.17</version>
	<exclusions>
		<exclusion>
			<groupId>javax.mail</groupId>
			<artifactId>mail</artifactId>
		</exclusion>
		<exclusion>
			<groupId>javax.jms</groupId>
			<artifactId>jms</artifactId>
		</exclusion>
		<exclusion>
			<groupId>com.sun.jdmk</groupId>
			<artifactId>jmxtools</artifactId>
		</exclusion>
		<exclusion>
			<groupId>com.sun.jmx</groupId>
			<artifactId>jmxri</artifactId>
		</exclusion>
	</exclusions>
	<!-- <scope>runtime</scope> -->
</dependency>

<!-- java Test 사용시 단위테스트  (spring-test모듈로 스프링 가동 후) : Junit 버전 반드시 4.10이상 사용 -->
<dependency>
	<groupId>junit</groupId>
	<artifactId>junit</artifactId>
	<version>4.12</version>
	<scope>test</scope>
</dependency>
```

- **java Configuration으로 설정하는 경우** 
```java
//pom.xml
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

<!-- java 설정 패키지 생성필요 (하단 참고) -->
```
- **RootConfig.java (Part5 포함 버전)** 
```java
@Configuration
@ComponentScan(basePackages = {"org.zerock.service"})
@ComponentScan(basePackages = {"org.zerock.aop"}) //part5
@EnableAspectJAutoProxy //part5
//@EnableAspectautoProxy(proxyTargetClass=true) //part5
@EnableTransactionManagement //part5
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
	
	//part5
	@Bean
	public DataSourceTransactionManager txManager() {
		return new DataSourceTransactionManager(dataSource());
	}
}
```

- **WebConfig.java**
```
@Configuration
public class WebConfig extends AbstractAnnotationConfigDispatcherServletInitializer{
	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class[] {RootConfig.class};
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class[] {ServletConfig.class}; //Part1에서는 사용안함 (Web 연결시부터 사용)
	}

	@Override
	protected String[] getServletMappings() {
		return new String[] {"/"}; //Part1에서는 사용안함 (Web 연결시부터 사용)
	}
	
	
  @Override 
  protected void customizeRegistration(ServletRegistration.Dynamic
  registration) {
  registration.setInitParameter("throwExceptionIfNoHandlerFound", "true"); }
	 
}
```


### 2. 스프링의 특징과 의존성 주입
- **의존성 주입(DI) 방식의 기본 개념** 
  
 	A는 B가 필요하다는 신호만 보내고, B객체를 주입하는것은 외부에서 이루어지는 방식. <br>
	DI를 사용하려면 A,B외에 바깥쪽에 추가적인 하나의 존재가 필요(=Application Context)하며, 이 존재는 의존성이 필요한 객체(A)에 필요한 객체(B)를 찾아서 '주입'하는 역할을 함.
	따라서 스프링을 이용하면 기존의 프로그래밍과 달리 객체와 객체를 분리해서 생성하고, 이러한 객체들을 엮는 작업을 하는 형태의 개발을 하게됨. (=Bean 생성) 
	ApplicationContext가 관리하는 객체들을 'Bean'으로 부르고, 빈과 빈 사이의 의존관계를 처리하는 방식으로 XML 설정, 어노테이션 설정, Java 설정 방식을 이용함.
```java
//Chef.java

@Component //Component: 스프링 관리대상 표시
@Data //Data: Lombok의 setter/getter/toString/생성자 자동생성
public class Chef {
	
}
```
```java
//Restaurant.java

@Component
@Data
public class Restaurant {
	@Setter(onMethod_ = @Autowired) //Setter 어노테이션으로 아래 setChef 메소드 없어도 컴파일시 자동생성됨 
	private Chef chef;

	/*
	 * public Chef getChef() { return chef; }
	 * 
	 * public void setChef(Chef chef) { this.chef = chef; }
	 */
}
```
- **의존성 주입 설정**

```java
//root-context.xml

//NameSpaces 탭 > context 항목 체크 > 아래내용 추가 > Beans Graph 확인(Bean 객체 생성)
	<context:component-scan base-package="org.zerock.sample"></context:component-scan>	
</beans>



//RootConfig.java

@Configuration
@ComponentScan(basePackages= {"org.zerock.sample"})
public class RootConfig {
```

- **스프링 동작과정**

	Spring 시작(spring 메모리 영역 생성 = Context)) <br>
	=> Spring의 컨텍스트(ApplicationContext 객체 생성) <br>
	=> Spring이 생성하고 관리해야하는 객체 설정 확인 @root-context.xml (context:component-scan 을 통해 패키지 스캔)<br>
	=> 해당 패키지에 있는 클래스 중 @Component 어노테이션 존재하는 클래스의 인스턴스 생성 (Bean 생성) <br>
	=> 이후 @Autowired 어노테이션 확인 후 객체 


- **단위테스트 진행**
```
//src/test/java/org.zerock.sample
//SampleTests.java

@RunWith(SpringJUnit4ClassRunner.class) //현재 테스트 코드가 스프링을 실행하는 역할 표시
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml") //중요
//@ContextConfiguration(classes = RootConfig.class)
@Log4j //Lombok을 이용해서 로그를 기록하는 Logger를 변수로 생성. 
public class SampleTests {
	@Setter(onMethod_ = {@Autowired})
	private Restaurant restaurant;
	
	@Test //JUnit 테스트 대상 
	public void testExist(){
		assertNotNull(restaurant);
		log.info(restaurant);
		log.info("------------------");
		log.info(restaurant.getChef());
	}
}

```

- **AOP의 지원**

	대부분의 시스템이 **공통**으로 가지고 있는 **보안이나, 로그, 트랜잭션**과 같이 비즈니스 로직은 아니지만, 반드시 처리가 필요한 부분을 스프링에서는 **횡단관심사(cross-confern)** 이라고 하며, AOP를 이용하면 이러한 욍단 관심사를 모듈로 분리해서 제작하는것이 가능하다.



### 3. 스프링과 Orable DataBase 연동 
- **계정생성**
```
CREATE USER book_ex IDENTIFIED BY book_ex
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

GRANT CONNECT, DBA BOOK_EX;
```

- **커넥션풀 설정(Hikari-CP)**

	여러명의 사용자를 동시에 처리해야 하는 웹 애플리케이션의 경우 데이터베이스 연결을 이용할 때는 커넥션 풀을 이용.<br>
	Java에서는 DataSource라는 인터페이스를 통해서 커넥션 풀을 사용함. (매번 데이터베이스와 연결하는방식이 아닌, 미리 연결을 맺어주고 반환하는 구조로 성능향상)
```java
//pom.xml

//HikariCP사용
<!-- HikariCP -->
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>2.7.8</version>
</dependency>
```

```java
//root-context.xml

<--! 커넥션 풀 생성 (s) : log4jjdbc 사용시 driver & url 변경예정 -->
<bean id="hikariConfig" class="com.zaxxer.hikari.HikariConfig">
	<property name="driverClassName" 
	value="oracle.jdbc.driver.OracleDriver"></property> 
	<property name="jdbcUrl" value="jdbc:oracle:thin:@localhost:1521:XE"></property>
	<property name="username" value="book_ex"></property>
	<property name="password" value="book_ex"></property>
</bean>	

<!-- HikariCP Configuration -->
<bean id="dataSource" class="com.zaxxer.hikari.HikariDataSource" destroy-method="close">
	<constructor-arg ref="hikariConfig"></constructor-arg>
</bean>
<--! 커넥션 풀 생성 (e) -->

<context:component-scan base-package="org.zerock.sample"></context:component-scan>


//RootConfig.java

@Configuration
@ComponentScan(basePackages = {"org.zerock.sample"})
public class RootConfig {
	
	//Connection Pool 생성(s)
	@Bean
	public DataSource dataSource() {
		HikariConfig hikariConfig = new HikariConfig();
		hikariConfig.setDriverClassName("oracle.jdbc.driver.OracleDriver");
		hikariConfig.setJdbcUrl("jdbc:oracle:thin:@localhost:1521:XE");
		hikariConfig.setUsername("book_ex");
		hikariConfig.setPassword("book_ex");
		
		HikariDataSource dataSource = new HikariDataSource(hikariConfig);
		return dataSource;
	}
}	
	
```
### 4. Mybatis와 스프링 연동 (Mybatis, SQLSessionFatory, Mapper)
- **Mybatis 설정**
```
//pom.xml

//mybatis/mybatis-spring: MyBatis와 스프링 연동 라이브러리 
<!-- Mybatis -->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.4.6</version>
</dependency>

<!-- Mybatis-spring -->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-spring</artifactId>
    <version>1.3.2</version>
</dependency>

//spring-jdbc/spring-tx: 스프링에서 데이터베이스 처리와 트랜잭션 처리(없으면 에러남)
<!-- Spring-tx -->
<dependency>
	<groupId>org.springframework</groupId>
	<artifactId>spring-tx</artifactId>
	<version>${org.springframework-version}</version>
</dependency>

<!-- Spring-jdbc -->
<dependency>
	<groupId>org.springframework</groupId>
	<artifactId>spring-jdbc</artifactId>
	<version>${org.springframework-version}</version>
</dependency>

```

- **SQLSessionFactory 생성 (SQLSession 을 통해 Connection 생성 > 원하는 SQL 전달 > 결과를 리턴 받음)**
```java
//root-context.xml

<--!  Mybatis: SQLSessionFatory 생성 (s) -->
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
	<property name="dataSource" ref="dataSource"></property>
</bean>
<--! Mybatis: SQLSessionFatory 생성 (e) -->

<--!  Mybatis: Mapper 설정으로 SQL 설정 분리 & 자동처리방식 가능 (s) -->
<mybatis-spring:scan base-package="org.zerock.mapper"/>
<--!  Mybatis: Mapper 설정으로 SQL 설정 분리 & 자동처리방식 가능 (e) -->


//RootConfig.java

@Configuration
@ComponentScan(basePackages = {"org.zerock.sample"})
@MapperScan(basePackages = {"org.zerock.mapper"}) //Mybatis: Mapper 설정으로 SQL 설정 분리 & 자동처리방식 가능
public class RootConfig {
	
	//(MyBatis에서 나올)SQLSessionFactory 생성
	@Bean
	public SqlSessionFactory sqlSessionFactory() throws Exception {
		SqlSessionFactoryBean sqlSessionFactory = new SqlSessionFactoryBean();
		sqlSessionFactory.setDataSource(dataSource());
		return (SqlSessionFactory)sqlSessionFactory.getObject();
	}
```

- **sql.xml 파일 생성**
```java
//src/main/resources/

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper 
	PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" 
	"http://mybatis.org//dtd/mybatis-3-mapper.dtd">
//namespace 는 interface Mapper 클래스명과 동일하게 설정.
<mapper namespace="org.zerock.mapper.TimeMapper">
	<select id="getTime2" resultType="string">
		SELECT sysdate FROM dual
	</select>
</mapper>
```

- **log4jdbc-log4j2 (SQL로그) 설정**
```java
//pom.xml
<!-- log4jdbc-log4j2-jdbc4 (SQL로그)-->
<dependency>
    <groupId>org.bgee.log4jdbc-log4j2</groupId>
    <artifactId>log4jdbc-log4j2-jdbc4</artifactId>
    <version>1.16</version>
</dependency>
```
```java
//src/main/resources/log4jdbc.log4j2.properties 파일 추가
log4jdbc.spylogdelegator.name=net.sf.log4jdbc.log.slf4j.Slf4jSpyLogDelegator
```
```java
//root-context.xml
//log4jdbc를 이용하는 경우 JDBC Driver와 URL 정보 수정필요
<bean id="hikariConfig" class="com.zaxxer.hikari.HikariConfig">
		//<property name="driverClassName" value="oracle.jdbc.driver.OracleDriver"></property> 
		//<property name="jdbcUrl" value="jdbc:oracle:thin:@localhost:1521:XE"></property>
		<property name="driverClassName" value="net.sf.log4jdbc.sql.jdbcapi.DriverSpy"></property>
		<property name="jdbcUrl" value="jdbc:log4jdbc:oracle:thin:@localhost:1521:XE"></property>
		<property name="username" value="book_ex"></property>
		<property name="password" value="book_ex"></property>
	</bean>	

//RootConfig.java
@Bean
	public DataSource dataSource() {
		HikariConfig hikariConfig = new HikariConfig();
		
		hikariConfig.setDriverClassName("net.sf.log4jdbc.sql.jdbcapi.DriverSpy"); //변경
		hikariConfig.setJdbcUrl("jdbc:log4jdbc:oracle:thin:@localhost:1521:xe");  //변경
		hikariConfig.setUsername("book_ex");
		hikariConfig.setPassword("book_ex");
		
		HikariDataSource dataSource = new HikariDataSource(hikariConfig);
		return dataSource;
	}
```

- **로그레벨 변경**
```java
//log4j.xml 파일 (src/main/resources 또는 src/test/resources)

//value 부분 수정: info/warn

<!-- Root Logger -->
<root>
	<priority value="warn" />
	<appender-ref ref="console" />
</root>
//필요시 추가 logger 작성으로 조절 가능 
<logger name="jdbc.audit">
	<level value="warn" />
</logger>
<logger name="jdbc.resultset">
	<level value="warn" />
</logger>
<logger name="jdbc.connection">
	<level value="warn" />
</logger>
```
<br>
<br>
## Part2 스프링 MVC 설정

### 1. 스프링 MVC의 기본구조
//프로젝트 구동은 
//0. **web.xml** 부터 시작 
//1. **ContextLoaderListener** 실행 (w/ context-param:root-context.xml) 
//2. **root-context.xml**에 정의된 bean 설정 읽음 (context에 bean 생성 : DataSource(jdbc), sqlSessionfactory, txManager, service, mapper, aop 등) 
//3. **DispatcherServlet**에서 서블렛 설정 동작 (w/ XmlApplicationContext를 이용해서 init-param:servlet-context.xml 로딩) //제일중요!! 웹관련 처리 준비작업!!
//4. **servlet-context.xml** 설정 읽음 (웹 관련 처리 준비작업 진행(설정:ViewResolver, ResourceHandlers. Bean생성: MultipartResolver & Controller) => 이 과정에서 등록된 Bean들은 기존에 만들어진 Bean들과 연동 됨)


- **환경셋팅**
- 	*pom.xml, root-context.xml, web.xml - java버전 Part1 셋팅과 동일*

- **Servlet 클래스** (Part2 Spring MVC)
```


//ServletConfig.java
@EnableWebMvc
@ComponentScan(basePackages = {"org.zerock.controller, org.zerock.exception"})
public class ServletConfig implements WebMvcConfigurer{

	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
		InternalResourceViewResolver bean= new InternalResourceViewResolver();
		bean.setViewClass(JstlView.class);
		bean.setPrefix("/WEB-INF/views/");
		bean.setSuffix(".jsp");
		registry.viewResolver(bean);
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/resources/**").addResourceLocations("/resources/");
	}
	
	@Bean(name="multipartResolver")
	public CommonsMultipartResolver getResolver() throws IOException {
		CommonsMultipartResolver resolver = new CommonsMultipartResolver();
		
		//10MB
		resolver.setMaxUploadSize(1024*1024*10);
		resolver.setMaxUploadSizePerFile(1024*1024*2);
		resolver.setMaxInMemorySize(1024*1024);
		
		resolver.setUploadTempDir(new FileSystemResource("C:\\upload\\tmp"));
		resolver.setDefaultEncoding("utf-8");
		
		return resolver;
	}
}
```


- **모델2와 스프링MVC**
```
# 모델2 방식
      
  심플하게 비지니스 로직과 화면(view)를 분리.<br> 
  모델 2방식에서 사용자의 Request는 특별한 상황이 아닌 이상 먼저 Controller를 호출 => 데이터처리 => Response 할때 데이터를 View쪽으로 전달. 
  모델 2방식에서는 Servlet API의 RequestDispatcher 등을 이용해서 직접 처리 (불편..) 

# 스프링 MVC 방식 

  사용자의 Request는 Front-Controller인 DisplatcherServlet을 통해 처리 (일단 모든 Request는 DisparcherServelt이 받음)<br>
  이후 HandlerMapping&HanlderAdapter(=Controller) => ViewResolver(=View)를 통해 처리
  
  1. 모든 Request는 DispatcherServlet(Front-Contrller)이 받음 @web.xml 설정 참고
  2. HandlerMapping은 Request의 처리를 담당하는 컨트롤러를 찾기위해 존재 (이 중 RequestMappingHandlerMapping은 @RequestMapping 어노테이션이 적용 된것을 기준으로 판단함)
  3. 적절한 컨트롤러가 찾아졌다면 HandlerAdapter를 이용해서 해당 컨트롤러를 동작시킴
  4. Controller는 실제 Request를 처리하는 로직을 작성 (View에 전달해야 하는 데이터는 주로 Model에 담아서 전달. Controller는 다양한 타입의 결과를 반환하는데 이에대한 처리는 ViewResoler를 이용)
  5. ViewResoler는 Controller가 반환한 결과를 어떤 View를 통해서 처리할지 해석하는 역할 @servlet-context.xml 설정 참고 
  6. View는 실제로 응답 보내야 하는 데이터를 Jsp 등을 이용해서 생성하는 역할 (만들어진 응답은 DisparcherServlet을 통해 전송됨)
  
**Front-Contrller :**
패턴을 이용하는 경우 모든 Request의 처리에 대한 분배가 정해진 방식대로만 동작하기 때문에 좀 더 엄격한 구조를 만들어 낼 수 있음.
```  


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
  
## Part6 파일 업로드 처리

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