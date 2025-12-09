package org.zerock.mapper;

import static org.junit.jupiter.api.Assertions.*;

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
class MemberMapperTests {
    
	@Autowired
	private MemberMapper memberMapper;
	
	@Test
	void testInsert() {
		MemberDTO dto = MemberDTO.builder()
				.name("홍길동")
				.email("test4@naver.com")
				.password("1234")
				.build();
		
		memberMapper.insert(dto);
		
		//log.info("생성된 PK : " + dto.getMno());
		
		assertNotNull(dto.getMno());
	}
	
	@Test
	void testList() {
		memberMapper.getList()
		.forEach(member-> log.info(member));
	}
	
	@Test
	void testMemberById() {
		MemberDTO dto = memberMapper.memberById(3);
		
		log.info(dto);
	}
	
	@Test
	void testUpdate() {
		MemberDTO dto = MemberDTO.builder()
				.name("이길동")
				.password("1234")
				.email("test@test.com")
				.mno(2)
				.build();
		
		memberMapper.update(dto);
		
		log.info(memberMapper.memberById(2));
	} // end testUpdate
	
	@Test
	void testDelete() {
		memberMapper.delete(5);
		
	}

} // end test
