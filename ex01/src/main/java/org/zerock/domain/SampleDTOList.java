package org.zerock.domain;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class SampleDTOList {
	private List<SampleDTO> list;
	
	public SampleDTOList(SampleDTO sampleDTO) {
		list = new ArrayList<>();
	}

//	public List<SampleDTO> getList() {
//		return list;
//	}
//
//	public void setList(List<SampleDTO> list) {
//		this.list = list;
//	}
	
	
}
