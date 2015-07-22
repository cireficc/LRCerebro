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

/*
* Helper method to destroy nested objects for a simple "remove this"-type functionality.
* Find the closest "removable-fields" class, hide it, then find its "_destroy" input
* using the "ends with" selector, and set it to true. The user will no longer see the
* nested object, and when the form is submitted, Rails will destroy it.
*/
$(document).on('click', '#remove_fields', function(event) {
    
    $(this).closest('.removable-fields').hide().find('input[id$="_destroy"]').val(true);
});

/*
* Helper method to create nested objects for a simple "add another"-type functionality.
* The necessary HTML is already attached to the button, so replace the id with the time
* (this acts as a unique identifier for the object), then append the HTML above the add
* button.
*/
$(document).on('click', '#add_fields', function(event) {
    
    var addFieldsDataElement, regexp, time;
    
    addFieldsDataElement = $(this).find('#add_fields_data');
    time = new Date().getTime();
    regexp = new RegExp(addFieldsDataElement.data('id'), 'g');
    
    $(this).before(addFieldsDataElement.data('fields').replace(regexp, time));
    
    return event.preventDefault();
});

// If a calendar glyphicon is clicked, initialize the DateTimePicker
$(document).on('click', '.glyphicon-calendar', function() {

	$(this).closest('.input-group').datetimepicker();
});