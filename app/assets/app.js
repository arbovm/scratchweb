

$(document).ready(function(){

	$.post('/uploads.js', function(json_str) {

		var upload = $.parseJSON(json_str)
		var uploadPath = '/uploads/'+upload._id
		
		console.log(uploadPath)

		var query_progress = function(){
			$.get(uploadPath+'/progress', update_progress);
		}

		var update_progress = function(percent) {
	 		$('#progress').text(percent);
			if(percent != "100"){
				setTimeout(query_progress, 500);
			}
		}
		
		$("#upload_form")[0].action = uploadPath
		$("#upload_form").submit(function(){
			update_progress(0);
		});
		

	});
	
	
});