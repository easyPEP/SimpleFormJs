define ['jquery', 'js-fixtures'], ($, fixtures) ->

  describe "_includeBlankDefinition", ->

    # HELPERS
    # ------------------------------------------------------------------------------------
    simpleForm = null

    # BEFORE AND AFTER
    # ------------------------------------------------------------------------------------
    beforeEach ->
      simpleForm = new ST.SimpleForm()

    afterEach ->
      fixtures.cleanUp()

    # SPECS
    # ------------------------------------------------------------------------------------
    it "sample equal assertion", ->
      simpleForm.input('account', 'name')
