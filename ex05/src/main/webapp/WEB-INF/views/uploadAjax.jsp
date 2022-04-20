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


<!-- 
<script src="https://code.jquery.com/jquery-3.4.1.js"   
	integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="   
	crossorigin="anonymous">
</script> 
-->
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script>
	$(document).ready(function(){
					
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$"); //정규표현식 참고: https://webclub.tistory.com/95 , https://soooprmx.com/%EC%A0%95%EA%B7%9C%ED%91%9C%ED%98%84%EC%8B%9D%EC%9D%98-%EA%B0%9C%EB%85%90%EA%B3%BC-%EA%B8%B0%EC%B4%88-%EB%AC%B8%EB%B2%95/
		var maxSize = 5242880; //5MB
		
		//첨부파일 확장자나 크기의 사전처리
		function checkExtension(fileName, fileSize){
			
			if(fileSize >= maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}
			return true;
		}
		
		
		
		//첨부파일 등록하기 
		$("#uploadBtn").on("click", function(e){
			
			//jquery사용시 파일업로드는 FormData라는 객체를 이용 (=가상의 form태그와 같음)
			//FormData를 이용해서 필요한 파라미터를 담아서 전송하는 방식
			var formData = new FormData(); //가상의 form 태그
			
			var inputFile = $("input[name='uploadFile']");
			
			var files = inputFile[0].files;
			console.log(files);
			
			//add filedata to formdata
			for(var i=0; i<files.length; i++){
				
				//첨부파일 확장자와 사이즈 체크
				if(!checkExtension(files[i].name, files[i].size)){
					return false;
				}
				
				formData.append("uploadFile", files[i]);
			}
			
			//첨부파일 데이터는 formData에 추가한뒤 Ajax를 통해서 formData 자체를 전송. 이때 processData와 contentType은 반드시 false 여야함.
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false,
				contentType: false,
				data: formData,
				type: 'POST',
				dataType: 'json',
				success: function(result){
					alert("Uploaded");
					console.log(result);
				}
			});
			
		});
	});
</script>

</body>
</html>