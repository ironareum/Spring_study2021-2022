<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>



<%@ include file ="../includes/header.jsp" %>

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
		background-color: gray;
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
			
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Register</h1>
                </div>
                <!-- /. col-lg-12 -->
            </div>
            <!-- /. row -->
            
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                    
                        <div class="panel-heading">Board Register</div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            
                        	<form role="form" action="/board/register" method="post">
                        		<div class="form-group">
                        			<label for="title">Title</label>
                        			<input class="form-control" type="text" name="title"/>
                        		</div>
                        		
                        		<div class="form-group">
                        			<label for="content">Text area</label>
                        			<textarea class="form-control" rows="3" name="content"></textarea>
                        		</div>

                        		<div class="form-group">
                        			<label for="writer">Writer</label>
                        			<input class="form-control" name="writer">
                        		</div>
                        		<button type="submit" class="btn btn-default">Submit Button</button>
                        		<button type="reset" class="btn btn-default">Reset Button</button>
                        	</form>
                            
                        </div>
                        <!-- (e) panel-body -->
                    </div>
                    <!-- (e) panel -->
                </div>
                <!-- (e) col-lg-6 -->
            </div>
            <!-- (e) row -->
        	
        	
        	
        	<!-- 첨부파일 -->
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-heading">File Attach</div>
						
						<div class="panel-body">
							<!-- 파일등록 -->
							<div class="form-group uploadDiv">
								<input type="file" name="uploadFile" multiple>
							</div>
							
							<!-- 파일등록 결과 -->							
							<div class="uploadResult">
								<ul></ul>
							</div>
						</div>
						
						
					</div>
				</div>
			</div>        	
        	
        	
        	
        	
<%@ include file="../includes/footer.jsp" %>
    
    
<script>
$(document).ready(function(e){
	
	var formObj = $("form[role='form']");
	var cloneObj = $(".uploadDiv").clone(); 
	console.log("form[role='form'] => " + formObj);
	
	$("button[type='submit']").on("click", function(e){
		e.preventDefault();
		
		console.log("submit clicked");
		
		var str ="";
		
		$(".uploadResult ul li").each(function(i, obj){
			var jobj = $(obj);
			console.dir(jobj);
			
			str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
		});
		
		formObj.append(str).submit();
	});
	
	
	//input type=file 내용이 변경되는것을 감지하려 업로드 처리 
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880; //5MB
	
	function checkExtension(fileName, fileSize){
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드 할 수 없습니다.");
			return false;
		}
		return true;
	}
	
	//업로드 결과화면
	function showUploadResult(uploadResultArr){
		if(!uploadResultArr || uploadResultArr.length == 0) {return;}
		var uplaodUL = $(".uploadResult ul");
		var str ="";
		
		$(uploadResultArr).each(function(i, obj){
			
			//image type
			if(obj.image){	
				//파일경로 인코딩, 첨부파일의 정보를 
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_"+ obj.fileName);
				
				str += "<li data-path='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid +"' ";
				str +=	" data-filename='" + obj.fileName +"' data-type='"+ obj.image +"'>"; 
				str += 	"<div>";
				str += 		"<span> "+ obj.fileName + "</span>";
				str += 		"<button type='button' data-file=\'" + fileCallPath +"\' data-type='image' "; 
				str += 			" class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += 		"<img src='/display?fileName=" + fileCallPath + "'>";
				str += 	"</div>";
				str + "</li>";
				
			}else {				
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_"+ obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				
				str += "<li data-path='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid +"' ";
				str +=	" data-filename='" + obj.fileName +"' data-type='"+ obj.image +"'>"; 
				str += 	"<div>";
				str += 		"<span> "+ obj.fileName + "</span>";
				str += 		"<button type='button' data-file=\'" + fileCallPath +"\' data-type='file' "; 
				str += 			" class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += 		"<img src='/resources/img/attach.png'>";
				str += 	"</div>";
				str + "</li>";

			}
		});
		
		uplaodUL.append(str);
	}
	
	$("input[type='file']").change(function(e){
		var formData = new FormData();
		
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files; //업로드된 파일
		
		for(var i=0; i<files.length; i++){
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
				//alert("Uploaded");
				console.log(result);
				showUploadResult(result); //업로드 결과 처리함수 
				//$(".uploadDiv").html(cloneObj.html());
			}
		});	
	});
	
	//첨부파일 삭제
	$(".uploadResult").on("click", "button", function(e){
		console.log("delete file");
		
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		
		console.log(targetFile);
		
		var targetLi = $(this).closest("li");
		
		$.ajax({
			url: '/deleteFile',
			data: {fileName: targetFile, type: type},
			dataType: 'text',
			type: 'POST',
			success: function(result){
				alert(result);
				targetLi.remove();
				//$(".uploadDiv").html(cloneObj.html());
			}
		});
	});
		
});
</script>    