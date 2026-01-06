package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.dto.MemberDTO;

public interface MemberMapper {
	
	//1. 회원 가입 (성공 시 1 반환)
	int insert(MemberDTO dto);
	
	//2. 권한 부여 (userid와 rolename 매핑)
	int insertRole(@Param("userid") String userid, @Param("rolename") String rolename);
	
	//3. 단인 회원 조회 (로그인 시 사용, 권한 리스트 포함)
	MemberDTO selectOne(String userid);
	
	//4. 회원 탈퇴 또는 삭제
	int remove(String userid);
	
	//5. 회원 정보 수정 (이름, 이메일, 연락처 등)
	int update(MemberDTO dto);
	
	//6. 회원 목록 및 검색 (BoardMapper의 listSearch 스타일)
	/*
	 * types: ID(userid), E(email), N(name) 등
	 * keyword: 검색어
	 */
	List<MemberDTO> listSearch(
			@Param("skip") int skip,
			@Param("count") int count,
			@Param("types") String[] types,
			@Param("keyword") String keyword
			);
	
	//7. 검색 결과 총 개수 (페이징용)
	int listCountSearch(
			@Param("types") String[] types,
			@Param("keyword") String keyword
			);
}
