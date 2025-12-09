<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Todo Register</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="container mt-3">
  <h2>Todo 등록</h2>
  <form action="${pageContext.request.contextPath}/todo/register" method="post">
    
    <div class="mb-3 mt-3">
      <label for="title">Title (제목):</label>
      <input type="text" class="form-control" id="title" placeholder="Enter title" name="title" required>
    </div>
    
    <div class="mb-3 mt-3">
      <label for="description">Description (설명):</label>
      <textarea class="form-control" id="description" rows="3" placeholder="Enter description" name="description"></textarea>
    </div>
    
    
    <button type="submit" class="btn btn-primary">등록</button>
    <button type="reset" class="btn btn-secondary">초기화</button>
    <a href="${pageContext.request.contextPath}/todo/list" class="btn btn-info">목록으로</a>
  </form>
</div>

</body>
</html>