package org.zerock.domain;

import lombok.Data;

@Data
public class AttachDTO {
	private String fileName;
	private String uploadPath;
	private String uuid;
	private boolean image;
}
