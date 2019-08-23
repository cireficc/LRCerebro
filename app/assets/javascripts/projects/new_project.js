// Page ready
$(document).ready(function() {
	
	// Toggle the 'projects ready by' field if the 'present' checkbox is checked
	$("#publish_by_hidden").toggle($("#project_present").is(":checked"));
});

// If the checkbox for presenting projects is clicked, toggle the ready by form field
$(document).on('click', '#project_present', function() {
	
	$("#publish_by_hidden").toggle($(this).is(":checked"));
});