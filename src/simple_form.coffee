window.JoB = {} if window.JoB is undefined
window.JoB.SimpleForm = {} if JoB.SimpleForm is undefined

# Main constructor and option Class
class JoB.SimpleForm.Base
  # _.extend @::, JoB.Form.OptionsHelper::,
  #               JoB.Form.TagHelper::

  # Mapping to Job helpers
  INPUT_MAPPING =
    boolean: 'checkBoxTag'
    checkboxes: 'checkBoxTag'
    datetime: 'datetimeFieldTag'
    date: 'dateFieldTag'
    decimal: 'input'
    email: 'emailFieldTag'
    file:  'fileFieldTag'
    float: 'input'
    hidden:  'hiddenFieldTag'
    integer: 'input'
    select: 'selectTag'
    string:  'textFieldTag'
    tel: 'telephoneFieldTag'
    password:  'passwordFieldTag'
    radiobuttons: 'radioButtonTag'
    range: 'rangeFieldTag'
    search:  'searchFieldTag'
    text: 'textAreaTag'
    textarea: 'textAreaTag'
    time: 'timeFieldTag'
    url: 'urlFieldTag'

  constructor: (argument) ->
    @optionsHelper = new JoB.Form.OptionsHelper()
    @tagHelper = new JoB.Form.TagHelper()

  # extract ressource from options.
  # you can provide ressource in form of:
  # Backbone.model or string
  # Backbone.model class should respond to modelName or className
  #   @base.ressource will hold Backbone model if available
  #   @base.ressourceName will hold model name
  _ressoureDefinition: () ->
    if _.isString(@base.ressource)
      @base.ressourceName = @base.ressource
      @base.ressource     = false
    else if _.isObject(@base.ressource)

      # guess ressourceName
      if @base.ressource.modelName?
        @base.ressourceName = @base.ressource.modelName
      else if @base.ressource.className?
        @base.ressourceName = @base.ressource.className
      else
        console.log "We could not guess ressourceName,
        please add modelName or className to the ressource option"

      # convert ressource to hash
      if _.isFunction(@base.ressource.toJSON)
        @base.ressource = @base.ressource.toJSON()
      else
        @base.ressource = @base.ressource

  # extract value from ressource or inputOptions hash
  # prefer option value over ressource value
  _value: () ->
    returnString = ""
    if @options.value is false
      returnString = ''
    else if _.isString(@options.value) and _.isEmpty(@options.value) is false
      returnString = @options.value
    else if @base.ressource and _.isString(@base.ressource[@base.fieldName])
      returnString = @base.ressource[@base.fieldName]
    returnString

  _placeholder: () ->
    returnString = ''
    if @options.placeholder is false
      returnString = ''
    else if _.isString(@options.placeholder) and _.isEmpty(@options.placeholder) is false
      returnString = @options.placeholder
    else
      translatedPlaceholder = @translationHelper.placeholder()
      if translatedPlaceholder?
        returnString = translatedPlaceholder
      else
        returnString = ''
    returnString

  _inputType: () ->
    type = ''
    if @options.collection? and @options.as is 'string'
      # collectio is select as default
      type = INPUT_MAPPING['select']
    else if _.isString(@options.as) and _.isString(INPUT_MAPPING["#{@options.as}"])
      type = INPUT_MAPPING["#{@options.as}"]
    else
      type = INPUT_MAPPING['string']
    type

  _selectedOptionTag: () ->
    selected = undefined
    if @base.ressource and @options.collection
      selected = _.find @options.collection, (el) =>
        return el[0] is @base.ressource[@base.fieldName]
    selected

  #  COllection in the form of:
  # [[value, text]]
  # [value, value]
  # include_blank: false
  _collection: () ->
    collection = @options.collection
    # include a blank option ?
    if @options.includeBlank or _.isEmpty(@options.includeBlank) is false
      if _.isString(@options.includeBlank)
        collection.unshift ["", @options.includeBlank]
      else
        collection.unshift ["", ""]
    collection

  _optionTags: () ->
    @optionsHelper.optionsForSelect @_collection(), @_selectedOptionTag()

  _radioOrCheckTags: (inputType) ->
    els  = []
    ressource = @base.ressource
    _.each @options.collection, (option) =>
      checked = if (ressource and ressource[@base.fieldName] is option[0]) then true else false
      inputOptions = _.clone(@inputOptions)
      inputOptions.value = option[0]
      if inputType is INPUT_MAPPING['radiobuttons']
        inputTag = @tagHelper.radioButtonTag(@base.ressourceName, @base.fieldName, checked, inputOptions)
        withWrapper = @wrapperHelper.radiobutton(inputTag, option[1])
      else
        inputTag = @tagHelper.checkBoxTag(@base.ressourceName, @base.fieldName, checked, inputOptions)
        withWrapper = @wrapperHelper.checkbox(inputTag, option[1])
      els.push withWrapper
    els

  inputWithWrapper: () ->
    inputType = @_inputType()
    inputWithWrapper = ''

    # <select />
    if inputType is INPUT_MAPPING['select']
      @inputOptions['class'] += " form-control"
      inputHtml = @tagHelper.selectTag(
        @base.ressourceName,
        @base.fieldName,
        @_optionTags()
        @inputOptions
      )
      inputWithWrapper = @wrapperHelper.default(inputHtml)

    # Shortcut for input with boolean value (true or false)
    # <input type="checkbox" />
    else if @options.as is 'boolean'
      checked = if (@base.ressource and @base.ressource[@base.fieldName] is 1) then true else false
      @inputOptions.value = 1
      inputHtml = @tagHelper.checkBoxTag(
        @base.ressourceName,
        @base.fieldName,
        checked,
        @inputOptions
      )
      label = @wrapperHelper._label()
      inputWithWrapper = @wrapperHelper.checkbox(inputHtml, label)

    # <input type="checkbox" /> or <input type="radiobutton" />
    else if inputType is INPUT_MAPPING['checkboxes'] or inputType is INPUT_MAPPING['radiobuttons']
      inputWithWrapper = @_radioOrCheckTags(inputType).join("")

    # <input type="file" />
    else if inputType is INPUT_MAPPING['file']
      inputHtml = @tagHelper[inputType](
        @base.ressourceName,
        @base.fieldName,
        @inputOptions
      )
      inputWithWrapper = @wrapperHelper.default(inputHtml)

    # <textarea />
    else if inputType is INPUT_MAPPING['text'] or inputType is INPUT_MAPPING['textarea']
      content = @inputOptions.value; delete @inputOptions.value
      @inputOptions['class'] += " form-control"
      @labelOptions['class'] += " control-label"
      inputHtml = @tagHelper.textAreaTag(
        @base.ressourceName,
        @base.fieldName,
        content,
        @inputOptions
      )
      inputWithWrapper = @wrapperHelper.default(inputHtml)
    # <textarea />
    else
      # input fields with default option (mostly 'input' with type)
      if inputType is INPUT_MAPPING['range']
        @inputOptions['class'] += ""
      else if inputType is INPUT_MAPPING['hidden']
        @options.label = false
      else
        @inputOptions['class'] += " form-control"
        @labelOptions['class'] += " control-label"
      inputHtml = @tagHelper["#{@_inputType()}"](
        @base.ressourceName,
        @base.fieldName,
        @inputOptions
      )
      inputWithWrapper = @wrapperHelper.default(inputHtml)

    inputWithWrapper

  # input( ressource, fieldName, {options})
  # model, collection, value, label, hint, as, required, placeholder, type, addonText, addonPosition, includeBlank, inputClass, wrapperClass, translator
  input: (ressource, fieldName, options = {}, inputOptions = {}, labelOptions = {}, wrapperOptions = {}) ->
    # @_argumentsValidator(arguments)
    @base =
      fieldName: fieldName
      ressource: ressource

    @_ressoureDefinition()

    @translationHelper = new JoB.SimpleForm.TranslationHelper(@base)

    @options = _.defaults(
      options,
      {
        as: 'string',
        type: 'text',
        label: true,
        value: true,
        required: false,
        addonPosition: 'right',
        includeBlank: true
      })

    @inputOptions = _.defaults(
      inputOptions,
      {
        class: '',
        value: @_value(),
        placeholder: @_placeholder()
      })
    @labelOptions = _.defaults(labelOptions,
      {
        class: ''
      })

    @wrapperOptions = _.defaults(
      wrapperOptions,
      {
        class: ''
      })
    # @wrapperOptions.class = "form-group #{@wrapperOptions.class}"
    @wrapperHelper = new JoB.SimpleForm.WrapperHelper(@base, @options, @labelOptions, @wrapperOptions)

    # @_translatorFunction(translator)
    # @_placeHolderDefinition(placeholder)
    # @_labelDefinition(label)
    # @_hintDefinition(hint)
    # @_wrapperClassDefinition(wrapperClass)

    @inputWithWrapper()

  button: (text, htmlOptions = {}) ->
    options = _.defaults(htmlOptions, {
        class: "btn btn-default"
      })
    @tagHelper.buttonTag(text, options)






