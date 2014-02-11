define ['jquery', 'js-fixtures'], ($, fixtures) ->

  describe "Labels", ->
    simpleForm = null
    translatedSimpleForm = null
    $textControl = null
    collection = ['male', 'female']

    control = (options={}) ->
      simpleForm.input('user', 'name', options)

    $label = (options={}) ->
      $(control(options)).find('label')

    translations =
      simple_form:
        hints: user: name: 'translated hints: Name'
        labels: user: name: 'translated labels: Name'
        placeholders: user: name: 'translated labels: Name'

    translator = (attr) =>
      attrs = attr.split('.')
      attrs.push(attr)
      trans = _.clone(translations)
      while attrs.length
        trans = trans[attrs.shift()]
        break if _.isString(trans) or trans is `undefined` or trans is null
      trans

    beforeEach ->
      simpleForm = new ST.SimpleForm()
      translatedSimpleForm = new ST.SimpleForm(translator: translator)

    afterEach ->
      fixtures.cleanUp()

    describe "test label options", ->

      it "should set default label to attributeName", ->
        $label().text().should.eq 'name'

      it "should set custom label text", ->
        $label(label: "hello world").text().should.eq 'hello world'

      it "should render without label", ->
        $(control(label: false)).find(".label").length.should.eq 0

      it "should render translated label", ->
        ct = translatedSimpleForm.input('user', 'name')
        $(ct).find('label').text().should.eq 'translated labels: Name'
