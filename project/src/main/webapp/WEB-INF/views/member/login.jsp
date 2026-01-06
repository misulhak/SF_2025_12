<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>로그인</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body { background-color: #f8f9fa; }
    .login-box {
        max-width: 400px;
        margin-top: 100px;
        padding: 30px;
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0,0,0,0.1);
    }
</style>
</head>

<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="login-box">

            <h3 class="text-center mb-4">로그인</h3>

            <c:if test="${param.error != null}">
                <div class="alert alert-danger">
                    아이디 또는 비밀번호가 올바르지 않습니다.
                </div>
            </c:if>

            <c:if test="${param.logout != null}">
                <div class="alert alert-success">
                    정상적으로 로그아웃되었습니다.
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/member/login">

                <div class="mb-3">
                    <label class="form-label">아이디</label>
                    <input type="text" name="username" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">비밀번호</label>
                    <input type="password" name="password" class="form-control" required>
                </div>

                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" name="remember-me" id="rememberMe">
                    <label class="form-check-label" for="rememberMe">
                        로그인 상태 유지
                    </label>
                </div>

                <button type="submit" class="btn btn-primary w-100">
                    로그인
                </button>

            </form>

            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/member/register" class="text-decoration-none">회원가입</a>
            </div>

        </div>
    </div>
</div>

</body>
</html>