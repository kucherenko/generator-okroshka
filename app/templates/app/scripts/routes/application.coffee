define [
  'backbone'
  'views/application'
], (Backbone, Application) ->
  class ApplicationRouter extends Backbone.Router
    routes:
      'about': 'showAbout'
      '': 'defaultRoute'
    showAbout: ->
      @view = new Application()
      $('#main').html @view.render()

    defaultRoute: ->
      @.showAbout()