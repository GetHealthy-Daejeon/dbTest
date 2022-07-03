package com.example.dbTest.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ExcelMapper {
	/**
	 * @return
	 * @author : Youngjoon Yoo 
	 * @date : 2022. 7. 1.
	 * comment : 유성구 조회 함수
	 */
	public List<Map<String, Object>> selectYuseong();

	public List<Map<String, Object>> dataTest();
	public List<Map<String, Object>> facilityList(String facilityName);

	
	/**
	 * @return
	 * @author : Daeun Yang
	 * @date : 2022. 7. 1.
	 * comment : 대덕구 조회 함수
	 */
	public List<Map<String, Object>> selectDaedeok();
	
	/**
	 * @return
	 * @author : Daeun Yang
	 * @date : 2022. 7. 1.
	 * comment : 동구 조회 함수
	 */
	public List<Map<String, Object>> selectDong();
	
	/**
	 * @return
	 * @author : Daeun Yang
	 * @date : 2022. 7. 1.
	 * comment : 중구 조회 함수
	 */
	public List<Map<String, Object>> selectJung();
	
	/**
	 * @return
	 * @author : Daeun Yang
	 * @date : 2022. 7. 1.
	 * comment : 서구 조회 함수
	 */
	public List<Map<String, Object>> selectSeo();
	
	
	/**
	 * @return
	 * @author : Daeun Yang
	 * @date : 2022. 7. 3.
	 * comment : 운동 종목 카테고리별 조회
	 */
	public List<Map<String, Object>> selectEventCode(String eventCode);
}
