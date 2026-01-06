package org.zerock.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.zerock.dto.MemberDTO;
import org.zerock.mapper.MemberMapper;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private MemberMapper memberMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.info("---------------- loadUserByUsername: " + username + " ----------------");

        // 1. DB에서 회원 정보 조회
        MemberDTO memberDTO = memberMapper.selectOne(username);

        // 2. 사용자가 없을 경우 예외 처리
        if (memberDTO == null) {
            log.warn("사용자를 찾을 수 없음: " + username);
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
        }

        log.info("로그인 성공 처리 중: " + memberDTO.getUserid());

        // 3. UserDetails를 구현한 memberDTO를 리턴
        return memberDTO;
    }
}