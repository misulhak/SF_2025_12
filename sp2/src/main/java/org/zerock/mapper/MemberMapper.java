package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.zerock.dto.MemberDTO;

@Mapper
public interface MemberMapper {

	void insert(MemberDTO dto);
	
	List<MemberDTO> getList();
	
	MemberDTO memberById(int mno);
	
	void update(MemberDTO dto);
	
	void delete(int mno);
}
