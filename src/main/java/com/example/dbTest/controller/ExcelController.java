package com.example.dbTest.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.dbTest.service.ExcelService;

@Controller
public class ExcelController {
	
	@Autowired
	private ExcelService excelService;
	
	@GetMapping("/home")
	public String callHomepage(ModelMap map) {
		List<Map<String, Object>> list = excelService.getYuseongFacilityList();
//		List<Map<String, Object>> list = excelService.getTestList();
		map.addAttribute("list", list);
		return "map";
	}
}
