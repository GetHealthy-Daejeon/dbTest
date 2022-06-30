package com.example.dbTest.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ExcelMapper {
	public List<Map<String, Object>> selectYuseong();
}
