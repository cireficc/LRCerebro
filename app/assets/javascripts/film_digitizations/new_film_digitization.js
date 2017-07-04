// Page ready
$(document).ready(function() {
    
    toggleFormElements();
});

// If the checkbox for presenting projects is clicked, toggle the ready by form field
$(document).on('change', '#film_digitization_media_source', function() {

    toggleFormElements();
});

function toggleFormElements() {

    var mediaSource = $('#film_digitization_media_source').val();
    var chooseExistingFilm = mediaSource === "LRC film collection";
    console.log("Media source: " + mediaSource + " || choose existing film? " + chooseExistingFilm);

    if (mediaSource === "") { return; }

    // Show the appropriate form field depending on media source
    if (chooseExistingFilm) {
        $('#film_digitization_existing_film').show();
        $('#film_digitization_new_film').hide();
    } else {
        $('#film_digitization_new_film').show();
        $('#film_digitization_existing_film').hide();
    }
}