<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container-fluid">
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Member Profile</h6>
        </div>
        <div class="card-body">
            <div class="mb-3">
                <label class="form-label fw-bold">No (회원번호)</label>
                <input type="text" class="form-control bg-light" value="${member.num}" id="memberNum" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">User ID</label>
                <input type="text" class="form-control bg-light" value="${member.userid}" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Name</label>
                <input type="text" class="form-control bg-light" value="${member.name}" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Email</label>
                <input type="text" class="form-control bg-light" value="${member.email}" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Phone</label>
                <input type="text" class="form-control bg-light" value="${member.phone}" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold d-block">Account Role</label>
                <c:choose>
                    <c:when test="${member.admin == 1}">
                        <span class="badge bg-danger p-2">Admin (관리자 계정)</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-secondary p-2">User (일반 회원)</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <hr>

            <div class="mt-4 float-end">
                <sec:authorize access="hasRole('ROLE_ADMIN') or principal.username == '${member.userid}'">
                    <a href="${pageContext.request.contextPath}/member/modify/${member.userid}?page=${page}&size=${size}&types=${types}&keyword=${keyword}" class="btn btn-warning">Modify</a>
                </sec:authorize>
                <a href="${pageContext.request.contextPath}/member/list?page=${page}&size=${size}&types=${types}&keyword=${keyword}" class="btn btn-secondary">List</a>
            </div>
        </div>
    </div>

    <div class="row mt-5">
        <div class="col-md-12">
            <div class="card shadow mb-4 border-left-primary">
                <div class="card-header py-3 bg-primary text-white d-flex justify-content-between">
                    <h6 class="m-0 font-weight-bold">계좌 특이사항 기록</h6>
                    <span class="badge bg-light text-primary" id="replyCount">0</span>
                </div>
                <div class="card-body">
                    
                    <%-- [수정] 권한 체크: 관리자거나 본인일 때만 입력창 노출 --%>
                    <sec:authorize access="hasRole('ROLE_ADMIN') or principal.username == '${member.userid}'">
                        <div class="input-group mb-3">
                            <span class="input-group-text">작성자</span>
                            <input type="text" id="replyer" class="form-control col-2" 
                                   value="<sec:authentication property='principal.username'/>" readonly>
                            <input type="text" id="replyText" class="form-control" placeholder="상담 내용 및 특이사항을 입력하세요.">
                            <button class="btn btn-primary" id="replyAddBtn" type="button">등록</button>
                        </div>
                    </sec:authorize>
                    
                    <%-- 권한이 없을 경우 안내 문구 --%>
                    <sec:authorize access="!(hasRole('ROLE_ADMIN') or principal.username == '${member.userid}')">
                        <div class="alert alert-light text-center">
                            ※ 특이사항은 본인 또는 관리자만 기록할 수 있습니다.
                        </div>
                    </sec:authorize>

                    <hr>
                    <ul class="list-group list-group-flush" id="replyList"></ul>
                </div>
                <div class="card-footer bg-white">
                    <nav><ul class="pagination justify-content-center" id="replyPaging"></ul></nav>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<script>
    const memberNum = "${member.num}"; 
    const contextPath = "${pageContext.request.contextPath}"; 
    
    // 현재 로그인한 사용자 정보 (자바스크립트 권한 체크용)
    const currentUser = "<sec:authentication property='principal.username'/>";
    const isAdmin = <sec:authorize access="hasRole('ROLE_ADMIN')">true</sec:authorize><sec:authorize access="!hasRole('ROLE_ADMIN')">false</sec:authorize>;

    const replyList = document.querySelector("#replyList");
    const replyPaging = document.querySelector("#replyPaging");
    
    let currentPage = 1;
    let currentSize = 5;

    // 목록 출력 함수
    const printList = (list) => {
        let str = '';
        if(!list || list.length === 0) {
            replyList.innerHTML = '<li class="list-group-item text-center text-muted">등록된 기록이 없습니다.</li>';
            return;
        }

        for (const dto of list) {
            // [수정] 삭제 버튼 권한 제어: 관리자거나 본인이 쓴 글일 때만 삭제 버튼 노출
            let deleteBtn = "";
            if(isAdmin || currentUser === dto.replyer) {
                deleteBtn = `<button class="btn btn-sm btn-outline-danger" onclick="removeReply(\${dto.rno}, '\${dto.replyer}')">삭제</button>`;
            }

            str += `<li class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <span class="fw-bold text-primary">[\${dto.replyer}]</span> 
                            <span class="ms-2">\${dto.replyText}</span>
                            <div class="small text-muted">\${dto.replyDate}</div>
                        </div>
                        \${deleteBtn}
                    </li>`;
        }
        replyList.innerHTML = str;
    }

    const printPaging = (data) => {
        let str = '';
        if(data.prev) {
            str += `<li class="page-item"><a class="page-link" href="#" onclick="getServerList(\${data.start - 1})">Prev</a></li>`;
        }
        data.pageNums.forEach(n => {
            str += `<li class="page-item \${data.page === n ? 'active' : ''}">
                        <a class="page-link" href="#" onclick="getServerList(\${n})">\${n}</a>
                    </li>`;
        });
        if(data.next) {
            str += `<li class="page-item"><a class="page-link" href="#" onclick="getServerList(\${data.end + 1})">Next</a></li>`;
        }
        replyPaging.innerHTML = str;
    }

    function getServerList(page) {
        currentPage = page || 1;
        axios.get(`\${contextPath}/replies/member/\${memberNum}/list`, { 
            params: { page: currentPage, size: currentSize } 
        })
        .then(res => {
            printList(res.data.replyDTOList);
            printPaging(res.data);
            document.querySelector("#replyCount").innerText = res.data.totalCount;
        })
        .catch(err => console.error("로딩 에러:", err));
    }

    // 등록 이벤트
    const addBtn = document.querySelector("#replyAddBtn");
    if(addBtn) { // 버튼이 존재할 때만 이벤트 리스너 등록
        addBtn.addEventListener("click", () => {
            const replyTextObj = document.querySelector("#replyText");
            const replyDTO = {
                num: memberNum,
                replyText: replyTextObj.value,
                replyer: document.querySelector("#replyer").value
            };

            if(!replyDTO.replyText) { alert("내용을 입력해주세요."); return; }

            axios.post(`\${contextPath}/replies`, replyDTO)
                .then(res => {
                    alert("특이사항이 등록되었습니다.");
                    replyTextObj.value = "";
                    getServerList(1);
                })
                .catch(err => {
                    if(err.response && err.response.status === 403) alert("등록 권한이 없습니다.");
                    else alert("등록 실패!");
                });
        });
    }

    // 삭제 함수
    window.removeReply = function(rno, replyer) {
        if(!confirm("이 기록을 삭제하시겠습니까?")) return;

        // [수정] 보안 강화를 위해 DTO 형태로 replyer 정보를 함께 보냄 (컨트롤러 @PreAuthorize 대응)
        axios.delete(`\${contextPath}/replies/\${rno}`, { data: { replyer: replyer } })
            .then(res => {
                alert("삭제되었습니다.");
                getServerList(currentPage);
            })
            .catch(err => {
                if(err.response && err.response.status === 403) alert("삭제 권한이 없습니다.");
                else alert("삭제 실패!");
            });
    }

    if(memberNum) { getServerList(); }
</script>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>