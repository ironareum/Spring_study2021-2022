<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="text/css">
	.uploadResult {
		width:100%;
		background-color: gray;
	}
	
	.uploadResult ul{
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li{
		list-style: none;
		padding: 10px;
	}
	
	.uploadResult ul li img{
		width: 40px;
	}
	
	.uploadResult ul li span{
		color: white;
	}
	
	.bigPictureWrapper {
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: grey;
		z-index: 100;
		background: rgba(255,255,255,0.5);
	}
	
	.bigPicture {
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	
	.bigPicture img {
		width: 600px;
	}
	
</style>
</head>
<body>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple/>
	</div>
	
	<div class="uploadResult">
		<ul>
		</ul>
	</div>
	
	<button id="uploadBtn">Upload</button>
	
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
	</div>
	
<!-- 
<script src="https://code.jquery.com/jquery-3.4.1.js"   
	integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="   
	crossorigin="anonymous">
</script> 
-->
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script>
	//ready 바깥에 작성한 이유: 나중에 <a> 태그에서 직접 해당 함수를 호출 할 수 있는 방식으로 작성하기 위함.
	function showImage(fileCallPath){
		//alert(fileCallPath);
		
		$(".bicPictureWrapper").css("display", "flex").show();
		$(".bicPicture").html("<img src='/display?fileName=" + encodeURI(fileCallPath)+ "'>")
		.animate({width: '100%', height: '100%'}, 1000);
	}

	$(document).ready(function(){
					
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$"); //정규표현식 참고: https://webclub.tistory.com/95 , https://soooprmx.com/%EC%A0%95%EA%B7%9C%ED%91%9C%ED%98%84%EC%8B%9D%EC%9D%98-%EA%B0%9C%EB%85%90%EA%B3%BC-%EA%B8%B0%EC%B4%88-%EB%AC%B8%EB%B2%95/
		var maxSize = 5242880; //5MB
		
		var cloneObj = $(".uploadDiv").clone(); 
		var uploadResult = $(".uploadResult ul"); //업로드파일 결과 리스트
		
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
					showUploadFile(result);
					$(".uploadDiv").html(cloneObj.html());
				}
			});
			
		});
		
		//원본이미지 클릭
		$(".bigPictureWrapper").on("click",function(e){
			//이미지 점점 작게 애니메이션
			$(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
			
			//1초 후 이미지 사라짐
			setTimeout(()=>{ //=>는 IE11에서는 동작 안함..!
				$(this).hide();
			}, 1000);
			
			//IE11 식 코드
			/*
			setTimeout(function(){
				$(".bigPrictureWrapper").hide();
			},1000);
			*/
		});
		
		
		function showUploadFile(uploadResultArr){
			var str = "";
			
			$(uploadResultArr).each(function(index, obj){
				if(!obj.image){	
					var fileCallPath = encodeURIComponent(obj.uploadPath +"/"+obj.uuid+"_"+obj.fileName);
					str += "<li><a href='/download?fileName="+fileCallPath+"'><img src='resources/img/attach.png'>" + obj.fileName + "</a></li>";
				}else {
					//str += "<li>"+ obj.fileName + "</li>" ;				
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_"+ obj.fileName);
					
					//RegExp(/\\/g)가 /'원화''원화'/ 로 보이기 때문에 replace 해줌. 
					//정규 표현식 뒤의 "g"는 전체 문자열을 탐색해서 모든 일치를 반환하도록 지정하는 전역 탐색 플래그 
					var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
					originPath = originPath.replace(new RegExp(/\\/g) , "/"); 
					
					str += "<li><a href=\"javascript:showImage(\'" + originPath+"\')\"><img src='/display?fileName=" + fileCallPath +"'>"+obj.fileName+"</a></li>";
				}
			});		
			uploadResult.append(str);	
		}
		
		
		
	});
</script>

</body>
</html>