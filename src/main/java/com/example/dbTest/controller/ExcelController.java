package com.example.dbTest.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.example.dbTest.service.ExcelService;

@Controller
public class ExcelController {
	
	@Autowired
	private ExcelService excelService;
	
	@CrossOrigin 
	@GetMapping("/home/{event_code}")
	public String callHomepage(ModelMap map, @PathVariable("event_code") String eventCode) {
		List<Map<String, Object>> yuseongList = excelService.getYuseongFacilityList(eventCode);
//		List<Map<String, Object>> list = excelService.getTestList();
		map.addAttribute("yuseongList", yuseongList);
		
		List<Map<String, Object>> daedeokList = excelService.getDaedeokFacilityList(eventCode);
		map.addAttribute("daedeokList", daedeokList);
		
		List<Map<String, Object>> dongList = excelService.getDongFacilityList(eventCode);
		map.addAttribute("dongList", dongList);
		
		List<Map<String, Object>> jungList = excelService.getJungFacilityList(eventCode);
		map.addAttribute("jungList", jungList);

		List<Map<String, Object>> seoList = excelService.getSeoFacilityList(eventCode);
		map.addAttribute("seoList", seoList);
		
		
		return "map";
	}
	
}
