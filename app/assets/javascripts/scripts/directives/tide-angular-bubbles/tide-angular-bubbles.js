
"use strict";
/* jshint undef: true, unused: true */
/* global angular */

/**
 * @ngdoc overview
 * @name tide-angular
 * @description
 * Data visualization tools from TIDE SA
 *
 *
 */
angular.module("tide-angular")
.directive("tdBubbles",["$compile","_", "d3", "toolTip", "$window","$location", "tdPercentileBarLayout",function ($compile,_, d3, tooltip, $window, $location, layout) {
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
        sizeAttribute: "=?tdSizeAtribute",
        labelAttribute: "=?tdLabelAttribute",
        blockHeight : "=?tdBlockeight",
        blockLeftMargin : "=?tdBlockLeftMargin",
        blockPadding : "=?tdBlockPadding",
        highlightedItem : "=?tdHighlightedItem",
        maxSize : "=?tdMaxSize", // Max size (value) for bubbles
        minSize : "=?tdMinSize", // Min size (value) for bubbles
        highlightText : "=?tdHighlightText", 
        highLightSearchAttribute : "=?tdHighLightSearchAttribute", 
        alpha : "=?tdAlpha", 
        color : "=?tdColor"
      },
      
      link: function (scope, element, attrs) {

        var margin = {};
        margin.left = scope.options && scope.options.margin && scope.options.margin.left ? scope.options.margin.left : 5;
        margin.right = 40;
        margin.top = 1;
        margin.bottom = 1;

        var width = element.width()-margin.left-margin.right;
        var height = scope.height ? scope.height : 400;

        var idAttribute = scope.idAttribute ? scope.idAttribute : "MateriaCodigo"
        var sizeAttribute = scope.sizeAttribute ? scope.sizeAttribute : "totalProfesores"
        var highLightSearchAttribute = scope.highLightSearchAttribute ? scope.highLightSearchAttribute : "MateriaDescripcion" 

        var colorScale = d3.scale.category10();

        var fillColor = scope.color ? scope.color : "#0000CD";

        // Define dataPoints tooltip generator
        var dataPointTooltip = tooltip();
        if (scope.tooltipMessage) {
          dataPointTooltip.message(scope.tooltipMessage);
        } else {
          dataPointTooltip.message(function(d) {
            var msg = d.MateriaDescripcion;

            var porcentajeCompatible = Math.floor(10*d.conTituloYFormacionCompatible/d.totalProfesores)*10;

            msg += "<br>"+porcentajeCompatible+"%";
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
          svgMainContainer.attr("width",element.width())
 
        }

        var force = d3.layout.force()
                .gravity(0.05)
                .charge(-3);

        var render = function(data) {


          if (data) {
            var highlightText = scope.highlightText ? scope.highlightText : null 


            var maxSize = scope.maxSize ? +scope.maxSize : d3.max(data, function(d) {return +d[sizeAttribute]})
            var minSize = scope.minSize ? +scope.minSize : d3.min(data, function(d) {return +d[sizeAttribute]})

            var radioScale = d3.scale.sqrt()
              .domain([minSize, maxSize])
              .range([2,30]);

            var defs = svgMainContainer.append("defs")

            var grad = defs.append("linearGradient").attr("id", "gradMaster")
                .attr("x1", "0%").attr("x2", "0%").attr("y1", "100%").attr("y2", "0%");
            grad.append("stop").attr("offset", "90%").style("stop-color", fillColor);
            grad.append("stop").attr("offset", "90%").style("stop-color", "white");

            var grad50 = defs.append("linearGradient").attr("id", "grad50")
                .attr("x1", "0%").attr("x2", "0%").attr("y1", "100%").attr("y2", "0%")
                .call(
                  function(gradient) {
                    gradient.append("stop").attr("offset", "50%").style("stop-color", fillColor);
                    gradient.append("stop").attr("offset", "50%").style("stop-color", "white");
                  });

            var grad90 = defs.append("linearGradient").attr("id", "grad90")
                .attr("x1", "0%").attr("x2", "0%").attr("y1", "100%").attr("y2", "0%")
                .call(
                  function(gradient) {
                    gradient.append("stop").attr("offset", "90%").style("stop-color", fillColor);
                    gradient.append("stop").attr("offset", "90%").style("stop-color", "white");
                  });

            var gradData = [0,10,20,30,40,50,60,70,80,90,100];
 
            defs.selectAll('.gradient').data(gradData)
              .enter().append('svg:linearGradient')
              .attr('id', function(d, i) { return 'gradient' + d; })
              .attr('class', 'gradient')
              .attr('xlink:href', '#gradMaster')
              .call(
                  function(gradient) {
                    gradient.append("stop").attr("offset", function(d) {return d+"%"}).style("stop-color", fillColor);
                    gradient.append("stop").attr("offset", function(d) {return d+"%"}).style("stop-color", "white");
                  });


            var nodes = data;


            // Actualiza posición de los nuevos nodos en base a posición de actuales burbujas para el mismo key
            var actualesNodos = _.indexBy(svgContainer.selectAll(".bubble").data(), function(d) {
              return d[idAttribute];
            })

            _.each(nodes, function(d) {
              d.radius = radioScale(d.totalProfesores);
              d.x = actualesNodos[d[idAttribute]] ? actualesNodos[d[idAttribute]].x : null
              d.y = actualesNodos[d[idAttribute]] ? actualesNodos[d[idAttribute]].y : null
              d.px = actualesNodos[d[idAttribute]] ? actualesNodos[d[idAttribute]].px : null
              d.py = actualesNodos[d[idAttribute]] ? actualesNodos[d[idAttribute]].py : null
            })

            force 
                .nodes(nodes)
                .size([width, height]);

            var bubbles = svgContainer.selectAll(".bubble")
              .data(nodes, function(d) {return d[idAttribute]});

            bubbles.exit()
              .transition()
              .duration(1000)
              .attr("r", function(d) {return 0})
              .attr("cx", function(d,i) {return -1000})
              .attr("cy", function(d,i) {return -0})
              .remove()

            bubbles.enter()
              .append("circle")
              .attr("class", "bubble")
              .attr("r", function(d) {
                return radioScale(d[sizeAttribute]);
              })
              .attr("cx", function(d,i) {return d.x})
              .attr("cy", function(d,i) {return d.y})
              .attr("stroke", "grey")
              .attr("fill", function(d,i) {
                var porcentajeCompatible = Math.floor(10*d.conTituloYFormacionCompatible/d.totalProfesores)*10;
                return "url(#gradient"+porcentajeCompatible+")"
              })
              .on("mouseenter", function(d) {
                dataPointTooltip.show(d);
              })
              .on("mouseleave", function() {
                dataPointTooltip.hide();
              })
              .call(force.drag);         

            bubbles
              .attr("fill", function(d,i) {
                var porcentajeCompatible = Math.floor(10*d.conTituloYFormacionCompatible/d.totalProfesores)*10;
                return "url(#gradient"+porcentajeCompatible+")"
              })  
              .transition()
              .attr("stroke", function(d) {
                return (highlightText && d[highLightSearchAttribute] && d[highLightSearchAttribute].toLowerCase().indexOf(highlightText.toLowerCase()) >=0) ? "red" : "grey";
              })
              .attr("stroke-width", function(d) {
                return (highlightText && d[highLightSearchAttribute] && d[highLightSearchAttribute].toLowerCase().indexOf(highlightText.toLowerCase()) >=0) ? 2 : 1;
              })
              .duration(1000)
              .attr("r", function(d) {
                return radioScale(d[sizeAttribute]);
              })

            highlight();

            force.start();

            force.on("tick", function(e) {
              var q = d3.geom.quadtree(nodes),
                  i,
                  d,
                  n = nodes.length;

              for (i = 0; i < n; ++i) q.visit(collide(nodes[i]));
             
              if (e.alpha < 0.02) {force.alpha(0)}

              scope.$apply(function() {
                //scope.alpha = e.alpha; 
              })
              

              bubbles
                .attr("cx", function(d) {return d.x})
                .attr("cy", function(d) {return d.y})


            });

            var collide = function(node) {
              var r = node.radius + 16,
                  nx1 = node.x - r,
                  nx2 = node.x + r,
                  ny1 = node.y - r,
                  ny2 = node.y + r;
              return function(quad, x1, y1, x2, y2) {
                if (quad.point && (quad.point !== node)) {
                  var x = node.x - quad.point.x,
                      y = node.y - quad.point.y,
                      l = Math.sqrt(x * x + y * y),
                      r = node.radius + quad.point.radius;
                  if (l < r) {
                    l = (l - r) / l * .5;
                    node.x -= x *= l;
                    node.y -= y *= l;
                    quad.point.x += x;
                    quad.point.y += y;
                  }
                }
                return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1;
              };
            }



 
          } //end if
          
        };

        var highlight = function() {
          var highlightText = scope.highlightText ? scope.highlightText : null 

            svgContainer.selectAll(".bubble")
              .attr("stroke", function(d) {
                return (highlightText && d[highLightSearchAttribute] && d[highLightSearchAttribute].toLowerCase().indexOf(highlightText.toLowerCase()) >=0) ? "red" : "grey";
              })
              .attr("stroke-width", function(d) {
                return (highlightText && d[highLightSearchAttribute] && d[highLightSearchAttribute].toLowerCase().indexOf(highlightText.toLowerCase()) >=0) ? 2 : 1;
              })

        }

        scope.$watch("data", function () {
          render(scope.data);
        });      

        scope.$watch("highlightText", function () {
          highlight();
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

