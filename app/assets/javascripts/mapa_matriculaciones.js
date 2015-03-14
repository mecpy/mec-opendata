/*
* @author Rodrigo Parra
* Desarrollado en base al trabajo previo de Rafael Palau y Pedro Amarilla
* @copyright 2014 Governance and Democracy Program USAID-CEAMSO
* @license http://www.gnu.org/licenses/gpl-2.0.html
*
* USAID-CEAMSO
* Copyright (C) 2014 Governance and Democracy Program
* http://ceamso.org.py/es/proyectos/20-programa-de-democracia-y-gobernabilidad
*
----------------------------------------------------------------------------
* This file is part of the Governance and Democracy Program USAID-CEAMSO,
* is distributed as free software in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. You can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License version 2 as published by the
* Free Software Foundation, accessible from <http://www.gnu.org/licenses/> or write
* to Free Software Foundation (FSF) Inc., 51 Franklin St, Fifth Floor, Boston,
* MA 02111-1301, USA.
---------------------------------------------------------------------------
* Este archivo es parte del Programa de Democracia y Gobernabilidad USAID-CEAMSO,
* es distribuido como software libre con la esperanza que sea de utilidad,
* pero sin NINGUNA GARANTÍA; sin garantía alguna implícita de ADECUACION a cualquier
* MERCADO o APLICACION EN PARTICULAR. Usted puede redistribuirlo y/o modificarlo
* bajo los términos de la GNU Lesser General Public Licence versión 2 de la Free
* Software Foundation, accesible en <http://www.gnu.org/licenses/> o escriba a la
* Free Software Foundation (FSF) Inc., 51 Franklin St, Fifth Floor, Boston,
* MA 02111-1301, USA.
*/

$(function() {
    /* Se inicializa y configura el mapa*/
    var southWest = L.latLng(-26, -62),
        northEast = L.latLng(-21, -52),
        bounds = L.latLngBounds(southWest, northEast);    
    var map = L.map('map', {
        attributionControl: false,
        maxZoom: 10,
        minZoom: 5,
        maxBounds: bounds
    }).setView([-23.4, -57], 6);
    var legend = L.control({position: 'bottomright'});
    legend.onAdd = function (map) {
        var div = L.DomUtil.create('div', 'info legend'),
            grades = [1, 100, 500, 1000, 5000, 10000, 20000, 40000, 70000, 100000, 150000, 250000, 300000],
            labels = [],
            from, to;
        labels.push('<i style="background:' + getColor(0) + '"></i> ' + '0');
        for (var i = 0; i < grades.length; i++) {
            from = grades[i];
            to = grades[i + 1];
            labels.push(
                '<i style="background:' + getColor(from + 1) + '"></i> ' +
                from + (to ? '&ndash;' + to : '+'));
        }
        div.innerHTML = '<span>N&uacutemero de Matriculados</span><br>' + labels.join('<br>')
        return div;
    };
    legend.addTo(map);

    var info = L.control();
    info.onAdd = function (map) {
        this._div = L.DomUtil.create('div', 'info');
        this.update();
        return this._div;
    };
    info.update = function (props) {
        var cantidad = 0;
        if(props && props.cantidad){
          cantidad = props.cantidad;
        }
        var zona = $('.zona label.active').text().trim();
        var tipoGestion = $('.tipo-gestion label.active').text().trim();
        var nivel = $('.nivel label.active').text().trim();
        var subnivel = $('.subnivel label.active').text().trim();

        this._div.innerHTML =  '<h4>Cantidad de Matriculados</h4>'
            + (zona ? '<b>' + $('.zona > h3').text() + ': </b>' + zona + '</br>': '')
            + (tipoGestion ? '<b>' + $('.tipo-gestion > h3').text() + ': </b>' + tipoGestion + '</br>': '') 
            + (nivel ? '<b>' + $('.nivel > h3').text() + ': </b>' + nivel + '</br>': '') 
            + (subnivel ? '<b>' + $('.subnivel > h3').filter(':visible').text() + ': </b>' + subnivel + '</br>': '')              
            + (zona || tipoGestion || nivel || subnivel ? '</br>' : '')
            +  (props ? '<b>' + props.NAME_1 + '</b><br />' + cantidad + ' matriculados'
            : 'Marque un departamento');
    };
    info.addTo(map)

    /*Se añade capa de departamentos*/
    var statesLayer = L.geoJson(matriculadosPorDepartamento,  {style: getStyle, onEachFeature: onEachFeature}).addTo(map);

    /*Estilo de la capa de acuedo a cantidad de matriculados*/
    function getStyle(feature) {
        return { weight: 2, opacity: 0.1, color: 'black', dashArray: '3', fillOpacity: 0.7, fillColor: getColor(feature.properties.cantidad) };
    }

    /*Color de cada departamento según la cantidad de matriculados*/
    function getColor(d) {
        return    d > 300000    ? '#FE0516' :
                d > 250000    ? '#FD1E0F' :
                d > 150000    ? '#FD4619' :
                d > 100000    ? '#FD6C24' :
                d > 70000    ? '#FD8E2E' :
                d > 40000    ? '#FDAE39' :
                d > 20000    ? '#FDCB43' :
                d > 10000    ? '#FDE54E' :
                d > 5000    ? '#FDFC58' :
                d > 1000    ? '#E9FD62' :
                d > 500    ? '#D7FD6D' :
                d > 100    ? '#C8FD77' :
                d > 1    ? '#BCFD82' :
                            '#FFFFFF';
    }

    /*Eventos para cada departamento*/
    function onEachFeature(feature, layer) {
        layer.on({
            mousemove: mousemove,
            mouseout: mouseout,
            click: zoomToFeature
        });
    }

    var closeTooltip;

    /*Evento similar a hover para cada departamento*/
    function mousemove(e) {
        var layer = e.target;
        layer.setStyle({
            weight: 5,
            color: '#030303',
            dashArray: '',
            fillOpacity: 0.7
        });
        info.update(layer.feature.properties);
    }

    /*Evento al salir el puntero de un departamento*/
    function mouseout(e) {
        statesLayer.resetStyle(e.target);
        info.update();
    }

    /*Zoom al hacer click en un departamento*/
    function zoomToFeature(e) {
        map.fitBounds(e.target.getBounds());
    }

    /*Eliminar las capas de cada departamento*/
    function removeLayers(){
        map.eachLayer(function(layer){
            map.removeLayer(layer);
        });
    }

    /*Redibujar las capas del mapa*/
    function redrawLayers(){
        L.geoJson(matriculadosPorDepartamento,  {style: getStyle, onEachFeature: onEachFeature}).addTo(map);
    }

    $('.subnivel-basica, .subnivel-inclusiva, .subnivel-permanente, .subnivel-superior, .subnivel-media, .subnivel-inicial').toggle();

    /* slider para anho */
    $('#anho').slider({
        formater: function(value) {
            return value;
        }
    });

    /*Convertimos el grupo de checboxes en algo similar a un grupo de radio buttons*/    
    $('label.btn').click(function(){
        var self = $(this);
        $(this).children('input:checkbox').each(function(){
            if(!this.checked){
                self.siblings('label.btn').each(function(){
                    $(this).children('input:checkbox').each(function(){
                        $(this).attr('checked', false);
                        $(this).parent().removeClass('active');
                    });
                });
            }
        });
    });

    /*Se hacen visibles los filtros de subnivel de acuerdo al nivel seleccionado*/
    $('input[name="nivel"]').change(function(){
        $('h3.grado').css('visibility', 'hidden');
        $('h3.modalidad').css('visibility', 'hidden');
        if(this.checked){
            $('.subnivel > label > input').attr('checked', false);
            $('.subnivel > label').removeClass('active');
            switch($(this).val()) {
            case "matriculaciones_educacion_inclusiva":
                $('.subnivel > *').css('display', 'none').css('visibility', 'hidden');
                $('.subnivel > .subnivel-inclusiva').css('display', 'block').css('visibility', 'visible');
                $('h3.modalidad').css('visibility', 'visible').css('display', 'block');

                break;
            case "matriculaciones_inicial":
                $('.subnivel > *').css('display', 'none').css('visibility', 'hidden');
                $('.subnivel > .subnivel-inicial').css('display', 'block').css('visibility', 'visible');
                $('h3.grado').css('visibility', 'visible').css('display', 'block');

                break;
            case "matriculaciones_educacion_escolar_basica":
                $('.subnivel > *').css('display', 'none').css('visibility', 'hidden');
                $('.subnivel > .subnivel-basica').css('display', 'block').css('visibility', 'visible');
                $('h3.grado').css('visibility', 'visible').css('display', 'block');

                break;
            case "matriculaciones_educacion_permanente":
                $('.subnivel > *').css('display', 'none').css('visibility', 'hidden');
                $('.subnivel > .subnivel-permanente').css('display', 'block').css('visibility', 'visible');
                $('h3.modalidad').css('visibility', 'visible').css('display', 'block');

                break;
            case "matriculaciones_educacion_superior":
                $('.subnivel > *').css('display', 'none').css('visibility', 'hidden');
                $('.subnivel > .subnivel-superior').css('display', 'block').css('visibility', 'visible');
                $('h3.modalidad').css('visibility', 'visible').css('display', 'block');

                break;
            case "matriculaciones_media":
                $('.subnivel > *').css('display', 'none').css('visibility', 'hidden');
                $('.subnivel > .subnivel-media').css('display', 'block').css('visibility', 'visible');
                $('h3.grado').css('visibility', 'visible').css('display', 'block');

                break;
            default:
                console.log("default");
            }
        }else{
            $('.subnivel > *').css('display', 'none').css('visibility', 'hidden');
            $('.subnivel > * > input').attr('checked', false);
        }

    });

    /*Utilitario para eliminar acentos de la cadena, para poder comparar las claves
    (nombre del departamento) del servicio (BD MEC) con las del GEOJSON*/
    function removeAccents(strAccents) {
        var strAccents = strAccents.split('');
        var strAccentsOut = new Array();
        var strAccentsLen = strAccents.length;
        var accents = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñÿý';
        var accentsOut = "AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz";
        for (var y = 0; y < strAccentsLen; y++) {
            if (accents.indexOf(strAccents[y]) != -1) {
                strAccentsOut[y] = accentsOut.substr(accents.indexOf(strAccents[y]), 1);
            } else
                strAccentsOut[y] = strAccents[y];
        }
        strAccentsOut = strAccentsOut.join('');
        return strAccentsOut;
    }

    /*Llamada AJAX para el submit del form de filtros*/
    $("#form-buscar-matriculaciones").submit(function(e)
    {
        var postData = $(this).serializeArray();
        var formURL = $(this).attr("action");
        $.ajax(
        {
            url : formURL,
            type: "POST",
            data : postData,
            dataType: 'json',
            headers: {'X-Requested-With': 'XMLHttpRequest'},
            success:function(data, textStatus, jqXHR) 
            {
                for(var k in data){
                    data[removeAccents(k).toLowerCase()] = data[k]
                }
                for (index = 0; index < matriculadosPorDepartamento.features.length; ++index) {
                    matriculadosPorDepartamento.features[index].properties.cantidad = data[removeAccents(matriculadosPorDepartamento.features[index].properties.NAME_1).toLowerCase()];
                };
                removeLayers();
                redrawLayers();
                info.update();
                $('#map-link').attr('href', formURL + '.json?' + decodeURIComponent($.param(postData)));
            },
            error: function(jqXHR, textStatus, errorThrown) 
            {
                console.log(textStatus);
            }
        });
        e.preventDefault(); //STOP default action
    });

    /*Limpiamos el form inicialmente*/
    $('form').each(function() { this.reset() });
    
    /*Submit del form al cambiar el valor de cualquier checkbox*/
    $('input').change(function(){
        $("#form-buscar-matriculaciones").submit(); //Submit  the FORM
    });

    function getQueryVariable(variable)
    {
       var query = window.location.search.substring(1);
       var vars = query.split("&");
       for (var i=0;i<vars.length;i++) {
               var pair = vars[i].split("=");
               if(pair[0] == variable){return pair[1];}
        }
       return(false);
    }

    /*Se carga inicialmente el mapa*/
    var nivel = getQueryVariable('nivel');
    if(nivel){
        $("[value=" + nivel + "]").click();
    }else{
        $("#form-buscar-matriculaciones").submit();

    }
});
