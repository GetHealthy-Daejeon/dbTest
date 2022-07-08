 var overlay = null; 
    
 	function closeOverlay(){ //닫기 버튼 누르면 실행하는 함수
 		overlay.setMap(null);   
    }


function getParkInfo(guName){
  var parkMarkers = [];
  $('#park').click(function(){ //park 버튼 클릭했을 때 
    if($(this).hasClass("active")){ // if(active가 있다면)면 active 클래스 지우기
      $(this).removeClass("active");
      deletePolygon(parkMarkers);
    }else{
      $(this).addClass("active"); // else면 active 클래스 생성 
      $.ajax({ // 아작스 실행하면서 마커 찍기
      url : "https://api.odcloud.kr/api/15073859/v1/uddi:7789cfce-8a83-482e-a47d-8b7da41406ec?perPage=1000&serviceKey=eQZma%2BIrvJVJ%2FoYjIe5wYTnAwUZYZNAM5v%2BtmC8hutkmQ%2BFFsfQt5gbWiZ0FNXRs3LK%2BHxQ3oLQji3lZ%2BiLgKA%3D%3D",
      type : "GET",
      dataType : "json", // 서버 결과를 json으로 응답받겠다.
      success : function(response){
        // 사용할 데이터 : 공원명, 공원종류, 관리청, 비고, 위치
        response.data.forEach(function(test, index){
        // for문으로 response.data 불러올 시 geocoder 비동기작업으로 인해 한번에 진행되므로 제대로 값을 불러올 수 없음. 그래서 forEach 사용함
          if(response.data[index].위치.substring(0,3).replace(" ","") == guName){
            geocoder.addressSearch(response.data[index].위치, function(result, status) {
              // 검색 완료되면 결과값으로 받은 위치를 마커로 표시
              if (status === kakao.maps.services.Status.OK) {
              // 마커 이미지의 이미지 주소입니다
                var imageSrc;
                if(response.data[index].비고 == "<조성중>" || response.data[index].비고 == "<미조성>"){
                  imageSrc = "resources/static/img/under_construction.png"; 
                }else{
                  imageSrc = "resources/static/img/park.png"; 
                }
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                // 마커 이미지의 이미지 크기
                var imageSize = new kakao.maps.Size(50, 50); 
                // 마커 이미지를 생성
                var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
                var marker = new kakao.maps.Marker({
                    map: map,
                    position: coords,
                    image : markerImage // 마커 이미지 
                });
                parkMarkers.push(marker); // 공원만 제거하기 위한 배열
                markers.push(marker); // marker를 제거하기 위해 배열에 담음
                // 마커를 클릭했을 때 마커 위에 표시할 인포윈도우를 생성합니다
                	console.log(response.data[index].공원명)
                	var content = 
 		      		'<div class="wrap">' + 
 		            '    <div class="info">' + 
 		            '        <div class="title">' 
 		           	+response.data[index].공원명+ 
 		            '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' + 
 		            '        </div>' + 
 		            '        <div class="body">' + 
 		            '            <div class="img">' +
 		            '                <img src="resources/static/img/marker_img/gethealthy.png" width="73" height="70">' +
 		            '           	</div>' + 
 		            '            <div class="desc">' + 
 		            '                <div class="ellipsis">'+ response.data[index].위치 +'</div>' + 
 		            '                <div><a href="https://map.kakao.com/link/roadview/'+result[0].y+','+result[0].x+'" target="_blank">로드뷰</a> </div>' + 
 		            '                  <div><a href="https://map.kakao.com/link/to/'+response.data[index].공원명+','+ result[0].y+','+result[0].x+'" target="_blank" class="link">길찾기</a></div>' + 
 		            '            </div>' + 
 		            '        </div>' + 
 		            '    </div>' +    
 		            '</div>',
				iwRemoveable = true; // removeable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다				
				kakao.maps.event.addListener(marker, 'click', function() { // 마커를 클릭했을 때 커스텀 오버레이를 표시합니다
					overlay = new kakao.maps.CustomOverlay({
					    content: content,
					    map: map,
					    position: marker.getPosition()       
					});
					overlay.setMap(map);
				});	
              }
            });
          }
        })
      }
    });
    }
  });
}