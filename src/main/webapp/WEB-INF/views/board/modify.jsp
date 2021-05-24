<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">수정게시판</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                           글작성
                        </div>
                        <div class="panel-body">
                            <div class="row">
					<div class="col-lg-6">
					<form id="actionForm" action="/board/modify" method="post">
							<div class="form-group">
								<label>제목</label> <input class="form-control" name="title"
									value="<c:out value="${board.title}" />" >

							</div>
							<div class="form-group">
								<label>내용</label> <input class="form-control" name="content"
									value="<c:out value="${board.content}" />" >
							</div>
							<div class="form-group">
								<label>작성자</label> <input type="text" class="form-control" name="writer"
									value="<c:out value="${board.writer}" />" readonly >
							</div>
							<div class="form-group">
								<label>첨부파일</label> <input type="file">
							</div>

							<button type="submit" class="update" data-oper="update">등록</button>
							<button type="submit" class="delete" data-oper="delete">삭제</button>
							<button type="submit" class="list"><a herf="/board/list">목록으로</a></button>
							<input type="hidden" value='<c:out value="${board.bno }"/>' name="bno">
				 <br>
</form>
						<div class="card mb-2">
							<div class="card-header bg-light">
								<i class="fa fa-comment fa"></i> 
							</div>
							<div class="card-body">
								<ul class="list-group list-group-flush">
									<li class="list-group-item">
										<div class="form-inline mb-2">
											<label for="replyId"><i
												class="fa fa-user-circle-o fa-2x"></i></label> <input type="text"
												class="form-control ml-2" placeholder="아이디"
												id="replyId"> <label for="replyPassword"
												class="ml-4"><i class="fa fa-unlock-alt fa-2x"></i></label>
											<input type="password" class="form-control ml-2"
												placeholder="비밀번호" id="replyPassword">
										</div> <textarea class="form-control"
											id="exampleFormControlTextarea1" rows="3"></textarea>
										<button type="button" class="btn btn-dark mt-3"
											onClick="javascript:addReply();">등록</button>
										
									</li>
								</ul>
							</div>
						</div>

					</div>

<input id="bno" type="hidden" value="<c:out value='${board.bno}' />" />
<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
<input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
<input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>' />
<input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>

					<%@include file="../includes/footer.jsp"%>

<script>
$(document).ready(function(){
	
	var actionForm = $("#actionForm");
	
/* 	//목록 페이지로 이동
	$(".list").on("click",function(e){
		e.preventDefault();
		self.location ="/board/list";
	}); */
	
	//버튼의 data-oper속성을 통해 수정/삭제 판단 후 실행
	$('button').on("click", function(e){
		e.preventDefault();
		
		var operation = $(this).data("oper");
		console.log(operation);
		
		//같은 패턴으로 목록/수정등록 또한 가능
		if(operation === 'delete'){
			actionForm.attr("action","/board/remove")
		}else if(operation === 'list'){
			//이전에 봤던 페이지 정보 같이 넘기기
			actionForm.attr("action", "/board/list").attr("method");
			var pageNum= $("input[name='pageNum']").clone();
			var amount=	$("input[name='amount']").clone();
			
			actionForm.empty();
			actionForm.append(pageNum);
			actionForm.append(amount);
		}
		
		actionForm.submit();
	});
	
	
	
	
});
</script>
      