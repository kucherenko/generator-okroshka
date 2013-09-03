expect = chai.expect
describe "Models", ->
  describe "Sample Model", ->
    sut = null
    it 'should default null', ->
      expect(sut).to.be.a null
