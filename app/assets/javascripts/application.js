// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require moment
//= require bootstrap-datetimepicker
//= require_tree .

// Page ready for all pages
$(document).ready(function() {
	
	// Initialize all of the DateTimePickers with their correctly-displayed value
	$('.glyphicon-calendar').each(function (event) {
		var input = $(this).closest('.input-group');
	    var textField = input.find('input[type="text"]');
	    var text = textField.val();
	    input.datetimepicker();
	    
	    if (text.length != 0) input.data("DateTimePicker").date(new Date(text));
	});
});

/*
* Intercept all Rails form submissions. In this function, sanitize input such as:
* - DateTimePicker: convert the mm/dd/yyyy hh:mm A/PM format to a JavaScript date
*                   so that Rails can correctly create a DateTime object out of it.
*/
$(document).on("click", "[name='commit']", function(e) {
	
	// Prevent the form submission. Page-specific handlers will be called next and submit() the form
	e.preventDefault();
	
	// See function documentation for DateTimePicker
	$('.glyphicon-calendar').each(function (event) {
		var textField = $(this).closest('.input-group').find('input[type="text"]');
	    var text = textField.val();
	    
	    if (text.length != 0) textField.val(new Date(text));
	});
});

/*
* Helper method to destroy nested objects for a simple "remove this"-type functionality.
* Find the closest "removable-fields" class, hide it, then find its "_destroy" input
* using the "ends with" selector, and set it to true. The user will no longer see the
* nested object, and when the form is submitted, Rails will destroy it.
*/
$(document).on('click', '.remove-fields', function(event) {
    
    $(this).closest('.removable-fields').hide().find('input[id$="_destroy"]').val(true);
});

/*
* Helper method to create nested objects for a simple "add another"-type functionality.
* The necessary HTML is already attached to the button, so replace the id with the time
* (this acts as a unique identifier for the object), then append the HTML above the add
* button.
*/
$(document).on('click', '.add-fields', function(event) {
    
    var addFieldsDataElement, regexp, time;
    
    // Get the hidden element that contains all of the fields/data for a new nested object
    addFieldsDataElement = $(this).find('#add_fields_data');
    // Get the time (unique) and regex replace the id of the new nested object (for a truly unique id)
    time = new Date().getTime();
    regexp = new RegExp(addFieldsDataElement.data('id'), 'g');
    
    // Use the regex to update the id, then add the fields before the [+ Add] button
    $(this).closest("#add_fields_row").before(addFieldsDataElement.data('fields').replace(regexp, time));
});

// If a calendar glyphicon is clicked, initialize the DateTimePicker
$(document).on('click', '.glyphicon-calendar', function() {
    
    $(this).closest('.input-group').datetimepicker();
});