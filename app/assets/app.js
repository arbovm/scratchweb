

$(document).ready(function(){
	
	$.post('/uploads.js', function(json_str) {
		var upload = $.parseJSON(json_str);
		var uploadPath = '/uploads/'+upload._id;
		
		if (window.console && console.log) {
			console.log("Please disable Firebug completely under 'Extras > Add-ons' if the progress bar updates too slow.");
			console.log("uploadPath:"+uploadPath);
		}
		
		var submitTitle = function(percent) {
			$.post(uploadPath+'/title', {"title": $('#title').val()}, function(json_str) {
				var upload = $.parseJSON(json_str);
				$('#progress').css('background-color','#fff').html('<p class="small">saved as: '+upload.file+'</p>');
				$('#uploads').html('<a href="'+uploadPath+'/file/'+upload.title+'">'+upload.title+'</a><br />');
			});
		}

		var updateProgress = function(percent) {
	 		$('#progress').text(" "+percent+"%").width(3*parseInt(percent));			
		}

		var queryProgress = function() {
			$.get(uploadPath+'/progress', function(percent) {
				updateProgress(percent);
				if(percent != "100"){
					window.setTimeout(queryProgress, 500);
				} else {
					submitTitle();
				}
			});
		}
		
		var uploadForm = $('#upload_form');
		uploadForm[0].action = uploadPath+"/file";
		uploadForm.submit(function() {
			$('#progress').css('background-color','#ccf')
	 		updateProgress(0);
			window.setTimeout(queryProgress, 500);
		});
	});
});