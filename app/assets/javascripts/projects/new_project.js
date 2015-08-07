// Page ready
$(document).ready(function() {
	
	// Toggle the 'projects ready by' field if the 'present' checkbox is checked
	$("#viewable_by_hidden").toggle($("#project_present").is(":checked"));
});

/*
* Continue the form submission with validation
*/
$(document).on("click", "[name='commit']", function(e) {
	
	// TODO: validation
	
	$(this).closest("form").submit();
});

// If the checkbox for presenting projects is clicked, toggle the ready by form field
$(document).on('click', '#project_present', function() {
	
	$("#viewable_by_hidden").toggle($(this).is(":checked"));
});

/*
* When the project category changes, update the training/editing reservation sections with the
* default number of reservations for the selected type.
*/
$(document).on('change', '#project_category', function() {
	
	// If the category is "other", show the warning
	if ($(this).val() == "other") $("#other_warning").removeClass("hidden");
	else $("#other_warning").addClass("hidden");
	
	// Get the default number of training/editing from the selected element (in data)
	var num_training = $(this).find(':selected').data('default-training');
	var num_editing = $(this).find(':selected').data('default-editing');
	
	// Remove all training/editing sessions by calling click() on each remove button
	$(".remove-fields").each(function() { $(this).click(); })
	
	// Add the default number of reservations by clicking the add button N times for each type
	for (var i = 0; i < num_training; i ++) { $("#training_reservations").find('.add-fields').click(); }
	for (var i = 0; i < num_editing; i ++) { $("#editing_reservations").find('.add-fields').click(); }
});