

$(document).ready(function(){

	$.post('/uploads.js', function(json_str) {

		var upload = $.parseJSON(json_str)
		var uploadPath = '/uploads/'+upload._id
		
		console.log("uploadPath:"+uploadPath)

		var query_progress = function(){
			console.log("query_progress");
			$.get(uploadPath+'/progress', function(percent) {
				console.log(percent);
		 		$('#progress').text(percent);
				if(percent != "100"){
					window.setTimeout(query_progress, 500);
				}
			});
		}
		
		console.log("uploadPath:"+uploadPath)
		
		var upload_form = $('#upload_form')
		upload_form[0].action = uploadPath;
		console.log(upload_form[0]);		
		upload_form.submit(function() {
	 		$('#progress').text("0");
			window.setTimeout(query_progress, 500);
		});
		
		
	});
	
	
});