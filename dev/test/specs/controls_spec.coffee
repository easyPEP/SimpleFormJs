define ['jquery', 'js-fixtures'], ($, fixtures) ->

  describe "Controls", ->
    simpleForm = null

    beforeEach ->
      simpleForm = new ST.SimpleForm()

    afterEach ->
      fixtures.cleanUp()

    # SPECS
    # ------------------------------------------------------------------------------------
    it "shold render default text field", ->
      fixtures.load "controls.html"
      #$(fixtures.body()).filter('p.test').length.should.equal 1

      console.log $(fixtures.body()).filter('.form-group')

      input = simpleForm.input('account', 'name')
      input.should.equal(fixtures.body())
