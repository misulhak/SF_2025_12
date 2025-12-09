<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
</head>
<body>
<a href="/member/register" class="d-flex justify-content-end mb-3">
    <button type="button" class="btn btn-primary">등록</button>
</a>

<table class="table">
  <thead>
    <tr>
      <th scope="col">Mno</th>
      <th scope="col">Name</th>
      <th scope="col">Email</th>
      <th scope="col">RegDate</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="member" items="${memberList}">
        <tr>
          <td><c:out value="${member.mno}"></c:out></td>
          <td>
            <a href="/member/read/${member.mno}">
                <c:out value="${member.name}"></c:out>
            </a>
          </td>
          <td><c:out value="${member.name}"></c:out></td>
          <td><c:out value="${member.email}"></c:out></td>
          <td><c:out value="${member.createdDate}"></c:out></td>
    </tr>
    </c:forEach>
  </tbody>
</table>
</body>
</html>