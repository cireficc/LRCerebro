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
//= require cocoon
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require select2-full
//= require turbolinks
//= require moment
//= require bootstrap-datetimepicker
//= require_tree .

// Default options for the DateTimePicker
var dtpDefaults = {
	format: "YYYY-MM-DD h:mm A", // 2015-08-10 5:30 PM; Rails-friendly DateTime format
	sideBySide: true,
	viewMode: "months"
}

// Default options for DataTables
var dataTableDefaults = {
    order: [],
        columnDefs: [
            { orderable: false, targets: 'no-sort' }
        ],
        paging: false,
        info : false,
        bFilter: false
}

var currentGoogleCalendarIframeDate = new Date();

// Page ready and change for all pages (initialization code)
var initialize = function() {
	
	// Initialize all of the DateTimePickers with their correctly-displayed value
	$('.input-group-addon .glyphicon-calendar').each(function (event) {
		var input = $(this).closest('.input-group');
	    var textField = input.find('input[type="text"]');
	    var text = textField.val();
	    
	    // Only initialize a DTP when the input is enabled
	    if (!textField.prop('disabled')) {
	        input.datetimepicker(dtpDefaults);
	        if (text.length != 0) input.data("DateTimePicker").date(new Date(text));
	    }
	});

	// If a DTP start time is changed, update the end time to match it, and update the
    // Google Calendar iframe
	$('.input-group').on('dp.change', function(e) {

        if ($(this).find('input[type="text"]').attr('id').endsWith("start")) {
            var panelBody = $(this).closest('.panel-body');
            var endInput = $(panelBody).find('input[id$="_end"]');
            endInput.closest('.input-group').data("DateTimePicker").date(e.date);
        }

        updateGoogleCalendarIframe(e.date);
    });

	// Initialize all Bootstrap toolips and popovers
	$("[data-toggle='tooltip']").tooltip();
	$("[data-toggle='popover']").popover({ trigger: "focus", container: "body", html: true });

    $.fn.select2.defaults.set("theme", "bootstrap");
    $.fn.select2.defaults.set("width", "100%");

    // Initialize all acts-as-taggable-on + select2 tag inputs
	$("*[data-taggable='true']").each(function() {
        console.log("Taggable: " + $(this).attr('id') + "; initializing select2");
        $(this).select2({
            tags: true,
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

    // Initialize all select2 "Other"-enabled inputs
    $("select[data-other='true']").each(function() {
        $(this).select2({
            tags: true,
            createTag: function (params) {
                return {
                    id: params.term,
                    text: params.term,
                    newOption: true
                }
            },
            templateResult: function (data) {
                var $result = $("<span></span>");

                $result.text(data.text);

                if (data.newOption) {
                    $result.prepend("<strong>(Enter your own):</strong> ");
                }

                return $result;
            }
        });
    });
        
    // Initialze all selects (that aren't for tags or "Other" selects) with Select2
    $("select:not([data-taggable='true'], [data-other='true'])").each(function(index){ 
        $(this).select2();
    });
}

$(document).ready(initialize);

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
 * After a dynamic nested object is generated and inserted by Cocoon, re-initialize everything.
 */
$(document).on('cocoon:after-insert', function(e, item) { initialize() });

/*
 * For project scheduling, have a toggle to display the reservation calendar.
 */
$(document).on('click', '.reservation-calendar-toggle', function (event) {

    event.preventDefault();
    var cal = $(".reservation-calendar");
    var toggle = $(".reservation-calendar-toggle");

    cal.toggleClass('hidden');

    if (cal.hasClass('hidden')) {
        toggle.each(function (index) { $(this).find(".text").text(" Show reservation calendar"); });
    } else {
        toggle.each(function (index) { $(this).find(".text").text(" Hide reservation calendar"); });
    }
});

$(document).on('click', '.input-group-addon .glyphicon-calendar', function (event) {

    var cal = $(".reservation-calendar");
    var toggle = $(".reservation-calendar-toggle").first();
    var panelBody = $(this).closest('.panel-body');
    var startText = $(panelBody).find('input[id$="_start"]').val();
    var endText = $(panelBody).find('input[id$="_end"]').val();
    
    // If this is a reservation start or end field, update the iframe and show the calendar if it is hidden
    if (startText || endText) {
        
        if (cal.hasClass('hidden')) { toggle.click(); }
        
        if (startText.length != 0) {
            updateGoogleCalendarIframe(new Date(startText));
        }
    }
});

$(document).on('click', '#search_fields_toggle', function(event) {

    var sf = $(this).siblings('div[id$="_search_fields"]').first();
    sf.toggleClass('hidden');
    text = sf.hasClass('hidden') ? 'Show search fields' : 'Hide search fields';
    $(this).text(text);
    
});

function updateGoogleCalendarIframe(newTimestamp) {
    
    var newDate = new Date(newTimestamp);
    var now = new Date();
    var datesSame = (currentGoogleCalendarIframeDate.toDateString() === newDate.toDateString());

    // The date was erased, so reset the iframe to the current date in month view
    if (!newTimestamp) {
        setGoogleCalendarIframeUri(now, "MONTH");
        currentGoogleCalendarIframeDate = now;
    }
    // There is a new date being set, show it in agenda view
    if (!datesSame) {
        setGoogleCalendarIframeUri(newDate, "AGENDA");
        currentGoogleCalendarIframeDate = newDate;
    }
}

function setGoogleCalendarIframeUri(date, viewMode) {

    var googleCal = document.getElementById("google-res-calendar");
    var googleCalUri = googleCal.getAttribute("src");

    // Google Calendar iframe requires e.g. dates=20170105/20170105 for the querystring to display a date range
    var formattedDateString = moment(date).format('YYYYMMDD/YYYYMMDD');
    var newUri = updateQueryStringParameter(googleCalUri, "dates", formattedDateString);
    newUri = updateQueryStringParameter(newUri, "mode", viewMode);
    googleCal.setAttribute("src", newUri);
}

function updateQueryStringParameter(uri, key, value) {
    var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
    var separator = uri.indexOf('?') !== -1 ? "&" : "?";
    if (uri.match(re)) {
        return uri.replace(re, '$1' + key + "=" + value + '$2');
    }
    else {
        return uri + separator + key + "=" + value;
    }
}
