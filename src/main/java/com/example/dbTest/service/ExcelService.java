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
	
	// 유성구
	public List<Map<String, Object>> getYuseongFacilityList(){
		return excelMapper.selectYuseong();
	}
	
	public List<Map<String, Object>> getFacilityList(String facilityName){
		return excelMapper.facilityList(facilityName);
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
		return excelMapper.selectSeo();
	}
	
	
}
