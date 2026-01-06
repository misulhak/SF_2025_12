package org.zerock.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.zerock.dto.ReplyDTO;

public interface ReplyMapper {
    
    // 1. 특이사항 등록
    int insert(ReplyDTO replyDTO);
    
    // 2. 특이사항 상세 조회
    ReplyDTO read(@Param("rno") int rno);

    // 3. 특이사항 삭제
    int delete(@Param("rno") int rno);
    
    // 4. 특이사항 수정
    int update(ReplyDTO replyDTO);
    
    // 5. 특정 회원의 특이사항 목록 (페이징 적용)
    // 기존 bno(Long) 대신 num(int)을 사용합니다.
    List<ReplyDTO> listOfMember(
            @Param("num") int num,
            @Param("skip") int skip,
            @Param("limit") int limit			
    );

    // 6. 특정 회원의 전체 특이사항 개수 조회
    int countOfMember(@Param("num") int num);
}