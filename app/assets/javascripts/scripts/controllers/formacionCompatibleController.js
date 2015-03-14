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
.controller('formacionCompatibleController', ['$scope','$http','$modal', '_','d3', 'nivelFormacionDataService', "$timeout",function ($scope,$http,$modal,_,d3, dataServiceNivelFormacion, $timeout) {
	var myself = this;
    this.loading = false;

    this.departamentos = [];
    this.selectDepartamento = null;

    this.selectDepartamento = function() {
        var filterOptions = {DepartamentoCodigo: myself.selectedDepartamento.DepartamentoCodigo};
        myself.load(filterOptions)

        dataServiceNivelFormacion.getDistritos(myself.selectedDepartamento.DepartamentoCodigo)
        .then(function(data) {
            myself.distritos = data;
            myself.selectedDistrito = myself.distritos[0];
        })
    }

    this.selectDistrito = function() {
        var filterOptions = {DepartamentoCodigo: myself.selectedDepartamento.DepartamentoCodigo, DistritoCodigo: myself.selectedDistrito.DistritoCodigo};
        myself.load(filterOptions)
    }

    this.tooltipMessage = function(d) {
        var number = d3.format(",")

        var msg = "";
        msg += number(d.size)+" profesores<br>";

        return msg;
    }

    this.load = function(filterOptions) {
        dataServiceNivelFormacion.getDataCompatibleDepartamentos(filterOptions)
        .then(function(data) {
            myself.levelData = data;
        })
    }

    dataServiceNivelFormacion.getDepartamentos()
    .then(function(departamentos) {
        myself.departamentos = departamentos;
        myself.selectedDepartamento = myself.departamentos[0];

        myself.load({DistritoCodigo:"-1"});
    })

}]);
