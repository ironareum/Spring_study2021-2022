package org.zerock.domain;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
//@AllArgsConstructor
public class Ticket {
	private int tno;
	private String owner;
	private String grade;	
}
