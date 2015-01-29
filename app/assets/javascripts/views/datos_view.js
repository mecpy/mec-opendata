$(document).ready(function() {
    window.descripcion = function(btn) {
        var descripcion = $(btn).parent().parent().next();
        descripcion.parent().css('height', 'auto');

        if (!descripcion.is(':visible')) {
            descripcion.hide().removeClass('hidden-xs descripcion-oculta');
            descripcion.slideDown('slow', function() {
                $(btn).find('[data-ver]').hide();
                $(btn).find('[data-ocultar]').hide()
                        .removeClass('hidden').fadeIn();
            });
        } else {
            descripcion.slideUp('slow', function() {
                descripcion.addClass('hidden-xs descripcion-oculta');
                $(btn).find('[data-ocultar]').hide().addClass('hidden');
                $(btn).find('[data-ver]').fadeIn();
            });
        }
    };
});