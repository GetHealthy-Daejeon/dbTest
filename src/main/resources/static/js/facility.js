function getFacilityInfo(data){
	var FacilityMarkers = [];
	var checkId = []; // 눌렀던 id인지 체크하는 배열
	for(var i=0; i<$('input').length; i++){
		
	}
	$('input[name=facility]').click(function(){
		var id = $(this).attr("id") // 클릭한 input의 id
		
	    if($(this).hasClass("active")){ // if(active가 있다면)면 active 클래스 지우기
	        $(this).removeClass("active");
	        checkId = checkId.filter((element) => element !== id);
	        deletePolygon(FacilityMarkers);
		}else{
	        $(this).addClass("active");
			checkId.push(id);
			var convertedJson = jstlToJson(data);
			convertedJson.forEach(function(test, index){
				if(convertedJson[index].event_code == id){
					geocoder.addressSearch(convertedJson[index].addr_road, function(result, status) {
						if (status === kakao.maps.services.Status.OK) {
			                var imageSrc;
			                if(convertedJson[index].event_code == "T"){
			                    imageSrc = "resources/static/img/marker_img/tennis.png";
			                }else if(convertedJson[index].event_code == "B"){
			                	imageSrc = "resources/static/img/marker_img/badminton.png";
			                }else if(convertedJson[index].event_code == "BB"){
			                	imageSrc = "resources/static/img/marker_img/baseball.png";
			                }else if(convertedJson[index].event_code == "BK"){
			                	imageSrc = "resources/static/img/marker_img/basketball.png";
			                }else if(convertedJson[index].event_code == "J"){
			                	imageSrc = "resources/static/img/marker_img/footVolley.png";
			                }else if(convertedJson[index].event_code == "G"){
			                	imageSrc = "resources/static/img/marker_img/gateball.png";
			                }else if(convertedJson[index].event_code == "P"){
			                	imageSrc = "resources/static/img/marker_img/park_sports.png";
			                }else if(convertedJson[index].event_code == "F"){
			                	imageSrc = "resources/static/img/marker_img/soccer.png";
			                }else if(convertedJson[index].event_code == "S"){
			                	imageSrc = "resources/static/img/marker_img/swimming.png";
			                }else if(convertedJson[index].event_code == "V"){
			                	imageSrc = "resources/static/img/marker_img/volleyball.png";
			                }else if(convertedJson[index].event_code == "H"){
			                	imageSrc = "resources/static/img/marker_img/weightlifter.png";
			                }else if(convertedJson[index].event_code == "A"){
			                	imageSrc = "resources/static/img/marker_img/archery.png";
			                }else{
			                	imageSrc = "resources/static/img/marker_img/etc.png"; 
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
			                FacilityMarkers.push(marker); // 제거하기 위한 배열
			                markers.push(marker); // marker를 제거하기 위해 배열에 담음
			                // 마커를 클릭했을 때 마커 위에 표시할 인포윈도우를 생성합니다
			                 	var content = 
 		      		'<div class="wrap">' + 
 		            '    <div class="info">' + 
 		            '        <div class="title">' + 
 		           		'${item.fac_name}' + 
 		            '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' + 
 		            '        </div>' + 
 		            '        <div class="body">' + 
 		            '            <div class="img">' +
 		            '                <img src="resources/static/img/marker_img/gethealthy.png" width="73" height="70">' +
 		            '           	</div>' + 
 		            '            <div class="desc">' + 
 		            '                <div class="ellipsis">${item.addr_road}</div>' + 
 		            '                <div><a href="https://map.kakao.com/link/roadview/'+result[0].y+','+result[0].x+'" target="_blank">로드뷰</a> </div>' + 
 		            '                <div><a href="https://www.kakaocorp.com/main" target="_blank" class="link">홈페이지</a></div>' + 
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

// controller에서 받은 데이터를 json으로 변환 (javascript로 사용하기 위함)
function jstlToJson(data){
	var resultJson = [];
	var str = data.split('[{').join('').split('}]').join(''); //양끝 문자열 제거
	var rows = str.split('}, {'); //str는 배열
	for(var i=0; i<rows.length; i++){
		var cols = rows[i].split(',');
		var rowData = {};
		for(var j=0; j<cols.length; j++){
			var colData = cols[j].trim();
			
			var key = colData.substring(0, colData.indexOf("="));
			var val = colData.substring(colData.indexOf("=") +1);
			
			rowData[key] = val;
		}
		resultJson.push(rowData);
	}
	return resultJson;
}