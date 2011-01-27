

$(document).ready(function(){

	update_progress = function(){
		$.get('/uploads/progress', function(percent) {
	 		$('#progress').text(percent);
			if(!(percent == "100")){
				setTimeout(update_progress, 1000);
			}
		});
	}
	
	$("#upload_form").submit(update_progress);
	
});