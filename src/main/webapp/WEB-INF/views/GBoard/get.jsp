<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<style>
	/* 이미지 슬라이드 크기 조정 */
	 .item>img{
	   min-width:100%;
	   min-height:500px;
	   max-height:500px;
	 }
  .post-info{
    font-size: 17px;
    line-height: 35px;
  }
  .p-contents{
    margin-bottom: 40px;
    border-bottom: 2px solid #CCCC;
    padding-bottom: 20px;
  }
  .rep-contents{
    line-height: 40px;
  }
  .rep-wrapper{
    margin: 20px 0;
  }
  .arep-wrapper{
    margin:20px 0px 200px 20px;
    border:1px solid #cccc;
    padding: 10px;
  }
  .uploadResult{
		width:100%;
		background-color:gray;
	}
	
	.uploadResult ul{
		display:flex;
		flex-flow:row;
		justify-cotnet: center;
		align-items:center;
	}
	
	.uploadResult ul li {
		list-style:none;
		padding:10px;
	}
	
	.uploadResult ul li img{
		width:200px;
	}
	
	.uploadResult ul li span{
		color:white;
	}
</style>
<script>
	$(document).ready(function(){
		(function(){
			var bno = '<c:out value="${gboard.bno}"/>';
			$.getJSON("${pageContext.request.contextPath}/GBoard/getAttachList", {bno: bno}, function(arr){

				var str = "";
				//글내용 위에 이미지슬라이드
				$(arr).each(function(i,attach){
					if(attach.fileType){
						var fileCallPath = encodeURIComponent(attach.uploadPath+"/"+attach.uuid+"_"+attach.fileName);
						if(i===0){
							str += "<div class='item active'> <img src='/GBoard/display?fileName="+fileCallPath+"' style='width:100%;' ></div>"; 							
						}else{
							str += "<div class='item'> <img src='/GBoard/display?fileName="+fileCallPath+"' style='width:100%;' ></div>";	
						}						
					}
				});
				
				var imgResult = $('.items');
				imgResult.append(str);
				
				//첨부파일 목록 썸네일 이미지
				var list="";
				$(arr).each(function(i,attach){
					if(attach.fileType){
						var path = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
						list += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
						list += "<img src='/GBoard/display?fileName="+path+"'>";
						list += "</div>";
						list += "</li>";
					}
				});
				$(".uploadResult ul").html(list);
				
			});//end getjson
		})();//end function
		
		$(".uploadResult").on("click","li",function(e){
			console.log("view image");
			var liObj = $(this);
			
			var imgPath = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
			
			self.location = "/GBoard/download?fileName="+imgPath;
		});
	});
</script>

<%@ include file="../includes/header.jsp"%>
      <!----------------------- 게시판 헤더  ------------------------------->
    
      <div class="jumbotron">
        <h3>갤러리형 게시판</h3>
      </div>
    
    <!------------게시글 내용, 작성자, 작성일, 조회수, 추천수 ---------------------->
    <div class="container p-contents">
      <div class="row">
        <div class="col-lg-12">
          <h2>${gboard.title}</h2>
        </div>
          <div class="col-lg-12 post-info">
            <div class="col-lg-1">
              <img src="${pageContext.request.contextPath}/resources/img/userimage.jpg" style="width:70px;height:70px;"/>  
            </div>
            <div class="col-lg-2">
              <span class="post-info">${gboard.writer}</span><br>
              <span class="post-info"> 
              <c:if test="${empty gboard.updatedate}">
              	<fmt:formatDate pattern="yyyy-mm-dd" value="${gboard.regdate}" />
              	작성 
              </c:if>
              <c:if test="${!empty gboard.updatedate}">
              	<fmt:formatDate pattern="yyyy-mm-dd" value="${gboard.updatedate}" />
              	수정
              </c:if>
              </span> 
            </div>
            <div class="col-lg-9 text-right">
              <span class="post-info">조회수 ${gboard.visit}</span> 
              <span class="post-info">추천수 ${gboard.recommend }</span>
            </div>
          </div>
      </div>
    </div><!--//container-->

<!-----------------------------------작성 글 내용 ---------------------------->
<div class="container">
	<!--================================이미지 슬라이드 ======================================-->
	 <div id="myCarousel" class="carousel slide" data-ride="carousel">
	    <!-- Indicators -->
	    <ol class="carousel-indicators">
	      <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
	      <li data-target="#myCarousel" data-slide-to="1"></li>
	      <li data-target="#myCarousel" data-slide-to="2"></li>
	    </ol>
	
	    <!-- Wrapper for slides -->
	    <div class="carousel-inner items">
	    </div>
	
	    <!-- Left and right controls -->
	    <a class="left carousel-control" href="#myCarousel" data-slide="prev">
	      <span class="glyphicon glyphicon-chevron-left"></span>
	      <span class="sr-only">Previous</span>
	    </a>
	    <a class="right carousel-control" href="#myCarousel" data-slide="next">
	      <span class="glyphicon glyphicon-chevron-right"></span>
	      <span class="sr-only">Next</span>
	    </a>
	  </div>
	  <!-- ============================//이미지 슬라이드============================= -->
  <div class="row">
    <div class="col-lg-12 text-center">
      <p>
        
        ${gboard.content}
      </p>  
    </div>
  </div>
</div>
 
<div class="container">
<!--===========================첨부파일============================ -->  
  <div class="well well-sm">
    <strong>첨부파일</strong>
  </div>
  <div class="uploadResult">
    <ul>
       	
    </ul>
  </div>
<!----------------------------댓글 ------------------------------------------>
  <div class="well well-sm">
    <strong>댓글</strong>
    <span>${gboard.replycnt}</span>
  </div>
  <!---------------------------댓글 등록--------------------------------------->
  <div class="input-group">
    <input type="text" placeholder="로그인 한 사용자만 댓글등록이 가능합니다." class="form-control"
    />
    <div class="input-group-btn">
      <button class="btn btn-default" type="button">
        <i class="glyphicon glyphicon-pencil"></i>
      </button>
    </div>
  </div>
  <!-------------댓글 내용----------------------------------------------------->
  <!-------------------------------원댓글------------------------------------->
  <div class="rep-wrapper">
    <div class="row">
      <div class="col-lg-2">
        <img src="${pageContext.request.contextPath}/resources/img/userimage.jpg" style="width:40px;height:40px;"/> 
        아이디
      </div>
      <div class="col-lg-10 rep-contents">
        댓글내용댓글 내용
        댓글내용댓글 내용
        댓글내용댓글 내용
      </div>
  </div>
  <div class="row">
    <div class="col-lg-2 text-center">
      <span>2021-05-26</span>
    </div>
    <div class="col-lg-10">
      <i class="glyphicon glyphicon-share">답글쓰기</i>
      <i class="glyphicon glyphicon-edit">댓글수정</i>
      <i class="glyphicon glyphicon-remove">댓글삭제</i>
    </div>
    </div>
  </div>
  <!----------------------------------답글------------------------------------>
  <div class="arep-wrapper">
    <strong>답글</strong>
    <div class="row">
      <div class="col-lg-2">
        <img src="${pageContext.request.contextPath}/resources/img/userimage.jpg" style="width:40px;height:40px;"/> 
        아이디
      </div>
      <div class="col-lg-10 rep-contents">
        댓글내용댓글 내용
        댓글내용댓글 내용
        댓글내용댓글 내용
      </div>
  </div>
  <div class="row">
    <div class="col-lg-2 text-center">
      <span>2021-05-26</span>
    </div>
    <div class="col-lg-10">
      <i class="glyphicon glyphicon-edit">댓글수정</i>
      <i class="glyphicon glyphicon-remove">댓글삭제</i>
    </div>
    </div>
  </div>
  <!--------------------------------댓글 페이지 매김-------------------------------->
  <ul class="breadcrumb text-right" >
    <li><a href="#">1</a></li>
    <li><a href="#">2</a></li>
    <li><a href="#">3</a></li>
  </ul>
  <!-- ------------------------------목록, 수정, 삭제 버튼----------------------- -->
  <button data-oper="list" class="btn btn-default">목록</button>  
  <button data-oper="modify" class="btn btn-default">글 수정</button>
  <button data-oper="remove" class="btn btn-default" type="submit">글 삭제</button>
  <form method="post">
  	<input type="hidden" name="bno" value='${gboard.bno}'/>
  </form>  
  
  <br><br>  
</div>

<%@ include file="../includes/footer.jsp"%>
<script type="text/javascript">
		var formObj = $("form");
		$(document).ready(function(){
			$("button[data-oper='modify']").on('click',function(e){
				formObj.attr("action","/GBoard/modify").attr("method","get").submit();
			});
			$("button[data-oper='list']").on('click',function(e){
				formObj.attr("action","/GBoard/list").attr("method","get").empty().submit();
			});
			$("button[data-oper='remove']").on('click',function(e){
				formObj.attr("action","/GBoard/remove").submit();
			});
		});
</script>