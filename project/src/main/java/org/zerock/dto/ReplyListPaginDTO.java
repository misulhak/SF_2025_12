package org.zerock.dto;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import lombok.Data;

@Data
public class ReplyListPaginDTO {

    private List<ReplyDTO> replyDTOList;  // 특이사항 목록
    private int totalCount;               // 전체 기록 개수
    private int page, size;               // 현재 페이지, 페이지당 개수
    private int start, end;               // 시작 페이지, 끝 페이지 번호
    private boolean prev, next;           // 이전/다음 버튼 활성화 여부
    private List<Integer> pageNums;       // 화면에 뿌릴 페이지 번호 리스트

    public ReplyListPaginDTO(List<ReplyDTO> replyDTOList, int totalCount, int page, int size) {
        this.replyDTOList = replyDTOList;
        this.totalCount = totalCount;
        this.page = page;
        this.size = size;

        // 1. 끝 페이지 계산 (10개씩 끊어서 보여줄 때)
        int tempEnd = (int) (Math.ceil(page / 10.0)) * 10;

        // 2. 시작 페이지 계산
        this.start = tempEnd - 9;

        // 3. 실제 마지막 페이지 계산 (전체 개수 기준)
        int last = (int) (Math.ceil(totalCount / (double) size));

        // 4. 끝 페이지 보정
        this.end = tempEnd > last ? last : tempEnd;

        // 5. 이전/다음 여부
        this.prev = this.start > 1;
        this.next = totalCount > (this.end * this.size);

        // 6. 페이지 번호 리스트 생성 (start부터 end까지)
        this.pageNums = IntStream.rangeClosed(start, end > start ? end : start)
                .boxed()
                .collect(Collectors.toList());
    }
}