<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>로그아웃</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { background-color: #f8f9fa; }
    .logout-box {
        max-width: 450px;
        margin-top: 120px;
        padding: 30px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 0 15px rgba(0,0,0,0.1);
        text-align: center;
    }
</style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="logout-box">
            <h4 class="mb-3">로그아웃</h4>
            <p class="text-muted">정말 로그아웃 하시겠습니까?</p>

            <form method="post" action="${pageContext.request.contextPath}/member/logout">
                <button type="submit" class="btn btn-danger w-100 mb-2">
                    로그아웃
                </button>
            </form>

            <a href="${pageContext.request.contextPath}/member/list" class="btn btn-secondary w-100">
                취소 (목록으로)
            </a>
        </div>
    </div>
</div>

</body>
</html>