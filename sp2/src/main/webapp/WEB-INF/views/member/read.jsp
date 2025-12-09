<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Bootstrap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

<div class="container mt-3">
  <h2>Member Read</h2>
  <form action="/member/read" method="post" id="form">
    <input type="hidden" name="mno" value="${member.mno}">
    <div class="mb-3 mt-3">
      <label for="name">Name:</label>
      <input type="text" class="form-control" id="name" name="name" 
          value="<c:out value='${member.name}'/>">
    </div>
    <div class="mb-3 mt-3">
      <label for="email">Email:</label>
      <input type="email" class="form-control" id="email" 
       name="email" value="<c:out value='${member.email}'/>">
    </div>
    <div class="mb-3">
      <label for="pwd">Password:</label>
      <input type="password" class="form-control" id="pwd" placeholder="Enter password" 
      name="password" value="<c:out value='${member.password}'/>">
    </div>
    
    <button type="button" class="btn btn-primary update">수정</button>
    <button type="button" class="btn btn-danger delete">삭제</button>
    <button type="button" class="btn btn-info list">목록</button>
  </form>
</div>

<script type="text/javascript">
    const formObj = document.getElementById("form");
    document.querySelector(".update").addEventListener("click", ()=>{
    	formObj.action = "/member/modify";
    	formObj.method = "post"
        formObj.submit();
    });
    
    document.querySelector(".delete").addEventListener("click", ()=>{
    	formObj.action = "/member/delete";
    	formObj.method = "post"
        formObj.submit();
    });
    
    document.querySelector(".list").addEventListener("click", ()=>{
    	formObj.reset();
    	formObj.action = "/member/list";
    	formObj.method = "get"
        formObj.submit();
    });
</script>
</body>
</html>
