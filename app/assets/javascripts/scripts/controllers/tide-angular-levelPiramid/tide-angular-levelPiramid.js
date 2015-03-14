
"use strict";
/* jshint undef: true, unused: true */
/* global angular */

/**
 * @ngdoc overview
 * @name tide-angular
 * @description
 * Data visualization tools from TIDE SA
 *
 */
angular.module("tide-angular")
.directive("tdLevelPiramidChart",["$compile","_", "d3", "toolTip", "$window", "tdLevelPiramidLayout",function ($compile,_, d3, tooltip, $window, layout) {
 return {
  restrict: "A",
      //transclude: false,
      //template: "<div style='background-color:red' ng-transclude></div>",
      scope: {
        data: "=tdData",
        tooltipMessage: "=tdTooltipMessage",
        hiddenNodes : "=?tdHiddenNodes",
        selectedItem : "=?tdSelectedItem"

      },
      
      link: function (scope, element, attrs) {

        var margin = {};
        margin.left = scope.options && scope.options.margin && scope.options.margin.left ? scope.options.margin.left : 5;
        margin.right = 5;
        margin.top = 5;
        margin.bottom = 5;

        var levelHeight = 30;
        var levelPadding = 30;

        var width = element.width()-margin.left-margin.right;
        var height = scope.height ? scope.height : width;
 

        var colorScale = d3.scale.category10();

        // Define dataPoints tooltip generator
        var dataPointTooltip = tooltip();
        if (scope.tooltipMessage) {
          dataPointTooltip.message(scope.tooltipMessage);
        } else {
          dataPointTooltip.message(function(d) {
            var msg = d.name;

            return  msg;
          });
        }

        var svgMainContainer = d3.select(element[0])
          .append("svg")
          .attr("width", width+margin.left+margin.right)
          .attr("height", height+margin.top+margin.bottom)

        var svgContainer = svgMainContainer
          .append("g")

        var resizeSvg = function() {
          width = element.width()-margin.left-margin.right;
          svgMainContainer.attr("width",width)
          svgMainContainer.attr("height",height)
        }

        var xScale = d3.scale.linear();

        /*
        * render
        * Displays visual elements for available data
        */
        var render = function(data) {
          

          // Check that we have a valid dataset
          if (data) {
            console.log(layout.nodes(data));

            height = data.length*(levelHeight+levelPadding);
            svgMainContainer.attr("height",height);
  

            // Ajusta parametros y funciones que dependen de las actuales dimensiones del contenedor
            xScale.range([0,width])


            var levels = svgContainer.selectAll(".level")
              .data(layout.nodes(data));

            var newLevels = levels.enter()
              .append("g")
              .attr("class","level")

            levels.exit()
              .remove

            // Agrega elemento de texto para cada nuevo nivel
            newLevels
              .append("text")

            // Posiciona el gráfico
            levels
              .transition()
              .attr("class", "level")
              .attr("transform", function(d,i) {
                return "translate("+xScale(d.x)+"," + ((i)*(levelHeight+levelPadding)) + ")";
              })

            levels.select("text")
              .transition()
              .attr("x", function(d) {return xScale(d.dx/2)})
              .attr("y", levelHeight)
              .attr("dy", "1em")
              .attr("text-anchor", "middle")
              .text(function(d) {
                return d.name;
                //return d.name+ " ("+d.size+" profesores)"
              })

            var blocks = levels.selectAll(".block")
              .data(function(d) {return d.blocks})

            blocks.enter()
              .append("rect")
              .attr("class", "block")
              .attr("fill", function(d) {
                return colorScale(d.id);
              })
              .on("mouseenter", function(d) {
                dataPointTooltip.show(d);
              })
              .on("mouseleave", function() {
                dataPointTooltip.hide();
              });

            blocks.exit()
              .remove()

            blocks
              .transition()
              .attr("x", function(d) {
                // Atributo x tiene un valor de 0 a 1 dependiendo de tamaño relativo  la barra mayor
                return xScale(d.x);
              })
              .attr("width", function(d) {
                // Atributo dx tiene un valor de 0 a 1 dependiendo de tamaño relativo  la barra mayor
                return xScale(d.dx);
              })
              .attr("height", levelHeight)

            /*
            blocks  
              .append("title")
              .text(function(d) {return d.desc})
              */
 
          } //end if
          
        };


        scope.$watch("data", function () {
          render(scope.data);
        });      

        scope.$watch("hiddenNodes", function () {
          render(scope.data);
        });      

        scope.$watch("selectedItem", function () {
          //highlight();
        });   



        scope.getElementDimensions = function () {
          return { 'h': element.height(), 'w': element.width() };
        };

        scope.$watch(scope.getElementDimensions, function (newValue, oldValue) {
          resizeSvg();
        }, true);

        angular.element($window).bind('resize', function () {
          scope.$apply();
        });
 
      }
      
      
    };
  }]);


angular.module("tide-angular")
.service(
  "tdLevelPiramidLayout",["_", "d3",function (_, d3) {

    var layout = {};

    layout.nodes = function(data) {
      var nodes = []
      var maxSize = maxLevelSize(data);

      _.each(data, function(level,i) {
        level.size =  _.reduce(level.blocks, function(memo,d) {
          return memo + (+d.size);
        },0)
        level.level = i;
        level.dx = level.size / maxSize;
        level.x = (1-level.dx) / 2;

        var nextBlockX = 0;
        _.each(level.blocks, function(block) {
          block.x = nextBlockX;
          block.dx = block.size/maxSize
          nextBlockX = nextBlockX + block.dx;
        })

      })

      return data;
    };

    var maxLevelSize = function(data) {
      var maxSize = 0;

      _.each(data, function(level) {
        var levelSize = _.reduce(level.blocks, function(memo,d) {
          return memo + (+d.size);
        },0)
        maxSize = levelSize > maxSize ? levelSize : maxSize;
      })

      return maxSize;
    }


    layout.height = function(_) {
        if (!arguments.length) return height;
        height = _;
        return layout;
    };


    return layout

}]);

