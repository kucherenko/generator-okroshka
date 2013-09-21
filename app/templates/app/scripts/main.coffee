require.config
  paths:
    jquery: '../components/jquery/jquery'
    underscore: '../components/underscore/underscore'
    backbone: '../components/backbone/backbone'
    bootstrap: '../components/bootstrap/dist/js/bootstrap'
    handlebars: "../components/handlebars/handlebars"
  shim:
    underscore:
      exports: '_'
    backbone:
      deps: ['jquery', 'underscore']
      exports: 'Backbone'

    handlebars:
      exports: "Handlebars"
      init: ->
        @Handlebars = Handlebars
        @Handlebars

    bootstrap:
      deps: ['jquery']
      exports: 'jquery'

require [
  "jquery"
  "backbone"
  "routes/application"
  "handlebars"
], ($, Backbone, ApplicationRouter) ->

  $ ->
    console.log "Enjoy okroshka!"
    new ApplicationRouter()
    Backbone.history.start()
