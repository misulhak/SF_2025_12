package org.zerock.security;

import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import lombok.extern.log4j.Log4j2;

@Configuration
@Log4j2
@EnableWebSecurity
@EnableWebMvc
public class SecurityConfig {

    @Autowired 
    private DataSource dataSource;

    @Autowired
    private UserDetailsService userDetailsService;

    // [추가] 세션 저장소 빈 등록 (SuccessHandler와 공유하기 위함)
    @Bean
    public SecurityContextRepository securityContextRepository() {
        return new HttpSessionSecurityContextRepository();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        log.info("---------------- 시큐리티 필터 체인 설정 시작 ----------------");        
        
        // [수정] 세션 저장소 설정 적용
        http.securityContext(context -> context.securityContextRepository(securityContextRepository()));

        http.authorizeHttpRequests(auth -> {
            auth.requestMatchers("/resources/**", "/css/**", "/js/**", "/favicon.ico").permitAll();
            auth.requestMatchers("/member/login", "/member/register").permitAll();
            
            // ROLE_USER도 목록을 볼 수 있도록 설정 유지
            auth.requestMatchers("/member/list").hasAnyRole("USER", "ADMIN");
            
            auth.anyRequest().authenticated();
        });

        http.formLogin(config -> {
            config.loginPage("/member/login");
            // [수정] 핸들러에 세션 저장소 주입 (아래 CustomLoginSuccessHandler 수정 필요)
            config.successHandler(new CustomLoginSuccessHandler(securityContextRepository()));
            config.permitAll();
        });

        // 세션 관리 설정 추가 (로그인 시 세션 유실 방지)
        http.sessionManagement(session -> session
            .sessionFixation().migrateSession()
        );

        http.rememberMe(config -> {
            config.key("my-key");
            config.tokenRepository(persistentTokenRepository());
            config.userDetailsService(userDetailsService); 
            config.tokenValiditySeconds(60 * 60 * 24 * 30);
        });
        
        http.logout(config -> {
            config.logoutUrl("/member/logout");
            config.logoutSuccessUrl("/member/login");
            config.deleteCookies("JSESSIONID", "remember-me");            
        });        
        
        http.csrf(config -> config.disable());
        
        http.exceptionHandling(config -> {
            config.accessDeniedHandler(new Custom403Handler());
        });
        
        return http.build();
    }
    
    @Bean
    public PersistentTokenRepository persistentTokenRepository() {
        JdbcTokenRepositoryImpl tokenRepository = new JdbcTokenRepositoryImpl();
        tokenRepository.setDataSource(dataSource);
        return tokenRepository;
    }
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}