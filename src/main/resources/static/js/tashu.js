function getTashuInfo(guName){
  var TashuMarkers = [];
  $('#tashu').click(function(){
    if($(this).hasClass("active")){
      $(this).removeClass("active");
      deletePolygon(TashuMarkers);
    }else{
      $(this).addClass("active");
      $.ajax({
      url : "https://api.odcloud.kr/api/15062798/v1/uddi:cd8c82d9-b88c-42b0-bedd-a8b4b919732b?perPage=1000&serviceKey=eQZma%2BIrvJVJ%2FoYjIe5wYTnAwUZYZNAM5v%2BtmC8hutkmQ%2BFFsfQt5gbWiZ0FNXRs3LK%2BHxQ3oLQji3lZ%2BiLgKA%3D%3D",
      type : "GET",
      dataType : "json", // 서버 결과를 json으로 응답받겠다.
      success : function(response){
        // console.log(response.data)
        // console.log(response.data[0]['Station 스테이션/성명'])
        // console.log(response.data[100].위치.substring(6,9).replace(" ",""))
        // 사용할 데이터 : Station 스테이션/성명, 시군구명, 위치
        response.data.forEach(function(test, index){
          // console.log(response.data[index].위치)
        // for문으로 response.data 불러올 시 geocoder 비동기작업으로 인해 한번에 진행되므로 제대로 값을 불러올 수 없음. 그래서 forEach 사용함
          if(response.data[index].위치.substring(6,9).replace(" ","") == guName){
            geocoder.addressSearch(response.data[index].위치, function(result, status) {
              // 검색 완료되면 결과값으로 받은 위치를 마커로 표시
              if (status === kakao.maps.services.Status.OK) {
              // 마커 이미지의 이미지 주소입니다
                var imageSrc = "resources/static/img/bike.png"; 
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
                TashuMarkers.push(marker); // 타슈만 제거하기 위한 배열
                markers.push(marker); // marker를 제거하기 위해 배열에 담음
                // 마커를 클릭했을 때 마커 위에 표시할 인포윈도우를 생성합니다
                var iwContent = '<div style="width:100%;text-align:center;padding:20px 0;">정류장명 :'+response.data[index]['Station 스테이션/성명']+' <br> 위치 :'+response.data[index].위치+'</div>'
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
          }
        })
      }
    });
    }
  });
}