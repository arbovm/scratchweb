

$(document).ready(function(){

	$.post('/uploads.js', function(json_str) {

		var upload = $.parseJSON(json_str)
		var uploadPath = '/uploads/'+upload._id
		
		console.log(uploadPath)
		
		update_progress = function(){
			$.get(uploadPath+'/progress', function(percent) {
		 		$('#progress').text(percent);
				if(percent != "100"){
					setTimeout(update_progress, 1000);
				}
			});
		}
		
		$("#upload_form")[0].action = uploadPath
		$("#upload_form").submit(update_progress);
		

	});
	
	
});