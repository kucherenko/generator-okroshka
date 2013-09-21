require.config
  baseUrl: "../scripts/"
  paths:
    jquery: "../components/jquery/jquery"
    handlebars: "../components/handlebars/handlebars"
    underscore: "../components/underscore/underscore"
    backbone: "../components/backbone/backbone"
    chai: "../components/chai/chai"
    chaiJquery: "../components/chai-jquery/chai-jquery"

  shim:
    underscore:
      exports: "_"

    jquery:
      exports: "$"

    backbone:
      deps: ["underscore", "jquery"]
      exports: "Backbone"

    handlebars:
      exports: "Handlebars"

  urlArgs: "bust=" + (new Date()).getTime()

expect = chai.expect
chai.should()

env = null

mocha.setup
  ui: "bdd"
  ignoreLeaks: true

# Don't track
window.notrack = true

# Mocha run helper, used for browser
runMocha = ->
  if (window.mochaPhantomJS)
    mochaPhantomJS.run()
  else
    mocha.run()

# initialize sinone sandbox
beforeEach ->
  env = sinon.sandbox.create()

afterEach ->
  env.restore()

