// If the checkbox for presenting projects is clicked, toggle the ready by form field
$(document).on('click', '#present', function(event) {
	
	$("#viewable_by").toggleClass("hidden");
});


$(document).on('change', '#category', function() {
	
	if ($(this).val() == "other")
	    $("#other_warning").removeClass("hidden");
	else
	    $("#other_warning").addClass("hidden");
});