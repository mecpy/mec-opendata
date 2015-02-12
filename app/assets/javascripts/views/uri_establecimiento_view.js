$(document).ready(function() {
    window.redimensionar = function() {

        var bloques = $('#bloques').find('.bloque');

        for (var i = 0; (i + 1) < bloques.length; i = i + 2) {
            $(bloques[i + 1]).find('.map-canvas')
                    .css('height', $(bloques[i]).height())
                    .css('max-height', $(window).height());
        }

        $('.listado li').each(function(f, fila) {
            $(fila).css('height', 'auto');
            $(fila).css('height', $(fila).height());
        });

    };

    $('body').attr('onresize', 'redimensionar();');
    window.redimensionar();
});