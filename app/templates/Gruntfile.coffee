LIVERELOAD_PORT = 1337
lrSnippet = require("connect-livereload")(port: LIVERELOAD_PORT)

mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)


module.exports = (grunt) ->

  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)

  yeomanConfig =
    app: 'app/'
    tmp: '.tmp/'
    dist: 'dist/'
    test: 'test/'
    specs: 'test/specs/'
    features: 'test/features/'

  grunt.initConfig
    yeoman: yeomanConfig
    pkg: '<\json:package.json>'

    watch:
      options:
        nospawn: true

      coffee:
        files: ["<%= yeoman.app %>scripts/{,*/}*.coffee"]
        tasks: ["coffeeCoverage"]

      coffeeTest:
        files: ["<%= yeoman.specs %>**/*.coffee"]
        tasks: ["coffee:test", "scriptlinker"]

      livereload:
        options:
          livereload: LIVERELOAD_PORT

        files: [
          "<%= yeoman.app %>/*.html"
          "{<%= yeoman.tmp %>,<%= yeoman.app %>}styles/{,*/}*.css"
          "{<%= yeoman.tmp %>,<%= yeoman.app %>}scripts/{,*/}*.js"
          "<%= yeoman.app %>images/**/*.{png,jpg,jpeg,gif,webp}"
        ]

      jst:
        files: ["<%= yeoman.app %>scripts/templates/**/*.ejs"]
        tasks: ["jst"]

      handlebars:
        files: ["<%= yeoman.app %>scripts/templates/**/*.hbs"]
        tasks: ["handlebars"]

      less:
        files: ["<%= yeoman.app %>styles/**/*.less"]
        tasks: ["recess:dev"]

      features:
        files: [
          "<%= yeoman.features %>**/*.features"
          "<%= yeoman.features %>**/*.coffee"
        ]
        tasks: ["cucumberjs:wip"]

      test:
        files: [
          '<%= yeoman.app %>scripts/**/*.coffee'
          '<%= yeoman.specs %>**/*.coffee'
        ]
        tasks: ["mocha_browser", 'mocha_phantomjs']

    coffee:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>scripts"
          src: "**/*.coffee"
          dest: "<%= yeoman.tmp %>scripts"
          ext: ".js"
        ]

      test:
        options:
          bare: on
        files: [
          expand: true
          cwd: "test"
          src: "**/*.coffee"
          dest: "<%= yeoman.tmp %>test"
          ext: ".js"
        ]

    scriptlinker:
      test:
        options:
          startTag: '/* TESTS */',
          endTag: '/* END TESTS */',
          fileTmpl: "tests.push('%s');",
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
              mountFolder(connect, yeomanConfig.tmp)
              mountFolder(connect, yeomanConfig.app)
            ]

      test:
        options:
          middleware: (connect) ->
            [
              mountFolder(connect, yeomanConfig.tmp)
              mountFolder(connect, yeomanConfig.app)
            ]

      dist:
        options:
          middleware: (connect) ->
            [mountFolder(connect, yeomanConfig.dist)]

    open:
      server:
        path: "http://localhost:<%= connect.options.port %>"

    clean:
      dist: ["<%= yeoman.tmp %>", "<%= yeoman.dist %>*"]
      server: "<%= yeoman.tmp %>"

    mocha:
      all:
        options:
          run: true
          urls: ["http://localhost:<%= connect.options.port %>/test/"]

    mocha_phantomjs:
      all:
        options:
          reporter: 'dot'
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
        dest: yeomanConfig.dist

    usemin:
      html: ["<%= yeoman.dist %>**/*.html"]
      css: ["<%= yeoman.dist %>styles/**/*.css"]
      options:
        dirs: [yeomanConfig.dist]

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>images"
          src: "**/*.{png,jpg,jpeg}"
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
          cwd: yeomanConfig.app
          src: "*.html"
          dest: yeomanConfig.dist
        ]

    handlebars:
      options:
        amd: true
        processName: (filename) ->
          filename.replace("#{yeomanConfig.app}scripts/templates/", '').replace '.hbs', ''
      compile:
        files:
          '<%= yeoman.tmp %>scripts/templates.js': ['<%= yeoman.app %>scripts/templates/*.hbs']

    jst:
      options:
        amd: true
        processName: (filename) ->
          filename.replace("#{yeomanConfig.app}scripts/templates/", '').replace '.ejs', ''
      compile:
        files:
          '<%= yeoman.tmp %>scripts/templates.js': ['<%= yeoman.app %>scripts/templates/*.hbs']

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: yeomanConfig.app
          dest: yeomanConfig.dist
          src: ["*.{ico,txt}", ".htaccess", "images/**/*.{webp,gif}", "styles/fonts/*"]
        ]

      tests:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.test %>"
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
            "components/requirejs/require.js"
            "components/jquery/jquery.js"
            "components/underscore/underscore.js"
            "components/backbone/backbone.js"
            "components/handlebars/handlebars.js"
            "components/bootstrap/dist/js/bootstrap.js"
            "scripts/**/*.js"
          ]
        ]

    rev:
      dist:
        files:
          src: [
            "<%= yeoman.dist %>scripts/**/*.js",
            "<%= yeoman.dist %>styles/**/*.css",
            "<%= yeoman.dist %>images/**/*.{png,jpg,jpeg,gif,webp}",
            "<%= yeoman.dist %>styles/fonts/*"
          ]

    mocha_browser:
      all:
        options:
          output: "<%= yeoman.tmp %>test/coverage.html"
          reporter: 'html-cov'
          urls: ["http://localhost:<%= connect.options.port %>/test/"]

    coffeeCoverage:
      options:
        path: "<%= yeoman.app %>/scripts"
      '.tmp/scripts': "<%= yeoman.app %>/scripts"

    cucumberjs:
      wip:
        files: [
          src: '<%= yeoman.features %>'
        ]
        options:
          steps: "<%= yeoman.features %>step_definitions"
          tags: "@wip"
      done:
        files: [
          src: '<%= yeoman.features %>'
        ]
        options:
          steps: "<%= yeoman.features %>step_definitions"
          tags: "@done"
      all:
        files: [
          src: '<%= yeoman.features %>'
        ]
        options:
          steps: "<%= yeoman.features %>step_definitions"


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
        "coffeeCoverage"
        "handlebars" # use "jst" if you don't use handlebars templates
        "copy:tests"
        "scriptlinker"
        "recess:dev"
        "connect:livereload"
        "mocha_browser"
        "open"
        "watch"
      ]

  grunt.registerTask "test", [
    "clean:server"
    "coffeeCoverage"
    "coffee:test"
    "copy:tests"
    "scriptlinker"
    "handlebars" # use "jst" if you don't use handlebars templates
    "connect:test"
    "mocha_phantomjs"
    "mocha_browser"
  ]

  grunt.registerTask "e2e", [
    "clean:server"
    "coffeeCoverage"
    "coffee:test"
    "copy:tests"
    "scriptlinker"
    "handlebars" # use "jst" if you don't use handlebars templates
    "connect:test"
    "cucumberjs:done"
  ]

  grunt.registerTask "build", [
    "clean:dist"
    "coffee:dist"
    "handlebars" # use "jst" if you don't use handlebars templates
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