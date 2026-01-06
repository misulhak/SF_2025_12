package org.zerock.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.dto.MemberDTO;
import org.zerock.dto.MemberPagingDTO;
import org.zerock.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    // 1. 로그인 페이지
    @GetMapping("/login")
    public void loginGET(String error, String logout) {
        log.info("--- Member Login GET ---");
        if (error != null) log.info("login error........");
        if (logout != null) log.info("user logout........");
    }

    // 2. 회원 목록
    @PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')") // USER와 ADMIN 모두 허용
    @GetMapping("/list")
    public void list(
            @RequestParam(name="page", defaultValue = "1") int page,
            @RequestParam(name="size", defaultValue = "10") int size,
            @RequestParam(name="types", required = false) String types,
            @RequestParam(name="keyword", required = false) String keyword,            
            Model model) {
        
        log.info("--- Member List ---");
        MemberPagingDTO list = memberService.getList(page, size, types, keyword);
        model.addAttribute("dto", list);
    }

    // 3. 등록 화면/처리
    @GetMapping("/register")
    public void register() { }

    @PostMapping("/register")
    public String registerPost(MemberDTO dto, RedirectAttributes rttr) {
        log.info("--- Member Register Post --- " + dto);
        memberService.register(dto);
        rttr.addFlashAttribute("result", dto.getUserid());
        return "redirect:/member/list";
    }

    // 4. 상세 조회 (MemberController.java)
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/read/{userid}")
    public String read(@PathVariable("userid") String userid,  // 반환 타입을 String으로 변경
                       @RequestParam(name="page", defaultValue = "1") int page,
                       @RequestParam(name="size", defaultValue = "10") int size,
                       @RequestParam(name="types", required = false) String types,
                       @RequestParam(name="keyword", required = false) String keyword,
                       Model model) {
        
        log.info("--- Member Read GET --- " + userid);
        
        MemberDTO dto = memberService.read(userid);
        model.addAttribute("member", dto);
        
        // JSP에서 검색/페이징 정보 유지를 위해 model에 담음
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("types", types);
        model.addAttribute("keyword", keyword);
        
        // ★ 중요: 반환값을 명시하여 /member/read/아이디.jsp가 아닌 /member/read.jsp를 보게 함
        return "member/read"; 
    }

 // 5. 수정 화면 이동 (MemberController.java)
    @PreAuthorize("hasRole('ROLE_ADMIN') or principal.username == #userid")
    @GetMapping("/modify/{userid}")
    public String modifyGet(@PathVariable("userid") String userid, 
                           @RequestParam(name="page", defaultValue = "1") int page,
                           @RequestParam(name="size", defaultValue = "10") int size,
                           @RequestParam(name="types", required = false) String types,
                           @RequestParam(name="keyword", required = false) String keyword,
                           Model model) {
        
        log.info("--- Member Modify GET --- " + userid);
        
        MemberDTO dto = memberService.read(userid);
        model.addAttribute("member", dto);
        
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("types", types);
        model.addAttribute("keyword", keyword);
        
        // ★ 이 부분을 void에서 String으로 바꾸고 아래와 같이 리턴하세요.
        // 이렇게 해야 /member/modify/somi10000.jsp가 아닌 /member/modify.jsp를 찾습니다.
        return "member/modify"; 
    }

    // 6. 수정 처리 (MemberController.java)
    @PreAuthorize("hasRole('ROLE_ADMIN') or principal.username == #dto.userid")
    @PostMapping("/modify")
    public String modifyPost(@ModelAttribute("dto") MemberDTO dto, 
                             int page, 
                             int size, 
                             String types, 
                             String keyword, 
                             RedirectAttributes rttr) {
        
        log.info("--- Member Modify Post --- " + dto);
        memberService.modify(dto);

        // 쿼리스트링 파라미터 추가
        rttr.addAttribute("page", page);
        rttr.addAttribute("size", size);
        rttr.addAttribute("types", types);
        rttr.addAttribute("keyword", keyword);

        rttr.addFlashAttribute("result", "modified");
        
        // 수정된 부분: "redirect:" 다음에 반드시 전체 경로를 써줍니다.
        // contextPath가 자동으로 붙으므로 /member/read/... 로 시작하면 됩니다.
        return "redirect:/member/read/" + dto.getUserid();
    }

    // 7. 삭제 처리
    @PreAuthorize("hasRole('ROLE_ADMIN') or principal.username == #userid")
    @PostMapping("/remove")
    public String remove(@RequestParam("userid") String userid, 
                         int page, 
                         int size, 
                         String types, 
                         String keyword, 
                         RedirectAttributes rttr) {
        
        log.info("--- Member Remove --- " + userid);
        memberService.remove(userid);
        
        // 삭제 후 리스트로 돌아갈 때도 검색 조건 유지
        rttr.addAttribute("page", page);
        rttr.addAttribute("size", size);
        rttr.addAttribute("types", types);
        rttr.addAttribute("keyword", keyword);

        rttr.addFlashAttribute("result", "removed");
        return "redirect:/member/list";
    }
}