<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">자유게시판</h1>
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
							<div class="form-group">
								<label>제목</label> <input class="form-control"
									value="<c:out value="${board.title}" />" readonly>

							</div>
							<div class="form-group">
								<label>내용</label> <input class="form-control"
									value="<c:out value="${board.content}" />" readonly>
							</div>
							<div class="form-group">
								<label>작성자</label> <input type="text" class="form-control"
									value="<c:out value="${board.writer}" />" readonly>
							</div>
							<div class="form-group">
								<label>첨부파일</label> <input type="file">
							</div>

							<button type="submit" class="update">수정</button>
							<button type="submit" class="delete">삭제</button>
							<button type="submit" class="list"><a herf="/board/list">목록으로</a></button>
							
							<form id="actionForm">
								<input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>' >
								<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
  								<input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
  								 	<input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>' />
							 	<input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
							 	<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>
							</form>
							
				 <br>
<!-- 댓글 작성란=============================================================================== -->
						<div class="card mb-2">
							<div class="card-header bg-light">
								<i class="fa fa-comment fa"></i> 
							</div>
							<div class="card-body">
								<ul class="list-group list-group-flush">
									<li class="list-group-item">
										<div class="form-inline mb-2">
											<label for="replyId"><i
												class="fa fa-user-circle-o fa-2x"></i></label>
												 <input type="text" id="rmdReplayer" name="replayer"
												class="form-control ml-2" placeholder="아이디"
												id="replyId"> <label for="replyPassword"
												class="ml-4"><i class="fa fa-unlock-alt fa-2x"></i></label>
											<input type="password" class="form-control ml-2"
												placeholder="비밀번호" id="replyPassword">
										</div> <textarea id="rmdInput" class="form-control" name="reply"
											id="exampleFormControlTextarea1" rows="3"></textarea>
										<button id="rmdBtn"type="button" class="btn btn-dark mt-3">등록</button>
										
									</li>
								</ul>
							</div>
						 </div>
						 
<!-- 댓글 수정시 나오는 모달창=============================================================================== -->						 
<!-- Modal -->
      <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
        aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal"
                aria-hidden="true">&times;</button>
              <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            </div>
            <div class="modal-body">
              <div class="form-group">
                <label>Reply</label> 
                <input class="form-control" name='reply' value='New Reply!!!!'>
              </div>      
              <div class="form-group">
                <label>Replyer</label> 
                <input class="form-control" name='replyer' value='replyer'>
              </div>
              <div class="form-group">
                <label>Reply Date</label> 
                <input class="form-control" name='replyDate' value='2018-01-01 13:13'>
              </div>
      
            </div>
<div class="modal-footer">
        <button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
        <button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
        <button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
        <button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
      </div>          </div>
          <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
      </div>
      <!-- /.modal -->
						 
						 
<!-- 댓글 목록 나오는 란======================================================================== -->
						<div class='row'>

							<div class="col-lg-12">

								<!-- /.panel -->
								<div class="panel panel-default">
									<div class="panel-heading">
										<i class="fa fa-comments fa-fw"></i> 댓글
									</div>
									<!-- /.panel-heading -->
									<div class="panel-body">
										
										<ul class="chat">
										 <li class="left clearfix" data-rno='10'>
										   <div>
										   	<div class="header">
										   	<!-- 댓글 작성자 나오는곳 <strong> -->
										   		<strong class="primary-font"></strong>
										   		<!-- 댓글 작성날짜 나오는곳 <small> -->	
										   		<small class="pull-right text-muted"></small><br>
										   	</div>
										   	<!-- 댓글 내용 나오는곳<p> -->	
										   	<p></p><br>
										   </div>
										  </li> 	
										</ul>
										<!-- ./ end ul -->
									</div>
									<!-- /.panel .chat-panel -->
<!-- 댓글 페이징 번호 생성란 [panel-footer]============================================================================================ -->				
									<div class="panel-footer"></div>


								</div>
							</div>
							<!-- ./ end row -->
						</div>
					

					<%@include file="../includes/footer.jsp"%>

<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	console.log(replyService)
	
	var actionForm = $("#actionForm");
	
	//목록페이지로 이동
	$(".list").on("click",function(e){
		e.preventDefault();
		self.location ="/board/list";
	});
	
	//수정페이지로 이동
	$(".update").on("click",function(e){
		e.preventDefault();
		actionForm.attr("action","/board/modify").attr("method","get").submit();
	});
	
});//end document

$(document).ready(function(){
var bnoValue = '<c:out value="${board.bno}"/>';
var replyChat = $(".chat");
//1.댓글 등록 처리Test======================================================	
	console.log("================");
	console.log("댓글 처리 테스트");

/* 	//reply.js 에서 함수 호출
 	replyService.add(
		{reply:"댓글 등록 테스트", replayer:"윤주영", bno:bno},
		
		function(result){
			alert("결과:  " + result)
		}
	); */ 
//2.댓글 조회 Test=========================================================	
/* 	replyService.getList({bno: bnoValue, page:1}, function(list){
		console.log("댓글 조회 테스트");
		for(var i =0, len = list.length || 0; i <len; i++){
			console.log(list[i]);
		}
	}); */
	
/* //3.댓글 삭제 test========================================================
	replyService.remove(22, function(count){
		console.log(count);
		if(count==="success"){
			alert("삭제성공");
		}
	}, function(err){
		alert("삭제 에러 발생");
	}); */
	
//4.댓글 수정 test=========================================================
	/* replyService.update({
		rno : 34,
		bno : bnoValue,
		reply : "댓글 수정 테스트"
	}, function(result){
		alert("수정 완료");
	}); */
	
//5.특정 댓글 조회 test==========================================================
/* 	replyService.get(10, function(result){
		console.log(result);
	});
	 */
	 
	//댓글 페이징 번호 생성==============================================================================
	var pageNum =1;
	var replyPageFooter = $(".panel-footer"); // 페이징 생성되는 태그
	
	function showReplyPage(replyCnt){
		
		var endNum = Math.ceil(pageNum / 10.0) + 10;
		var startNum = endNum-9;
		
	    var prev = startNum != 1;
		var next = false;
		
		
		if(endNum *10 > replyCnt){
			next= true;
		}
		
		var str = "<ul class='pagination pull-right'>";
		
		if(prev){
			str += "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
		}
		
		for(var i = startNum; i<=endNum; i++){
			var active = pageNum ==i ? "active" :"";
			str += "<li class='page-item"+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
		}
		
		if(next){
			str += "<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
		}
		
		str += "</ul></div>";
		console.log(str);
		replyPageFooter.html(str);
	}	 
	 
	 

//게시글의 조회와 동시에 댓글 목록을 가져온다.===================================================
 	showList(1);
	 
	 //댓글 조회 메서드=========================
	 function showList(page){
		 console.log(page);
		 replyService.getList({bno:bnoValue, page:page||1}, function(replyCnt,list){
			 console.log("replyCnt:  " + replyCnt);
			 console.log("list:  " + list);

			 if(page == -1){
				 pageNum = Math.ceil(replyCnt/10.0);
				 showList(pageNum);
				 return;
			 }
			 
			 var str="";
			 if(list == null|| list.length == 0){
				 return;
			 }
			 for(var i=0, len=list.length||0; i<len; i++){
				 str +=" <li id='rnoid' class='left claerfix' data-rno='"+list[i].rno+"'>";
				 str +="  <div><div class='header'><strong class='primary-font'>"+list[i].replayer+"</strong>";
				 str +="   <small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
				 str +="    <p id='Rereply'>"+list[i].reply+"</p><button id='Replyremove' type='button' data-rno='"+list[i].rno+"'>삭제</button></div></li>";
			 }
			 replyChat.html(str);
			 
			showReplyPage(replyCnt);

	      });//end function
	      
	   }//end showList *
	
	//댓글 관련 버튼============================================================================
	var rmdBtn=$("#rmdBtn"); //댓글 등록버튼
	var rmdInput=$("#rmdInput"); //댓글 작성란
	var rmdReplayer=$("#rmdReplayer"); //댓글 작성자 작성란
	var Replymodify=$("#Replymodify"); //댓글 수정 버튼
	var	Replyremove=$("#Replyremove"); //댓글 삭제버튼
	var Rereply=$("#Rereply"); //
	var modal = $(".modal");
	
	
	//댓글 등록 처리============================================================================
	rmdBtn.on("click", function(e){
		var reply = {
				reply : rmdInput.val(),
				replayer : rmdReplayer.val(),
				bno : bnoValue };
		
		replyService.add(reply, function(result){
			alert("댓글 작성 성공");
			showList(1);
		});
		
		});//end rmdBtn
		
	//댓글 삭제===============================================================================	 
	replyChat.on("click", "button", function(e){
		var rno=$(this).attr("data-rno");
		console.log(rno);
		
		replyService.remove(rno, function(result){
			alert("삭제 완료");
			//showList(1);
			showList(-1);
		});
		
	});


		
	
//댓긓 페이징된 번호를 눌렀을때================================================================================	
	 replyPageFooter.on("click","li a", function(e){
	        e.preventDefault();
	        console.log("page click");
	        
	        var targetPageNum = $(this).attr("href");
	        
	        console.log("targetPageNum: " + targetPageNum);
	        
	        pageNum = targetPageNum;
	        
	        showList(pageNum);
	      });   
	
});	

	
	

</script>
      