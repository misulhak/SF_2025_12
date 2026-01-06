package org.zerock.service;

import java.util.List;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.dto.MemberDTO;
import org.zerock.dto.MemberPagingDTO;
import org.zerock.mapper.MemberMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
@RequiredArgsConstructor
public class MemberService {

    private final MemberMapper memberMapper;
    private final PasswordEncoder passwordEncoder;

    // 1. 회원 등록 (트랜잭션 적용 및 비밀번호 암호화)
    @Transactional
    public void register(MemberDTO dto) {
        log.info("--- Member Register Service --- " + dto);
        
        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(dto.getPwd());
        dto.setPwd(encodedPassword);
        
        memberMapper.insert(dto);
        
        // 기본 권한 부여
        memberMapper.insertRole(dto.getUserid(), "ROLE_USER");
        if(dto.getAdmin() == 1) {
            memberMapper.insertRole(dto.getUserid(), "ROLE_ADMIN");
        }
    }

    // 2. 회원 상세 조회
    public MemberDTO read(String userid) {
        log.info("--- Member Read Service: " + userid);
        return memberMapper.selectOne(userid);
    }

    // 3. 회원 목록 및 검색 (Controller에서 호출하는 getList)
    public MemberPagingDTO getList(int page, int size, String typeStr, String keyword) {
        log.info("--- Member List Service: Page=" + page + ", Type=" + typeStr + " ---");
        
        page = page <= 0 ? 1 : page;
        size = size <= 0 ? 10 : size;
        
        int skip = (page - 1) * size;
        String[] types = (typeStr != null && !typeStr.isEmpty()) ? typeStr.split("") : null;
        
        List<MemberDTO> list = memberMapper.listSearch(skip, size, types, keyword);
        int total = memberMapper.listCountSearch(types, keyword);
        
        return new MemberPagingDTO(list, total, page, size, typeStr, keyword);
    }
    
    // 4. 회원 정보 수정
    public void modify(MemberDTO dto) {
        log.info("--- Member Modify Service --- " + dto);
        memberMapper.update(dto);
    }

    // 5. 회원 삭제
    public void remove(String userid) {
        log.info("--- Member Remove Service: " + userid);
        memberMapper.remove(userid);
    }
}