package org.zerock.mapper;

import org.apache.ibatis.annotations.Select;
import org.zerock.dto.SampleDTO;

public interface TimeMapper {

	@Select("select now()")
	String getTime();	
	
	String getTime2();
	
	
}
