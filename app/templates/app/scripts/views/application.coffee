define [
  'backbone'
  'templates'
], (Backbone, templates) ->

  class ApplicationView extends Backbone.View
    template: templates.application
    render: ->
      @.$el.html @template()
