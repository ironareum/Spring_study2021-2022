<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<%@ include file ="../includes/header.jsp" %>
			
	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header">Board Register</h1>
	    </div>
	</div>
	<!-- /. row -->
	
	<!-- Board (s) -->
	<div class="row">
	    <div class="col-lg-12">
	        <div class="panel panel-default"> 
	            <div class="panel-heading">Board Register</div>
	            
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
	            </div> <!-- (e) panel-body -->
	            
	        </div>
	    </div>
	</div>
	<!-- Board (e) -->
	
	
	<!-- 댓글 (s) -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					<i class="fa fa-comments fa-fw"></i> Reply
					<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New</button>
				</div>
			
				
				<!-- panel body -->
				<div class="panel-body">
					<ul class="chat">
						<li class="left clearfix" data-rno='12'>
							<div>
								<div class="header">
									<strong class="primary-font">user00</strong>
									<small class="pull-right text-muted">2018-01-01 13:13</small>
								</div>
								<p>Good job!</p>
							</div>
						</li>
					</ul>
				</div>
				<!-- // panel body -->
				
				<!-- reply pagination -->
				<div class="panel-footer">
					
				</div>
			</div>
		</div>
	</div>
	<!-- 댓글 (e) -->
	
	<!-- modal (s) -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" >
		<div class="modeal-dialog">
			<div class="modal-content">
				
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >REPLY MODAL</h4>
				</div>
				
				<div class="modal-body" >
					<div class="form-group" >
						<label>Reply</label>
						<input class="form-control" name="reply" value="unloaded" />
					</div>
					<div class="form-group" >
						<label>Replyer</label>
						<input class="form-control" name="replyer" value="unloaded" />
					</div>
					<div class="form-group" >
						<label>Reply Date</label>
						<input class="form-control" name="replyDate" value="unloaded" />
					</div>
				</div>
				
				<div class="modal-footer" >
					<button id="modalModfBtn" type="button" class="btn btn-warning" >Modify</button>
					<button id="modalRemoveBtn" type="button" class="btn btn-danger" >Remove</button>
					<button id="modalRegisterBtn" type="button" class="btn btn-default" >Register</button>
					<button id="modalCloseBtn" type="button" class="btn btn-default" >Close</button>
				</div>
				
			</div>
		</div>
	</div>
	<!-- modal (e) -->
        	        	
<%@ include file="../includes/footer.jsp" %>


<!-- reply 관련 스트립트  -->
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script>
$(document).ready(function(){	
	var bnoValue = '<c:out value="${board.bno}"/>';
	var replyUL = $(".chat");
	var pageNum = 1;
	var replyPageFooter = $(".panel-footer");
	
	/* reply 관련 초기화 */
	showList(1);	
	function showList(page){
		console.log("show reply list page at "+ page);
		
		replyService.getList({bno:bnoValue, page:page||1}, 
			function(result){	
				var replyCnt = result.replyCnt;
				var list = result.list;
				console.log("replyCnt: ", replyCnt);
				console.log("list: ", list);
				
				if (page == -1){ /* 새로운 댓글 추가시 호줄함수 : showList(1). 현재는 책에서 처럼 새로운 댓글이 맨 마지막 페이지에 보여진다는 가정하에 -1로 호출 */
					pageNum = Math.ceil(replyCnt /10.0);
					showList(pageNum);
					return;
				}
				
				var str="";
				
				if(list == null || list.length == 0){
					replyUL.html("");
					return ;	
				}
				
				for(var i = 0, len = list.length||0 ; i < len; i++ ){
					console.log(list[i]);
					
					str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
					str += "	<div><div class='header'><strong class='primary-font'>["+list[i].rno+"] " + list[i].replyer + "</strong>";
					str += "		<small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small>"; /* replyService.displayTime(list[i].replyDate) */
					str += "	</div><p>" + list[i].reply + "</p></div></li>";
				}
				
				/* reply 목록 초기화 */
				replyUL.html(str);
				
				/* reply pagination 초기화 */
				showReplyPage(replyCnt);
			});
	}
	/* 댓글목록 초기화 (e)*/
	
	
	/* reply pagination 목록 생성 */
	function showReplyPage(replyCnt){
		var endNum = Math.ceil(pageNum / 10.0) *10;
		var startNum = endNum -9;
		
		var prev = startNum !=1;
		var next = false;
		
		if(endNum *10 >= replyCnt){
			endNum = Math.ceil(replyCnt/10.0);
		}
		
		if(endNum *10 < replyCnt){
			next = true;
		}
		
		var str ="<ul class='pagination pull-right'>";
		
		if(prev){
			str += "<li class='page-item'><a class='page-link' href='" + (startNum-1)+"'> Previous </a></li>";
		}
		
		for(var i= startNum; i<= endNum; i++){
			var active = pageNum == i? "active":"";
			str += "<li class='page-item "+ active +"'> <a class='page-link' href='" + i + "'>"+ i+"</a></li>"
		}
		
		if(next){
			str += "<li class='page-item'> <a class='page-link' href='" + (endNum +1) + "> Next </a></li>";
		}
		
		str += "</ul>";
		
		console.log("reply pagination: ", str);
		
		replyPageFooter.html(str);
	}
	
	

	/***************  
	** reply 페이지 번호 클릭시 작동 함수 **
	****************/
	replyPageFooter.on("click", "li a", function(e){
		e.preventDefault();
		console.log("page click");
		
		var targetPageNum = $(this).attr("href");
		console.log("targetPageNum: "+ targetPageNum);
		
		pageNum = targetPageNum; /* 현재 페이지 변수에 저장 */
		showList(pageNum);
	})
	
	
	
	
	/***************  
	** 모달 작동 함수 **
	****************/
	var modal = $(".modal")
	
	/* modal inputs */
	var modalInputReply = modal.find("input[name='reply']");
	var modalInputReplyer = modal.find("input[name='replyer']");
	var modalInputReplyDate = modal.find("input[name='replyDate']");
	
	/* modal Btns */
	var modalModfBtn = $("#modalModfBtn");
	var modalRemoveBtn = $("#modalRemoveBtn");
	var modalRegisterBtn = $("#modalRegisterBtn");
	var modalCloseBtn = $("#modalCloseBtn");
	
	/* New reply */
	$("#addReplyBtn").on("click",function(e){
		modal.find("input").val("");
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id != 'modalCloseBtn']").hide();
		modalRegisterBtn.show();
		
		$(".modal").modal("show");
	});
	
	
	/* 댓글 등록 버튼 on 모달 */
	modalRegisterBtn.on("click", function(){
		var reply = {
				reply: modalInputReply.val(),
				replyer: modalInputReplyer.val(),
				bno: bnoValue
		}
		
		replyService.add(reply, 
				function(result){
					alert(result + " - register reply!");
					modal.find("input").val("");
					modal.modal("hide");
					showList(1); //댓글 초기화
					
				}, function(){
					alert(result + " - err: register");
				});
	});
	
	
	/* 개별 댓글 띄우기 on modal  */
	/* 이벤트리스너 동적 적용 .chat -> li에게 이벤트 위임(delegation) */
	$(".chat").on("click", "li", function(e){
		
		var rno = $(this).data("rno");
		
		replyService.get(rno
				, function(replyVo){
					console.log("replyVo: ", replyVo);
					modalInputReply.val(replyVo.reply);
					modalInputReplyer.val(replyVo.replyer);
					modalInputReplyDate.val(replyService.displayTime(replyVo.replyDate)).attr("readonly", "readonly");
					
					modal.data("rno", replyVo.rno); /* data 속성추가. 수정 삭제시 필요 */
					
					modal.find("button[id != modalCloseBtn]").hide();
					modal.find("button[id = modalModfBtn]").show();
					modal.find("button[id = modalRemoveBtn]").show();					
				});

		$(".modal").modal("show");
	})
	
	/* 모달창 닫기 */
	modalCloseBtn.on("click", function(e){
		modal.modal("hide");
	});
	
	/* 댓글 수정 on modal */
	modalModfBtn.on("click", function(e){
		var reply = {
				rno : modal.data("rno"),
				reply: modalInputReply.val()
		};
				
		replyService.update(reply, function(result){
			
			alert(result +" - update reply");
			modal.modal("hide");
			showList(pageNum);
			
		});
	});
	
	
	/* 댓글 삭제 on modal */
	modalRemoveBtn.on("click", function(e){
		var rno = modal.data("rno");
		replyService.remove(rno, function(result){
			
			alert(result +" - remove");
			
			modal.modal("hide");
			showList(pageNum);
		});
	});
	
});
	
	/********************** 
	* ajax 댓글처리 테스트 (s) * 
	***********************/
	console.log("=========");
	console.log("JS TEST");
	
	var bnoValue = '<c:out value="${board.bno}"/>';
	console.log("bno: ", bnoValue);
	
	/* 댓글 삽입 */
	/* replyService.add(
		{reply:"JS TEST", replyer: "tester", bno: bnoValue},
		function(result){
			alert("RESULT: "+ result);
		},
		function(err){
			alert("error: insert");
		}); */
	
	/*  댓글 리스트 조회 */	
	/*  replyService.getList({bno:bnoValue, page: 1}, function(list){
		for(var i = 0, len = list.length || 0; i < len; i++ ){
			console.log(list[i]);
		}
	});  */
	
	/* 댓글 삭제 */
	/* replyService.remove(24, function(result){
		console.log(result);
		if(result === 'success'){
			alert("Removed");
		}
	}, function(err){
		alert("Error : remove");
	});  */
	
	/* 댓글 수정 */
	/* replyService.update({rno: 54, bno: bnoValue, reply: "수정되고 있어??????????????????"}
	, function(result){
		console.log("update result: "+ result);
		alert("수정 완료..." + result ); }
	, function(err){
		alert("Error : modify");
	}); */
	
	/* 단일 댓글 조회 */
	/* replyService.get(42, function(data){
		console.log("단일댓글 data: ",data);
	});  */

</script>
<!-- //reply 관련 스트립트 (e) -->

<!-- board 관련 함수 -->
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