<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
    
<%@include file="/WEB-INF/views/includes/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-12">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Member Register</h6>
            </div>
            
            <div class="card-body">
                <%-- action 경로에 ${pageContext.request.contextPath}를 추가하는 것이 안전합니다 --%>
                <form action="${pageContext.request.contextPath}/member/register" method="post" class="p-3">
                    
                    <%-- 1. CSRF 토큰 추가 (Security 사용 시 필수) --%>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">User ID (아이디)</label> 
                        <input type="text" name="userid" class="form-control" placeholder="사용할 아이디를 입력하세요" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Password (비밀번호)</label>
                        <input type="password" name="pwd" class="form-control" placeholder="비밀번호를 입력하세요" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Name (이름)</label> 
                        <input type="text" name="name" class="form-control" placeholder="이름을 입력하세요" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Email (이메일)</label> 
                        <input type="email" name="email" class="form-control" placeholder="example@test.com" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Phone (전화번호)</label> 
                        <input type="text" name="phone" class="form-control" placeholder="010-0000-0000">
                    </div>

                    <%-- 2. 관리자 권한 설정 (일반적으로 관리자만 체크 가능하도록 제한) --%>
                    <sec:authorize access="hasRole('ROLE_ADMIN')">
                        <div class="mb-3 form-check">
                            <input type="checkbox" name="admin" value="1" class="form-check-input" id="adminCheck">
                            <label class="form-check-label" for="adminCheck">관리자로 등록하시겠습니까?</label>
                        </div>
                    </sec:authorize>

                    <div class="d-flex justify-content-end mt-4">
                        <button type="reset" class="btn btn-secondary me-2">Reset</button>
                        <button type="submit" class="btn btn-primary">Submit</button>
                        <a href="${pageContext.request.contextPath}/member/list" class="btn btn-outline-dark ms-2">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/views/includes/footer.jsp" %>