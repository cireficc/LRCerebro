// Page ready
$(document).ready(function() {
    
    // Toggle the 'projects ready by' field if the 'present' checkbox is checked
    $("#mini_publish_by_hidden").toggle($("#mini_project_present").is(":checked"));
    // Toggle the supplemental materials description field if the supplemental materials select is "Yes"
    $("#mini_supplemental_materials_description_hidden").toggle($("#mini_project_supplemental_materials").val() == "true");
});

// If the checkbox for presenting projects is clicked, toggle the ready by form field
$(document).on('click', '#mini_project_present', function() {

    $("#mini_publish_by_hidden").toggle($(this).is(":checked"));
});

// If the select for supplemental materials is clicked, toggle the supplemental materials description form field
$(document).on('change', '#mini_project_supplemental_materials', function() {

    $("#mini_supplemental_materials_description_hidden").toggle($("#mini_project_supplemental_materials").val() == "true");
});