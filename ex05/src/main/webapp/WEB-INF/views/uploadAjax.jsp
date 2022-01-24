<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple/>
	</div>
	<button id="uploadBtn">Upload</button>


	<!-- <script src="https://code.jquery.com/jquery-3.4.1.js"   
		integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="   
		crossorigin="anonymous">
	</script> -->
	<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
	<script>
		$(document).ready(function(){
			$("#uploadBtn").on("click", function(e){
				//jquery사용시 파일업로드는 FormData라는 객체를 이용 (=가상의 form태그와 같음)
				//FormData를 이용해서 필요한 파라미터를 담아서 전송하는 방식
				var formData = new FormData(); 
				
				var inputFile = $("input[name='uploadFile']");
				
				var files = inputFile[0].files;
				console.log(files);
			});
		});
	</script>

</body>
</html>