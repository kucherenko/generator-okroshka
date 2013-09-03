chai = require("chai")
expect = chai.expect
module.exports = ->
  @World = require("../support/world").World # overwrite default World constructor

  @Given /^I am on the first page$/, (next) ->
    @visit "http://localhost:9000/", next

  @Then /^I should see \"Make Borsch\" image$/, (next) ->
    expect(@browser.text("body")).to.contain "Borsch"
    next()

