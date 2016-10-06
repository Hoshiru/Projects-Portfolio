$(document).ready(function() {
   /* $('body').scrollspy({target: "#side-nav", offset: 50}); */  
    
    dropCategory();
    sideDrop();
    
})

function dropCategory() {
    $("#dropWeb").on('click', function() {
        $("#web").slideToggle();
    })
    $("#dropHardware").on('click', function() {
        $("#hardware").slideToggle(); 
    });   
    $("#dropMobile").on('click', function() {
        $("#mobile").slideToggle();
    });   
    $("#dropEmbedded").on('click', function() {
        $("#embedded").slideToggle();
    });
}

function sideDrop() {
    $("#ilink1").on('click', function() {
        $(".pcategory").slideUp();
        $("#web").slideDown();
    })
    $("#ilink2").on('click', function() {
        $(".pcategory").slideUp();
        $("#hardware").slideDown(); 
    });   
    $("#ilink3").on('click', function() {
        $(".pcategory").slideUp();
        $("#mobile").slideDown();
    });   
    $("#ilink4").on('click', function() {
        $(".pcategory").slideUp();
        $("#embedded").slideDown();
    });
}