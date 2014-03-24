define ['jquery', 'fixtures'], ($, fixtures) ->

  describe "Values", ->
    simpleForm = null
    $textControl = null
    account = name: 'STAFFOMATIC', className: 'account'
    AccountModel = Backbone.Model.extend
      modelName: 'account'

    control = (options={}) ->
      simpleForm.input(options.ressource, options.method, options)

    beforeEach ->
      simpleForm = new JoB.SimpleForm.Base()

    afterEach ->
      fixtures.cleanUp()

    describe "find value", ->
      it "should get value from Hash", ->
        ctr = $(simpleForm.input(account, 'name')).find('input')
        ctr.val().should.eq 'STAFFOMATIC'

      it "find value in Backbone.Model", ->
        ctr = $(simpleForm.input(new AccountModel(account), 'name')).find('input')
        ctr.val().should.eq 'STAFFOMATIC'
