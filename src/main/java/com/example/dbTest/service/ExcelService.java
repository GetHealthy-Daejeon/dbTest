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
	
	public List<Map<String, Object>> getYuseongFacilityList(){
		return excelMapper.selectYuseong();
	}
	
	public List<Map<String, Object>> getFacilityList(String facilityName){
		return excelMapper.facilityList(facilityName);
	}
}
