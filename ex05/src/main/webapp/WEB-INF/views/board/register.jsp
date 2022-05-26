<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

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
                            
                        	<form action="/board/register" method="post">
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
							<div class="form-group uploadDiv">
								<input type="file" name="uploadFile" multiple>
							</div>
							
							<div class="uploadResult">
								<ul></ul>
							</div>
						</div>
					</div>
				</div>
			</div>        	
        	
        	
        	
        	
<%@ include file="../includes/footer.jsp" %>
    
    
<script>
$.(document).ready(function(e){
	var formObj = $("form[role='form']");
	$("button[type='submit']").on("click", function(e){
		e.preventDefault();
		
		console.log("submit clicked");
	});
});
</script>    