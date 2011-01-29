

$(document).ready(function(){

	$.post('/uploads.js', function(json_str) {

		var upload = $.parseJSON(json_str)
		var uploadPath = '/uploads/'+upload._id
		
		console.log("uploadPath:"+uploadPath)

		var query_progress = function(){
			$.get(uploadPath+'/progress', function(percent) {
		 		$('#progress').text(" "+percent+"%");
		 		$('#progress').width(3*parseInt(percent));
				if(percent != "100"){
					window.setTimeout(query_progress, 500);
				}
			});
		}
		
		var upload_form = $('#upload_form')
		upload_form[0].action = uploadPath;
		upload_form.submit(function() {
	 		$('#progress').text("  0%");
			window.setTimeout(query_progress, 500);
		});
	});
});