// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.autocomplete
//= require underscore
// require_tree .
//= stub matriculados
//= stub mapa_matriculaciones
//= stub leaflet
//= stub bootstrap-slider
//= stub gmaps/gmaps.js
//= stub gmaps/markerclusterer.js
// require jquery.ui.all
//= require firsttime
//= require intro.min.js
//= stub views/index_view.js
//= stub views/datos_ver_view.js
//= stub views/datos_view.js
//= stub views/visualizaciones_view.js
//= require datos_abiertos_plugins.js
//= stub diccionario/contrataciones.js
//= stub diccionario/directorios_instituciones.js
//= stub diccionario/establecimientos.js
//= stub diccionario/establecimientos111.js
//= stub diccionario/establecimientos822.js
//= stub diccionario/instituciones.js
//= stub diccionario/matriculaciones_departamentos_distritos.js
//= stub diccionario/matriculaciones_educacion_escolar_basica.js
//= stub diccionario/matriculaciones_educacion_inclusiva.js
//= stub diccionario/matriculaciones_educacion_media.js
//= stub diccionario/matriculaciones_educacion_permanente.js
//= stub diccionario/matriculaciones_educacion_superior.js
//= stub diccionario/matriculaciones_inicial.js
//= stub diccionario/nomina_administrativos.js
//= stub diccionario/nomina_docentes.js
//= stub diccionario/registros_titulos.js
//= stub diccionario/requerimientos_aulas.js
//= stub diccionario/requerimientos_mobiliarios.js
//= stub diccionario/requerimientos_otros_espacios.js
//= stub diccionario/requerimientos_sanitarios.js
//= stub diccionario/servicios_basicos.js

/*Funcion que limpia el formulario del Dataset*/
function resetForm(formId, valor_defecto) {
    var form=$(formId);
    form.find('input:text, input:password, input:file, select, textarea').val('');
    form.find('input:radio, input:checkbox')
            .removeAttr('checked').removeAttr('selected');

    $.each(valor_defecto, function(idx, v) {
        $(v.id).val(v.valor);
    });
    $.ajaxQ.abortAll();
    form.submit();
}
/*Funcion que quita el filtro seleccionado*/
function quitar_filtro(form, id, valor_defecto) {
    var form=$(formId);
    if (typeof (valor_defecto) !== "undefined") {
        $(id).val(valor_defecto);
    } else {
        $(id).val('');
    }
    $.ajaxQ.abortAll();
    form.submit();
}

$.ajaxQ = (function() {

    var id = 0, Q = {};

    $(document).ajaxSend(function(e, jqx) {
        jqx._id = ++id;
        Q[jqx._id] = jqx;
    });
    $(document).ajaxComplete(function(e, jqx) {
        delete Q[jqx._id];
    });

    return {
        abortAll: function() {
            var r = [];
            $.each(Q, function(i, jqx) {
                r.push(jqx._id);
                jqx.abort();
            });
            return r;
        }
    };

})();
$(function() {
    tour();
    listados();
    basico();
});
function tour() {
    if ($('#start-tour').length) {
        if ($.cookie('firstVisit') === undefined) {
            $.cookie('firstVisit', 'true');
            var date = new Date();
            var m = 1;
            date.setTime(date.getTime() + (m * 60 * 1000));
            $.cookie("firstVisit", "value", {expires: date});
        } else {
            $.cookie('firstVisit', 'false');
        }
        var firstVisit = $.cookie('firstVisit');
        if (firstVisit === 'true') {
            introJs().setOptions({
                doneLabel: 'Salir',
                nextLabel: 'Siguiente &rarr;',
                prevLabel: '&larr; Anterior',
                skipLabel: 'Salir',
                steps: stepsListado
            }).start();
        } else {
            //nothing to do
        }
    } else {
        //nothing to do
    }
}
;
function listados() {
    window.redimensionar = function() {

        $('.descripcion-oculta').each(function(d, descripcion) {
            $(descripcion).addClass('hidden-xs').show();
        });

        $('.listado li').each(function(f, fila) {
            $(fila).css('height', 'auto');
            $(fila).css('height', $(fila).height());
        });

    };
    $('body').attr('onresize', 'redimensionar();');
    window.redimensionar();
}
;
function basico() {
    $('select').combobox();
    $('#compartir').sharrre({
        share: {
            twitter: true,
            facebook: true,
            googlePlus: true
        },
        urlCurl: 'assets/sharrre.php',
        template: '<div class="box">' +
                '<div class="left">Compartir</div>' +
                '<div class="middle">' +
                '<a href="#" class="facebook"><i class="fa fa-fw fa-facebook"></i></a>' +
                '<a href="#" class="twitter"><i class="fa fa-fw fa-twitter"></i></a>' +
                '<a href="#" class="googleplus"><i class="fa fa-fw fa-google-plus"></i></a>' +
                '</div>' +
                '<div class="right">{total}</div>' +
                '</div>',
        enableHover: false,
        enableTracking: true,
        render: function(api, options) {
            $(api.element).on('click', '.twitter', function() {
                api.openPopup('twitter');
            });
            $(api.element).on('click', '.facebook', function() {
                api.openPopup('facebook');
            });
            $(api.element).on('click', '.googleplus', function() {
                api.openPopup('googlePlus');
            });
        }
    });
}
;
