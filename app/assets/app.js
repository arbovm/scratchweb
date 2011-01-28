

$(document).ready(function(){

	$.post('/uploads.js', function(json_str) {

		var upload = $.parseJSON(json_str)
		var uploadPath = '/uploads/'+upload._id
		
		console.log(uploadPath)

		var query_progress = function(){
			console.log("query_progress");
			$.get(uploadPath+'/progress', update_progress);
		}

		var update_progress = function(percent) {
	 		$('#progress').text(percent);
			if(percent != "100"){
				window.setTimeout(query_progress, 500);
			}
		}
		var upload_form = document.getElementById('form_frame').contentWindow.document.getElementById('upload_form')
		
		upload_form.action = uploadPath
		$(upload_form).submit(function(){
			update_progress(0);
		});
	
	});
	
	
});