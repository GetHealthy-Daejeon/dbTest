<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>건강하슈</title>
    <style>
      .info {
        font-size: 12px;
        padding: 5px;
      }
      .info .title {
        font-weight: bold;
      }
      #map{
        width: 100%;
        height: 1065px;
        z-index: 0;
      }
      .banner{
        position: fixed;
        width: 8%;
        height: 1065px;
        background-color: rgb(255, 255, 255);
        border-right: 1px solid gray;
        box-shadow: 1px 1px 5px gray;
        z-index: 1;
      }
      .banner-list{
        display: block;
        margin-top: 50px;
        
      }
      #banner-btn{
        width: 80%;
        height: 50px;
        margin: 5px 15px;
        border-radius: 10%;
        border-color: rgb(156, 156, 156);
        cursor: pointer;
        background-color: rgb(255, 255, 255);
        box-shadow: 1px 3px 3px rgb(143, 143, 143);
        font-size: 15px;
        font-weight: 600;
        color: rgb(70, 70, 70);
      }
      #banner-btn:hover{
        background-color: rgba(0, 148, 0, 0.623);
        color: #ffffff;
      }
      .logo{
        margin: 15px;
        border-bottom: 1px solid;
        
      }
      .banner .btn{
        width: 50px;
        height: 50px;
        background-color: #ffffff;
        border: 1px solid grey;
        box-shadow: 0px 0px 1px gray;
        border-left: #ffffff;
        margin-left: 150px;
        
      }
    </style>
  </head>
        <h3>${list}</h3>

  <body>
    <div class="container">
      <div class="banner">
        <div class="logo">
          <img src="logo.png" alt="">
        </div>
        <div class="btn">

        </div>
        <div class="banner-list">
          <input type="button" id="banner-btn" value="테니스장">
          <input type="button" id="banner-btn" value="수영장">
          <input type="button" id="banner-btn" value="공원">
          <input type="button" id="banner-btn" value="농구장">
          <input type="button" id="banner-btn" value="풋살&축구">
          <input type="button" id="banner-btn" value="초기화" onclick="window.location.reload()">
        </div>

      </div>
      <div id="map"></div>
      <!-- <p id="result"></p> 이건 왜 있을까용??-->
    </div>
  </body>
  <script
    src="https://code.jquery.com/jquery-3.6.0.min.js"
    integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
    crossorigin="anonymous"
  ></script>
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=42189fc27ae4cf0d73678ba4cae1e6a0&libraries=services"></script>
  <script>
    // 스크롤 컨트롤 기능 함수
    function setZoomable(zoomable) {
      // 마우스 휠로 지도 확대,축소 가능여부를 설정하는 함수
      map.setZoomable(zoomable);
    }
    var mapContainer = document.getElementById("map"), // 지도를 div
      mapOption = {
        center: new kakao.maps.LatLng(36.3504119, 127.3845475), // 중심좌표
        level: 8,
      };
    var map = new kakao.maps.Map(mapContainer, mapOption); // 지도 생성
    
	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();
		
    // 행정구 이름 표시
    (customOverlay = new kakao.maps.CustomOverlay({})),
      (infowindow = new kakao.maps.InfoWindow({ removable: true }));
    var markerPosition = new kakao.maps.LatLng(36.3504119, 127.3845475); // 마커 위치

    // 마커 생성
    var marker = new kakao.maps.Marker({
      position: markerPosition,
      clickable: true, // 마커를 클릭했을 때 지도의 클릭 이벤트가 발생하지 않도록 설정
    });
    marker.setMap(map); // 마커 표시

    // 마커 제거
    // marker.setMap(null);

    // 마커 클릭하면 나올 인포윈도우
    var iwContent =
        '<div style="padding:10px; font-size: 20px; width: 100%; font-weight: 900" >대전광역시 건강하슈!</div>',
      iwRemoveable = true; // 인포윈도우를 닫는 x버튼 표시

    // 인포윈도우 생성
    var infowindow = new kakao.maps.InfoWindow({
      content: iwContent,
      removable: iwRemoveable,
    });

    // 마커 위에 인포윈도우 표시
    kakao.maps.event.addListener(marker, "click", function () {
      infowindow.open(map, marker);
    });
  </script>
  <script>
    var polygons = []; // 폴리곤 지울때 사용하는 배열 담는 변수

    //지도 위 표시되고 있는 폴리곤 제거
    function deletePolygon(polygons) {
      console.log(polygons.length);
      for (var i = 0; i < polygons.length; i++) {
        polygons[i].setMap(null);
      }
      polygons = [];
    }

    // 유성구
    // 유성구 폴리곤 데이터 갖고오기
    $.getJSON("resources/static/구별json/yuseong.json", function (geojson) {
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
      var yuseongPolygonPath = [];
      var points = [];
      $.each(coordinates[0], function (index, coordinate) {
        // coordinates [0]번째에 배열 있음
        var point = new Object();
        point.x = coordinate[1]; // 경도
        point.y = coordinate[0]; // 위도
        points.push(point);
        yuseongPolygonPath.push(
          new kakao.maps.LatLng(coordinate[1], coordinate[0])
        );
        //new kakao.maps.LatLng가 없으면 인식을 못해서 polygonPath 배열에 추가
      });
      // 유성구 다각형 설정
      var yuseongPolygon = new kakao.maps.Polygon({
        map: map, // 다각형을 표시할 지도 객체
        path: yuseongPolygonPath, // 좌표 배열
        strokeWeight: 4, // 선 두께 // ======> 0624 두껍게 조절
        strokeColor: "#FFFFFF", // 선 색깔
        strokeOpacity: 0.8, // 선 불투명도
        fillColor: "#6ADF35", // 채우기 색깔 // ======> 0624 색상 변경
        fillOpacity: 0.8, // 채우기 불투명도 // ======> 0624 투명도 진하게 조절
      });
      polygons.push(yuseongPolygon); // 폴리곤 제거하기 위한 배열
      // 유성구 폴리곤을 클릭하면 유성구 행정동 폴리곤 데이터 가져오기
      kakao.maps.event.addListener(
        yuseongPolygon,
        "click",
        function (mouseEvent) {
          var level = map.getLevel() - 2;
          // map.setLevel(level, {anchor: centroid(points), animate: {
          map.setLevel(level, {
            anchor: new daum.maps.LatLng(
              mouseEvent.latLng.getLat(),
              mouseEvent.latLng.getLng()
            ),
            animate: {
              duration: 350, // 확대 애니메이션 시간
            },
          });
          $.getJSON("resources/static/행정동json/yuseong-gu.json", function (geojson) {
            var data = geojson.features;
            var coordinates = []; // 좌표 저장
            var dongName = ""; // 동 이름
            $.each(data, function (index, val) {
              coordinates = val.geometry.coordinates;
              name = val.properties.SGG_NM;
              displayYuseong_dong(coordinates, name);
              setZoomable(false) // 클릭시 마우스 휠 작동 off
            });
          });
          deletePolygon(polygons); //폴리곤 제거
          customOverlay.setMap(null); // 커스텀 오버레이(구 이름) 제거
          
  		// 도로명 주소로 좌표 검색 & 마커 생성
  		geocoder.addressSearch('방동 144-3', function(result, status) {
  		    // 검색 완료되면 
  		     if (status === kakao.maps.services.Status.OK) {
  		        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
  		        console.log(coords)
  		        // 결과값으로 받은 위치를 마커로 표시합니다
  		        var marker = new kakao.maps.Marker({
  		            map: map,
  		            position: coords
  		        });
  		        // 인포윈도우로 장소에 대한 설명을 표시합니다
  		        var infowindow = new kakao.maps.InfoWindow({
  		            content: '<div style="width:150px;text-align:center;padding:6px 0;">테스트 마커</div>'
  		        });
  		        infowindow.open(map, marker);
  		    }
  		});
        }
      );

      // 마우스오버 이벤트
      kakao.maps.event.addListener(yuseongPolygon, "mouseover", function () {
        yuseongPolygon.setOptions(mouseoverOption);
      });
      // 마우스오버 이벤트 채우기
      var mouseoverOption = {
        fillColor: "#09f", // 색상
        fillOpacity: 0.8, // 불투명도
      };
      // 마우스아웃 이벤트
      daum.maps.event.addListener(yuseongPolygon, "mouseout", function () {
        yuseongPolygon.setOptions(mouseoutOption);
      });
      // 마우스아웃 채우기
      var mouseoutOption = {
        fillColor: "#6ADF35", // 채우기 색깔 초록색 : A2FF99
        fillOpacity: 0.8, // 채우기 불투명도
      };

      // 커스텀 오버레이 내용
      // var content = '<div class ="label"><span class="left"></span><span class="center">유성구</span><span class="right"></span></div>';
      var content = '<div class ="label" style ="font-size:30px">유성구</div>';
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
    // 유성구 행정동 폴리곤 만들기
    function displayYuseong_dong(coordinates, name) {
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
        strokeColor: "#004c80", // 선 색깔
        strokeOpacity: 0.8, // 선 불투명도
        fillColor: "#6ADF35", // 채우기 색깔
        fillOpacity: 0.5, // 채우기 불투명도
      });
      yuseong_dong_Polygon.setOptions({
        fillColor: "#A2FF99",
        fillOpacity: 0.5,
      });
      // 행정동 클릭 이벤트
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
        fillColor: "	#FFD700", // 채우기 색깔
        fillOpacity: 0.8, // 채우기 불투명도
      });
      polygons.push(daedeokPolygon); // 폴리곤 제거하기 위한 배열
      // 대덕구 폴리곤을 클릭하면 대덕구 행정동 폴리곤 데이터 가져오기
      kakao.maps.event.addListener(
        daedeokPolygon,
        "click",
        function (mouseEvent) {
          var level = map.getLevel() - 2;
          map.setLevel(level, {
            anchor: centroid(points),
            animate: {
              duration: 350, // 확대 애니메이션 시간
            },
          });
          $.getJSON("resources/static/행정동json/daedeok-gu.json", function (geojson) {
            var data = geojson.features;
            var coordinates = [];
            var dongName = "";
            $.each(data, function (index, val) {
              coordinates = val.geometry.coordinates;
              name = val.properties.SGG_NM;
              displayYuseong_dong(coordinates, name); // 행정동 폴리곤 만들기 공동사용
              setZoomable(false) // 클릭시 마우스 휠 작동 off
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
        fillColor: "#09f", // 색상
        fillOpacity: 0.8, // 불투명도
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
      var content = '<div class ="label" style ="font-size:30px">대덕구</div>';
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
        fillColor: "#87CEFA", // 채우기 색깔
        fillOpacity: 0.8, // 채우기 불투명도
      });
      polygons.push(dongPolygon); // 폴리곤 제거하기 위한 배열
      // 동구 폴리곤을 클릭하면 대덕구 행정동 폴리곤 데이터 가져오기
      kakao.maps.event.addListener(dongPolygon, "click", function (mouseEvent) {
        var level = map.getLevel() - 2;
        map.setLevel(level, {
          anchor: centroid(points),
          animate: {
            duration: 350, // 확대 애니메이션 시간
          },
        });
        $.getJSON("resources/static/행정동json/dong-gu.json", function (geojson) {
          var data = geojson.features;
          var coordinates = [];
          var dongName = "";
          $.each(data, function (index, val) {
            coordinates = val.geometry.coordinates;
            name = val.properties.SGG_NM;
            displayYuseong_dong(coordinates, name);
            setZoomable(false) // 클릭시 마우스 휠 작동 off
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
        fillOpacity: 0.8, // 불투명도
      };
      // 마우스아웃 이벤트
      daum.maps.event.addListener(dongPolygon, "mouseout", function () {
        dongPolygon.setOptions(mouseoutOption);
      });
      // 마우스아웃 채우기
      var mouseoutOption = {
        fillColor: "#87CEFA", // 채우기 색깔 초록색 : A2FF99
        fillOpacity: 0.8, // 채우기 불투명도
      };

      // 커스텀 오버레이 내용
      var content = '<div class ="label" style ="font-size:30px">동구</div>';
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
    // 중구
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
        fillOpacity: 0.8, // 채우기 불투명도
      });
      polygons.push(jungPolygon); // 폴리곤 제거하기 위한 배열
      // 중구 폴리곤을 클릭하면 대덕구 행정동 폴리곤 데이터 가져오기
      kakao.maps.event.addListener(jungPolygon, "click", function (mouseEvent) {
        var level = map.getLevel() - 2;
        map.setLevel(level, {
          anchor: centroid(points),
          animate: {
            duration: 350, // 확대 애니메이션 시간
          },
        });
        $.getJSON("resources/static/행정동json/jung-gu.json", function (geojson) {
          var data = geojson.features;
          var coordinates = [];
          var dongName = "";
          $.each(data, function (index, val) {
            coordinates = val.geometry.coordinates;
            name = val.properties.SGG_NM;
            displayYuseong_dong(coordinates, name);
            setZoomable(false) // 클릭시 마우스 휠 작동 off
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
        fillColor: "#09f", // 색상
        fillOpacity: 0.8, // 불투명도
      };
      // 마우스아웃 이벤트
      daum.maps.event.addListener(jungPolygon, "mouseout", function () {
        jungPolygon.setOptions(mouseoutOption);
      });
      // 마우스아웃 채우기
      var mouseoutOption = {
        fillColor: "#FF4500", // 채우기 색깔 초록색 : A2FF99
        fillOpacity: 0.8, // 채우기 불투명도
      };

      // 커스텀 오버레이 내용
      // var content = '<div class ="label"><span class="left"></span><span class="center">유성구</span><span class="right"></span></div>';
      var content = '<div class ="label" style ="font-size:30px">중구</div>';
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
        fillOpacity: 0.8,
      });
      polygons.push(seoPolygon); // 폴리곤 제거하기 위한 배열
      // 서구 폴리곤을 클릭하면 대덕구 행정동 폴리곤 데이터 가져오기
      kakao.maps.event.addListener(seoPolygon, "click", function (mouseEvent) {
        var level = map.getLevel() - 2;
        map.setLevel(level, {
          anchor: centroid(points),
          animate: {
            duration: 350,
          },
        });
        $.getJSON("resources/static/행정동json/seo-gu.json", function (geojson) {
          var data = geojson.features;
          var coordinates = [];
          var dongName = "";
          $.each(data, function (index, val) {
            coordinates = val.geometry.coordinates;
            name = val.properties.SGG_NM;
            displayYuseong_dong(coordinates, name);
            setZoomable(false) // 클릭시 마우스 휠 작동 off
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
        fillColor: "#09f",
        fillOpacity: 0.8,
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
      var content = '<div class ="label" style ="font-size:30px">서구</div>';
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
 
  </script>
</html>