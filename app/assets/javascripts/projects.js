$(document).ready(function() {
    
    // If the checkbox for presenting projects is clicked, toggle the ready by form field
    $('#present').click(function() {
        $('#viewable_by').toggleClass("hidden");
    });        
});