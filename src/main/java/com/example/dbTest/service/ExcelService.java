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
	
//	public List<Map<String, Object>> getFacilityList(){
//		return excelMapper.facilityList();
//	}
	
	// 유성구
	public List<Map<String, Object>> getYuseongFacilityList(){
		return excelMapper.selectYuseong();
	}

	// 대덕구
	public List<Map<String, Object>> getDaedeokFacilityList(){
		return excelMapper.selectDaedeok();
	}
	
	// 동구
	public List<Map<String, Object>> getDongFacilityList(){
		return excelMapper.selectDong();
	}
	
	// 중구
	public List<Map<String, Object>> getJungFacilityList(){
		return excelMapper.selectJung();
	}
	
	// 서구
	public List<Map<String, Object>> getSeoFacilityList(){
//		List<Map<String, Object>> list = excelMapper.selectSeo(eventCode);
		return excelMapper.selectSeo();
	}
	
	
	// 종목코드별 조회
	public List<Map<String, Object>> getEventCode(String eventCode){
		return excelMapper.selectEventCode(eventCode);
	}
	
	
}
