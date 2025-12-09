package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.zerock.dto.TodoDTO;

@Mapper
public interface TodoMapper {

	void insert(TodoDTO dto);
	
	List<TodoDTO> getList();
	
	TodoDTO todoById(int mno);
	
	void update(TodoDTO dto);
	
	void delete(int mno);
}
