<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<style>

</style>
	<meta charset="utf-8" />
	<title>건강하슈</title>
	<link href="/resources/static/css/map.css" rel="stylesheet">
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Gamja+Flower&family=Orbitron:wght@600&display=swap" rel="stylesheet">
</head>
<body>
	<div class="container">
		<div class="logo">
		  <a class="navbar-brand custom_navbar-brand" href="/health/index">
		  	<img src="/resources/static/img/logo.png" alt="">
		  </a>
		  <div class="side-button">
		  	<ul>
			  	<li>
			  		<div class="location_btn">
			  			<button><img src="./resources/static/img/gps.png" alt="">내 위치</button>
			  		</div>
			  	</li>
			  	<li>
			  		<div class="test_btn">
			  		<!-- style="display: none" -->
				  		<button><img src="./resources/static/img/gps.png" alt="">테스트</button>		  		
			  		</div>
			  	</li>
		  	</ul>
		  </div>
		</div>
		<div class="banner">
			<div class="banner-list">
				<input name ="facility" type="button" id="T" value="테니스장">
				<input name ="facility" type="button" id="B" value="배드민턴">
				<input name ="facility" type="button" id="BB" value="야구">
				<input name ="facility" type="button" id="BK" value="농구">
				<input name ="facility" type="button" id="J" value="족구">
				<input name ="facility" type="button" id="G" value="게이트볼">
				<input name ="facility" type="button" id="F" value="풋살&축구">
				<input name ="facility" type="button" id="S" value="수영장">
				<input name ="facility" type="button" id="V" value="배구">
				<input name ="facility" type="button" id="H" value="체육관">
				<input name ="facility" type="button" id="A" value="양궁">
				<input name ="facility" type="button" id="P" value="공원체육시설">
				<input name ="facility" type="button" id="E" value="기타체육시설">
				<hr width="90%" color="#000" noshade />
				<input type="button" id="park" value="공원">
				<input type="button" id="tashu" value="타슈">
				<input type="button" id="deleteMarker" value="마크제거(테스트용)" onclick="deletePolygon(markers)">
				<input type="button" id="refresh" value="지도초기화" onclick="window.location.reload()">
			</div>
			<div class="text-box">
				구&nbsp;를&nbsp;&nbsp;선&nbsp;택&nbsp;해&nbsp;&nbsp;주&nbsp;세&nbsp;요
			</div>
		 </div>
		<div id="map"></div>
	</div>
</body>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"
	integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
	crossorigin="anonymous"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=053fa1a57cda6a2315480dc66ba2a3ec&libraries=services"></script>
<script>
	// 지도 설정
	var mapContainer = document.getElementById("map"), // 지도를 div
	mapOption = {
	  center: new kakao.maps.LatLng(36.3504119, 127.3845475), // 중심좌표
	  level: 8,
	};
	
	// 지도 생성
    var map = new kakao.maps.Map(mapContainer, mapOption); 
    
	// 주소-좌표 변환 객체를 생성
	var geocoder = new kakao.maps.services.Geocoder();
    
	// 지도 오른쪽 위에 지도 타입 컨트롤 추가
    var mapTypeControl = new kakao.maps.MapTypeControl();
	map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
</script>
<script>
    var polygons = []; // 폴리곤 제거하기 위한 배열
    var markers = []; // 마커 전체 제거하기 위한 배열

    // 폴리곤(또는 마커) 제거 함수
    function deletePolygon(polygons) {
      for (var i = 0; i < polygons.length; i++) {
        polygons[i].setMap(null);
      }
      polygons = [];
    }

    // 유성구
    // 유성구 폴리곤 데이터 갖고오기
    $.getJSON("resources/static/구별json/yuseong.json", function (geojson) { // yuseong.json 파일의 데이터를 가져 옴
        var data = geojson.features;
        var coordinates = []; // 좌표 저장
        var name = ""; // 구 이름
        $.each(data, function (index, val) {
          coordinates = val.geometry.coordinates;
          name = val.properties.SGG_NM;
          displayYuseongArea(coordinates, name);
        });
    });
    // 유성구 폴리곤 생성
	function displayYuseongArea(coordinates, name) {
		var yuseongPolygonPath = []; // 유성구 폴리곤 배열
		var points = []; // centroid 함수에 사용하기 위해 좌표를 저장시키는 배열
		$.each(coordinates[0], function (index, coordinate) { // coordinates [0]번째에 배열 있음
			var point = new Object();
			point.x = coordinate[1]; // 경도. ex) 36.3504119
			point.y = coordinate[0]; // 위도. ex) 127.3845475
			points.push(point); // points 배열에 저장
			yuseongPolygonPath.push(new kakao.maps.LatLng(coordinate[1], coordinate[0])); // yuseongPolygonPath에 저장
		});
		// 유성구 다각형(yuseongPolygon) 만들기
		var yuseongPolygon = new kakao.maps.Polygon({
	        map: map, // 다각형을 표시할 지도이름
	        path: yuseongPolygonPath, // 위에서 만든 좌표 배열
	        strokeWeight: 4, // 선 두께
	        strokeColor: "#FFFFFF", // 선 색
	        strokeOpacity: 0.8, // 선 불투명도
	        fillColor: "#6ADF35", // 채우기 색
	        fillOpacity: 0.7, // 채우기 불투명도
		});
		polygons.push(yuseongPolygon); // polygons 배열에 yuseongPolygon push. 제거하기 위함.
		
		// 유성구 폴리곤을 클릭 이벤트(유성구 행정동 폴리곤 데이터 가져오기)
		kakao.maps.event.addListener(
			yuseongPolygon,
			"click",
			function (mouseEvent) {
				$(".text-box").css({"visibility":"hidden"}) // 구 클릭하면 텍스트박스 사라짐
				$(".banner").css({"visibility":"visible", "max-width":"10%"}) // 구 클릭하면 배너가 옆으로 나오는 이벤트
				$(".banner-list").css({"visibility":"visible","width":"100%"}) // 구 클릭하면 리스트가 옆으로 나오는 이벤트
				getParkInfo(name); // 공원정보
				getTashuInfo(name); // 타슈정보
				getFacilityInfo('${yuseongList}'); // 시설정보
				var level = map.getLevel() - 1; // 지도 레벨 -1(확대)
				// 클릭한 곳으로 이동하는 것으로 교체 -> 클릭한 지도의 중앙으로 이동 : map.setLevel(level, {anchor: centroid(points), animate: {
				map.setLevel(level, {
					anchor: new daum.maps.LatLng(
						mouseEvent.latLng.getLat(),
						mouseEvent.latLng.getLng()
					),
					animate: {
						duration: 350, // 확대 애니메이션 시간
					},
				});
				
				$.getJSON("resources/static/구별json/yuseong.json", function (geojson) {
					var data = geojson.features;
					var coordinates = []; // 좌표 저장
					var dongName = ""; // 동 이름
					$.each(data, function (index, val) {
						coordinates = val.geometry.coordinates;
						name = val.properties.SGG_NM;
						var color = "#6ADF35";
						displayYuseong_dong(coordinates, name, color);
					});
				});
				deletePolygon(polygons); //폴리곤 제거
				customOverlay.setMap(null); // 커스텀 오버레이(구 이름) 제거
			}
		); // 유성구 폴리곤을 클릭 이벤트 종료

		// 유성구 마우스오버 이벤트
		kakao.maps.event.addListener(yuseongPolygon, "mouseover", function () {
			yuseongPolygon.setOptions({
				fillColor: "#6ADF35", // 색상
				fillOpacity: 1, // 불투명도
			});
		});
		// 유성구 마우스아웃 이벤트
		daum.maps.event.addListener(yuseongPolygon, "mouseout", function () {
			yuseongPolygon.setOptions({
		        fillColor: "#6ADF35", // 채우기 색깔 초록색 : A2FF99
		        fillOpacity: 0.8, // 채우기 불투명도
			});
		});

		// 커스텀 오버레이 내용
		var content = '<div class ="label" style ="font-size:40px; font-weight : 800">'+name+'</div>'; // name은 위에서 받아 온 유성구
		// 커스텀 오버레이 위치
		var position = centroid(points);
		// 위 오버레이 설정으로 커스텀 오버레이 생성
		var customOverlay = new kakao.maps.CustomOverlay({
			position: position,
			content: content,
		});
		// 커스텀 오버레이를 지도에 표시
		customOverlay.setMap(map);
	} // 유성구 폴리곤 생성함수 끝
	
    // 확대된 유성구 폴리곤 만들기 함수 ((구)행정동(유성구) 폴리곤 만들기)
	function displayYuseong_dong(coordinates, name, color) { // 좌표, 이름, 색상을 파라미터로 받는다
		var yuseong_dong_PolygonPath = [];
		$.each(coordinates[0], function (index, coordinate) {
			yuseong_dong_PolygonPath.push(
				new kakao.maps.LatLng(coordinate[1], coordinate[0])
			);
		});
		var yuseong_dong_Polygon = new kakao.maps.Polygon({
			map: map, // 다각형을 표시할 지도 객체
			path: yuseong_dong_PolygonPath, // 좌표 배열
			strokeWeight: 2, // 선 두께
			strokeColor: "#00ff0000", // 선 색깔 
			strokeOpacity: 0.8, // 선 불투명도
			fillColor: color, // 채우기 색깔
			fillOpacity: 0.2, // 채우기 불투명도
		});

		// (최신)확대된 유성구 클릭 이벤트 ((구)행정동 클릭 이벤트)
		kakao.maps.event.addListener(
			yuseong_dong_Polygon,
			"click",
			function (mouseEvent) {
				var level = map.getLevel() - 2;
				map.setLevel(level, {
					anchor: new daum.maps.LatLng(
						mouseEvent.latLng.getLat(),
						mouseEvent.latLng.getLng()
					),
					animate: {
						duration: 350,
					},
				});
			}
		);
	}

    // 대덕구
    // 대덕구
    $.getJSON("resources/static/구별json/daedeok.json", function (geojson) {
      var data = geojson.features;
      var coordinates = [];
      var name = "";
      $.each(data, function (index, val) {
        coordinates = val.geometry.coordinates;
        name = val.properties.SGG_NM;
        displayDaedeokArea(coordinates, name);
      });
    });
    // 대덕구 폴리곤 생성
    function displayDaedeokArea(coordinates, name) {
      var daedeokPolygonPath = [];
      var points = [];
      $.each(coordinates[0], function (index, coordinate) {
        var point = new Object();
        point.x = coordinate[1];
        point.y = coordinate[0];
        points.push(point);
        daedeokPolygonPath.push(
          new kakao.maps.LatLng(coordinate[1], coordinate[0])
        );
      });
      // 대덕구 다각형 설정
      var daedeokPolygon = new kakao.maps.Polygon({
        map: map, // 다각형을 표시할 지도 객체
        path: daedeokPolygonPath, // 좌표 배열
        strokeWeight: 4, // 선 두께
        strokeColor: "#FFFFFF", // 선 색깔
        strokeOpacity: 0.8, // 선 불투명도
        fillColor: "#FFD700", // 채우기 색깔
        fillOpacity: 0.8, // 채우기 불투명도
      });
      polygons.push(daedeokPolygon); // 폴리곤 제거하기 위한 배열
      // 대덕구 폴리곤을 클릭하면 대덕구 행정동 폴리곤 데이터 가져오기
      kakao.maps.event.addListener(
        daedeokPolygon,
        "click",
        function (mouseEvent) {
            $(".text-box").css({"visibility":"hidden"})
            $(".banner").css({"visibility":"visible", "max-width":"10%"})
            $(".banner-list").css({"visibility":"visible","width":"100%"})
            getParkInfo(name); // name = 대덕구
            getTashuInfo(name);
            getFacilityInfo('${daedeokList}');
        	
			var level = map.getLevel() - 2;
			map.setLevel(level, {
				anchor: new daum.maps.LatLng(
					mouseEvent.latLng.getLat(),
					mouseEvent.latLng.getLng()
				),
			animate: {
				duration: 350, // 확대 애니메이션 시간
            },
          });
          $.getJSON("resources/static/구별json/daedeok.json", function (geojson) {
            var data = geojson.features;
            var coordinates = [];
            var dongName = "";
            var color = "#FFD700";
            $.each(data, function (index, val) {
              coordinates = val.geometry.coordinates;
              name = val.properties.SGG_NM;
              displayYuseong_dong(coordinates, name, color); // 행정동 폴리곤 만들기 공동사용
            });
          });
          deletePolygon(polygons);
          customOverlay.setMap(null); // 커스텀 오버레이(구 이름) 제거
        }
      );
      // 마우스오버 이벤트
      kakao.maps.event.addListener(daedeokPolygon, "mouseover", function () {
        daedeokPolygon.setOptions(mouseoverOption);
      });
      // 마우스오버 이벤트 채우기
      var mouseoverOption = {
        fillColor: "#FFD700", // 색상
        fillOpacity: 1, // 불투명도
      };
      // 마우스아웃 이벤트
      daum.maps.event.addListener(daedeokPolygon, "mouseout", function () {
        daedeokPolygon.setOptions(mouseoutOption);
      });
      // 마우스아웃 채우기
      var mouseoutOption = {
        fillColor: "#FFD700",
        fillOpacity: 0.8, // 채우기 불투명도
      };

      // 커스텀 오버레이 내용
      var content = '<div class ="label" style ="font-size:40px; font-weight : 800">'+name+'</div>';
      // 커스텀 오버레이 위치
      var position = centroid(points);
      // 커스텀 오버레이 생성
      var customOverlay = new kakao.maps.CustomOverlay({
        position: position,
        content: content,
      });
      // 커스텀 오버레이를 지도에 표시
      customOverlay.setMap(map);
    }

    // 동구 --- 멀티폴리곤(성남동) 구현 필요함
    // 동구
    $.getJSON("resources/static/구별json/dong.json", function (geojson) {
      var data = geojson.features;
      var coordinates = []; // 좌표 저장
      var name = ""; // 구 이름
      $.each(data, function (index, val) {
        coordinates = val.geometry.coordinates;
        name = val.properties.SGG_NM;
        displayDongArea(coordinates, name);
      });
    });
    // 동구 폴리곤 생성
    function displayDongArea(coordinates, name) {
      var dongPolygonPath = [];
      var points = [];
      $.each(coordinates[0], function (index, coordinate) {
        var point = new Object();
        point.x = coordinate[1];
        point.y = coordinate[0];
        points.push(point);
        dongPolygonPath.push(
          new kakao.maps.LatLng(coordinate[1], coordinate[0])
        );
      });
      // 동구 다각형 설정
      var dongPolygon = new kakao.maps.Polygon({
        map: map, // 다각형을 표시할 지도 객체
        path: dongPolygonPath, // 좌표 배열
        strokeWeight: 4, // 선 두께
        strokeColor: "#FFFFFF", // 선 색깔
        strokeOpacity: 0.8, // 선 불투명도
        fillColor: "#09f", // 채우기 색깔
        fillOpacity: 0.8, // 채우기 불투명도
      });
      polygons.push(dongPolygon); // 폴리곤 제거하기 위한 배열
      // 동구 폴리곤을 클릭하면 대덕구 행정동 폴리곤 데이터 가져오기
		kakao.maps.event.addListener(dongPolygon, "click", function (mouseEvent) {
			$(".text-box").css({"visibility":"hidden"})
			$(".banner").css({"visibility":"visible", "max-width":"10%"})
			$(".banner-list").css({"visibility":"visible","width":"100%"})
			getParkInfo(name); // name = 동구
			getTashuInfo(name);
			getFacilityInfo('${dongList}');

			var level = map.getLevel() - 2;
			map.setLevel(level, {
				anchor: new daum.maps.LatLng(
					mouseEvent.latLng.getLat(),
					mouseEvent.latLng.getLng()
				),
			animate: {
				duration: 350, // 확대 애니메이션 시간
            },
        });
        $.getJSON("resources/static/구별json/dong.json", function (geojson) {
          var data = geojson.features;
          var coordinates = [];
          var dongName = "";
          var color = "#09f";
          $.each(data, function (index, val) {
            coordinates = val.geometry.coordinates;
            name = val.properties.SGG_NM;
            displayYuseong_dong(coordinates, name, color);
          });
        });
        deletePolygon(polygons);
        customOverlay.setMap(null); // 커스텀 오버레이(구 이름) 제거
      });
      // 마우스오버 이벤트
      kakao.maps.event.addListener(dongPolygon, "mouseover", function () {
        dongPolygon.setOptions(mouseoverOption);
      });
      // 마우스오버 이벤트 채우기
      var mouseoverOption = {
        fillColor: "#09f", // 색상
        fillOpacity: 1, // 불투명도
      };
      // 마우스아웃 이벤트
      daum.maps.event.addListener(dongPolygon, "mouseout", function () {
        dongPolygon.setOptions(mouseoutOption);
      });
      // 마우스아웃 채우기
      var mouseoutOption = {
        fillColor: "#09f", // 채우기 색깔 초록색 : A2FF99
        fillOpacity: 0.8, // 채우기 불투명도
      };

      // 커스텀 오버레이 내용
      var content = '<div class ="label" style ="font-size:40px; font-weight : 800">'+name+'</div>';
      // 커스텀 오버레이 위치
      var position = centroid(points);
      // 커스텀 오버레이 생성
      var customOverlay = new kakao.maps.CustomOverlay({
        position: position,
        content: content,
      });
      // 커스텀 오버레이를 지도에 표시
      customOverlay.setMap(map);
    }

    // 중구
    // 중구 -- 옥계동 멀티폴리곤 수정 필요
    $.getJSON("resources/static/구별json/jung.json", function (geojson) {
      var data = geojson.features;
      var coordinates = []; // 좌표 저장
      var name = ""; // 구 이름
      $.each(data, function (index, val) {
        coordinates = val.geometry.coordinates;
        name = val.properties.SGG_NM;
        displayJungArea(coordinates, name);
      });
    });
    // 중구 폴리곤 생성
    function displayJungArea(coordinates, name) {
      var jungPolygonPath = [];
      var points = [];
      $.each(coordinates[0], function (index, coordinate) {
        var point = new Object();
        point.x = coordinate[1];
        point.y = coordinate[0];
        points.push(point);
        jungPolygonPath.push(
          new kakao.maps.LatLng(coordinate[1], coordinate[0])
        );
      });
      // 중구 다각형 설정
      var jungPolygon = new kakao.maps.Polygon({
        map: map, // 다각형을 표시할 지도 객체
        path: jungPolygonPath, // 좌표 배열
        strokeWeight: 4, // 선 두께
        strokeColor: "#FFFFFF", // 선 색깔
        strokeOpacity: 0.8, // 선 불투명도
        fillColor: "#FF4500", // 채우기 색깔
        fillOpacity: 0.7, // 채우기 불투명도
      });
      polygons.push(jungPolygon); // 폴리곤 제거하기 위한 배열
      // 중구 폴리곤을 클릭하면 대덕구 행정동 폴리곤 데이터 가져오기
      kakao.maps.event.addListener(jungPolygon, "click", function (mouseEvent) {
		$(".text-box").css({"visibility":"hidden"})
		$(".banner").css({"visibility":"visible", "max-width":"10%"})
		$(".banner-list").css({"visibility":"visible","width":"100%"})
		getParkInfo(name); // name = 중구
		getTashuInfo(name);
		getFacilityInfo('${jungList}');

		var level = map.getLevel() - 2;
		map.setLevel(level, {
			anchor: new daum.maps.LatLng(
				mouseEvent.latLng.getLat(),
				mouseEvent.latLng.getLng()
			),
		animate: {
			duration: 350, // 확대 애니메이션 시간
        },
	});
        $.getJSON("resources/static/구별json/jung.json", function (geojson) {
          var data = geojson.features;
          var coordinates = [];
          var dongName = "";
          var color = "#FF4500";
          $.each(data, function (index, val) {
            coordinates = val.geometry.coordinates;
            name = val.properties.SGG_NM;
            displayYuseong_dong(coordinates, name, color);
          });
        });
        deletePolygon(polygons);
        customOverlay.setMap(null);
      });
      // 마우스오버 이벤트
      kakao.maps.event.addListener(jungPolygon, "mouseover", function () {
        jungPolygon.setOptions(mouseoverOption);
      });
      // 마우스오버 이벤트 채우기
      var mouseoverOption = {
        fillColor: "#FF4500",
        fillOpacity: 1,
      };
      // 마우스아웃 이벤트
      daum.maps.event.addListener(jungPolygon, "mouseout", function () {
        jungPolygon.setOptions(mouseoutOption);
      });
      // 마우스아웃 채우기
      var mouseoutOption = {
        fillColor: "#FF4500",
        fillOpacity: 0.8,
      };

      // 커스텀 오버레이 내용
      // var content = '<div class ="label"><span class="left"></span><span class="center">유성구</span><span class="right"></span></div>';
      var content = '<div class ="label" style ="font-size:40px; font-weight : 800">'+name+'</div>';
      // 커스텀 오버레이 위치
      var position = centroid(points);
      // 커스텀 오버레이 생성
      var customOverlay = new kakao.maps.CustomOverlay({
        position: position,
        content: content,
      });
      // 커스텀 오버레이를 지도에 표시
      customOverlay.setMap(map);
    }

    // 서구
    $.getJSON("resources/static/구별json/seo.json", function (geojson) {
      var data = geojson.features;
      var coordinates = []; // 좌표 저장
      var name = ""; // 구 이름
      $.each(data, function (index, val) {
        coordinates = val.geometry.coordinates;
        name = val.properties.SGG_NM;
        displaySeoArea(coordinates, name);
      });
    });
    // 서구 폴리곤 생성
    function displaySeoArea(coordinates, name) {
      var seoPolygonPath = [];
      var points = [];
      $.each(coordinates[0], function (index, coordinate) {
        var point = new Object();
        point.x = coordinate[1];
        point.y = coordinate[0];
        points.push(point);
        seoPolygonPath.push(
          new kakao.maps.LatLng(coordinate[1], coordinate[0])
        );
      });
      // 서구 다각형 설정
      var seoPolygon = new kakao.maps.Polygon({
        map: map,
        path: seoPolygonPath,
        strokeWeight: 4,
        strokeColor: "#FFFFFF",
        strokeOpacity: 0.8,
        fillColor: "#F08080",
        fillOpacity: 0.7,
      });
      polygons.push(seoPolygon); // 폴리곤 제거하기 위한 배열
      // 서구 폴리곤을 클릭하면 대덕구 행정동 폴리곤 데이터 가져오기
      kakao.maps.event.addListener(seoPolygon, "click", function (mouseEvent) {
		$(".text-box").css({"visibility":"hidden"})
		$(".banner").css({"visibility":"visible", "max-width":"10%"})
		$(".banner-list").css({"visibility":"visible","width":"100%"})
		getParkInfo(name); // name = 서구
		getTashuInfo(name);
		getFacilityInfo('${seoList}');
    	
		var level = map.getLevel() - 2;
		map.setLevel(level, {
			anchor: new daum.maps.LatLng(
				mouseEvent.latLng.getLat(),
				mouseEvent.latLng.getLng()
			),
		animate: {
			duration: 350, // 확대 애니메이션 시간
        },
	});
        $.getJSON("resources/static/구별json/seo.json", function (geojson) {
          var data = geojson.features;
          var coordinates = [];
          var dongName = "";
          var color = "#F08080";
          $.each(data, function (index, val) {
            coordinates = val.geometry.coordinates;
            name = val.properties.SGG_NM;
            displayYuseong_dong(coordinates, name, color);
          });
        });
        deletePolygon(polygons);
        customOverlay.setMap(null);
      });
      // 마우스오버 이벤트
      kakao.maps.event.addListener(seoPolygon, "mouseover", function () {
        seoPolygon.setOptions(mouseoverOption);
      });
      // 마우스오버 이벤트 채우기
      var mouseoverOption = {
        fillColor: "#F08080",
        fillOpacity: 1,
      };
      // 마우스아웃 이벤트
      daum.maps.event.addListener(seoPolygon, "mouseout", function () {
        seoPolygon.setOptions(mouseoutOption);
      });
      // 마우스아웃 채우기
      var mouseoutOption = {
        fillColor: "#F08080",
        fillOpacity: 0.8,
      };

      // 커스텀 오버레이 내용
      var content = '<div class ="label" style ="font-size:40px; font-weight : 800">'+name+'</div>';
      // 커스텀 오버레이 위치
      var position = centroid(points);
      // 커스텀 오버레이 생성
      var customOverlay = new kakao.maps.CustomOverlay({
        position: position,
        content: content,
      });
      // 커스텀 오버레이를 지도에 표시
      customOverlay.setMap(map);
    }

    //centroid 알고리즘 (폴리곤 중심좌표 구하기 위함)
    function centroid(points) {
      var i, j, len, p1, p2, f, area, x, y;

      area = x = y = 0;

      for (i = 0, len = points.length, j = len - 1; i < len; j = i++) {
        p1 = points[i];
        p2 = points[j];

        f = p1.y * p2.x - p2.y * p1.x;
        x += (p1.x + p2.x) * f;
        y += (p1.y + p2.y) * f;
        area += f * 3;
      }
      return new daum.maps.LatLng(x / area, y / area);
    }

    // 아래와 같이 옵션을 입력하지 않아도 된다
    var zoomControl = new kakao.maps.ZoomControl();
    // 지도 오른쪽에 줌 컨트롤이 표시되도록 지도에 컨트롤을 추가한다.
    map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
    kakao.maps.event.addListener(map, 'zoom_changed', function() {        
        // 지도 현재 레벨
        var level = map.getLevel();
        console.log('현재 지도 레벨은 ' + level + ' 입니다');
        if(level >= 10){
        	// 지도레벨이 10이면 커스텀 오버레이 지우는 코드 작성중... 
			$('.label').remove();
        }
    });
	</script>
	<script src="/resources/static/js/park.js"></script>
	<script src="/resources/static/js/tashu.js"></script>
	<script src="/resources/static/js/facility.js"></script>
	<script src="/resources/static/js/getGps.js"></script>
<script type="text/javascript">

</script>
</html>