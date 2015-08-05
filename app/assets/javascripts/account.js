$( document ).ready(function() {
    
    // Check the value of the signup hidden field. If true, switch to the signup tab
    var signup = $("#signup_true").val();
    if (signup)
        $("#signup_tab").click();
});