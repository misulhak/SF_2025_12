package org.zerock.dto;

import java.util.List;
import java.util.stream.IntStream;
import lombok.Data;

@Data
public class MemberPagingDTO {

    private List<MemberDTO> memberDTOList; // 회원 목록 데이터
    private int totalCount;                // 전체 회원 수
    private int page, size;                // 페이지 번호, 페이지당 개수
    private int start, end;                // 페이지 시작, 끝 번호
    private boolean prev, next;            // 이전, 다음 버튼 여부
    
    private List<Integer> pageNums;        // 화면에 뿌릴 페이지 번호 리스트 [1, 2, 3...]
    
    private String types;                  // 검색 유형 (u, e, ep, nu 등)
    private String keyword;                // 검색 키워드

    // 🔹 MyBatis 동적 SQL 처리를 위한 메서드 추가
    // types가 "ep"라면 ['e', 'p'] 배열로 반환하여 OR 검색이 가능하게 합니다.
    public String[] getTypesArr() {
        if (types == null || types.isEmpty()) {
            return null;
        }
        return types.split(""); // "ep" -> ["e", "p"]
    }

    public MemberPagingDTO(List<MemberDTO> memberDTOList, int totalCount, 
                           int page, int size, String types, String keyword) {
        
        this.memberDTOList = memberDTOList;
        this.totalCount = totalCount;
        this.page = page;
        this.size = size;
        this.types = types;
        this.keyword = keyword;

        // -----------------------------------------
        // 🔹 페이징 계산 구역
        // -----------------------------------------

        // 1. 임시 끝 번호 계산 (10개씩 끊어서 보여준다고 가정)
        int tempEnd = (int)(Math.ceil(page / 10.0)) * 10;

        // 2. 시작 번호 계산
        this.start = tempEnd - 9;

        // 3. 실제 끝 번호(end) 계산
        int last = (int)(Math.ceil(totalCount / (double)size));

        if (tempEnd > last) {
            this.end = last;
        } else {
            this.end = tempEnd;
        }

        // -----------------------------------------
        // 🔹 이전(prev), 다음(next) 버튼 표시 여부
        // -----------------------------------------
        this.prev = this.start > 1;
        this.next = last > this.end;

        // -----------------------------------------
        // 🔹 페이지 번호 리스트 생성 (IntStream 활용)
        // -----------------------------------------
        if (this.end > 0) {
            this.pageNums = IntStream.rangeClosed(start, end)
                                     .boxed()
                                     .toList();
        }
    }
}