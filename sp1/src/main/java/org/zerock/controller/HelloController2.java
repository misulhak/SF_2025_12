package org.zerock.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.zerock.dto.SampleDTO;
import org.zerock.service.HelloService;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/test")
public class HelloController2 {

	//localhost:8080/test/ex1
	// /WEB-INF/views/test/ex1.jsp
	@GetMapping("/ex1") 
	public void ex1() {
		log.info("/sample/ex1");
	}

	//localhost:8080/test/ex2	
	// /WEB-INF/views/sample/success.jsp
	@GetMapping("/ex2")
	public String ex2() {
		log.info("/sample/success");
		return "sample/success";
	}

	//localhost:8080/test/ex3
	//localhost:8080/sample/ex3re
	@GetMapping("/ex3")
	public String ex3() {
		return "redirect:/test/ex3re";
	}
	
	//localhost:8080/test/ex3re
	// /WEB-INF/views/sample/ex3Result.jsp
	@GetMapping("/ex3re")
	public String ex3Re() {
		return "sample/ex3Result";
	}
	
	//localhost:8080/test/ex4?num=10&name=홍길동
	// /WEB-INF/views/test/ex4.jsp
	@GetMapping("/ex4")
	public void ex4(@RequestParam(name="num", defaultValue = "1") int num,
					@RequestParam("name") String name) {		
		log.info("num : " + num);
		log.info("name : " + name);		
	}

	//localhost:8080/test/ex5?id=1234&name=홍길동
	// /WEB-INF/views/test/ex5.jsp
	@GetMapping("/ex5")
	public void ex5(SampleDTO dto) {
		log.info(dto);
	}
	
}
