package org.zerock.service;

import java.util.List;
import org.springframework.stereotype.Service;
import org.zerock.dto.TodoDTO;
import org.zerock.mapper.TodoMapper;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2; // 로그 사용 시 추가

@Service
@RequiredArgsConstructor
@Log4j2 // 로그 추가
public class TodoService {
	
	private final TodoMapper mapper;
	
	public List<TodoDTO> getList() { 
        log.info("Service: getList 호출");
		return mapper.getList();
	}
	
	public TodoDTO getTodoById(int id) { 
        log.info("Service: getTodoById 호출, ID: " + id);
		return mapper.todoById(id);
	}
	
    @Transactional
	public void update(TodoDTO dto) {
        log.info("Service: update 호출, DTO: " + dto);
		mapper.update(dto);
	}
	
    @Transactional
	public void insert(TodoDTO dto) {
        log.info("Service: insert 호출, DTO: " + dto);
		mapper.insert(dto);
	}
	
    @Transactional
	public void delete(int id) {
        log.info("Service: delete 호출, ID: " + id);
		mapper.delete(id);
	}
}