package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.dto.BoardDTO;

public interface BoardMapper {
	
	int insert(BoardDTO dto);
	
	BoardDTO selectOne(Long bno);
	
	int remove(Long bno);
	
	int update(BoardDTO dto);
	
	List<BoardDTO> list();
	
	List<BoardDTO> list2(@Param("skip") int skip, @Param("count") int count);
	
	int listCount();
	
	/*
	 * T, C, W
	 * types : TCW -> T|C|W
	 * keyword : 스프링 검색
	 */
	List<BoardDTO> listSearch(@Param("skip") int skip,
								@Param("count") int count,
								@Param("type")String[] types,
								@Param("keyword")String keyword
								);
}
