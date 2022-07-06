 function displayYuseongArea() {
	  		// 도로명 주소로 좌표 검색 & 마커 생성
	  		geocoder.addressSearch(daedeokList.addr_road, function(result, status) {
	  		    // 검색 완료되면 결과값으로 받은 위치를 마커로 표시
	  		     if(status === kakao.maps.services.Status.OK) {
	  		    	// 마커 이미지의 이미지 주소입니다
	  		    	var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png"; 
	  		    	var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
					// 마커 이미지의 이미지 크기
					var imageSize = new kakao.maps.Size(24, 35); 
					// 마커 이미지를 생성  
					var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
	  		        var marker = new kakao.maps.Marker({
	  		            map: map,
	  		            position: coords,
	  		          	image : markerImage // 마커 이미지 
	  		        });
  		      		markers.push(marker); // marker를 제거하기 위해 배열에 담음
					// 마커를 클릭했을 때 마커 위에 표시할 인포윈도우를 생성합니다
	  		      	var iwContent = '<div style="width:100%;text-align:center;padding:20px 0;">장소 : ${item.fac_name} <br> 주소 : ${item.addr_road} <br> <a href="https://map.kakao.com/link/roadview/'+result[0].y+','+result[0].x+'" target="_blank">로드뷰</a> </div>',
						iwRemoveable = true; // removeable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다
					// 인포윈도우를 생성합니다
					var infowindow = new kakao.maps.InfoWindow({
					    content : iwContent,
					    removable : iwRemoveable
					});
					// 마커에 클릭이벤트를 등록합니다
					kakao.maps.event.addListener(marker, 'click', function() {
					      // 마커 위에 인포윈도우를 표시합니다
					      infowindow.open(map, marker);  
						});
	  		    	}
	  			});
			// } // end for
 
}    