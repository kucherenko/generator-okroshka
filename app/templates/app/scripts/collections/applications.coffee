define (require) ->

  Backbone = require 'backbone'
  Application = require 'models/application'

  class ApplicationsCollection extends Backbone.Collection
    model: Application
