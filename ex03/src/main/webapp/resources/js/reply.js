console.log("Reply Module...");

var replyService = (function(){
	
	/* 댓글 삽입 */
	function add(reply, callback, error){
		console.log("add reply......");

		$.ajax({
			type:'post',
			url: '/replies/new',
			data: JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr){
				if(callback){
					callback(result);
				}
			},
			error: function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	/* 리스트 조회 */
	function getList(param, callback, error){
		
		var bno = param.bno;
		var page = param.page || 1;
		
		$.getJSON("/replies/pages/"+bno+"/"+page+".json", 
			function(data){
				if(callback){
					callback(data);
				}
			}
		).fail(function(xhr, status, err){
			if(error){
				error();
			}
		});
	}
	
	/* 삭제 */
	function remove(rno, callback, error){
		$.ajax({
			type: 'delete',
			url: '/replies/'+rno,
			success: function(deleteResult, status, xhr){
				if(callback){
					callback(deleteResult);
				}
			},
			error: function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	/* 댓글 수정 */
	function update(reply, callback, error){
		console.log("update in ajax : "+ reply);

		$.ajax({
			type:'put',
			url: '/replies/'+ reply.rno,
			data: JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr){
				if(callback){
					callback(result);
				}
			},
			error: function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	function get(rno, callback, error){
		$.get("/replies/"+ rno +".json", 
		function(result){
			if(callback){
				callback(result);
			}
		}).fail(function(xhr, status, err){
			if(error){
				error();
			}
		})
	}

	//날짜, 시간 표기법
	function displayTime(timeValue){		
		var today = new Date();		
		var gap = today.getTime() - timeValue;	
		//console.log("gap time: ", gap);	
		var dateObj = new Date(timeValue);		
		var str ="";
		
		//댓글 등록시간이 현재시간 기준으로 하루(24시간) 이내 이면
		if(gap < (1000*60*60*24)){
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
		
			return [ (hh > 9 ? '':'0')+hh, ':', (mi > 9 ? '':'0')+mi, ':', (ss > 9 ? '':'0')+ss].join('');
		
		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth();
			var dd = dateObj.getDate();
			
			return [yy, '/', (mm > 9 ? '':'0')+mm, '/', (dd > 9 ? '':'0')+dd].join('');
		}
	}
	
	return {
		add: add,
		getList: getList,
		remove: remove,
		update: update,
		get: get,
		displayTime: displayTime
	};
})(); //즉시실행함수 