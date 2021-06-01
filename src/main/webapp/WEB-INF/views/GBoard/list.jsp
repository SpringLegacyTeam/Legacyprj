<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<style>
  .register-btn{
    margin-bottom:50px;
  }
</style>
	
<%@ include file="../includes/header.jsp"%>
  <!--  =============================게시판 헤더 ==================================-->
    <div class="jumbotron">
      <h3>갤러리형 게시판</h3>
    </div>
 <!--  ===========================글 등록 ===================================-->
    <div class="row register-btn" >
      <div class="col-lg-12">
        <form>
          <div class="col-lg-2">
            <select class="form-control" >
              <option value="title">제목</option>
              <option value="contents">내용</option>
              <option value="writer">작성자</option>
            </select>
          </div>
          <div class="col-lg-4">
            <div class="input-group">
              <input type="text" class="form-control"/>
              <div class="input-group-btn">
                <button class="btn btn-default" type="submit" ><i class="glyphicon glyphicon-search"></i></button>
              </div>
            </div>
          </div>
        </form>
          <div class="col-lg-6 text-right">
            <button id="regBtn" class="btn btn-default">글 등록</button>
          </div>
      </div>
    </div>
<!--  ===========================게시글 목록 ===================================-->
    <div class="wrapper">
		<c:forEach items="${list}" var="gboard" varStatus="status">
		      <c:if test="${status.count%4 eq 1}">
			      <div class="row">
			  </c:if>
			        <div class="col-lg-3">
			          <div class="thumbnail">
			            <a href="get?bno=${gboard.bno}" target="_blank">
			             <img src="${pageContext.request.contextPath}/resources/img/macaron.jpg" alt="이미지" style="width:100%;height:300px;">
			            </a>
			              <div class="caption">
			                <p>
			                  <a href="get?bno=${gboard.bno}">${gboard.title}</a>
			                </p>
			                  <img src="${pageContext.request.contextPath}/resources/img/userimage.jpg" style="width:30px;height:30px;"/> 
			                  <span>${gboard.writer}</span> 
			                  <button type="button" class="btn btn-default btn-sm">
			                    <span class="glyphicon glyphicon-thumbs-up"></span> 추천수 ${gboard.recommend} 
			                  </button> 
			              </div>
			          </div>
			        </div><!--//col-lg-3--> 
		      <c:if test="${status.count%4 eq 0}">
		      	</div><!--//row-->
		      </c:if>
		 </c:forEach>
		 
		  <!-- Modal -->
                            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                            <h4 class="modal-title" id="myModalLabel">알림</h4>
                                        </div>
                                        <div class="modal-body">
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                    <!-- /.modal-content -->
                                </div>
                                <!-- /.modal-dialog -->
                            </div>
                            <!-- /.modal -->
    </div><!--//wrapper-->  
<!--  ===========================페이지 매김 ===================================-->
    <ul class="breadcrumb text-center" >
      <li><a href="#">1</a></li>
      <li><a href="#">2</a></li>
      <li><a href="#">3</a></li>
    </ul>
  	<br><br>

<%@ include file="../includes/footer.jsp"%>


<script type="text/javascript">
		 var result ='<c:out value="${result}"/>';
		 
		 checkModal(result);
		 
		 history.replaceState({},null,null);
		 
		 function checkModal(result){
			 if(result==='' || history.state){
				 return;
			 }
			 
			 if(parseInt(result)>0){
				 $(".modal-body").html("게시글"+parseInt(result)+"번이 등록되었습니다.");
			 }else if(result.toString()==='msuccess'){
				 $(".modal-body").html("수정이 완료되었습니다.");
			 }else if(result.toString()==='dsuccess'){
				 $(".modal-body").html("수정이 완료되었습니다.");
			 }
			 
			 $("#myModal").modal("show");
		 }
		 
		 $("#regBtn").on("click",function(){
			self.location = "/GBoard/register"; 
		 });
</script>
