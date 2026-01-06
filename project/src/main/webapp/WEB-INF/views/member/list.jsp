<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container-fluid">
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">Member List</h6>
            <a href="${pageContext.request.contextPath}/member/register" class="btn btn-primary btn-sm">신규 회원 등록</a>
        </div>
        
        <div class="card-body">
            <div class="row mb-4">
                <div class="col-md-8">
                    <div class="d-flex">
                        <select name="typeSelect" class="form-select me-2" style="width: 220px;">
                            <option value="" ${dto.types == null ? 'selected' : ''}>-- 검색 조건 --</option>
                            <option value="u" ${dto.types == 'u' ? 'selected' : ''}>회원ID</option>
                            <option value="e" ${dto.types == 'e' ? 'selected' : ''}>이메일</option>
                            <option value="ep" ${dto.types == 'ep' ? 'selected' : ''}>이메일 OR 전화번호</option>
                            <option value="nu" ${dto.types == 'nu' ? 'selected' : ''}>이름 OR 회원ID</option>
                        </select>
                        <input type="text" class="form-control me-2" name="keywordInput" 
                               value="<c:out value='${dto.keyword}'/>" placeholder="검색어를 입력하세요">
                        <button class="btn btn-outline-primary searchBtn" style="min-width: 80px;">Search</button>
                        <a href="${pageContext.request.contextPath}/member/list" class="btn btn-outline-secondary ms-1">Clear</a>
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="dataTable">
                    <thead class="table-light text-center">
                        <tr>
                            <th>번호(No)</th>
                            <th>이름</th>
                            <th>회원ID</th>
                            <th>비밀번호</th>
                            <th>이메일</th>
                            <th>전화번호</th>
                            <th>관리자</th>
                        </tr>
                    </thead>
                    <tbody class="text-center">
                        <c:choose>
                            <c:when test="${not empty dto.memberDTOList}">
                                <c:forEach var="member" items="${dto.memberDTOList}">
                                    <%-- [수정] 관리자 계정(admin==1)일 경우 행 배경색을 연한 파란색으로 강조 --%>
                                    <tr class="${member.admin == 1 ? 'table-primary' : ''}">
                                        <td class="align-middle"><c:out value="${member.num}" /></td>
                                        <td class="align-middle">
                                            <c:if test="${member.admin == 1}">
                                                <i class="fas fa-user-shield text-danger me-1"></i>
                                            </c:if>
                                            <c:out value="${member.name}" />
                                        </td>
                                        <td class="align-middle">
                                            <a href="${pageContext.request.contextPath}/member/read/${member.userid}?page=${dto.page}&size=${dto.size}&types=${dto.types}&keyword=${dto.keyword}" class="fw-bold">
                                                <c:out value="${member.userid}" />
                                            </a>
                                        </td>
                                        <td class="align-middle"><small class="text-muted">Encrypted</small></td>
                                        <td class="align-middle"><c:out value="${member.email}" /></td>
                                        <td class="align-middle"><c:out value="${member.phone}" /></td>
                                        <td class="align-middle">
                                            <c:choose>
                                                <c:when test="${member.admin == 1}">
                                                    <span class="badge bg-danger p-2"><i class="fas fa-crown me-1"></i>Admin</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary p-2">User</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="py-5 text-muted">검색 결과가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            
            <%-- 페이징 --%>
            <div class="d-flex justify-content-center mt-4">
                <ul class="pagination">
                    <c:if test="${dto.prev}">
                        <li class="page-item">
                            <a class="page-link" href="${dto.start - 1}">Prev</a>
                        </li>
                    </c:if>
                    
                    <c:forEach var="num" items="${dto.pageNums}">
                        <li class="page-item ${dto.page == num ? 'active' : ''}">
                            <a class="page-link" href="${num}">${num}</a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${dto.next}">
                        <li class="page-item">
                            <a class="page-link" href="${dto.end + 1}">Next</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>  
    </div>
</div>

<script type="text/javascript">
    const ctx = "${pageContext.request.contextPath}";
    const currentSize = "${dto.size}" || "10";
    
    document.querySelector(".pagination").addEventListener("click", (e) => {
        e.preventDefault();
        const target = e.target;
        if(target.tagName !== 'A') return;
        const targetPage = target.getAttribute("href");
        
        const types = document.querySelector("select[name='typeSelect']").value;
        const keyword = document.querySelector("input[name='keywordInput']").value;
        
        let url = ctx + "/member/list?page=" + targetPage + "&size=" + currentSize;
        if(types && keyword) {
            url += "&types=" + types + "&keyword=" + encodeURIComponent(keyword);
        }
        location.href = url;
    }, false);
    
    document.querySelector(".searchBtn").addEventListener("click", () => {
        const typesSelect = document.querySelector("select[name='typeSelect']").value;
        const keywordInput = document.querySelector("input[name='keywordInput']").value;

        if(typesSelect && (!keywordInput || keywordInput.trim() === "")) {
            alert("검색어를 입력해주세요.");
            return;
        }

        location.href = ctx + "/member/list?page=1&size=" + currentSize 
                        + "&types=" + typesSelect 
                        + "&keyword=" + encodeURIComponent(keywordInput);
    });

    document.querySelector("input[name='keywordInput']").addEventListener("keydown", (e) => {
        if(e.keyCode === 13) {
            document.querySelector(".searchBtn").click();
        }
    });
</script>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>