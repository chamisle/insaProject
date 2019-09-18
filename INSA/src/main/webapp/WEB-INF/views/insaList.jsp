<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<title>인사 조회</title>
	
	<div align="right">
    <h2>IT & BIZ</h2>
    </div>
	    	<!-- jQuery UI CSS파일 -->  
	<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />  
		<!-- jQuery 기본 js파일-->
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>  
		<!-- jQuery UI 라이브러리 js파일 -->
	<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>  

	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript">
	function loadCommonCode(){
	}
	function resetAll(){
 		var thisForm = arguments[0];
		for(var i=0 ; i<thisForm.length ; i++){
			if(thisForm[i].type!="button"){
				thisForm[i].value="";
				thisForm[i].disabled= false; 
			}
		}
		var list=null;
		makeList(list);
		
	}
		
 		$('#reset').click(function(){
			alert("reset");
			$(":text").val()="";
//			$(":option").value="";
			document.getElementById("sabun").disabled=false;
			document.getElementsByClassName("form-control").disabled=false;
		}); 
								
				
				
 				/* document.getElement
				ById("myRange").disabled = true;  */
	
	
	//검색
	function send(){
		var inputForm = arguments[0];
		var flagForSend = true;
		var str="";
		for (var idx=0 ; idx<inputForm.elements.length; idx++){				//폼의 모든 elements 가져오기
			if(inputForm.elements[idx].value.trim().length>0 && inputForm.elements[idx].type!="button"){	//값이 있는지 확인
				str += "인풋의 "+inputForm.elements[idx].name+"에 값있음 : "+inputForm.elements[idx].value+"\n";
				flagForSend=false;		//값이 있으면 getList, 값이 없으면 getAll
			}else{
				str="인풋에 값없음";
			}
		}
		console.log(str);
		var getterList;
		if(flagForSend){
			console.log("----------전체불러오기----------");
			ajaxCall_forGetAll(1);
			
 			inputForm.action="getAll";
			inputForm.method="post";
			inputForm.submit(); 

		}else{
			console.log("------------조건불러오기---------");
			ajaxCall_forGetList();
			
 			inputForm.action="get";
			inputForm.method="post";
			inputForm.submit(); 

		}
	}
	
	function ajaxCall_forGetAll(thisPage){
		console.log("겟페이지:::ajaxCall_forGetAll(thisPage):::"+thisPage);
		var formData = new FormData();
		formData.append("page",thisPage);
		$.ajax({
//			url: "getAll",
			url: "goPaging",
			data : formData,
			type:"post",
			processData : false,
            contentType : false,
//			dataType : 'application/json;charset=UTF-8' ,
//			contentType: 'application/json;charset=UTF-8' ,
	//		traditional:true,
	        //Ajax 성공시
			success : function(data){
				console.log("--------불러오기 성공-------\n DATA : ", data);
	//			console.log("데이타 확인 0번 : "+data[0].sabun);
				
	
			/* 	if(data.indexOf("업")){
					makeList(data);
				}else{
					alert("해당 결과가 없습니다.");
				}
			 */	
				
				$('#listView').html(data);
				if(data.indexOf("검색된 데이터가 없습니다.")>0){
					alert("해당 결과가 없습니다.");
				}
				
		    },
	        //Ajax 실패시
		    error : function(status, error,request, data){
		    	console.log("불러오기 실패\n"+status+"\n"+error+"\n"+request.responseText+"\n"+request.status+"\n////////");
		   		return;
		    }
		});
	}
	function ajaxCall_forGetList(){
		console.log("JSON:"+JSON.stringify($('#inputForm').serializeObject()));
		$.ajax({
			headers: { 
				'Accept': 'application/json',
			    'Content-Type': 'application/json' 
		    },
			url: "get",
			type:"post",
			dataType : 'json',
			data:JSON.stringify($('#inputForm').serializeObject()),
			contentType: 'application/json;charset=UTF-8' ,
			traditional:true,
	        //Ajax 성공시
			success : function(data){
				console.log("--------불러오기 성공-------\n DATA : ", data);
	//			console.log("데이타 확인 0번 : "+data[0].sabun);
				if(data.length!=0){
					makeList(data);
				}else{
					makeList(null);
					alert("해당 결과가 없습니다.");
				}
		    },
	        //Ajax 실패시
		    error : function(status, error,request, data){
		    	console.log("불러오기 실패\n"+status+"\n"+error+"\n"+request.responseText+"\n"+request.status+"\n////////");
		   		return;
		    }
		});
	}
	//json타입으로 바꾸기1
	jQuery.fn.serializeObject = function() {
		var obj = null;
		try {
			if(this[0].tagName && this[0].tagName.toUpperCase() == "FORM" ) {
				console.log("getPage:::serializeObject 실행");
				var arr = this.serializeArray();
				if(arr){ 
					obj = {};
					jQuery.each(arr, function() {
						obj[this.name] = this.value; 
					}); 
				} 
			} 
		}catch(e) {
			alert(e.message);
		}finally { } 
		return obj;
	}
	
	function makeList(list){
		var html="";
		if( list==null || list.length==0){
			html ="<tr><td colspan=\"9\" align=\"center\">검색된 데이터가 없습니다.</td></tr>";
		}else{
			
			for(var idx=0 ; idx<list.length ; idx++){
				var row = list[idx];
				var join
				console.log("투입여부 : "+row.inandout);
				var strInandout;
				if(row.inandout==1){
					strInandout="투입";
				}else{
					strInandout="미투입";
				}
				html +="<tr class=\"resultRow\" onclick=\"resultRowClick(this)\"><td class=\"td_sabun\">"+row.sabun+"</td><td>"
					+row.name+"</td><td>"+row.reg_no+"</td><td>"
					+row.hp+"</td><td>"+row.pos_gbn_code+"</td><td>"
					+row.join_day+"</td><td>"+row.retire_day+"</td><td>"
					+strInandout+"</td><td align=\"right\">"+comma(row.salary)+"</td></tr>";
			}
		} 
		


		$('#listView').html(html);
//		$('#listView').innerHTML = html;
// 		console.log("html : " + $('#listView').html());
//        console.log("후 : " + $('#listTable').html()); 
        


	}
	
	function comma(str) { 
	    str = String(str); 
	    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'); 
	} 
	
	function resultRowClick(obj){
		var theSabun = obj.cells[0].innerHTML;
		console.log("나는 누구인가 : "+obj.nodeName);
		console.log("cells[0] : "+obj.cells[0].innerHTML);
		console.log("obj.cells.length : "+obj.cells.length);
		alert("선택 사번 : "+theSabun);
		
		//form 동적 생성
		 var form = document.createElement("form");
         form.setAttribute("charset", "UTF-8");
         form.setAttribute("method", "Post");  //Post 방식
         form.setAttribute("action", "getOne"); //요청 보낼 주소

         var hiddenField = document.createElement("input");
         hiddenField.setAttribute("type", "hidden");
         hiddenField.setAttribute("name", "pickSabun");
         hiddenField.setAttribute("value", theSabun);
         form.appendChild(hiddenField);
         
         document.body.appendChild(form);
         form.submit();
	}
	
	
	/* function pagingCounter(){
		var totalCount;
		$.ajax({
			url:"totalPagingCounter",
			type:"post",
			success : function(data){
				
			},
			error : function(data, error){
				
			}
		});
		return totalCount;
	} */
	
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	$(document).ready(function(){
		loadCommonCode();
		/* $('.resultRow').click(function(){
			alert("resultRow 선택");
			var theSabun = $(this).children().eq(0).text();
			alert("선택 사번 : "+theSabun);
			location.href="/sys/getOne?sabun="+theSabun;
		}); */
		
		 //검색
		 $('#search').click(function(){
				location.href="/getAll";
		});  
		//초기화
		$('#reset').click(function(){
				location.href="/insaList";
		});
		//이전화면
		$('#forward').click(function(){
				location.href="/";
		});
		
		
		
		$('#sabun').focus(function(){
			$(".form-control").attr("disabled", true);
			
/* 			if(inputForm.sabun.value.trim()!=""){
			}else{
				$(":disabled").attr("disabled", false);
			}
 */		});	
		
		/* $('#sabun').blur(function(){
			if(inputForm.sabun.value.trim()==""){
				$(":disabled").attr("disabled", false);
//				$(".form-control").attr("disabled", false);
				insaList.sabun.value="";
			} 
		});
		
		*/
		$('#sabun').blur(function(){
			if($("#sabun").val().trim()=="" || $("#sabun").val()==null){
				$("#sabun").val("");
				$(":disabled").attr("disabled", false);
			}	
		}); 
	
		$(".form-control").focus(function(){
			$('#sabun').attr("disabled", true);
		});
		$(".form-control").blur(function(){
			var flag_hasContents=true;
			$(".form-control").each(function(idx, item){
				if(item.value!=0 || item.value.trim()!="" ){
					flag_hasContents=false;	
				}
				if(flag_hasContents){
					$('#sabun').attr("disabled", false);
				}
				
			});
			//for()
				
		});
		//enabled , disabled로 중복 없애보기
	});
	
/* 		var sabun_showMember = arguments[0];
		sabun_showMember.action="getOne";
		sabun_showMember.method="get";
		sabun_showMember.submit();
	}
	 */
	
	
	
</script>

	</head>
		<div align="center";>
		<h1>인사 관리 시스템</h1>
		</div>
	<body>
	<h1 style="margin-top: 0px;">직원 리스트</h1>
	<form id="selectInsa" name="selectInsa"action="/getAll" method="post">
		<!-- 버튼 라인 -->
		
			<input type="submit" id="search" name="search" value="검색" /> <!-- onclick="send(this.form)" -->
			<input type="button" id="reset" value="초기화" onclick="reset"/> <!-- onclick="resetAll(this.form)" -->
			<input type="button" id="forward" value="전화면" />
			<hr>
		<table>
			<!-- 1번째 줄 -->
			<tr>
				<!-- 사번 -->
					<td>사번</td>
					<td>
						<input type="text"  id="sabun" name="sabun" style="text-align: right;"  value="">
					</td>
				<!-- 성명 -->
					<td>성명</td>
					<td>
						<input type="text" class="form-control" id="name" name="name" style="text-align: right;" value="">
					</td>
				<!-- 입사여부 -->
					<td>입사여부</td>
					<td>
						<select class="form-control" name="join_type"  value="0">
							<option value="0">(선택)</option>
							<option value="1">근무중</option>
							<option value="2">퇴사</option>
						</select>
					</td>
				
				</tr>
					
			<!-- 2번째 줄 -->
				<tr>
				<!-- 직위 -->
					<td>직위</td>
					<td>
						<select name="pos_gbn_code" id="pos_gbn_code" value="0">
							<option value="0">(선택)</option>
							<option value="1">(사원)</option>
							<option value="2">(주임)</option>
							<option value="3">(대리)</option>
							<option value="4">(과장)</option>
						</select>
					</td>
				<!-- 입사일자 -->
					<td>입사일자</td>
					<td>
							<input type="date" id="join_day" name="join_day" class="form-control" value="">
					</td>
				<!-- 퇴사일자 -->
					<td>퇴사일자</td>
					<td>
							<input type="date" id="retire_day" name="retire_day" class="form-control" value="">
					</td>
				
				</tr>
			<br>
	
		</table>
	</form>
	<br>
	<hr>
	<br>
	<table  border="2">
		<thead>
			<tr align="center">
				<th>　　사번　　</th>
				<th>　　성명　　</th>
				<th>　주민번호　</th>
				<th>　핸드폰번호　</th>
				<th>　　직위　　</th>
				<th>　입사일자　</th>
				<th>　퇴사일자　</th>
				<th>　투입여부　</th>
				<th>　연봉(만원) </th>
			</tr>
		</thead>
		<tbody id="listView">
			<tr>
				<td colspan="9" align="center">검색된 데이터가 없습니다.</td>
			</tr>
		
			<c:choose>
				<c:when test="${empty list || list==null }">
					<tr>
						<td colspan="9" align="center">검색된 데이터가 없습니다.</td>
					</tr>
				</c:when>
				 <c:otherwise>
					<c:forEach  items="${list}" var="searchResult">
						<tr class="resultRow">
								<td id="td_sabun"><a href="/insaDetail?pickSabun=${searchResult.sabun}">${searchResult.sabun}</td>
								<td id="td_name">${searchResult.name}</a></td>
								<td id="td_reg_no">${searchResult.reg_no}</td>
								<td id="td_hp">${searchResult.hp}</td>
								<td id="td_pos_gbn_code">${searchResult.pos_gbn_code}</td>
								<td id="td_join_day">${searchResult.join_day}</td>
								<td id="td_retire_day">${searchResult.retire_day}</td>
								<td id="td_put_yn">${searchResult.put_yn}</td>
								<td id="td_salary">${searchResult.salary}</td>
						</tr>
					</c:forEach>
				</c:otherwise>			
			</c:choose>
		</tbody>
		<tfoot>
						
		</tfoot>
	</table>
	
</body>
</html>