'use strict';
/* jshint undef: true, unused: true */
/* global angular */




/**
 * @ngdoc controller
 * @name chilecompraApp.controller:CarrerasController
 * @requires $scope
 * @requires chilecompraApp.CarrerasDataService
 *
 * @property {array} colorOptions Array with options for colorAttributes
 * @property {string} colorAttribute Selected color attribute
 * @property {array} data Array with student data for the selected career & semester
 * @property {int} n Number of students in the selected data array
 * @property {int} maxCarreras Maximum number of carreras to be displayed when filtraTopCarreras is true
 * @property {array} semestres Array with the semesters options to be chosen
 * @property {string} selectedSemestre Selected semester for data selection
 * @property {string} psuValido Flag to select only data values with a valid psu score (prom_paa>0)
 * @property {string} loading Flag to show a "loading" message when its value is true
 * @description
 *
 * Controller for Carreras explorer
 *
 */
angular.module('tideApp')
.controller('tituloCompatibleController', ['$scope','$http','$modal', '_','d3', 'nivelFormacionDataService', "$timeout",function ($scope,$http,$modal,_,d3, dataServiceNivelFormacion, $timeout) {
	var myself = this;
    this.loading = false;
    this.data = null;

    this.maxSize = null;
    this.minSize = null;

    this.sectores = [
        {
            SectorCodigo: -1,
            nombre: "Todos los sectores"
        },
        {
            SectorCodigo: 1,
            nombre: "Oficial"
        },
        {
            SectorCodigo: 2,
            nombre: "Privado"
        },
        {
            SectorCodigo: 3,
            nombre: "Privado Subvencionado"
        }
    ];

    this.niveles = [
        {
            NivelCodigo: -1,
            nombre: "Todos los niveles"
        },
        {
            NivelCodigo: 22,
            nombre: "Bachillerato Científico"
        },
        {
            NivelCodigo: 23,
            nombre: "Bachillerato Técnico"
        },
        {
            NivelCodigo: 25,
            nombre: "Media Abierta"
        }
    ];

    this.areas = [
        {
            AreaCodigo: -1,
            nombre: "Todas las áreas"
        },
        {
            AreaCodigo: 1,
            nombre: "Urbano"
        },
        {
            AreaCodigo: 6,
            nombre: "Rural"
        }
    ];

    this.departamentos = null;
    this.opciones = null

    dataServiceNivelFormacion.getDepartamentos()
    .then(function(departamentos) {
        myself.departamentos = departamentos;

        myself.opciones = myself.departamentos;
        myself.opcionSeleccionada = myself.opciones[0];

    })


    this.selectOpcion = function(opcion) {
        var filterOptions = {};
        switch(myself.selectedTab) {
            case 'departamento':
                filterOptions.DepartamentoCodigo = opcion.DepartamentoCodigo;
                break;
            case 'sector':
                filterOptions.SectorCodigo = opcion.SectorCodigo;
                break;
            case 'nivel':
                filterOptions.NivelCodigo = opcion.NivelCodigo;
                break;
            case 'área':
                filterOptions.AreaCodigo = opcion.AreaCodigo;
                break;
            default:
                ;
        }
        myself.load(filterOptions);
    }


    this.tooltipMessage = function(d) {
        var number = d3.format(",")
        var percentage = d3.format(".1%")

        var msg = "";
        msg += "<strong class='text-muted'>"+d["MateriaDescripcion"]+"</strong>";
        msg += "<p class='text-info'>"+number(d["totalProfesores"])+" profesores enseñan la materia.</p>";
        msg += "<p class='text-muted'>"+number(d["conTituloYFormacionCompatible"])+" ("+percentage(d["conTituloYFormacionCompatible"]/d["totalProfesores"])+") tienen título compatible con la materia y formación compatible con enseñanza en Ed. Media</p>";
        msg += "<p class='text-muted'>"+number(d["conTituloCompatible"])+" ("+percentage(d["conTituloCompatible"]/d["totalProfesores"])+") tienen título compatible con la materia pero su formación puede no ser comptaible con enseñanza en Ed. Media</p>";

        return msg;
    }

    myself.selectedTab = "sector";

    // Clasificador:  departamento, nivel, area, sector
    this.SelectClasificador = function(clasificador) {
        myself.selectedTab = clasificador;

        switch(clasificador) {
            case 'departamento':
                myself.opciones = myself.departamentos;
                break;
            case 'sector':
                myself.opciones = myself.sectores;
                break;
            case 'nivel':
                myself.opciones = myself.niveles;
                break;
            case 'área':
                myself.opciones = myself.areas;
                break;
            default:
                ;
        }

        myself.opcionSeleccionada = myself.opciones[0];
        myself.selectOpcion(myself.opcionSeleccionada);
    }



    this.load = function(filterOptions) {
        var dataFunction = {
            'departamento': dataServiceNivelFormacion.getMateriasDepartamento,
            'área': dataServiceNivelFormacion.getMateriasArea,
            'sector': dataServiceNivelFormacion.getMateriasSector,
            'nivel' : dataServiceNivelFormacion.getMateriasNivel
        }

        dataFunction[myself.selectedTab](filterOptions)
        .then(function(data) {
            myself.maxSize = myself.maxSize ? myself.maxSize : _.max(data, function(d) {return +d.totalProfesores}).totalProfesores
            myself.minSize = myself.minSize ? myself.minSize : _.min(data, function(d) {return +d.totalProfesores}).totalProfesores
            myself.data = data;
        })    


    }

    // Cargar datos de departamentos
    dataServiceNivelFormacion.getDepartamentos()
    .then(function(departamentos) {
        myself.load({DepartamentoCodigo:-1});
    })



}]);
