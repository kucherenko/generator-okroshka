zombie = require("zombie")

World = (callback) ->
  @browser = new zombie()

  @visit = (url, callback) ->
    @browser.visit url, callback

  callback() # tell Cucumber we're finished and to use 'this' as the world instance

exports.World = World
