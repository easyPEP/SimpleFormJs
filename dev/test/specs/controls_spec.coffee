define ['jquery', 'js-fixtures'], ($, fixtures) ->

  describe "Controls", ->
    simpleForm = null
    $textControl = null
    collection = ['male', 'female']

    beforeEach ->
      simpleForm = new ST.SimpleForm()

    afterEach ->
      fixtures.cleanUp()

    describe "test for input attributes", ->
      beforeEach ->
        $textControl = $(simpleForm.input('user', 'name')).find('input')
      it "should be string input", ->
        $textControl.attr('type').should.equal 'string'

      it "should have valid name attribute", ->
        $textControl.attr('name').should.equal 'user[name]'

      it "should have valid class names", ->
        $textControl.attr('class').should.equal 'form-input form-control'

      it "should have valid ID's", ->
        $textControl.attr('id').should.equal 'user_name'

      it "should have valid placeholder", ->
        $placeholderControl = $(simpleForm.input('user', 'name', {placeholder: 'write your name'})).find('input')
        $placeholderControl.attr('placeholder').should.equal 'write your name'

      it "should have valid value", ->
        $placeholderControl = $(simpleForm.input('user', 'name', {value: 'kalle saas'})).find('input')
        $placeholderControl.attr('value').should.equal 'kalle saas'

      it "should have addition inputClass", ->
        $placeholderControl = $(simpleForm.input('user', 'name', {inputClass: 'important'})).find('input')
        $placeholderControl.hasClass('important').should.equal true

    describe "collections and blank options", ->
      control = null
      $control = null

      beforeEach ->
        control = simpleForm.input('user', 'gender', {collection: collection, as: "select"})
        $control = $(control).find('select')

      it "should have a male/female including blank options", ->
        $control.find('option').length.should.equal 3

      it "default blank should have no value", ->
        $control.find('option:eq(0)').val().should.equal ''

      it "default blank should have no text", ->
        $control.find('option:eq(0)').text().should.equal ''

      it "should not show an blank option", ->
        blank = simpleForm.input('user', 'gender', {includeBlank: false, collection: collection, as: "select"})
        $(blank).find('option:eq(0)').val().should.equal "male"
        $(blank).find('option:eq(0)').text().should.equal "male"

      it "should have a blank option with specific text", ->
        blank = simpleForm.input('user', 'gender', {includeBlank: 'please select a gender', collection: collection, as: "select"})
        $(blank).find('option:eq(0)').val().should.equal ""
        $(blank).find('option:eq(0)').text().should.equal "please select a gender"

    describe "control types", ->

      describe "<input type='*' /> controls", ->
        beforeEach ->
          $textControl = $(simpleForm.input('user', 'name')).find('input')

        it "should fallback to <input type='string' />", ->
          $textControl.is("input").should.equal true

      describe "<input type='radio' /> controls", ->
        control = null
        $control = null

        beforeEach ->
          control = simpleForm.input('user', 'gender', {as: 'radiobuttons', collection: collection})
          $control = $(control).find('input')

        it "should render as radio controls", ->
          $control.attr('type').should.equal 'radio'

        it "should by default not include blank options", ->
          $control.length.should.equal 2

      describe "<textare /> controls", ->
        $text = null
        text = null
        beforeEach ->
          text = simpleForm.input('user', 'vitae‎', as: 'text')
          $text = $(text).find('textarea')

        it "should render a <textarea />", ->
          $text.is("textarea").should.equal true


      describe "<select /> controls", ->
        control = null
        $control = null

        beforeEach ->
          control = simpleForm.input('user', 'gender', {collection: collection})
          $control = $(control).find('select')

        it "should fallback to be <select/> control", ->
          $control.is("select").should.equal true

