<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Todo List</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="container mt-4">
    <h1 class="mb-4">Simple Todo List</h1>

    <a href="${pageContext.request.contextPath}/todo/register" class="d-flex justify-content-end mb-3">
        <button type="button" class="btn btn-primary">새 TODO 등록</button>
    </a>

    <table class="table table-hover">
      <thead class="table-dark">
        <tr>
          <th scope="col">ID</th>
          <th scope="col">제목</th>
          <th scope="col">설명</th>
          <th scope="col">완료 여부</th>
          <th scope="col">등록일</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="todo" items="${todoList}">
            <tr class="${todo.done ? 'done' : ''}"> 
              <td><c:out value="${todo.id}"></c:out></td>
              <td>
                <a href="${pageContext.request.contextPath}/todo/read/${todo.id}">
                    <c:out value="${todo.title}"></c:out>
                </a>
              </td>
              <td><c:out value="${todo.description}"></c:out></td>
              <td>
                <c:choose>
                    <c:when test="${todo.done}">완료</c:when>
                    <c:otherwise>진행 중</c:otherwise>
                </c:choose>
              </td>
              <td>
                <fmt:formatDate value="${todo.createAt}" pattern="yyyy-MM-dd HH:mm"/>
              </td>
        </tr>
        </c:forEach>
      </tbody>
    </table>
</div>

<script src="cdn.jsdelivr.net" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>