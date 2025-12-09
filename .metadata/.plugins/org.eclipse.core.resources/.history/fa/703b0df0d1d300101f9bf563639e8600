package org.zerock.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/*
 * create table table_board(
    bno int auto_increment primary key,
   title varchar(500) not null,
   content varchar(2000) not null,
   writer varchar(50) not null,
   regdate timestamp default now(),
   updatedate timestamp default now(),
   delflag boolean default false
   );
 */
@AllArgsConstructor  
@Builder              
@Data
@NoArgsConstructor   
public class MemberDTO {

	private int mno;
	private String name;
	private String email;
	private String password;
	private LocalDateTime regDate;
	private LocalDateTime updateDate;
	
	public String getCreatedDate() {
		return regDate.format(DateTimeFormatter.ISO_DATE);
	}
		
}
