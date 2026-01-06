package org.zerock.security;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.context.SecurityContextRepository;
import lombok.extern.log4j.Log4j2;

@Log4j2
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

    private final SecurityContextRepository repository;

    // 생성자를 통해 SecurityConfig에서 만든 저장소를 주입받음
    public CustomLoginSuccessHandler(SecurityContextRepository repository) {
        this.repository = repository;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        
        log.info("LOGIN SUCCESS: " + authentication.getName());

        // 명시적으로 인증 정보를 세션에 저장 (시큐리티 6 필수 과정)
        repository.saveContext(org.springframework.security.core.context.SecurityContextHolder.getContext(), request, response);

        response.sendRedirect(request.getContextPath() + "/member/list");
    }
}