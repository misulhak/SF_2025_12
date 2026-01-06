<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container-fluid">

    <h1 class="h3 mb-4 text-gray-800">Member Modify</h1>

    <div class="card shadow mb-4">
      <div class="card-header py-3">
        <h6 class="m-0 fw-bold text-primary">회원 정보 수정</h6>
      </div>
      
      <div class="card-body">
        <form id="actionForm" action="${pageContext.request.contextPath}/member/modify" method="post">
          
          <%-- CSRF 토큰 --%>
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
          
          <%-- 페이징 및 검색 정보 유지용 hidden 필드 --%>
          <input type="hidden" name="page" value="<c:out value='${page}'/>">
          <input type="hidden" name="size" value="<c:out value='${size}'/>">
          <input type="hidden" name="types" value="<c:out value='${types}'/>">
          <input type="hidden" name="keyword" value="<c:out value='${keyword}'/>">

          <div class="mb-3">
            <label class="form-label fw-bold">No (회원번호)</label>
            <input type="text" name="num" class="form-control bg-light" value="<c:out value='${member.num}'/>" readonly>
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold">User ID</label>
            <input type="text" name="userid" class="form-control bg-light" value="<c:out value='${member.userid}'/>" readonly>
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold">Name</label>
            <input type="text" name="name" class="form-control bg-light" value="<c:out value='${member.name}'/>" readonly>
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold">Password</label>
            <input type="text" class="form-control bg-light" value="******** (Encrypted)" readonly>
            <div class="form-text text-muted">비밀번호 변경은 별도 메뉴를 이용해 주세요.</div>
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold">Email</label>
            <input type="email" name="email" class="form-control" value="<c:out value='${member.email}'/>" required>
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold">Phone</label>
            <input type="text" name="phone" class="form-control" value="<c:out value='${member.phone}'/>" required>
          </div>

          <%-- [수정] 중복 제거: 관리자만 권한을 수정할 수 있도록 통합된 영역 --%>
          <div class="mb-3">
            <label class="form-label fw-bold d-block">Account Role</label>
            
            <%-- 1. 관리자(ROLE_ADMIN)에게만 노출되는 수정 스위치 --%>
            <sec:authorize access="hasRole('ROLE_ADMIN')">
                <div class="form-check form-switch">
                    <%-- 체크박스 해제 시 0을 전송하기 위한 트릭 --%>
                    <input type="hidden" name="admin" value="0">
                    <input type="checkbox" name="admin" value="1" class="form-check-input" id="adminCheck" ${member.admin == 1 ? 'checked' : ''}>
                    <label class="form-check-label" for="adminCheck">관리자 권한 부여 (Admin Privilege)</label>
                </div>
            </sec:authorize>

            <%-- 2. 일반 유저에게는 배지 표시 및 기존 값 hidden 전송 --%>
            <sec:authorize access="!hasRole('ROLE_ADMIN')">
                <c:choose>
                    <c:when test="${member.admin == 1}">
                        <span class="badge bg-danger p-2">Admin Account</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-secondary p-2">Standard User</span>
                    </c:otherwise>
                </c:choose>
                <input type="hidden" name="admin" value="${member.admin}">
            </sec:authorize>
          </div>

        </form>

        <hr>

        <div class="d-flex justify-content-between">
          <button type="button" class="btn btn-outline-secondary btnList">
            <i class="bi bi-list"></i> BACK TO LIST
          </button>
          
          <div>
            <sec:authentication property="principal" var="secInfo" />
            <sec:authentication property="authorities" var="roles"/>
             
            <%-- 본인 또는 관리자만 실제 수정/삭제 버튼 동작 --%>
            <c:if test="${secInfo.username == member.userid || fn:contains(roles, 'ROLE_ADMIN')}">       
                <button type="button" class="btn btn-warning btnModify me-2">SAVE CHANGES</button>
                <button type="button" class="btn btn-danger btnRemove">REMOVE ACCOUNT</button>
            </c:if>
          </div>
        </div>
      </div>
    </div>
</div>

<script type="text/javascript">
    const formObj = document.querySelector("#actionForm");
    const ctx = "${pageContext.request.contextPath}";

    // 1. 저장 버튼 클릭
    document.querySelector(".btnModify")?.addEventListener("click", () => {
        const email = document.querySelector("input[name='email']").value;
        const phone = document.querySelector("input[name='phone']").value;

        if(!email || !phone) {
            alert("이메일과 전화번호는 필수 입력 항목입니다.");
            return;
        }

        if(confirm("수정된 내용을 저장하시겠습니까?")) {
            formObj.submit();
        }
    });
    
    // 2. 목록 이동 버튼
    document.querySelector(".btnList").addEventListener("click", () => {
        const page = document.querySelector("input[name='page']").value || 1;
        const size = document.querySelector("input[name='size']").value || 10;
        const types = document.querySelector("input[name='types']").value;
        const keyword = document.querySelector("input[name='keyword']").value;
        
        let url = `\${ctx}/member/list?page=\${page}&size=\${size}`;
        if(types && keyword) {
            url += `&types=\${types}&keyword=\${encodeURIComponent(keyword)}`;
        }
        location.href = url;
    });
    
    // 3. 삭제 버튼 클릭
    document.querySelector(".btnRemove")?.addEventListener("click", () => {
        if(confirm("정말로 이 회원 계정을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.")) {
            formObj.setAttribute("action", `\${ctx}/member/remove`);
            formObj.submit();
        }
    });
</script>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>