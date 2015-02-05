$(document).ready(function() {
    $('.vista').each(function(v, vista) {

        $('<img>').load(function() {
            if ($('.no-cargada').length == 0) {
                $('#visualizaciones').masonry({
                    // options
                    itemSelector: '.vista'
                });
            }
        })
                .attr('src', $(vista).find('img').attr('src')).each(function() {
            $(vista).removeClass('no-cargada');

            // fail-safe for cached images which sometimes don't trigger "load" events
            if (this.complete) {
                $(this).load();
            }
        });

    });
});