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
public class MapController {
	
	@Autowired
	private ExcelService excelService;
	
//	@CrossOrigin 
//	@GetMapping("/home/yuseong")
//	public String callHomepage(ModelMap map) {
//		List<Map<String, Object>> yuseongList = excelService.getYuseongFacilityList();
//		map.addAttribute("yuseongList", yuseongList);
//		return "map";
//	}
//	
//	@CrossOrigin
//	@GetMapping("/home/daedeok")	
//	public String callHomePage2(ModelMap map) {
//		List<Map<String, Object>> daedeokList = excelService.getDaedeokFacilityList();
//		map.addAttribute("daedeokList", daedeokList);
//		return "map";
//	}
//	
//	@CrossOrigin 
//	@GetMapping("/home/dong")	
//	public String callHomePage3(ModelMap map) {
//		List<Map<String, Object>> dongList = excelService.getDongFacilityList();
//		map.addAttribute("dongList", dongList);
//		return "map";
//	}
//	
//	@CrossOrigin 
//	@GetMapping("/home/jung")	
//	public String callHomePage4(ModelMap map) {
//		List<Map<String, Object>> jungList = excelService.getJungFacilityList();
//		map.addAttribute("jungList", jungList);
//		return "map";
//	}
//		
//	@CrossOrigin 
//	@GetMapping("/home/seo")	
//	public String callHomePage5(ModelMap map) {
//		List<Map<String, Object>> seoList = excelService.getSeoFacilityList();
//		map.addAttribute("seoList", seoList);
//		return "map";
//	}
	
	@GetMapping("/map")
	public String callHomepage(ModelMap map) {
		List<Map<String, Object>> yuseongList = excelService.getYuseongFacilityList();
//		List<Map<String, Object>> list = excelService.getTestList();
		map.addAttribute("yuseongList", yuseongList);
		
		List<Map<String, Object>> daedeokList = excelService.getDaedeokFacilityList();
		map.addAttribute("daedeokList", daedeokList);
		
		List<Map<String, Object>> dongList = excelService.getDongFacilityList();
		map.addAttribute("dongList", dongList);
		
		List<Map<String, Object>> jungList = excelService.getJungFacilityList();
		map.addAttribute("jungList", jungList);

		List<Map<String, Object>> seoList = excelService.getSeoFacilityList();
		map.addAttribute("seoList", seoList);
		
		return "map";
	}
		
	
}
