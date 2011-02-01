

$(document).ready(function(){
	console.log("Please disable Firebug / Web Inspector if the progress bar updates too slow!");
	
	$.post('/uploads.js', function(json_str) {

		var upload = $.parseJSON(json_str)
		var uploadPath = '/uploads/'+upload._id
		console.log("uploadPath:"+uploadPath)
		
		var submit_title = function(percent) {
			$.post(uploadPath+'/title', {"title": $('#title').val()}, function(json_str){
				var upload = $.parseJSON(json_str);
				$('#progress').css('background-color','#fff').html('<p class="small">saved as: '+upload.file+'</p>');
				$('#uploads').html('<a href="'+uploadPath+'/file/'+upload.title+'">'+upload.title+'</a><br />');
			})
		}

		var update_progress = function(percent){
	 		$('#progress').text(" "+percent+"%");
	 		$('#progress').width(3*parseInt(percent));			
		}

		var query_progress = function(){
			$.get(uploadPath+'/progress', function(percent) {
				update_progress(percent);
				if(percent != "100"){
					window.setTimeout(query_progress, 500);
				} else {
					submit_title();
				}
			});
		}
		
		var upload_form = $('#upload_form')
		upload_form[0].action = uploadPath+"/file";
		upload_form.submit(function() {

			upload_form.filter(':input').each(function(input){
				input.disable();
			});
	 		update_progress(0);
			window.setTimeout(query_progress, 500);
		});
	});
});