
"use strict";
/* jshint undef: true, unused: true */
/* global angular */

/**
 * @ngdoc overview
 * @name tide-angular
 * @description
 * Data visualization tools from TIDE SA
 *
 * Expects data record with the form
 *
 * [
 *   {
 *     left: [
 *       {size: 200, color:"red"},
 *       {size: 300, color:"purple"}
 *     ],
 *     right: [
 *       {size: 100, color:"yellow"},
 *       {size: 150, color:"green"}
 *     ]
 *   }
 * ] 
 *
 */
angular.module("tide-angular")
.directive("tdPercentileBar3",["$compile","_", "d3", "toolTip", "$window","$location", "tdPercentileBarLayout",function ($compile,_, d3, tooltip, $window, $location, layout) {
 return {
  restrict: "A",
      //transclude: false,
      //template: "<div style='background-color:red' ng-transclude></div>",
      scope: {
        data: "=tdData",
        leftCategories: "=tdLeftCategories",
        rightCategories: "=tdRightCategories",
        tooltipMessage: "=tdTooltipMessage",
        indicator: "=?tdIndicator",
        indicatorLeftMessage: "=?tdIndicatorLeftMessage",
        indicatorRigthMessage: "=?tdIndicatorRigthMessage",
        idAttribute: "=?tdIdAttribute",
        labelAttribute: "=?tdLabelAttribute",
        blockHeight : "=?tdBlockeight",
        blockLeftMargin : "=?tdBlockLeftMargin",
        blockPadding : "=?tdBlockPadding",
        highlightedItem : "=?tdHighlightedItem",
      },
      
      link: function (scope, element, attrs) {

        var margin = {};
        margin.left = scope.options && scope.options.margin && scope.options.margin.left ? scope.options.margin.left : 5;
        margin.right = 40;
        margin.top = 1;
        margin.bottom = 1;

        var width = element.width()-margin.left-margin.right;
        var height = scope.height ? scope.height : 20;
        var blockHeight = scope.blockHeight ? scope.blockHeight : 20;
        var blockLeftMargin = scope.blockLeftMargin ? scope.blockLeftMargin : width/2;
        var blockPadding = scope.blockPadding ? scope.blockPadding : 2;

        var idAttribute = scope.idAttribute ? scope.idAttribute : "id";
        var labelAttribute = scope.labelAttribute ? scope.labelAttribute : "label";
        var indicatorLeftMessage = scope.indicatorLeftMessage ? scope.indicatorLeftMessage : "Bajo";
        var indicatorRigthMessage = scope.indicatorRigthMessage ? scope.indicatorRigthMessage : "Alto";

        var highlightedItem = scope.highlightedItem ? scope.highlightedItem : null;
 

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



        var xWidthScale = d3.scale.linear()
          .domain([0,1])
          .range([0,(width-blockLeftMargin)/2])

        var xPosScale = d3.scale.linear()
          .domain([-1,1])
          .range([0,width-blockLeftMargin])

        var resizeSvg = function() {
          width = element.width()-margin.left-margin.right;
          svgMainContainer.attr("width",element.width())
          blockLeftMargin = scope.blockLeftMargin ? scope.blockLeftMargin : width/2;
          xWidthScale = d3.scale.linear()
            .domain([0,1])
            .range([0,(width-blockLeftMargin)/2])
          xPosScale = d3.scale.linear()
            .domain([-1,1])
            .range([0,width-blockLeftMargin])

        }

        var svgComunasContainer = svgContainer
          .append("g")
  

        var svgIndicator = svgContainer
          .append("g")
          .attr("class", "indicator")
          .attr("transform", function(d,i) {
            return "translate("+blockLeftMargin+","+ 0 + ")"
          })

        var indicatorline = svgIndicator
              .append("line")
              .attr("x1",xPosScale(0))
              .attr("x2",xPosScale(0))
              .attr("y1",0)
              .attr("y2",blockHeight*20)
              .attr("stroke-width", 2)
              .attr("stroke", "grey");

//<text x="20" y="20" font-family="sans-serif" font-size="20px" fill="red">Hello!</text>
        var rigtText = svgIndicator
              .append("text")
              .attr("dy", "-.35em")
              .attr("dx", ".35em")
              .attr("x",xPosScale(0))
              .attr("y",blockHeight)
              .text(indicatorRigthMessage)
              .attr("text-anchor", "start")
              .attr("fill","grey")

        var leftText = svgIndicator
              .append("text")
              .attr("dy", "-.35em")
              .attr("dx", "-.35em")
              .attr("x",xPosScale(0))
              .attr("y",blockHeight)
              .text(indicatorLeftMessage)
              .attr("text-anchor", "end")
              .attr("fill","grey")

        var round = d3.format(".0f");
        var percentaje = d3.format(".1%");



        var render = function(data) {

          /*
          data es un arreglo con objetos del tipo 
            {
              left: [
                {size: 200, color:"red"},
                {size: 300, color:"purple"}
              ],
              right: [
                {size: 100, color:"yellow"},
                {size: 150, color:"green"}
              ]
            }
          */

          if (data) {

            var nodes = layout.nodes(data);

            // Actualiza altura de elemento svg para hacerlo compatible con cantidad de datos
            svgMainContainer
              .attr("height", (nodes.length+1)*(blockHeight+blockPadding))


            svgIndicator
              .attr("transform", function(d,i) {
                return "translate("+blockLeftMargin+","+ 0 + ")"
              })

            // Actualiza altura de línea divisora entre sector izuierdo y derecho
            indicatorline
              .transition()
              .attr("y2", (data.length+1)*(blockHeight+blockPadding))
              .attr("x1",xPosScale(0))
              .attr("x2",xPosScale(0))

            rigtText
              .attr("x",xPosScale(0))


            leftText
                .attr("x",xPosScale(0))


            // Actualiza contenedores para cada comuna (".comunas")
            var comunas = svgComunasContainer.selectAll(".comunas")
              .data(nodes, function(d) {return d[idAttribute]})

            comunas.exit()
              .remove()

            var newComunas = comunas.enter()
              .append("g")
              .attr("class","comunas")


            // Crea nuevos contenedores para el nombre de la comuna
            newComunas
              .append("g")
              .attr("class", "nameCell")
              .append("text")
              .attr("x",0)
              .attr("y", blockHeight)
              .attr("text-anchor", "start")
              .style("cursor", function(d) {
                if (d.url) {
                  return "pointer";
                } else {
                  return null;
                }
              })
              .on("click", function(d) {
                if (d.url) {
                  scope.$apply(function() {
                    $location.path(d.url);
                  })
                }
              })

            // Crea nuevos contenedores para los bloques/graficos de cada comuna
            newComunas
              .append("g")
              .attr("class", "blockCell")
              .attr("transform", function(d,i) {
                return "translate("+blockLeftMargin+","+ 0 + ")"
              }) 
              
            // Ajusta posición de todos los contenedores de bloques (en caso de cambio de tamaño de ventana)
            comunas.select(".blockCell")
              .attr("transform", function(d,i) {
                return "translate("+blockLeftMargin+","+ 0 + ")"
              }) 

            // Agrega rectangulo de fondo en el gráfico
            newComunas.select(".blockCell")
              .append("rect")
              .attr("x", 0)
              .attr("width", width-blockLeftMargin)
              .attr("height", blockHeight)
              .attr("fill", "white")
              .attr("fill-opacity",0.9)


            // Agrega texto para porcentaje al costado derecho
            newComunas.select(".blockCell")
              .append("text")
              .attr("class", "blockTextRigth")
              .attr("dy", "-.35em")
              .attr("dx", ".35em")
              .attr("x",width-blockLeftMargin+margin.right)
              .attr("y",blockHeight)
              .attr("text-anchor", "end")
              .attr("fill", function(d) {
                if (highlightedItem == d.id) {
                  return "blue"
                } else {
                  return "grey"
                }
              });
            // Actualiza posición de texto en todos los bloques
            comunas.select(".blockTextRigth")
              .attr("x",width-blockLeftMargin+margin.right)


            // Agrega texto para porcentaje al costado derecho
            newComunas.select(".blockCell")
              .append("text")
              .attr("class", "blockTextLeft")
              .attr("dy", "-.35em")
              .attr("dx", ".35em")
              .attr("x",0)
              .attr("y",blockHeight)
              .attr("text-anchor", "start")
              .attr("fill", function(d) {
                if (highlightedItem == d.id) {
                  return "blue"
                } else {
                  return "grey"
                }
              });

            // Actualiza el nombre de las comunas
            comunas.select(".nameCell").select("text")
              .text(function(d) { return d[labelAttribute]})
              .attr("dy", "-0.35em")
              .attr("fill", function(d) {
                if (highlightedItem == d.id) {
                  return "blue"
                } else {
                  return "black"
                }
              });

            // Actualiza posición de las comunas
            comunas
              .transition()
              .duration(500)
              .attr("transform", function(d,i) {
                return "translate("+0+","+ ((blockHeight+blockPadding)*(i+1)) + ")"
              }) 

              // Agrega indicador de porcentaje al extremo derecho
            comunas.select(".blockCell").select(".blockTextRigth")
            .text(function(d) {
                return percentaje(d.rightPercentage)
            })

            // Agrega indicador de porcentaje al extremo derecho
            comunas.select(".blockCell").select(".blockTextLeft")
            .text(function(d) {
                return percentaje(d.leftPercentage)
            })

            // Crea bloques con datos a
            var blocks = comunas.select(".blockCell").selectAll(".blocks")
              .data(function(d) {return _.union(d.left, d.right)})

            blocks.enter()
              .append("rect")
              .attr("class","blocks")
              .attr("height", height)
              .attr("fill", function(d) {return d.color})
              .attr("fill-opacity",0.9)
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
              .duration(1000)
              .attr("width", function(d) {
                return xWidthScale(d.dx)
              })
              .attr("x", function(d) {
                return xPosScale(d.x)
              })
 
          } //end if
          
        };

        scope.$watch("data", function () {
          render(scope.data);
        });      


        scope.getElementDimensions = function () {
          return { 'h': element.height(), 'w': element.width() };
        };

        scope.$watch(scope.getElementDimensions, function (newValue, oldValue) {
          resizeSvg();
          render(scope.data);
        }, true);

        angular.element($window).bind('resize', function () {
          scope.$apply();
        });
 
      }
      
      
    };
  }]);

angular.module("tide-angular")
.service(
  "tdPercentileBarLayout",["_", "d3",function (_, d3) {

    var layout = {};
    var scale = d3.scale.ordinal();


    layout.nodes = function(data) {
      var nodes = [];

      _.each(data, function(item) {

        var sizeLeft = _.reduce(item.left, function(memo,d) {
          return memo + (+d.size);
        },0);

        var sizeRight = _.reduce(item.right, function(memo,d) {
          return memo + (+d.size);
        },0)

        var sizeTotal = sizeLeft + sizeRight;

        var previousX = 0;

        item.leftPercentage = sizeLeft/sizeTotal;
        item.rightPercentage = sizeRight/sizeTotal;


        // Position left side nodes
        _.each(item.left, function(d) {
          var dx = d.size/sizeTotal;
          var x = previousX - dx;
          previousX = x;

          d.dx = dx;
          d.x = x;
        })

        // Position right side nodes
        previousX = 0
        _.each(item.right, function(d) {
          var dx = d.size/sizeTotal;
          var x = previousX;
          previousX = x+dx;
          
          d.dx = dx;
          d.x = x;
          nodes.push(d)
        })

      })

      return _.sortBy(data, function(d) {return d.leftPercentage});
    };

    layout.height = function(_) {
        if (!arguments.length) return height;
        height = _;
        return layout;
    };

    return layout

}]);

