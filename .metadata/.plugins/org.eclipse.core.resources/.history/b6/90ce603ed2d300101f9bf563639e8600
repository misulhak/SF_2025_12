package org.zerock.service;

import static org.junit.jupiter.api.Assertions.*;import java.lang.reflect.Member;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.zerock.dto.MemberDTO;

import lombok.extern.log4j.Log4j2;

@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j2
class MemberServiceTest {

	@Autowired
	private MemberService memberService;
	
	@Test
	void test() {
		memberService.getList()
		.forEach(member-> log.info(member));
	}
	
	@Test
	void testOne() {
		MemberDTO dto = memberService.memberById(1);
		
		log.info(dto);
	}
	
	@Test
	void testInsert() {
		MemberDTO dto = MemberDTO.builder()
				.name("이길동")
				.email("test@test.com")
				.password("1234")
				.build();
		
		memberService.insert(dto);

	}
	
	@Test
	void testUpdate() {
		MemberDTO dto = MemberDTO.builder()
				.name("김길동")
				.email("aaa@test.com")
				.password("1111")
				.mno(10)
				.build();
		
		memberService.update(dto);
	}
	
	@Test
	void testDelete() {
		memberService.delete(3);
	}

}
