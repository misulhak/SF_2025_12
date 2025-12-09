package org.zerock.dto;

import java.sql.Timestamp; 
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/*
  CREATE TABLE simple_todo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description VARCHAR(500),
    done BOOLEAN DEFAULT FALSE,
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
 */
@AllArgsConstructor  
@Builder              
@Data
@NoArgsConstructor   
public class TodoDTO {

	private int id;
    private String title;
    private String description;
    private boolean done;
    private Timestamp createAt;
	
}
