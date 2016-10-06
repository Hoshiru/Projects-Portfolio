$(document).ready(function() {
    navCheck();
    $("#menu-toggle").on('click', function() {
        $("#nav").slideToggle();
    });

    $(window).on('resize', function() {
        navCheck();
    });
})

function navCheck() {
    if ($(window).width() < 570) {
        $("#nav").hide();   
        $(".highlight").on('click', function() {
            $("#nav").slideToggle();
        });
    } 
    else {
        $("#nav").show();
    }
}