module.exports = (grunt) ->
  grunt.initConfig
    pkg: '<\json:package.json>'

    coffee:
      lib:
        files:
          'lib/*.js': 'src/**/*.coffee'

    simplemocha:
      lib:
        src: 'test/unit/**/*_test.coffee'
        options:
          globals: ['expect']
          timeout: 3000
          ui: 'bdd'
          reporter: 'nyan'

    coffeelint:
      app: [
        'Gruntfile.coffee'
        'src/**/**/*.coffee'
        'test/**/**/*.coffee'
      ]

      options:
        no_tabs:
          level: 'error'

        no_trailing_whitespace:
          level: 'error'

        max_line_length:
          value: 79
          level: 'error'

        camel_case_classes:
          level: 'error'

        indentation:
          value: 2
          level: 'error'

        no_implicit_braces:
          level: 'ignore'

        no_trailing_semicolons:
          level: 'error'

        no_plusplus:
          level: 'ignore'

        no_throwing_strings:
          level: 'error'

        cyclomatic_complexity:
          value: 11
          level: 'ignore'

        line_endings:
          value: 'unix'
          level: 'ignore'

        no_implicit_parens:
          level: 'ignore'

    watch:
      files: [
        'Gruntfile.{coffee|js}'
        'app/source/**/*.{coffee|js}'
        'test/unit/**/*.coffee'
        'app/source/assets/stylesheets/**/*.less'<% if (isHandlebars) { %>
        'app/source/assets/templates/**/*.{handlebars|hbs}'<% } %>
      ]
      tasks: 'default'

  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'test', 'simplemocha'
  grunt.registerTask 'default', ['coffee', 'simplemocha']