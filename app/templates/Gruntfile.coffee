lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet

mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)


module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  yeomanConfig =
    app: 'app/'
    tmp: '.tmp/'
    dist: 'dist/'

  grunt.initConfig
    yeoman: yeomanConfig
    pkg: '<json:package.json>'

    esteWatch:
      options:
        dirs: [
          '<%= yeoman.app %>scripts/**/'
          '<%= yeoman.app %>styles/**/'
          '<%= yeoman.app %>images/**/'
          'test/specs/**/'
          'test/features/**/'
          '<%= yeoman.tmp %>scripts/**/'
          '<%= yeoman.tmp %>styles/**/'
        ]

      coffee: (filepath) ->
        isTest = filepath.indexOf('test') isnt -1
        cwd = if isTest then 'test/' else '<%= yeoman.app %>scripts/'
        files = [
          expand: true
          cwd: cwd
          src: filepath.replace cwd, ''
          ext: '.js'
          dest: if isTest then '<%= yeoman.tmp %>test/' else '<%= yeoman.tmp %>scripts/'
        ]
        grunt.config ['coffee', 'dist', 'files'], files
        [
          'coffee:dist'
          'scriptlinker'
          "cucumberjs:wip"
          'mocha'
        ]

      feature: (filepath) ->
        grunt.config ['cucumberjs', 'wip', 'files'], [
          src: filepath
        ]
        ['cucumberjs:wip']
      hbs: ->
        ['handlebars']
      ejs: ->
        ['jst']
      less: ->
        ['recess:dev']

    coffee:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>scripts"
          src: "{,*/}*.coffee"
          dest: "<%= yeoman.tmp %>scripts"
          ext: ".js"
        ]

      test:
        files: [
          expand: true
          cwd: "test"
          src: "{,*/}*.coffee"
          dest: "<%= yeoman.tmp %>test"
          ext: ".js"
        ]

    scriptlinker:
      test:
        options:
          appRoot: '<%= yeoman.tmp %>test/'
        files:
          "<%= yeoman.tmp %>test/index.html": ["<%= yeoman.tmp %>test/specs/**/*.js"]

    connect:
      options:
        port: 9000

      # change this to '0.0.0.0' to access the server from outside
        hostname: "localhost"

      livereload:
        options:
          middleware: (connect) ->
            [
              lrSnippet
              mountFolder(connect, ".tmp")
              mountFolder(connect, "app")
            ]

      test:
        options:
          middleware: (connect) ->
            [
              mountFolder(connect, ".tmp")
              mountFolder(connect, "app")
            ]

      dist:
        options:
          middleware: (connect) ->
            [mountFolder(connect, "dist")]

    open:
      server:
        path: "http://localhost:<%= connect.options.port %>"

    clean:
      dist: [".tmp", "<%= yeoman.dist %>*"]
      server: ".tmp"

    mocha:
      all:
        options:
          run: true
          urls: ["http://localhost:<%= connect.options.port %>/test/"]

    recess:
      dev:
        options:
          compile: true
        files:
          '<%= yeoman.tmp %>styles/main.css': ['<%= yeoman.app %>styles/main.less']
      dist:
        options:
          compile: true
        files:
          '<%= yeoman.dist %>styles/main.css': ['<%= yeoman.app %>styles/main.less']

    requirejs:
      dist:
        options:
          baseUrl: "<%= yeoman.tmp %>scripts"
          optimize: "none"
          preserveLicenseComments: false
          useStrict: true
          wrap: true

    useminPrepare:
      html: "<%= yeoman.app %>index.html"
      options:
        dest: "dist"

    usemin:
      html: ["<%= yeoman.dist %>{,*/}*.html"]
      css: ["<%= yeoman.dist %>styles/{,*/}*.css"]
      options:
        dirs: ["dist"]

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yeoman.dist %>images"
        ]

    cssmin:
      dist:
        files:
          "<%= yeoman.dist %>styles/main.css": ["<%= yeoman.dist %>styles/main.css"]

    htmlmin:
      dist:
        options:
          removeComments: true

        files: [
          expand: true
          cwd: "app"
          src: "*.html"
          dest: "dist"
        ]

    handlebars:
      options:
        amd: true
        processName: (filename) ->
          filename.replace('<%= yeoman.app %>scripts/templates/', '').replace '.hbs', ''
      compile:
        files:
          '<%= yeoman.tmp %>scripts/templates.js': ['<%= yeoman.app %>scripts/templates/*.hbs']

    jst:
      options:
        amd: true
        processName: (filename) ->
          filename.replace('<%= yeoman.app %>scripts/templates/', '').replace '.ejs', ''
      compile:
        files:
          '<%= yeoman.tmp %>scripts/templates.js': ['<%= yeoman.app %>scripts/templates/*.hbs']

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: "app"
          dest: "dist"
          src: ["*.{ico,txt}", ".htaccess", "images/{,*/}*.{webp,gif}", "styles/fonts/*"]
        ]

      tests:
        files: [
          expand: true
          dot: true
          cwd: "test/"
          dest: "<%= yeoman.tmp %>test"
          src: ['index.html']
        ]

      prepareRequirejs:
        files: [
          expand: true
          dot: true
          cwd: "app"
          dest: ".tmp"
          src: [
            "components/requirejs/require.js",
            "components/jquery/jquery.js",
            "components/underscore/underscore.js",
            "components/backbone/backbone.js",
            "components/handlebars/handlebars.js",
            "components/bootstrap/dist/js/bootstrap.js",
            "scripts/{,*/}*.js"
          ]
        ]

    rev:
      dist:
        files:
          src: [
            "<%= yeoman.dist %>scripts/{,*/}*.js",
            "<%= yeoman.dist %>styles/{,*/}*.css",
            "<%= yeoman.dist %>images/{,*/}*.{png,jpg,jpeg,gif,webp}",
            "<%= yeoman.dist %>styles/fonts/*"
          ]

    cucumberjs:
      wip:
        files: [
          src: 'test/features'
        ]
        options:
          steps: "test/features/step_definitions"
          tags: "@wip"
      done:
        files: [
          src: 'test/features'
        ]
        options:
          steps: "test/features/step_definitions"
          tags: "@done"
      all:
        files: [
          src: 'test/features'
        ]
        options:
          steps: "test/features/step_definitions"


  grunt.registerTask "server", (target) ->
    if target is "dist"
      grunt.task.run([
        "build"
        "open"
        "connect:dist:keepalive"
      ])
    else
      grunt.task.run [
        "clean:server"
        "coffee"
        "handlebars"
        "copy:tests"
        "scriptlinker"
        "recess:dev"
        "connect:livereload"
        "open"
        "esteWatch"
      ]

  grunt.registerTask "test", [
    "clean:server"
    "coffee"
    "copy:tests"
    "scriptlinker"
    "handlebars"
    "connect:test"
    "mocha"
  ]

  grunt.registerTask "build", [
    "clean:dist"
    "coffee"
    "handlebars"
    "recess:dist"
    "useminPrepare"
    "copy:prepareRequirejs"
    "requirejs"
    "imagemin"
    "htmlmin"
    "concat"
    "cssmin"
    "uglify"
    "copy"
    "rev"
    "usemin"
  ]
  grunt.registerTask "default", ["test", "build"]