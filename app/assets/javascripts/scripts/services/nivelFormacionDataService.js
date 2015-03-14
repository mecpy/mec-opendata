'use strict';
/* jshint undef: true, unused: true */
/* global angular */


/**
 * @ngdoc service
 * @name chilecompraApp.MyDataService
 * @requires $q
 * @requires d3
 * @requires _
 * @requires $http
 *
 * @description
 * Demo
 *
 */
angular.module('tideApp')
.service('nivelFormacionDataService',['$q', 'd3', '_', '$http',function($q, d3,_, $http) {
  var myself = this;

  myself.data = null;
  myself.niveles = null;
  myself.glosa = null;
  myself.materias = null;
  myself.materiasDepartamento = null;

  this.loadData = function() {
    var defer = $q.defer();

    if (!myself.data) {
      d3.tsv("dataNivelFormacion.txt", function(data) {
        if (data) {
          myself.data = data;
          defer.resolve(myself.data);
        } else {
          defer.reject();
        }
      })
    } else {
      defer.resolve(myself.data)
    }

    return defer.promise;
  }



  this.getData = function(filterOptions) {
    var defer = $q.defer();

    myself.loadData()
    .then(function(data) {
      if (filterOptions) {
        var filteredData = _.filter(data, function(d) {
          var valid = true;

          _.each(_.keys(filterOptions), function(key) {
            valid = valid && (+d[key] == filterOptions[key]);
          })

          return valid;
        })
        defer.resolve(filteredData);
      } else {
        defer.resolve(data);
      }
    })

    return defer.promise;
  }


  this.getDepartamentos = function() {
    var defer = $q.defer();

    d3.tsv("dataDepartamentos.txt", function(data) {
      if (data) {
        var firstRecord = {
          DepartamentoCodigo : -1,
          DepartamentoNombre : "TODOS",
          nombre: "Todos los departamentos"
        }

        _.each(data, function(d) {
          d.nombre = d.DepartamentoNombre
        })

        defer.resolve(_.union([firstRecord], data));
      } else {
        defer.reject();
      }
    })

    return defer.promise;
  }

  this.getDistritos = function(DepartamentoCodigo) {
    var defer = $q.defer();

    var filterDistritos = function(distritos, DepartamentoCodigo) {
      var filteredData = _.filter(distritos, function(d) {return d.DepartamentoCodigo == DepartamentoCodigo});
      var firstRecord = {
        DistritoCodigo : -1,
        DistritoNombre : "TODOS"
      }
      return _.union([firstRecord], filteredData);
    };

    if (myself.dataDistritos) {
      defer.resolve(filterDistritos(myself.dataDistritos,DepartamentoCodigo));
    } else {
      d3.tsv("dataDistritos.txt", function(data) {
        if (data) {
          myself.dataDistritos = data;
          defer.resolve(filterDistritos(myself.dataDistritos,DepartamentoCodigo));
        } else {
          defer.reject();
        }
      })      
    }

    return defer.promise;
  }

  this.getGlosa = function() {
    var defer = $q.defer();

    if (myself.glosa) {
      defer.resolve(myself.glosa);
    } else {
      $http.get("glosa.json")
      .then(function(response) {
        myself.glosa = response.data;
        defer.resolve(myself.glosa);
      })
      .catch(function(err) {
        alert("Error en archivo de datos glosa.json.\n"+err.message);
        defer.reject(err)
      })    
    }



    return defer.promise;
  }

  this.getNiveles = function() {
    var defer = $q.defer();

    if (myself.niveles) {
      defer.resolve(myself.niveles);
    } else {
      $http.get("niveles.json")
      .then(function(response) {
        myself.niveles = response.data;
        defer.resolve(myself.niveles);
      })
      .catch(function(err) {
        alert("Error en archivos de datos niveles.json.\n "+err.message)
        defer.reject(err);
      })
    }

    return defer.promise;
  }


  this.buildDataRecord = function(filterOptions) {
    var defer = $q.defer();

    myself.getNiveles()
    .then(function(niveles) {
      myself.niveles = niveles;

      return myself.getGlosa()
    })
    .then(function(glosa) {
      myself.glosaNiveles = glosa;

      return myself.getData(filterOptions)
    })
    .then(function(data) {
      var record = data[0];
      var output = [];

      _.each(myself.niveles, function(level) {
          var newLevel = {};
          newLevel.id = level.id;
          newLevel.name = myself.glosaNiveles[level.id] ?  myself.glosaNiveles[level.id].name : null;
          newLevel.desc = myself.glosaNiveles[level.id] ?  myself.glosaNiveles[level.id].desc : null;
          newLevel.blocks = [];

          _.each(level.blocks, function(blockId) {
              var newBlock = {};
              newBlock.id = blockId;
              newBlock.name = myself.glosaNiveles[blockId] ?  myself.glosaNiveles[blockId].name : null;
              newBlock.desc = myself.glosaNiveles[blockId] ?  myself.glosaNiveles[blockId].desc : null;
              newBlock.size = record[blockId];
              newLevel.blocks.push(newBlock);
          })
          output.push(newLevel);
      })

      defer.resolve(output);
    })

    return defer.promise;
  }

  this.getDataCompatibleDepartamentos = function() {
    var defer = $q.defer();

    myself.getData({DistritoCodigo:-1})
    .then(function(data) {
      var output = [];

      _.each(data, function(d) {
        output.push({
          "id": d.DepartamentoCodigo,
          "label": d.DepartamentoCodigo == -1 ? "PARAGUAY" : d.DepartamentoNombre,
          "compatibleEdMedia" : d.compatibleEdMedia,
          "noCompatibleEdMedia" : d.noCompatibleEdMedia,
          left : [
            {size: +d.noCompatibleEdMedia, color:"red"}
          ],
          right : [
            {size: +d.compatibleEdMedia, color:"blue"}
          ],

        })
      })

      output = _.sortBy(output, function(d) {
        return (+d.noCompatibleEdMedia)/(+d.compatibleEdMedia)
      })


      defer.resolve(output);

    })

    return defer.promise;
  }

   this.getMaterias = function() {
    var defer = $q.defer();

    if (myself.materias) {
      defer.resolve(myself.materias);
    } else {
      d3.tsv("dataMateriaTituloCompatibleNacional.txt", function(data) {
        if (data) {
          myself.materias = data;
          defer.resolve(myself.materias);
        } else {
          defer.reject();
        }
      })
    } 

    return defer.promise;
  }

  this.getMateriasDepartamento = function(filterOptions) {
    var defer = $q.defer();

    var DepartamentoCodigo = filterOptions && filterOptions.DepartamentoCodigo ? filterOptions.DepartamentoCodigo : -1;

    if (myself.materiasDepartamento) {
      defer.resolve(_.filter(myself.materiasDepartamento, function(d) {
        return d.DepartamentoCodigo == DepartamentoCodigo;
      }) );
    } else {
      d3.tsv("dataMateriaTituloCompatibleDepartamento.txt", function(data) {
        if (data) {
          myself.materiasDepartamento = data;
          defer.resolve(_.filter(myself.materiasDepartamento, function(d) {
            return d.DepartamentoCodigo == DepartamentoCodigo;
          }) );        
        } else {
          defer.reject();
        }
      })
    } 

    return defer.promise;
  }

  this.getMateriasSector = function(filterOptions) {
    var defer = $q.defer();

    var SectorCodigo = filterOptions && filterOptions.SectorCodigo ? filterOptions.SectorCodigo : -1;

    if (myself.materiasSector) {
      defer.resolve(_.filter(myself.materiasSector, function(d) {
        return d.SectorCodigo == SectorCodigo;
      }) );
    } else {
      d3.tsv("./data/dataMateriaTituloCompatibleSector.txt", function(data) {
        if (data) {
          myself.materiasSector = data;
          defer.resolve(_.filter(myself.materiasSector, function(d) {
            return d.SectorCodigo == SectorCodigo;
          }) );        
        } else {
          defer.reject();
        }
      })
    } 

    return defer.promise;
  }

  this.getMateriasNivel = function(filterOptions) {
    var defer = $q.defer();

    var NivelCodigo = filterOptions && filterOptions.NivelCodigo ? filterOptions.NivelCodigo : -1;

    if (myself.materiasNivel) {
      defer.resolve(_.filter(myself.materiasNivel, function(d) {
        return d.NivelCodigo == NivelCodigo;
      }) );
    } else {
      d3.tsv("dataMateriaTituloCompatibleNivel.txt", function(data) {
        if (data) {
          myself.materiasNivel = data;
          defer.resolve(_.filter(myself.materiasNivel, function(d) {
            return d.NivelCodigo == NivelCodigo;
          }) );        
        } else {
          defer.reject();
        }
      })
    } 

    return defer.promise;
  }

  this.getMateriasArea = function(filterOptions) {
    var defer = $q.defer();

    var AreaCodigo = filterOptions && filterOptions.AreaCodigo ? filterOptions.AreaCodigo : -1;

    if (myself.materiasArea) {
      defer.resolve(_.filter(myself.materiasArea, function(d) {
        return d.AreaCodigo == AreaCodigo;
      }) );
    } else {
      d3.tsv("dataMateriaTituloCompatibleArea.txt", function(data) {
        if (data) {
          myself.materiasArea = data;
          defer.resolve(_.filter(myself.materiasArea, function(d) {
            return d.AreaCodigo == AreaCodigo;
          }) );        
        } else {
          defer.reject();
        }
      })
    } 

    return defer.promise;
  }

}]);








