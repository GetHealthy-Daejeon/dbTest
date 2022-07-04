package com.example.dbTest.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.example.dbTest.service.ExcelService;

@RestController
public class ExcelRestController {
	@Autowired
	private ExcelService excelService;
	
//	@GetMapping("/facility/{facility_name}")
//	public List<Map<String, Object>> getTennis(@PathVariable("facility_name") String facilityName){
//		return excelService.getFacilityList(facilityName);
//	}
	
	
	
	

}

