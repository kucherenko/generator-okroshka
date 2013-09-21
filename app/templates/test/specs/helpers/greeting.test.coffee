define (require) ->

  Greeting = require "helpers/greeting"

  describe "Greeting Helper", ->
    sut = null

    beforeEach ->
      sut = new Greeting()

    it 'should contain image URL', ->
      logStub = env.stub console, 'log'
      sut.hello()
      logStub.should.have.been.calledWith 'Hello!'