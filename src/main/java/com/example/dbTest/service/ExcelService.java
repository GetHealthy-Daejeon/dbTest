package com.example.dbTest.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.dbTest.mapper.ExcelMapper;

@Service
public class ExcelService {
	@Autowired
	ExcelMapper excelMapper;
	
	public List<Map<String, Object>> getFacilityList(String facilityName){
		return excelMapper.facilityList(facilityName);
	}
	
	// 유성구
	public List<Map<String, Object>> getYuseongFacilityList(String eventCode){
		return excelMapper.selectYuseong(eventCode);
	}

	// 대덕구
	public List<Map<String, Object>> getDaedeokFacilityList(String eventCode){
		return excelMapper.selectDaedeok(eventCode);
	}
	
	// 동구
	public List<Map<String, Object>> getDongFacilityList(String eventCode){
		return excelMapper.selectDong(eventCode);
	}
	
	// 중구
	public List<Map<String, Object>> getJungFacilityList(String eventCode){
		return excelMapper.selectJung(eventCode);
	}
	
	// 서구
	public List<Map<String, Object>> getSeoFacilityList(String eventCode){
//		List<Map<String, Object>> list = excelMapper.selectSeo(eventCode);
		return excelMapper.selectSeo(eventCode);
	}
	
	
	// 종목코드별 조회
	public List<Map<String, Object>> getEventCode(String eventCode){
		return excelMapper.selectEventCode(eventCode);
	}
	
	
}
