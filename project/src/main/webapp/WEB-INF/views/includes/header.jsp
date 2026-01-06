<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Admin Panel</title>
  
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <%-- 커스텀 스타일 --%>
  <style>
    .list-group-item.active { background-color: #343a40; border-color: #343a40; }
    .sidebar { min-width: 250px; min-height: 100vh; background-color: #f8f9fa; }
    .navbar-brand { font-weight: bold; letter-spacing: 1px; }
    
    /* [추가] 우측 로그인 정보가 화면이 줄어도 밀리지 않게 강제 설정 */
    .user-info-area {
        white-space: nowrap; /* 줄바꿈 방지 */
        flex-shrink: 0;      /* 공간이 부족해도 크기를 줄이지 않음 */
    }
  </style>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

  <c:set var="ctx" value="${pageContext.request.contextPath}"/>
  <c:set var="requestURI" value="${pageContext.request.requestURI}"/>

  <%-- [수정] d-flex를 추가하여 내부 요소 배치를 강제하고, padding 조절 --%>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-3 px-md-4 shadow-sm">
    <div class="container-fluid d-flex justify-content-between align-items-center">
      
      <div class="d-flex align-items-center">
        <a class="navbar-brand" href="${ctx}/member/list">ADMIN PANEL</a>
        <div class="collapse navbar-collapse d-none d-lg-block">
          <ul class="navbar-nav me-auto">
            <li class="nav-item">
                <a class="nav-link ${requestURI.contains('/list') ? 'active' : ''}" href="${ctx}/member/list">Member List</a>
            </li>
          </ul>
        </div>
      </div>
      
      <%-- [수정] 우측 영역: d-flex와 user-info-area 클래스 적용 --%>
      <div class="user-info-area d-flex align-items-center text-white">
        <sec:authorize access="isAnonymous()">
          <a href="${ctx}/member/login" class="btn btn-outline-light btn-sm">Login</a>
        </sec:authorize>
        
        <sec:authorize access="isAuthenticated()">
          <span class="me-2 me-md-3 small">
            <%-- 화면이 작을 때는 'Logged in as' 숨기고 아이디만 표시 --%>
            <span class="d-none d-sm-inline">Logged in as </span>
            <strong><sec:authentication property="principal.username"/></strong>
            
            <sec:authorize access="hasRole('ROLE_ADMIN')">
                <span class="badge bg-danger ms-1">Admin</span>
            </sec:authorize>
          </span>

          <form action="${ctx}/member/logout" method="post" class="m-0">
             <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
             <button type="submit" class="btn btn-sm btn-light">Logout</button>
          </form>
        </sec:authorize>
      </div>
      
    </div>
  </nav>

  <div class="main-wrapper d-flex">
    
    <%-- 사이드바 영역 --%>
    <div class="sidebar border-end shadow-sm d-none d-md-block">
      <div class="list-group list-group-flush">
        <div class="list-group-item bg-light fw-bold text-muted small">MENU</div>
        <a href="${ctx}/member/list" 
           class="list-group-item list-group-item-action ${requestURI.contains('/list') ? 'active text-white' : ''}">
           User Management
        </a>
        <a href="${ctx}/member/register" 
           class="list-group-item list-group-item-action ${requestURI.contains('/register') ? 'active text-white' : ''}">
           Add New User
        </a>
        
        <sec:authorize access="hasRole('ROLE_ADMIN')">
          <div class="list-group-item bg-light fw-bold text-muted small mt-3">SYSTEM</div>
          <a href="#" class="list-group-item list-group-item-action">System Logs</a>
          <a href="#" class="list-group-item list-group-item-action">Settings</a>
        </sec:authorize>
      </div>
    </div>

    <%-- 본문 컨텐츠 영역 --%>
    <div class="content p-4 flex-grow-1">
        <c:if test="${not empty result}">
            <div class="alert alert-primary alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <strong>알림:</strong> 
                <c:choose>
                    <c:when test="${result eq 'modified'}">성공적으로 수정되었습니다.</c:when>
                    <c:when test="${result eq 'removed'}">성공적으로 삭제되었습니다.</c:when>
                    <c:otherwise><strong>${result}</strong>님 등록이 완료되었습니다.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>