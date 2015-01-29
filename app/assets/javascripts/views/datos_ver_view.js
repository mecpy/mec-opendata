$(document).ready(function() {
    var tabla = $('.table-responsive').responsiveTable({});
    var botones_derecha = $('.btn-toolbar').find('.dropdown-btn-group button');
    $(botones_derecha[0]).html('Ver todos');
    $(botones_derecha[1]).html('Ver columnas');
    $('.btn-toolbar .focus-btn-group button').html('<span class="glyphicon glyphicon-screenshot"></span> Resaltar');

    $('.orden').click(function() {

        // El comportamiento del botón es:
        // sin orden > descendente > ascendente > sin orden

        if ($(this).hasClass('ascendente')) {
            $(this).removeClass('ascendente');
        } else if ($(this).hasClass('descendente')) {
            $(this).removeClass('descendente');
            $(this).addClass('ascendente');
        } else {
            $(this).addClass('descendente');
        }

    });

    $('.limpiar').click(function() {
        var input = $(this).prev();
        input.val('');
        input.trigger('change');
    });
});