package com.example.dbTest.vo;

import lombok.Data;

@Data
public class FacilityVO {
	private int placeNo; // 시설 번호
	private String guCode; // 구코드
	private String eventCode; // 종목 코드
	private String facName; // 시설명
	private String digit; // 전화번호
	private double latitude; // 위도
	private double longitude; // 경도
	
}
