define (require) ->

  Backbone = require 'backbone'
  templates = require 'templates'

  class ApplicationView extends Backbone.View
    template: templates.application
    render: ->
      @.$el.html @template()
