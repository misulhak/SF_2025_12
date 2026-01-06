package org.zerock.dto;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;
import java.time.LocalDateTime;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.Builder;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Getter
@Setter
@ToString
@Builder
@AllArgsConstructor
@NoArgsConstructor
// 1. UserDetails 인터페이스를 구현합니다.
public class MemberDTO implements UserDetails {

    private int num;           
    private String name;        
    private String userid;      // 시큐리티의 username으로 사용
    private String pwd;         // 시큐리티의 password로 사용
    private String email;       
    private String phone;       
    private int admin;          // 관리자 여부
    private LocalDateTime regDate;
    
    private List<String> roleList; 

    // 2. 권한 목록 리턴 (roleList를 기반으로 생성)
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return roleList.stream()
                .map(roleName -> new SimpleGrantedAuthority(roleName))
                .collect(Collectors.toList());
    }

    // 3. 비밀번호 리턴
    @Override
    public String getPassword() {
        return this.pwd;
    }

    // 4. 아이디 리턴
    @Override
    public String getUsername() {
        return this.userid;
    }

    // 5. 계정 만료 여부 (true: 만료 안됨)
    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    // 6. 계정 잠김 여부 (true: 잠기지 않음)
    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    // 7. 비밀번호 만료 여부 (true: 만료 안됨)
    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    // 8. 계정 활성화 여부 (true: 활성)
    @Override
    public boolean isEnabled() {
        return true;
    }
}