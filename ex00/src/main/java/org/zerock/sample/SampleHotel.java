package org.zerock.sample;

import org.springframework.stereotype.Component;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.ToString;


@Component
@Getter
@ToString
@AllArgsConstructor
public class SampleHotel {
	
	private Chef chef;
	
	/*
	 * public SampleHotel(Chef chef){ this.chef = chef; }
	 */
}
