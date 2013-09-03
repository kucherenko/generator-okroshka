"use strict"
LIVERELOAD_PORT = 35729
lrSnippet = require("connect-livereload")(port: LIVERELOAD_PORT)
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->

  connect = require 'connect'
  require('time-grunt') grunt
  require('load-grunt-tasks') grunt

  yeomanConfig =
    app: 'app'
    dist: 'dist'

  grunt.initConfig
    yeoman: yeomanConfig
    pkg: '<\json:package.json>'

    clean:
      dist: ['.tmp', '<%= yeoman.dist %>/*']
      server: '.tmp'

    coffee:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/scripts"
          src: "{,*/}*.coffee"
          dest: ".tmp/scripts"
          ext: ".js"
        ]

      test:
        files: [
          expand: true
          cwd: "test/unit"
          src: "{,*/}*.coffee"
          dest: ".tmp/unit"
          ext: ".js"
        ]

    simplemocha:
      lib:
        src: 'test/unit/**/*_test.coffee'
        options:
          globals: ['expect']
          timeout: 3000
          ui: 'bdd'
          reporter: 'nyan'


    requirejs:
      dist:
        options:
          baseUrl: "<%= yeoman.app %>/scripts"
          optimize: "none"
          paths:
            templates: "../../.tmp/scripts/templates"
          preserveLicenseComments: false
          useStrict: true
          wrap: true
    bower:
      all:
        rjsConfig: '<%%= yeoman.app %>/scripts/main.js'

    connect:
      options:
        port: 9001

        # change this to '0.0.0.0' to access the server from outside
        hostname: "localhost"

      livereload:
        options:
          middleware: (connect) ->
            [
              lrSnippet,
              mountFolder connect, ".tmp"
              mountFolder connect, yeomanConfig.app
            ]

      test:
        options:
          middleware: (connect) ->
            [
              mountFolder connect, ".tmp"
              mountFolder connect, "test"
              mountFolder connect, yeomanConfig.app
            ]

      dist:
        options:
          middleware: (connect) -> [mountFolder connect, yeomanConfig.dist]

    watch:
      options:
        nospawn: true

      coffee:
        files: ["<%= yeoman.app %>/scripts/{,*/}*.coffee"]
        tasks: ["coffee:dist"]

      coffeeTest:
        files: ["test/unit/{,*/}*.coffee"]
        tasks: ["coffee:test"]

      livereload:
        options:
          livereload: LIVERELOAD_PORT

        files: [
          "<%= yeoman.app %>/*.html"
          "{.tmp,<%= yeoman.app %>}/assets/stylesheets/{,*/}*.css"
          "{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js"
          "<%= yeoman.app %>/assets/images/{,*/}*.{png,jpg,jpeg,gif,webp}"
        ]

  grunt.registerTask 'test', 'simplemocha'
  grunt.registerTask 'default', [
    'coffee'
    'simplemocha'
  ]