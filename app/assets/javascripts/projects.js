$(document).ready(function() {
    $(".list-group").sortable({
        connectWith: ".list-group",
        update: function() {
            $(".project-group").each(function() {
                //console.log("PG: " + $(this).children().length);
                var ids = [];
                $(this).children().map(function() {
                    ids.push($(this).attr('id'));
                });
                console.log("Ids for " + $(this).prev("input").attr('id') + ": " + JSON.stringify(ids));
                var hidden = $(this).prev("input");
                if (hidden.val() != 'undefined') {
                    hidden.val(ids.toString());
                }
            });
            
            $("#unassigned_header").text("Unassigned students (" + $("#unassigned_list").children().length + ")")
        }
    });
});