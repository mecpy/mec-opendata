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
//= require underscore
//= require_tree .
//= stub matriculados
//= stub mapa_matriculaciones
//= stub leaflet
//= stub bootstrap-slider
//= stub gmaps/gmaps.js
//= stub gmaps/markerclusterer.js
// require jquery.ui.all
//= require firsttime
//= require intro.min.js

$.ajaxQ = (function () {

    var id = 0, Q = {};

    $(document).ajaxSend(function (e, jqx) {
        jqx._id = ++id;
        Q[jqx._id] = jqx;
    });
    $(document).ajaxComplete(function (e, jqx) {
        delete Q[jqx._id];
    });

    return {
        abortAll: function () {
            var r = [];
            $.each(Q, function (i, jqx) {
                r.push(jqx._id);
                jqx.abort();
            });
            return r;
        }
    };

})();
$(function () {
    if ($('#start-tour').length) {
        if ($.cookie('firstVisit') === undefined) {
            $.cookie('firstVisit', 'true');
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
});