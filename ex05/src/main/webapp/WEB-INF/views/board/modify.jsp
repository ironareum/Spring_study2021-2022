<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<style type="text/css">
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	
	.uploadResult ul{
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-times: center;
	}
	
	.uploadResult ul li{
		list-style: none;
		padding: 10px;
		align-content: center;
		text-align: center;
	}
	
	.uploadResult ul li img{
		width: 40px;
	}
	
	.uploadResult ul li span{
		color: white;
	}
	
	.bigPictureWrapper{
		position: absolute;
		display: none;
		justify-conent: center;
		align-items:center;
		top:0%;
		width: 100%;
		height: 100%;
		background-color: gray;
		z-index: 100;
		background: rgba(255,255,255,0.5);
	}
	
	.bigPicture{
		position:relative;
		dispay:flex;
		justify-content:center;
		align-items:center;
	}
	
	.bigPicture img{
		width:600px;
	}
</style>

<%@ include file ="../includes/header.jsp" %>
			
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Modify Page</h1>
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
                        	
                        	<form role="form" action="/board/modify" method="post">
                    
                        		<div class="form-group">
                        			<label for="bno">Bno</label>
                        			<input class="form-control" name="bno" 
                        			value='<c:out value="${board.bno}"/>' readonly="readonly"/>
                        		</div>
                        		
                        		<div class="form-group">
                        			<label for="title">Title</label>
                        			<input class="form-control" name="title"
                        			value='<c:out value="${board.title}"/>'/>
                        		</div>
                        		
                        		<div class="form-group">
                        			<label for="content">Text area</label>
                        			<textarea class="form-control" rows="3" name="content"><c:out value="${board.content}"/>
                       				</textarea>
                        		</div>

                        		<div class="form-group">
                        			<label for="writer">Writer</label>
                        			<input class="form-control" name="writer"
                        			value='<c:out value="${board.writer}"/>'/>
                        		</div>

                        		<div class="form-group">
                        			<label for="regDate">RegDate</label>
                        			<input class="form-control" name="regDate"
                        			value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regdate}"/>' readonly="readonly"/>
                        		</div>

                        		<div class="form-group">
                        			<label for="updateDate">Update Date</label>
                        			<input class="form-control" name="updateDate"
                        			value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate}"/>' readonly="readonly"/>
                        		</div>
                        		
                        		<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum}'/>"/>
	                            <input type="hidden" name="amount" value="<c:out value='${cri.amount}'/>"/>
	                            <input type="hidden" name="type" value="<c:out value='${cri.type}'/>"/>
	                            <input type="hidden" name="keyword" value="<c:out value='${cri.keyword}'/>"/>
                        		
                        		<button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
                        		<button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
                        		<button type="submit" data-oper="list" class="btn btn-info">List</button>
                        		
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
        	<div class="bigPictureWrapper">
        		<div class="bigPicture">
        		</div>
        	</div>
        	
        	<div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                    
                        <div class="panel-heading">Files</div>
                        
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


<!-- 수정/삭제/목록 버튼 -->
<script type="text/javascript">
	$(document).ready(function(){
		
		var formObj = $("form");
		
		$('button').on('click', function(e){
			e.preventDefault();
			
			//버튼 항목
			var operation = $(this).data("oper");
			console.log(operation);
			
			if(operation === 'remove'){
				formObj.attr("action", "/board/remove");
			
			} else if(operation === 'list'){
				//move to list
				formObj.attr("action", "/board/list").attr("method", "get");
				
				var pageNumTag = $('input[name="pageNum"]').clone();
				var amountTag = $('input[name="amount"]').clone();
				var keywordTag = $('input[name="keyword"]').clone();
				var typeTag = $('input[name="type"]').clone();
				
				formObj.empty();
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
			
			} else if(operation === 'modify'){
				console.log("submit clicked");
				
				var str ="";
				
				$(".uploadResult ul li").each(function(i, obj){
					
					var jobj = $(obj);
					//console.log("obj: "+obj); //HTML LI Element (=list element)
					//console.log("jobj:"+ jobj); //Object
					console.dir(jobj);
					
					str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"' />"; 
					str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"' />";
					str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"' />";
					str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"' />";
				});
				
				//첨부파일 정보 form에 추가 
				formObj.append(str).submit();
			}		
			
			formObj.submit();
			
		});
	});
</script>


<!-- 첨부파일 관련  -->
<script>
	<!-- 첨부파일 로드 -->
	$(document).ready(function(){
		(function(){
			var bno = '<c:out value="${board.bno}"/>';
			$.getJSON("/board/getAttachList", {bno:bno}, function(arr){
				console.log(arr);
				var str = "";
				
				$(arr).each(function(i, obj){
					//image type
					if(obj.fileType){
						//파일경로 인코딩, 첨부파일의 정보를 
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_"+ obj.fileName);
						
						str += "<li data-path='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid +"' ";
						str +=	" data-filename='" + obj.fileName +"' data-type='"+ obj.fileType +"'>"; 
						str += 	"<div>";
						str += 		"<span>"+obj.fileName +"</span>";
						str += 		"<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' ";
						str += 		"class='btn btn-warning btn-circle'><i class='fa fa-times'/></button><br>"
						str += 		"<img src='/display?fileName=" + fileCallPath + "'>";
						str += 	"</div>";
						str + "</li>";
						
					}else {				
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_"+ obj.fileName);
						var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
						
						str += "<li data-path='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid +"' ";
						str +=	" data-filename='" + obj.fileName +"' data-type='"+ obj.fileType +"'>"; 
						str += 	"<div>";
						str +=      "<span>"+obj.fileName+"</span>";
						str += 		"<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' ";
						str += 		"class='btn btn-warning btn-circle'><i class='fa fa-times'/></button><br>"
						str += 		"<img src='/resources/img/attach.png'>";
						str += 	"</div>";
						str + "</li>";
					}
				});
				
				$(".uploadResult ul").html(str);
				
			});//end getJson
		})(); //end function
	});
	
	
	
	//첨부파일 삭제
	$(".uploadResult").on("click", "button", function(e){
		console.log("delete file");
		
		if(confirm("Remove this file? ")){	
			var targetLi = $(this).closest("li");
			//화면상에서만 삭제 => 실제 파일삭제는 게시물의 수정버튼을 누르고 처리되는 과정에서 이뤄지도록 함.(데이터베이스와 비교해서 상이한 부분.)
			targetLi.remove();
		}
	});
	
	
	//첨부파일 추가  
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
	
	//input type=file 내용이 변경되는것을 감지하려 업로드 처리 
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
	
	
</script>    