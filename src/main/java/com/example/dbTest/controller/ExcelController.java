package com.example.dbTest.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.dbTest.service.ExcelService;


@Controller
public class ExcelController {
	
	@Autowired
	private ExcelService excelService;
	
	@GetMapping("/home")
	public String callHomepage() {
		return "map";
//		index.jsp의 파일명
	}
}
