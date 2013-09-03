require.config
  baseUrl: "/test/"
  paths:
    jquery: "../components/jquery/jquery"
    underscore: "../components/underscore/underscore"
    backbone: "../components/backbone/backbone"
    chai: "../components/chai/chai"
    chaiJquery: "../components/chai-jquery/chai-jquery"
    handlebars: "../components/handlebars/handlebars"
    borsch: "../scripts"

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

require ['chai', 'chaiJquery'], (chai, chaiJquery) ->
