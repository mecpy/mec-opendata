
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
var tideElements = angular.module("tide-angular", []);


tideElements.directive("tdColorLegend2",["_", "d3",function (_, d3) {
 return {
  restrict: "A",
      //transclude: false,
      //template: "<div style='background-color:red' ng-transclude></div>",
      scope: {
        colorAttribute: "=tdColorAttribute",
        data: "=tdData",
      },
      
    link: function (scope, element, attrs) {
        var legendPlaceHolder = d3.select(element[0])
              .append("div")
              .attr("class", "row");

        var width = 200

        var render = function() {
          var colorScale = d3.scale.category10();

          // Asign colors according to alphabetical order to avoid inconsistency
          if (scope.colorAttribute) {
            var colorDomain = _.keys(_.groupBy(scope.data, function(d) {return d[scope.colorAttribute]})).sort();
            colorScale.domain(colorDomain);
          }

          //Remover Leyenda
          legendPlaceHolder.selectAll("div").remove();


          var legends = legendPlaceHolder.selectAll(".legends")
              .data(colorDomain)
              .enter()
                .append("div")
                .attr("class", "legends col-md-2")

          legends.append("div")
              .style("background", function(d) {return colorScale(d)})
              .style("width", "10px").style("height", "10px")
              .style("float", "left")
              .style("margin", "3px")


          legends.append("div")
              .text(function(d) {return d}) 
          }

          //render();
          scope.$watch("data", function (newVal, oldVal) {
            if (newVal) {
            }
            render();
          });   

          scope.$watch("colorAttribute", function (newVal, oldVal) {
            if (newVal) {
            }
            render();
          }); 
        
      }
    };
  }]);






/**
 * @ngdoc directive
 * @name tide-angular.directive:tdXyChart
 * @requires underscore._
 * @requires d3service.d3
 * @requires tideLayoutXY
 * @requires linearRegression
 * @requires toolTip
 * @element div
 * 
 * @param {array} tdData Data array used for populating the chart
 * @param {string} tdXattribute Name of the attribute used for the X values in data objects
 * @param {string} tdYattribute Name of the attribute used for the Y values in data objects
 * @param {string} tdIdAttribute Name of the attribute used for the ID of unique entities in teh data set
 * @param {string} tdSizeAttribute Name of the attribute used for defining the size of the bubbles
 * @param {string} tdColorAttribute Name of the attribute used to define the color categories in the chart
 * @param {boolean=} tdSqrScaleX Indicates if shoudl display x axis using a sqr scale
 * @param {function=} tdTooltipMessage Function that should return a text to be displayed in the tooltip, given a data element
 * @param {int=} tdWidth Chart widht (and height)
 * @param {boolean=} tdTrendline Wether a trendline is displayed in the graph (linear regression)
 * @param {int=} tdMaxSize Maximum size of the bubbles (defaults to 5)
 * @param {int=} tdMinSize Minimun size of the bubbles (defaults to 1)
 * @param {array=} tdColorLegend Array that returns the color codes used in the legend each element is an array ["category", "color"]
 * @param {object=} tdSelected Object with the data element of the selected point in the chart
 * @param {object=} tdOptions Options for chart configuration (i.e. options.margin.left)
 * @description
 *
 * Generates a scatered XY Chart
 *
 */
angular.module("tide-angular")
.directive("tdXyChart",["$compile","_", "d3","tideLayoutXY","linearRegression", "toolTip",function ($compile,_, d3, layout, regression, tooltip) {
 return {
  restrict: "A",
      //transclude: false,
      //template: "<div style='background-color:red' ng-transclude></div>",
      scope: {
        data: "=tdData",
        xAttribute: "=tdXattribute",
        yAttribute: "=tdYattribute",
        idAttribute: "=?tdIdAttribute",
        sqrScaleX: "=?tdSqrScaleX",
        tooltipMessage: "=?tdTooltipMessage",
        highlight: "=tdHighlight",

        width: "=?tdWidth",
        trendline : "=?tdTrendline",

        // Bubble size
        maxSize : "=?tdMaxSize",
        minSize : "=?tdMinSize",
        sizeAttribute: "=?tdSizeAttribute",

        // Bubble color
        colorAttribute: "=?tdColorAttribute",
        colorLegend : "=?tdColorLegend",

        selected: "=?tdSelected",

        options : "=?tdOptions",

        // Indicates wether the chart is being drawn  
        drawing : "=?tdDrawing",

        excludeZeroX : "=?tdExcludeZeroX"
      },
      
      link: function (scope, element, attrs) {
        var width = scope.width ? scope.width : 300;
        var height = scope.width ? scope.width : 300;
        var margin = {};
        margin.left = scope.options && scope.options.margin && scope.options.margin.left ? scope.options.margin.left : 50;
        margin.right = 20;
        margin.top = 20;
        margin.bottom = 20;

        // Default: not drawing
        scope.drawing = false;


        // Setup scope default values if not assigned
        scope.idAttribute = scope.idAttribute ? scope.idAttribute : "id";

        // Define dataPoints tooltip generator
        var dataPointTooltip = tooltip();
        if (scope.tooltipMessage) {
          dataPointTooltip.message(scope.tooltipMessage);
        } else {
          dataPointTooltip.message(function(d) {
            var msg = scope.xAttribute + " : " + d[scope.xAttribute];
            msg += "<br>" + scope.yAttribute +  " : " + d[scope.yAttribute];

            return  msg;
          });
        }


        // Define trendLine tooltip generator
        var trendlineTooltip = tooltip();
        trendlineTooltip.message(function(d) {
          var formatDecimal = d3.format(".2f");
          var formatDecimal4 = d3.format(".4f");

          var slopeMsg = d.slope > 0.01 ? formatDecimal(d.slope) : formatDecimal4(d.slope);
          var interceptMsg = d.intercept > 0.01 ? formatDecimal(d.intercept) : formatDecimal4(d.intercept);

          var msg = "y = "+slopeMsg+"*X +"+interceptMsg+"<br>";
          msg += "R2: "+formatDecimal(d.r2*100)+"%<br>";

          return  msg;
        });


        var svgContainer = d3.select(element[0])
          .append("svg")
          .attr("width", width+margin.left+margin.right)
          .attr("height", height+margin.top+margin.bottom)
          .append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

        var svgXAxis = svgContainer.append("g")
        .attr("class", "x axis")
        .attr("transform","translate(0," + height + ")")
        .attr("stroke-width", "1.5px")
        ;
        var svgYAxis = svgContainer.append("g")
        .attr("class", "y axis");


        var svgXAxisText = svgXAxis
        .append("text")
        .attr("class", "label")
        .attr("x", width )
        .attr("y", -6)
        .style("text-anchor", "end")
        .text(scope.xAttribute);

        var svgYAxisText = svgYAxis
        .append("text")
        .attr("class", "label")
        .attr("transform", "rotate(-90)")
        .attr("y", -margin.left)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text(scope.yAttribute);

        var trendLine = svgContainer.select(".trendline");

        var circles = svgContainer.selectAll("circle");


        var render = function(data) {
          if (data) {
            data = _.filter(data, function(d,i) {
              var accepted = true;

              if (scope.excludeZeroX) {
                accepted = accepted && (+d[scope.xAttribute] > 0);
              }
              return accepted;
            });

            if (data.length) {scope.drawing = true;}
            
            scope.maxSize = scope.maxSize ? scope.maxSize : 5;
            scope.minSize = scope.minSize ? scope.minSize : 1;

            // sizeScale - defines the size fo each bubble
            var sizeScale=d3.scale.linear().range([scope.minSize, scope.maxSize]);
            if (scope.sizeAttribute) {
              sizeScale.domain(d3.extent(data, function(d) {return +d[scope.sizeAttribute];}));
            } else {
              sizeScale.domain([1,1]).range([scope.maxSize, scope.maxSize]);
            }            

            layout
            .size([width, height])
            .xAttribute(scope.xAttribute)
            .yAttribute(scope.yAttribute)
            .sizeAttribute(scope.sizeAttribute)
            .useLog(scope.sqrScaleX)
            .sizeScale(sizeScale);


            var nodes = layout.nodes(data);

            //var xAxis = d3.svg.axis().scale(layout.xScale()).ticks(7).tickFormat(d3.format("d")).tickSubdivide(0);
            //var yAxis = d3.svg.axis().scale(layout.yScale()).orient("left").ticks(7).tickFormat(d3.format("d")).tickSubdivide(0);



            var digitWidth = 25;
            var xMaxDigits = Math.ceil(Math.log(Math.abs(layout.xScale().domain()[1]))/Math.log(10));
            var yMaxDigits = Math.ceil(Math.log(Math.abs(layout.yScale().domain()[1]))/Math.log(10));
            var xlabelLength = digitWidth*xMaxDigits;
            var ylabelLength = digitWidth*yMaxDigits;

            var xNumberOfTicks = (layout.xScale().range()[1]-layout.xScale().range()[0])/xlabelLength;
            var yNumberOfTicks = (Math.abs(layout.yScale().range()[1]-layout.yScale().range()[0]))/ylabelLength;
 

            var xDomainRange = Math.abs(layout.xScale().domain()[1]-layout.xScale().domain()[0]);
            var yDomainRange = Math.abs(layout.yScale().domain()[1]-layout.yScale().domain()[0]);

            var xFormat = xDomainRange/xNumberOfTicks > 1 ? d3.format("d") : d3.format(".1f");
            var yFormat = yDomainRange/yNumberOfTicks > 1 ? d3.format("d") : d3.format(".1f");


            var xAxis = d3.svg.axis().scale(layout.xScale()).ticks(xNumberOfTicks).tickFormat(xFormat).tickSubdivide(0);
            var yAxis = d3.svg.axis().scale(layout.yScale()).orient("left").ticks(yNumberOfTicks).tickFormat(yFormat).tickSubdivide(0);
            var colorScale = d3.scale.category10();

            // Information sent back with color legen data [{key:keyName, color:colorCode, n:numberOfRecords}, ...]
            scope.colorLegend = [];

            // Asign colors according to alphabetical order to avoid inconsistency
            if (scope.colorAttribute) {
              var groupsByColorAttribute = _.groupBy(data, function(d) {return d[scope.colorAttribute]});

              var colorDomain = _.keys(groupsByColorAttribute).sort();
              colorScale.domain(colorDomain);

              _.each(colorDomain, function(d) {
                scope.colorLegend.push({key:d, color:colorScale(d), n:groupsByColorAttribute[d].length});
              })
            }




            svgXAxis    
              .call(xAxis);

            svgXAxis.selectAll("path, line")
              .attr("fill","none")
              .attr("stroke", "black");

            svgYAxis
            .call(yAxis);

            svgYAxis.selectAll("path, line")
              .attr("fill","none")
              .attr("stroke", "black");

            circles = svgContainer.selectAll("circle")
            .data(nodes, function(d) {return d[scope.idAttribute];});

            circles.exit()
              .transition()
              .attr("r",0)
              .attr("cx",0)
              .attr("cy", height)
              .remove();

            circles.enter()
              .append("circle")
              .attr("cx", function(d) {
                return 0;
              })
              .attr("cy", function(d) {
                return height;
              })
              .attr("r", function(d) {
                return 0
              })              
              .attr("opacity", 0.8)
              .on("click", function(d) {
                if ((!scope.selected) || ((scope.selected[scope.idAttribute]) && (d[scope.idAttribute] != scope.selected[scope.idAttribute]))) {
                  // Select the node - save in the scope 
                  scope.$apply(function(){
                    scope.selected = d;
                  });
                } else {
                  // Unselect the node 
                  scope.$apply(function(){
                    scope.selected = null;
                  });
                }

              })              
              .on("mouseenter", function(d) {
                dataPointTooltip.show(d);
              })
              .on("mouseleave", function() {
                dataPointTooltip.hide();
              });

            circles
            .sort(function(a, b) {return scope.selected && a[scope.idAttribute] == scope.selected[scope.idAttribute]? 1 : scope.selected && b[scope.idAttribute] == scope.selected[scope.idAttribute] ? -1 : 0})
            .transition()
            .duration(0)
            .attr("cx", function(d) {
              return d.x;
            })
            .attr("cy", function(d) {
              return d.y;
            })
            .attr("r", function(d) {
              return  scope.selected && (d[scope.idAttribute] == scope.selected[scope.idAttribute]) ? 2*d.r : d.r
            })
            .attr("stroke-width", function(d) {
              return scope.selected && (d[scope.idAttribute] == scope.selected[scope.idAttribute])? 2 : 1;
            })
            .attr("fill", function(d) {
              return colorScale(d[scope.colorAttribute])
            })
            .attr("stroke", function(d) { return d3.rgb(colorScale(d[scope.colorAttribute])).darker(2); })
            .each("end", function() {
              scope.drawing = false;
              scope.$apply();
            })       

            svgXAxisText
              .text(scope.xAttribute);

            svgYAxisText
              .text(scope.yAttribute);

            // Trend Line - Linear Regression
            var datapoints = _.map(nodes, function(d) {return [+d[scope.xAttribute], +d[scope.yAttribute]];});
            var regObject = regression(datapoints);


           var line = d3.svg.line()
                .interpolate("basis");


          //Redraw trendline to place it on top of datapoints
          trendLine.remove();

          if (scope.trendline) {
            trendLine = svgContainer
              .append("path")
                .datum(regObject)
                .attr("class", "trendLine")
                .attr("stroke", "red")
                .attr("stroke-width", 4)
                .attr("fill", "none")
                .attr("opacity", 0.8)

                .attr("d", function(d) {
                  var trendlinePoints = _.map(d.points, function(d) {return [layout.xScale()(d[0]), layout.yScale()(d[1])];});
                  trendlinePoints = _.sortBy(trendlinePoints, function(d) {return d[0];});
                  return line(trendlinePoints);
                })
                .on("mouseenter", function(d) {
                  trendlineTooltip.show(d);
                })
                .on("mouseleave", function() {
                  trendlineTooltip.hide();
                });
          }

          }

          
        };

        scope.$watch("data", function () {
          render(scope.data);
        });      

        scope.$watch("sqrScaleX", function () {
          render(scope.data);
        });

        scope.$watch("selected", function () {
          render(scope.data);
        });

        scope.$watch("colorAttribute", function () {
          render(scope.data);
        });

        scope.$watch("excludeZeroX", function () {
          render(scope.data);
        });

        scope.$watch("xAttribute", function () {
          render(scope.data);
        });

        scope.$watch("yAttribute", function () {
          render(scope.data);
        });


      }
      
      
    };
  }]);


/**
* @ngdoc service
* @name tide-angular.tideLayoutXY
* @requires d3service.d3
* @requires underscore._
*
* @description
* Creates a layout (node array with position attributes) for building an XY bubble chart
*
*/
tideElements.service ("tideLayoutXY", ["d3","_", function(d3,_) {
  var xAttribute = null;
  var yAttribute = null;
  var sizeAttribute = null;
  var size = [200,200];
  var xScale = null;
  var yScale = null;
  var sizeScale = d3.scale.linear().domain([1,1]).range([2,2]);
  var useLog = false;

  /**
  * Calculates coordinates (x, dy, basey) for a group of area charts that can be stacked
  * each area chart is associated to a category in the data objects
  */
  /**
  * @ngdoc function
  * @name tide-angular.tideLayoutXY:nodes
  * @methodOf tide-angular.tideLayoutXY
  * @param {array} data Array with data objects 
  * @returns {arra} Array with layout nodes
  *
  * @description
  * Given an array of data objects, generates x & y coordinates and circle radious r for each of the nodes to be displayed in an XY chart. 
  */
  this.nodes = function(data) {

    var width = size[0];
    var height = size[1];

    if (true) {
      if (useLog) {
        xScale = d3.scale.pow().exponent(0.5).domain(d3.extent(data, function(d) {return +d[xAttribute];})).range([0,width]);
      } else {
        xScale = d3.scale.linear().domain(d3.extent(data, function(d) {return +d[xAttribute];})).range([0,width]);
      }
    }

    if (true) {
      yScale = d3.scale.linear().domain(d3.extent(data, function(d) {return +d[yAttribute];})).range([height,0]);
    }

    _.each(data, function(d) {
      d.x = xScale(d[xAttribute]);
      d.y = yScale(d[yAttribute]);
      d.r = sizeScale(d[sizeAttribute] ? d[sizeAttribute] : 1);
    }); 

    return data;
  };

  this.size = function(_) {
    if (!arguments.length) return size;
    size = _;
    return this;
  };
  // Consulta o modifica el atributa utilizado para la medida en el histograma
  this.xAttribute = function(_) {
    if(!arguments.length) return xAttribute;
    xAttribute = _;
    return this;
  };

  // Consulta o modifica el atributa utilizado para la categoría que agrupa distintos mantos
  this.yAttribute = function(_) {
    if(!arguments.length) return yAttribute;
    yAttribute = _;
    return this;
  };

  this.sizeAttribute = function(_) {
    if(!arguments.length) return sizeAttribute;
    sizeAttribute = _;
    return this;
  };


  // Gets or modifies xScale
  this.xScale = function(_) {
    if(!arguments.length) return xScale;
    xScale = _;
    return this;
  };

  // Gets or modifies yScale
  this.yScale = function(_) {
    if(!arguments.length) return yScale;
    yScale = _;
    return this;
  };

  // Gets or modifies yScale
  this.sizeScale = function(_) {
    if(!arguments.length) return sizeScale;
    sizeScale = _;
    return this;
  };

  // Gets or modifies flag for use of logaritmith scale in x axis
  this.useLog = function(_) {
    if(!arguments.length) return useLog;
    useLog = _;
    return this;
  };

  // Gets or sets size (r) for each node
  this.rSize = function(_) {
    if(!arguments.length) return rSize;
    rSize = _;
    return this;
  };


}]);




/**
* @ngdoc service
* @name tide-angular.linearRegression
* @requires underscore._
*
* @description
* Calculates linear regression parameters for a set of datapoints [[x1,y1], [x2,y2], ... [xn,yn]]
*
* Returns object {slope: slope, intercept:intercept, r2: r2, points:points}
*/
tideElements.factory("linearRegression", ["_",function(_) {
  // Calculates linear regresion on a set of data points: [[x1,y1], [x2,y2], ... [xn,yn]]
  // Returns object {slope: slope, intercept:intercept, r2: r2}

  var lr = function(data) {
    var sumX = 0;
    var sumY = 0;
    var sumX2 = 0;
    var sumY2 = 0;
    var sumXY = 0;
    var n = data.length;

    _.each(data, function(d) {
      sumX += d[0];
      sumY += d[1];
      sumX2 += d[0]*d[0];
      sumY2 += d[1]*d[1];
      sumXY += d[0]*d[1];
    });

    var slope = (n*sumXY-sumX*sumY)/(n*sumX2-sumX*sumX);
    var intercept = (sumY-slope*sumX)/n;
    var r2 = Math.pow((n*sumXY-sumX*sumY)/Math.sqrt((n*sumX2-sumX*sumX)*(n*sumY2-sumY*sumY)),2);
    var points = [];

    _.each(data, function(d) {
      var x = d[0];
      var y = d[0]*slope + intercept;
      points.push([x,y]);
    });


    return {"slope":slope, "intercept":intercept, "r2": r2, "points":points};
  };

  return lr;

}]);

/*
* toolTip
*/

/**
* @ngdoc service
* @name tide-angular.toolTip
* @requires d3service.d3
*
* @description
* Generates a tooltip element that will be shown at the mouse position
* It displays a message generated by message function, which can be overidden
* 
* Use:
* example.directive("myDirective",["toolTip",function (tooltip) {
*   var myTooltip = tooltip();
*   mytooTip.message(function(d) {
*     var msg = "Name: " + d.name;
*     return msg;
*   })
*
*   (...)
*   d3selection 
*     .on("mouseenter", function(d) {
*       mytooTip.show(d);
*     })
*     .on("mouseleave", function() {
*       mytooTip.hide();
*     });
*/
tideElements.factory("toolTip", ["d3",function(d3) {
  return function() {
      var tooltip = {};

      var message = function(d) {
        var id = d.id ? d.id : "noid";
        var msg = "<strong>ID: "+id +"</strong>";
        return msg;
      };


      tooltip.element = d3.select("body")
      .append("div")
      .attr("style", "background:#ffff99;width:350px;position:absolute;z-index:9999;border-radius: 8px;opacity:0.9;")
      .attr("class", "tooltipcontent")
      .style("visibility", "hidden");

      tooltip.content = tooltip.element
      .append("div")
      .attr("style", "padding:4px;");

      var tooltipPosition= function(mouseX, mouseY) {
        var windowH = window.innerHeight;
        var windowW = window.innerWidth;
        var scrollH = window.pageYOffset;
        var offsetV = window.document.body.offsetLeft;
        var tooltipH = tooltip.element[0][0].offsetHeight;
        var tooltipW = tooltip.element[0][0].offsetWidth;

        var posX = mouseX > (windowW-tooltipW-offsetV) ? windowW-tooltipW-offsetV : mouseX+10;

        var posY = 0;

        if ((mouseY+tooltipH-scrollH) < windowH) {
          posY = mouseY + 10;
        } else {
          posY = windowH-tooltipH+scrollH-10;
          posX = posX<(windowW-tooltipW-offsetV) ? posX : mouseX-tooltipW -10;
        }

        return {x:posX, y:posY};
      };

      tooltip.show = function(d) {
        var bodyLeft = document.body.getBoundingClientRect().left;

        var pos = {x:d3.event.pageX-bodyLeft, y:d3.event.pageY};

        var newpos = tooltipPosition(pos.x, pos.y);

        tooltip.element
        .style("top", newpos.y+"px")   
        .style("left", newpos.x+"px") 
        .style("visibility", "visible") 
        .html(message(d));      
      };

      tooltip.hide =  function() {
        tooltip.element
        .style("visibility", "hidden");
      };

    // Gets or modifies xScale
    tooltip.message = function(_) {
      if(!arguments.length) return message;
      message = _;
      return tooltip;
    };

    return tooltip;
  };

}]);

/**
 * @ngdoc overview
 * @name underscore
 * @description
 * Wraps underscore as an angular module
 * 
 * The underscore library must be loaded and _ available as a global
 *
 */
angular.module("underscore", [])
  /**
  * @ngdoc service
  * @name underscore._
  *
  * @description
  * underscore.js - _
  */
  .factory("_", function() {
    return window._; // assumes underscore has already been loaded on the page
});

/**
 * @ngdoc overview
 * @name d3service
 * @description
 * Wraps d3js as an angular module
 *
 * d3 Library must be loaded and d3 available as a global
 *
 */
angular.module("d3service", [])
  /**
  * @ngdoc service
  * @name d3service.d3
  *
  * @description
  * d3js - d3
  */
  .factory("d3", [function(){
    var d3;

    d3 = window.d3;
    return d3;
}]);
 
angular.module("tide-angular")
.directive("tdTooltip",["d3",function (_, d3, layout, regression, tooltip) {
 return {
  restrict: "AE",
      transclude: false,
      replace:true,
      template: "<div class='tooltipcontent' style='background:#ffff99;width:350px;position:absolute;z-index:9999;border-radius: 8px;opacity:0.9;'></div>",
      scope: {
        msg: "=tdMsg",
        visible: "=tdVisible",
        x: "=",
        y: "="
      },
      

      link: function (scope, element, attrs) {

        var content = angular.element("<div>");
        content.attr("stye", "padding:4px;");
        element.append(content);

        var tooltipPosition= function(mouseX, mouseY) {
          var windowH = window.innerHeight;
          var windowW = window.innerWidth;
          var scrollH = window.pageYOffset;
          var offsetV = window.document.body.offsetLeft;
          var tooltipH = element[0].offsetHeight;
          var tooltipW = element[0].offsetWidth;

          var posX = mouseX > (windowW-tooltipW-offsetV) ? windowW-tooltipW-offsetV : mouseX+10;

          var posY = 0;

          if ((mouseY+tooltipH-scrollH) < windowH) {
            posY = mouseY + 10;
          } else {
            posY = windowH-tooltipH+scrollH-10;
            posX = posX<(windowW-tooltipW-offsetV) ? posX : mouseX-tooltipW -10;
          }

          return {x:posX, y:posY};
        };

        var show = function() {
          var bodyLeft = document.body.getBoundingClientRect().left;

          var pos = {x:scope.x-bodyLeft, y:scope.y};

          var newpos = tooltipPosition(pos.x, pos.y);

          element
          .css("top", newpos.y+"px")   
          .css("left", newpos.x+"px") 
          .css("visibility", "visible") 
          //.html(message(d));      
        };

        scope.$watch("msg", function (newVal) {
          content.text(newVal);
          show();
        });      

      }
      
      
    };
  }]);



/**
 * @ngdoc directive
 * @name tide-angular.directive:tdTreemap
 * @requires $compile
 * @requires underscore._
 * @requires d3service.d3
 * @requires tideLayoutTreemap
 * @requires toolTip
 * @element div
 * 
 * @param {array} tdData Data array used for populating the chart
 * @param {string} tdXattribute Name of the attribute used organizing columns with different categories
 * @param {string} tdIdAttribute Name of the attribute used for the ID of unique entities in teh data set
 * @param {string} tdSizeAttribute Name of the attribute used for defining the size of the elements (i.e. number of students)
 * @param {string} tdColorAttribute Name of the attribute used to define the color categories in the chart
 * @param {function=} tdTooltipMessage Function that should return a text to be displayed in the tooltip, given a data element
 * @param {int=} tdWidth Chart widht 
 * @param {int=} tdHeight Chart height 
 * @param {array=} tdColorLegend Array that returns the color codes used in the legend each element is an array ["category", "color"]
 * @param {string} tdUnidad Label with unit used for the size of the elements (Ex:  "Students")
 * @description
 *
 * Generates a Treemap with the total population distributed in "rectangles" acording to the size of each record
 * records are grouped in Columns (Ex. "Type of school") and Colors (Ex "zone") ... allowing to visualize the distribution of the population according to 2 main categories and within each unit of analisis (Ex School)
 *
 */
 angular.module("tide-angular")
 .directive("tdTreemap",["$compile","_", "d3","tideLayoutTreemap", "toolTip",function ($compile,_, d3, layout, tooltip) {
   return {
    restrict: "A",
      //transclude: false,
      //template: "<div style='background-color:red' ng-transclude></div>",
      
      scope: {

        data: "=tdData",
        xAttribute: "=tdXAttribute",
        sizeAttribute: "=tdSizeAttribute",
        idAttribute: "=?tdIdAttribute",
        tooltipMessage: "=?tdTooltipMessage",

        width: "=?tdWidth",
        height: "=?tdHeight",
        unidad: "=?tdUnidad",

        // Bubble color
        colorAttribute: "=tdColorAttribute",
        keyAttribute: "=tdKeyAttribute",

        colorLegend: "=?tdColorLegend"
        

      },
      
      link: function (scope, element, attrs) {

        var width = scope.width ? +scope.width : 800;
        var height = scope.height ? +scope.height : 400;
        var margin = {};
        margin.left = scope.options && scope.options.margin && scope.options.margin.left ? scope.options.margin.left : 20;
        margin.right = 20;
        margin.top = 20;
        margin.bottom = 40;

        //scope.colorAttribute = scope.colorAttribute ? scope.colorAttribute : "color";

        var color = d3.scale.category10();

        var size = [width,height];  

        
        layout
        .size([width,height]) 
        .sizeAttribute(scope.sizeAttribute)
        .xAttribute(scope.xAttribute )
        .colorAttribute(scope.colorAttribute)


        // Div principal
        var mainDiv = d3.select(element[0]).append("div")
        .style("position", "relative")
        .style("width", (width + margin.left + margin.right) + "px")
        .style("height", (height + margin.top + margin.bottom) + "px")
        .style("left", margin.left + "px")
        .style("top", margin.top + "px");

        var titlesDiv = mainDiv.append("div")
            .style("position", "relative")
            .style("width", width + "px")
            .style("height", 40 + "px")
            .style("left", 0 + "px")
            .style("top", 0 + "px")


        // Define dataPoints tooltip generator
        var dataTooltip = tooltip();
        if (scope.tooltipMessage) {
          dataTooltip.message(scope.tooltipMessage);
        } else {
          dataTooltip.message(function(d) {
            var msg = scope.xAttribute + " : " + d[scope.xAttribute];
            msg += "<br>" + scope.yAttribute +  " : " + d[scope.yAttribute];

            return  msg;
          });
        }

        /**
        * resize
        */
        var resize = function() {

          width = scope.width ? +scope.width : 800;
          height = scope.height ? +scope.height : 400;

          size = [width,height];  

          layout
          .size([width,height]) 

          mainDiv
            .style("width", (width + margin.left + margin.right) + "px")
            .style("height", (height + margin.top + margin.bottom) + "px");

          }


          var render = function(data) {
            if (data) {


                var colorCategories = _.keys(_.groupBy(data, function(d) {return d[scope.colorAttribute]})).sort();
                color.domain(colorCategories);

            // Color legend data to be shared through the scope
            scope.colorLegend = [];
            _.each(color.domain(), function(d) {
              scope.colorLegend.push([d, color(d)]);
            })


            layout
            .sizeAttribute(scope.sizeAttribute)
            .xAttribute(scope.xAttribute)
            .colorAttribute(scope.colorAttribute)

            var nodes = layout.nodes(data);

            var formatNumber = d3.format(",d");

            var titles = layout.titles();

            d3.selectAll(".etiqueta").remove();

            titlesDiv
            .style("width", width + "px")

            var titles = titlesDiv.selectAll(".title")
            .data(titles)

            titles
              .enter()
              .append("div")
              .attr("class","title")
              .style("float", "left")
              .style("position", "relative")
              .style("width", function(d) {return d.width+"px"})
              .append("div")
              .attr("class", "etiqueta")


            titles
              .style("width", function(d) {return d.width+"px"})
              .html(function(d) {
                return d.title +"<br>"+formatNumber(d.size) +" "+ scope.unidad    
              });

            var divNodes =  mainDiv.selectAll(".node")
            .data(nodes, function(d) {return d[scope.keyAttribute]})

            divNodes
            .exit()
            .transition()
            .attr("opacity", 0)
            .remove()

            divNodes
            .enter()
            .append("div")
            .attr("class", function(d) {
                    // Si son carreras
                    if (d.depth == 1) {
                      return "node leaf";
                    } else  {
                      return "node notleaf"
                    }
                  })
            .style("-webkit-box-sizing", "content-box")
            .style("-moz-box-sizing", "content-box")
            .style("box-sizing", "content-box")
            .text(function(d) { return d.children ? null : d.key; })
            .on("mouseenter", function(d) {
             if(d.depth !=0){
               dataTooltip.show(d)
             }
           })
            .on("mouseleave", function(d) {
             dataTooltip.hide()
           })

          divNodes
            .call(position)
            .style("background", function(d) { 
             return (!d.values && d.depth==1) ? color(d[scope.colorAttribute]) : null;
           })

          }
          
        }

        var position = function() {
          this.style("left", function(d) { 
            return d.x + "px"; 
          })
          .style("top", function(d) { 
            return d.y +40 + "px"; 
          })
          .style("width", function(d) { 
           return Math.max(0, d.dx - 1) + "px"; 
         })
          .style("height", function(d) { return Math.max(0, d.dy - 1) + "px"; });
        }


        render(scope.data);

        scope.$watch("data", function () {
          render(scope.data);
        });      


        scope.$watch("colorAttribute", function () {
          render(scope.data);
        });

        scope.$watch("width", function () {
          resize();
          render(scope.data);
        });

      }

    }

  }]);



/**
* @ngdoc service
* @name tide-angular.tideLayoutTreemap
* @requires d3service.d3
* @requires underscore._
*
* @description
* Creates a layout (node array with position attributes) for building an Treemap Chart
*
*/
angular.module("tide-angular")
.service ("tideLayoutTreemap", ["d3","_", function(d3,_) {
  var size = [1,1];
  var sizeAttribute  = "";
  var colorAttribute = "";
  var xAttribute    = "";
  var titles = [];

  this.nodes = function(data) {
    var dataGroups = createDataGroups(data);

    // sizes  : Objeto con los tamaños de cada grupo
    // Ej. sizes = {"CFT": 120340, "IP": 45687, ...}
    var sizes = calculateGroupSizes(dataGroups);

    // totalSize tamaño total de todos los nodos (Ej totalSize = 956875)
    var totalSize = calculateTotalSize(data);

    // ancho y alto del área de despliegue
    var w = size[0];
    var h = size[1];

    // Arreglo con las obicaciones de cada nodo
    var nodes = []

    var nextX = 0;  // Position of next group Node
    _.each(d3.keys(sizes).sort(), function(key) {
        var groupNode = {};
        groupNode.dx = w*sizes[key]/totalSize;
        groupNode.dy = h;
        groupNode.x = nextX;
        nextX = nextX + groupNode.dx;
        groupNode.y = 0;
        groupNode.depth = 0
        nodes.push(groupNode);

        var groupNodes = createGroupNodes(dataGroups[key], groupNode.x, groupNode.y, groupNode.dx, groupNode.dy, sizes[key]);
        nodes = nodes.concat(groupNodes);

    })

    // Genera un arreglo con texto y ancho de cada titulo
    titles = createTitles(sizes, totalSize);

    return nodes;
  };

  this.size = function(_) {
      if (!arguments.length) return size;
      size = _;
      return this;
  }

  this.sizeAttribute = function(_) {
      if (!arguments.length) return sizeAttribute;
      sizeAttribute = _;
      return this;
  };

  this.colorAttribute = function(_) {
      if (!arguments.length) return colorAttribute;
      colorAttribute = _;
      return this;
  };

  this.xAttribute = function(_) {
      if (!arguments.length) return xAttribute;
      xAttribute = _;
      return this;
  };


  this.titles = function() {
    return titles;
  }

  var createTitles = function(sizes, totalSize) {
    var titles = [];

    _.each(d3.keys(sizes).sort(), function(key) {
      var w = size[0];

      var title = {}
      title.title = key;
      title.width = w*sizes[key]/totalSize;
      title.size = sizes[key];

      titles.push(title);
    });

    return titles;
  }

  var createDataGroups = function(data) {
    // Agrupar datos según agrupaciones
    var dataGroups = _.groupBy(data, function(d) {return d[xAttribute]});
    return dataGroups;
  }

  var calculateGroupSizes = function(dataGroups) {

    // Objeto con los tamaños de cada grupo
    var sizes = {};

    _.each(d3.keys(dataGroups), function(key) {
      sizes[key] = _.reduce(dataGroups[key], function(memo, d) {
        return +d[sizeAttribute] + memo;
      }, 0);
    })
    return sizes;
  }

  var calculateTotalSize = function(data) {
    var totalSize =  _.reduce(data, function(memo, d) {
        return +d[sizeAttribute] + memo;
      }, 0);
    return totalSize;
  }

  var createGroupNodes = function(groupData, left, top, width, height, groupSize) {
    // Groups: CFT, IP, ...
    // Categories : Acredidata, No Acreditada

    var withinGroupCategories = _.groupBy(groupData, function(d) {
      return d[colorAttribute];
    });

    var categories = _.sortBy(d3.keys(withinGroupCategories), function(d) {
      return d;
    });

    var nodes = [];

    var nextY = 0
    _.each(categories, function(category) {
      var categorySize = _.reduce(withinGroupCategories[category], function(memo, d) {
        return +d[sizeAttribute] + memo;
      }, 0);

      
      var categoryNode = {};
      categoryNode.dx = width;
      categoryNode.dy = height*categorySize/groupSize;
      categoryNode.x = left;
      categoryNode.y = nextY;
      nextY = nextY + categoryNode.dy;
      
      categoryNode.depth = 0
      nodes.push(categoryNode);

      var nestedData = d3.nest()
        .key(function(d) {return category})
        .entries(withinGroupCategories[category]);
           
      var treemap = d3.layout.treemap()
        .size([categoryNode.dx, categoryNode.dy])
        .sticky(true)
        .children(function(d) {return d.values })
        .value(function(d) { return d[sizeAttribute]; });

      var mapNodes = treemap.nodes(nestedData[0]);

      // Trasladar la posición de cada nodo en función del origen left, top
      mapNodes = _.map(mapNodes, function(d) {
        d.x = d.x+left;
        d.y = d.y+top+categoryNode.y;
        return d
      })

      nodes = nodes.concat(mapNodes);

    });

    return nodes;
  }

}]);


