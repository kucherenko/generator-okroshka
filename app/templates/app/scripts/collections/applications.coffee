define ['backbone', 'models/application'], (Backbone, Application) ->
  class ApplicationsCollection extends Backbone.Collection
    model: Application
