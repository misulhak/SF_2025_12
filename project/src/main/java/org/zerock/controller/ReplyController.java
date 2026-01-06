package org.zerock.controller;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.dto.ReplyDTO;
import org.zerock.dto.ReplyListPaginDTO;
import org.zerock.service.ReplyService;
import org.zerock.service.ReplyException;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@RestController
@RequiredArgsConstructor
@Log4j2
@RequestMapping("/replies")
public class ReplyController {
	
	private final ReplyService replyService;
	
	@ExceptionHandler(ReplyException.class)
	public ResponseEntity<String> handleReplyError(ReplyException ex){
		log.error("Reply Error: " + ex.getMessage());
		return ResponseEntity.status(ex.getCode()).body(ex.getMsg());
	}

	// 1. 특이사항 등록
	// 관리자이거나, 요청 데이터(replyDTO)의 작성자(replyer)가 로그인한 사용자 본인인 경우만 허용
	@PreAuthorize("hasRole('ROLE_ADMIN') or principal.username == #replyDTO.replyer")
	@PostMapping("")
	public ResponseEntity<Map<String, Integer>> add(@RequestBody ReplyDTO replyDTO){
		
		log.info("--------------- 계좌 특이사항 등록 -----------------");
		log.info(replyDTO);
		
		replyService.add(replyDTO);
		
		return ResponseEntity.ok(Map.of("result", replyDTO.getRno()));
	}
	
	// 2. 목록 조회 (조회는 인증된 사용자라면 모두 가능)
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/member/{num}/list")
	public ResponseEntity<ReplyListPaginDTO> listOfMember(
				@PathVariable("num") int num, 
				@RequestParam(name="page", defaultValue = "1") int page,
				@RequestParam(name="size", defaultValue = "10") int size
			){
		
		log.info("--- 특정 회원 특이사항 목록 조회 (num: " + num + ") ---");
		ReplyListPaginDTO listPaginDTO = replyService.listOfMember(num, page, size);
		
		return ResponseEntity.ok(listPaginDTO);
	}
	
	// 3. 개별 조회
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/{rno}")
	public ResponseEntity<ReplyDTO> read(@PathVariable("rno") int rno){
		return ResponseEntity.ok(replyService.getOne(rno));
	}
	
	// 4. 특이사항 삭제
	// 삭제하려는 글의 작성자이거나 관리자여야 함 (Service에서 작성자 체크 로직이 포함되어야 더 완벽함)
	// 여기서는 간단하게 principal과 작성자를 대조하는 설정을 추가합니다.
	@PreAuthorize("hasRole('ROLE_ADMIN') or principal.username == #replyDTO.replyer")
	@DeleteMapping("/{rno}")
	public ResponseEntity<Map<String,String>> delete(@PathVariable("rno") int rno, @RequestBody(required = false) ReplyDTO replyDTO){
		
		log.info("--- 특이사항 삭제 (rno: " + rno + ") ---");
		replyService.remove(rno);
		
		return ResponseEntity.ok(Map.of("result", "deleted"));
	}
	
	// 5. 특이사항 수정
	@PreAuthorize("hasRole('ROLE_ADMIN') or principal.username == #replyDTO.replyer")
	@PutMapping("/{rno}")
	public ResponseEntity<Map<String,String>> modify(
            @PathVariable("rno") int rno,
			@RequestBody ReplyDTO replyDTO){
		
		log.info("--- 특이사항 수정 (rno: " + rno + ") ---");
		replyDTO.setRno(rno);
		replyService.modify(replyDTO);
		
		return ResponseEntity.ok(Map.of("result", "modified"));
	}
}