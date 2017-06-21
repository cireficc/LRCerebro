// Page ready
$(document).ready(function() {
    
    // Toggle the 'projects ready by' field if the 'present' checkbox is checked
    $("#mini_publish_by_hidden").toggle($("#mini_project_present").is(":checked"));
});

// If the checkbox for presenting projects is clicked, toggle the ready by form field
$(document).on('click', '#mini_project_present', function() {

    $("#mini_publish_by_hidden").toggle($(this).is(":checked"));
});