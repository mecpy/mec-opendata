$(document).ready(function() {
    var vistas = $('.vista-previa');
    $('#portada').data('total', vistas.length);

    for (var v = 0; v < vistas.length; v = v + 2) {
        var row = $('<div>').addClass('row');
        var col = $('<div>').addClass('col-sm-12')
                .appendTo(row);
        $(vistas[v]).before(row);
        $(vistas[v]).appendTo(col);
        $(vistas[v + 1]).appendTo(col);
    }

    window.redimensionar = function() {

        var alto = 0;

        $('.vista-previa').each(function(v, vista) {
            $(vista).css('height', $(vista).width())
                    .attr('data-indice', v)
                    .tooltip({title: $(vista).data('titulo')});
            alto += $(vista).outerHeight(true);
        });

        $('#portada').parent().css('height',
                $('.vista-previa').first().is(':visible') ?
                (alto / 2) - 15 : ($(window).height() - 30 -
                $('header').outerHeight(true) -
                $('#anterior').parent().outerHeight(true)));
    };

    $('body').attr('onresize', 'redimensionar();');
    window.redimensionar();

    window.cambiar = function(btn) {

        $('#informacion').stop().fadeOut('fast', function() {

            $('#portada').stop().fadeOut('slow', function() {

                $('#cargando').removeClass('hidden');
                $('.vista-previa.active').removeClass('active');
                $(btn).addClass('active');

                var indice = $(btn).data('indice');
                var imagen = $(btn).data('imagen');

                $('#portada').attr('onclick', 'window.open("' + $(btn).data('enlace') + '","_self");')
                        .data('indice', indice)
                        .empty();

                $('#informacion').empty();
                $('<h2>').html($(btn).data('titulo')).appendTo('#informacion');
                $('<p>').html($(btn).data('descripcion')).appendTo('#informacion');
                $('#informacion').fadeIn();

                if (indice == 0) {
                    $('#anterior').addClass('disabled');
                } else {
                    $('#anterior').removeClass('disabled');
                }

                if (indice == ($('#portada').data('total') - 1)) {
                    $('#siguiente').addClass('disabled');
                } else {
                    $('#siguiente').removeClass('disabled');
                }

                var cargar_imagen = function() {
                    $(btn).addClass('imagen-descargada');

                    if ($('#portada').data('indice') == indice) {
                        $('#portada').css('background-image', 'url(' + imagen + ')');
                        $('#cargando').addClass('hidden');
                        $('#portada').fadeIn();
                    }
                };

                if ($(btn).hasClass('imagen-descargada')) {
                    cargar_imagen();
                } else {
                    $('<img>').load(cargar_imagen)
                            .attr('src', imagen).each(function() {
                        // fail-safe for cached images which sometimes don't trigger "load" events
                        if (this.complete) {
                            $(this).load();
                        }
                    });
                }

            });

        });

    };

    window.cambiar($('.vista-previa').first());

    window.anterior = function(btn) {
        if ($(btn).parent().hasClass('disabled')) {
            return;
        }
        cambiar($('.vista-previa[data-indice=' +
                (parseInt($('#portada').data('indice')) - 1) + ']'));
    };

    window.siguiente = function(btn) {
        if ($(btn).parent().hasClass('disabled')) {
            return;
        }
        cambiar($('.vista-previa[data-indice=' +
                (parseInt($('#portada').data('indice')) + 1) + ']'));
    };

    window.seleccionar = function(btn) {
        $('#portada').removeClass('cambio-automatico');
        cambiar(btn);
    };

    window.autocambio = function() {
        setTimeout(function() {

            if ($('#portada').hasClass('cambio-automatico')) {
                var indice = $('#portada').data('indice');

                if (!$('#paginador').is(':visible')) {
                    if (indice < ($('#portada').data('total') - 1)) {
                        siguiente($('#siguiente a'));
                    } else {
                        cambiar($('.vista-previa').first());
                    }
                }

                autocambio();
            }

        }, 5000);
    };

    window.autocambio();
});