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
                        	
                        		<div class="form-group">
                        			<label for="bno">Bno</label>
                        			<input class="form-control" name="bno" 
                        			value='<c:out value="${board.bno}"/>' readonly="readonly"/>
                        		</div>
                        		
                        		<div class="form-group">
                        			<label for="title">Title</label>
                        			<input class="form-control" name="title"
                        			value='<c:out value="${board.title}"/>' readonly="readonly"/>
                        		</div>
                        		
                        		<div class="form-group">
                        			<label for="content">Text area</label>
                        			<textarea class="form-control" rows="3" name="content"
                        			 readonly="readonly"><c:out value="${board.content}"/></textarea>
                        		</div>

                        		<div class="form-group">
                        			<label for="writer">Writer</label>
                        			<input class="form-control" name="writer"
                        			value='<c:out value="${board.writer}"/>' readonly="readonly"/>
                        		</div>
                        		
                        		<button data-oper="modify" class="btn btn-default">Modify</button>
                        		
                        		<button data-oper="list" class="btn btn-info">List</button>
                            	
                            	<form id="operForm" action="/board/modify" method="get">
	                            	<input type="hidden" id="bno" name="bno" value="<c:out value='${board.bno}'/>" />
	                            	<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum}'/>"/>
	                            	<input type="hidden" name="amount" value="<c:out value='${cri.amount}'/>"/>
	                            	<input type="hidden" name="type" value="<c:out value='${cri.type}'/>"/>
	                            	<input type="hidden" name="keyword" value="<c:out value='${cri.keyword}'/>"/>
                            	</form>
                        </div>
                        <!-- (e) panel-body -->
                    </div>
                    <!-- (e) panel -->
                </div>
                <!-- (e) col-lg-6 -->
            </div>
            <!-- (e) row -->
        	
        	
        	<!-- 댓글 (s) -->
        	<div class="row">
        		<div class="col-lg-12">
        			<!-- .panel (s) -->
        			<div class="panel panel-default">
        				
        				<!-- panel heading -->
        				<div class="panel-heading">
        					<i class="fa fa-comments fa-fw"></i> Reply
        				</div>
        				
        				<!-- panel body -->
        				<div class="panel-body">
        					<ul class="chat">
        						
        						<!-- start reply -->
        						<li class="left clearfix" data-rno='12'>
        							<div>
        								<div class="header">
        									<strong class="primary-font">user00</strong>
        									<small class="pull-right text-muted">2018-01-01 13:13</small>
        								</div>
        								<p>Good job!</p>
        							</div>
        						</li>
        						<!-- end reply -->
        					</ul>
        					<!-- end ul -->
        				</div>
        				<!-- .panel .chat-panel (e) -->
        				
        			</div>
        		</div>
        	</div>
        	<!-- 댓글 (e) -->
        	
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
                        	<div class="uploadResult">
                        		<ul></ul>
                        	</div>
                        </div>
                    </div>
                </div>
            </div>
        	
<%@ include file="../includes/footer.jsp" %>



<!-- reply 관련 스트립트  -->
<script type="text/javascript" src="/resources/js/reply.js"></script>

<!-- 첨부파일 로드 -->
<script>
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
						str += 		"<img src='/display?fileName=" + fileCallPath + "'>";
						str += 	"</div>";
						str + "</li>";
						
					}else {				
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_"+ obj.fileName);
						var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
						
						str += "<li data-path='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid +"' ";
						str +=	" data-filename='" + obj.fileName +"' data-type='"+ obj.fileType +"'>"; 
						str += 	"<div>";
						str +=      "<span>"+obj.fileName+"</span><br>";				
						str += 		"<img src='/resources/img/attach.png'>";
						str += 	"</div>";
						str + "</li>";
					}
				});
				
				$(".uploadResult ul").html(str);
				
			});//end getJson
		})(); //end function
	});
	
	
	$(".uploadResult").on("click","li",function(e){
		console.log("view image");
		
		var liObj = $(this);
		
		var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
		console.log("liObj.data('path'): " + liObj.data("path"));
		console.log("path : "+ path);
		if(liObj.data("type")){
			showImage(path.replace(new RegExp(/\\/g), "/"));
		}else{
			//download
			self.location = "/download?fileName="+path
		}
	});
	
	/* 2022-06-06 추후 보완작업 필요: 첨부문서 다운로드시, 저장이름 기존 파일명과 동일하게 출력되도록 소스 수정필요 & 이미지파일 확장자 동일하게 다운로드 하도록 소스 수정필요*/
	function showImage(fileCallPath){
		alert(fileCallPath);
		$(".bigPictureWrapper").css("display", "flex").show();
		$(".bigPicture")
		.html("<img src='/display?fileName="+fileCallPath+"'>")
		.animate({width:'100%', height: '100%'}, 1000);
		
	}
	
	$(".bigPictureWrapper").on("click", function(e){
		$(".bigPicture").animate({width:'0%', height: '0%'}, 1000);
		setTimeout(function(){
			$(".bigPictureWrapper").hide();
		}, 1000);
	});
</script>
<script>
	$(document).ready(function(){
		
		var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");
		
		/* showList(1);
		
		function showList(page){
			replyService.getList({bno:bnoValue, page: page || 1}, function(list){
				
				var str="";
				if(list == null || list.length == 0){

					replyUL.html("");
					return;
					
				}
				for(var i = 0, len = list.length || 0; i < len; i++ ){
					str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
					str += "	<div><div class='header'><strong class='primary-font'>" + list[i].replyer + "</strong>";
					str += "		<small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small>";
					str += "</div><p>" + list[i].reply + "</p></div></li>";
				}
				
				replyUL.html(str);
			});
		}
		 */		
	});
	
	/********************** 
	* ajax 댓글처리 테스트 (s) * 
	***********************/
	/* console.log("=========");
	console.log("JS TEST");
	
	var bnoValue = '<c:out value="${board.bno}"/>';
	console.log("bno: ", bnoValue);
	
	//댓글 삽입 
	replyService.add(
		{reply:"JS TEST", replyer: "tester", bno: bnoValue},
		function(result){
			//alert("RESULT: "+ result);
		},
		function(err){
			//alert("error: insert");
		});
	
	//댓글 리스트 조회 	
	replyService.getList({bno:bnoValue, page: 1}, function(list){
		for(var i = 0, len = list.length || 0; i < len; i++ ){
			console.log(list[i]);
		}
	});
	
	//댓글 삭제
	replyService.remove(24, function(result){
		console.log(result);
		if(result === 'success'){
			//alert("Removed");
		}
	}, function(err){
		//alert("Error : remove");
	}); 
	
	//댓글 수정
	replyService.update({rno: 54, bno: bnoValue, reply: "수정되고 있어??????????????????"}
	, function(result){
		console.log("update result: "+ result);
		//alert("수정 완료..." + result ); }
	, function(err){
		//alert("Error : modify");
	});
	
	//단일 댓글 조회 
	replyService.get(42, function(data){
		console.log("단일댓글 data: ",data);
	});
 */
</script>
<script type="text/javascript">
	$(document).ready(function(){
		
		var operForm = $("#operForm");
		
		$("button[data-oper='modify']").on("click", function(e){
			operForm.attr("action", "/board/modify").submit();
		});
		
		$("button[data-oper='list']").on("click", function(e){
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list");
			operForm.submit();
		});
	});
</script>
