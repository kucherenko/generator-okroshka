define (require) ->

  Backbone = require 'backbone'
  ApplicationView = require 'views/application'

  class ApplicationRouter extends Backbone.Router

    routes:
      '*path': 'defaultRoute'

    defaultRoute: ->
      @view = new ApplicationView()
      $('#main').html @view.render()