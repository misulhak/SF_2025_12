package org.zerock.service;

import java.util.List;
import org.springframework.stereotype.Service;
import org.zerock.dto.ReplyDTO;
import org.zerock.dto.ReplyListPaginDTO; // 기존 페이징 DTO 활용
import org.zerock.mapper.ReplyMapper;
import org.zerock.service.ReplyException;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
@RequiredArgsConstructor // 생성자 주입
public class ReplyService {
    
    private final ReplyMapper replyMapper;
    
    // 1. 특이사항 등록
    public void add(ReplyDTO replyDTO) {
        log.info("--------- 계좌 특이사항 등록 -------------");
        try {
            replyMapper.insert(replyDTO);
        } catch(Exception e) {
            throw new ReplyException(500, "Insert Error");
        }
    }
    
    // 2. 특이사항 개별 조회
    public ReplyDTO getOne(int rno) {
        try {
            return replyMapper.read(rno);
        } catch(Exception e) {
            throw new ReplyException(404, "Not Found");
        }
    }
    
    // 3. 특이사항 수정
    public void modify(ReplyDTO replyDTO) {
        try {
            int count = replyMapper.update(replyDTO);
            if(count == 0) {
                throw new ReplyException(404, "Not Found");
            }
        } catch(Exception e) {
            throw new ReplyException(500, "Update Error");
        }
    }
    
    // 4. 특이사항 삭제 (또는 delflag 업데이트)
    public void remove(int rno) {
        try {
            int count = replyMapper.delete(rno);
            if(count == 0) {
                throw new ReplyException(404, "Not Found");
            }
        } catch(Exception e) {
            throw new ReplyException(500, "Delete Error");
        }
    }
    
    // 5. 특정 회원의 특이사항 목록 (페이징 포함)
    // bno 대신 회원 번호인 num을 사용합니다.
    public ReplyListPaginDTO listOfMember(int num, int page, int size) {
        try {
            int skip = (page - 1) * size;
            
            // Mapper의 메서드명도 상황에 맞게 매칭 (listOfMember, countOfMember)
            List<ReplyDTO> replyDTOList = replyMapper.listOfMember(num, skip, size);
            int count = replyMapper.countOfMember(num);
            
            return new ReplyListPaginDTO(replyDTOList, count, page, size);
            
        } catch(Exception e) {
            log.error(e.getMessage());
            throw new ReplyException(500, "List Load Error");
        }
    }
}