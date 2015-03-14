// Generated on 2014-05-05 using generator-angular 0.8.0
'use strict';


// # Globbing
// for performance reasons we're only matching one level down:
// 'test/spec/{,*/}*.js'
// use this if you want to recursively match all subfolders:
// 'test/spec/**/*.js'

module.exports = function (grunt) {

  // Define the configuration for all the tasks
  grunt.initConfig({
    ngdocs: {
      options: {
        scripts: [
          'angular.js', './tide-angular.js'
         ],
        html5Mode: false
      },
      all: [
        './tide-angular.js'
        ]
    },
 
  });

  // NG Docs
  grunt.loadNpmTasks('grunt-ngdocs');

  // Default task(s).
  grunt.registerTask('default', ['ngdocs']);

};

