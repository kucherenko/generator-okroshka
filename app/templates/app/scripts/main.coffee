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

    bootstrap:
      deps: ['jquery']
      exports: 'jquery'


define [
  'backbone'
  'routers/application'
], (Backbone, Application) ->
  new Application()
  Backbone.history.start()
