// Page ready
$(document).ready(function() {
    $('#script_due').datetimepicker();
    $('#due').datetimepicker();
    $('#viewable_by').datetimepicker();
    
    // Initialize the reservation start/end DateTimePickers
    $("#start, #end").each(function(i, el) {
		$(this).datetimepicker();
	});
});

// If the checkbox for presenting projects is clicked, toggle the ready by form field
$(document).on('click', '#present', function() {
	
	$("#viewable_by_hidden").toggleClass("hidden");
});


$(document).on('change', '#project_category', function() {
	
	if ($(this).val() == "other")
	    $("#other_warning").removeClass("hidden");
	else
	    $("#other_warning").addClass("hidden");
	    
	var num_training = $(this).find(':selected').data('default-training');
	var num_editing = $(this).find(':selected').data('default-editing');
	
	var training_html = generateEventHtml(num_training, "Training");
	var editing_html = generateEventHtml(num_editing, "Editing");
	
	$("#training_reservations").empty().append(training_html);
	$("#editing_reservations").empty().append(editing_html);
});

function generateEventHtml(num, type) {
	
	var type_lower = type.toLowerCase();
	
	var html = "";
	
	for (var i = 1; i <= num; i ++) {
		html += '<div class="form-group">\
  					<div class="col-md-2">\
    					<h4>' + type + ' ' + i + '</h4>\
  					</div>\
  					<div class="col-md-5">\
    					<input class="form-control" name="' + type_lower + '_start_' + i + '" type="text" />\
  					</div>\
  					<div class="col-md-5">\
    					<input class="form-control" name="' + type_lower + '_end_' + i + '" type="text" />\
  					</div>\
				</div>';
	}
	
	return html;
}