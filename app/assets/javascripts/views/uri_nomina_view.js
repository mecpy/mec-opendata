$(document).ready(function() {
    window.redimensionar = function() {

        $('.listado li').each(function(f, fila) {
            $(fila).css('height', 'auto');
            $(fila).css('height', $(fila).height());
        });

    };

    $('body').attr('onresize', 'redimensionar();');
    window.redimensionar();
});