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
//= require select2-full
//= require turbolinks
//= require moment
//= require bootstrap-datetimepicker
//= require_tree .

// Default options for the DateTimePicker
var dtpDefaults = {
	format: "YYYY-MM-DD  h:mm A" // 2015-08-10 5:30 PM; Rails-friendly DateTime format
}

// Page ready and change for all pages (initialization code)
var readyAndChange = function() {
	
	// Initialize all of the DateTimePickers with their correctly-displayed value
	$('.glyphicon-calendar').each(function (event) {
		var input = $(this).closest('.input-group');
	    var textField = input.find('input[type="text"]');
	    var text = textField.val();
	    
	    // Only initialize a DTP when the input is enabled
	    if (!textField.prop('disabled')) {
	        input.datetimepicker(dtpDefaults);
	        if (text.length != 0) input.data("DateTimePicker").date(new Date(text));
	    }
	});
	
	// Initialize all Bootstrap toolips
	$("[data-toggle='tooltip']").tooltip();
	
	// Initialize all acts-as-taggable-on + select2 tag inputs
	$("*[data-taggable='true']").each(function() {
        console.log("Taggable: " + $(this).attr('id') + "; initializing select2");
        $(this).select2({
            tags: true,
            theme: "bootstrap",
            width: "100%",
            tokenSeparators: [','],
            minimumInputLength: 2,
            ajax: {
                url: "/tags",
                dataType: 'json',
                delay: 100,
                data: function (params) {
                    console.log("Using AJAX to get tags...");
                    console.log("Tag name: " + params.term);
                    console.log("Existing tags: " + $(this).val());
                    console.log("Taggable type: " + $(this).data("taggable-type"));
                    console.log("Tag context: " + $(this).data("context"));
                    return {
                        name: params.term,
                        tags_chosen: $(this).val(),
                        taggable_type: $(this).data("taggable-type"),
                        context: $(this).data("context"),
                        page: params.page
                    }
                },
                processResults: function (data, params) {
                    console.log("Got tags from AJAX: " + JSON.stringify(data, null, '\t'));
                    params.page = params.page || 1;
            
                    return {
                        results: $.map(data, function (item) {
                            return {
                                text: item.name,
                                // id has to be the tag name, because acts_as_taggable expects it!
                                id: item.name
                            }
                        })
                    };
                },
                cache: true
            }
        });
    });
        
    // Initialze all selects (that aren't for tags) with Select2
    $("select:not([data-taggable='true'])").each(function(index){  
        $(this).select2({theme: "bootstrap", width: "100%"});
    });
}

$(document).ready(readyAndChange);
$(document).change(readyAndChange);

/*
* When any taggable input changes, get the value from the select2 input and
* convert it to a comma-separated string. Assign this value to the nearest hidden
* input, which is the input for the acts-on-taggable field. Select2 submits an array,
* but acts-as-taggable-on expects a CSV string; it is why this conversion exists.
*/
$(document).on('select2:select select2:unselect', "*[data-taggable='true']", function() {
	 
	var taggable_id = $(this).attr('id')
	// genre_list_select2 --> genre_list
    var hidden_id = taggable_id.replace("_select2", "");
    // inventory_item_film_*genre_list* ($= jQuery selectors ends with)
    var hidden = $("[id$=" + hidden_id + "]")
    // Select2 either has elements selected or it doesn't, in which case use []
    var joined = ($(this).val() || []).join(",");
    hidden.val(joined);
});

/*
* Helper method to destroy nested objects for a simple "remove this"-type functionality.
* Find the closest "removable-fields" class, hide it, then find its "_destroy" input
* using the "ends with" selector, and set it to true. The user will no longer see the
* nested object, and when the form is submitted, Rails will destroy it.
*/
$(document).on('click', '.remove-fields', function(event) {
    
    // Prompt for confirmation before actually removing the fields
    if (confirm("Are you sure you want to delete this?")) {
        $(this).closest('.removable-fields').hide().find('input[id$="_destroy"]').val(true);
    }
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
    
    // Trigger a document change event so that any initialization code is run
    $(document).trigger("change");
});

// If a calendar glyphicon is clicked, initialize the DateTimePicker
$(document).on('click', '.glyphicon-calendar', function() {
    
    var input = $(this).closest('.input-group');
	var textField = input.find('input[type="text"]');
    
    // Only initialize a DTP when the input is enabled
	if (!textField.prop('disabled')) {
	    input.datetimepicker(dtpDefaults);
	}
});