window.ST = {}

ST.Error = {}
class ST.Error.Arguments extends Error
  constructor: (argument) ->
    throw new Error("#{argument} not provided")

class ST.CollectionHelper

  collectionParser: (collection) ->
    # [[option1, option1], [option2, option2]]
    # [option1, option2] => [[option1, option1], [option2, option2]]
    # include_blank: false
    converted = []
    unless @options.includeBlank is false
      converted.push
        value: ""
        text: if @options.includeBlank? then @options.includeBlank else ''

    _.each collection, (element) ->
      if _.isArray(element) and element.length is 2
        converted.push
          value: element[0]
          text: element[1]
      else if _.isBoolean(element) or _.isString(element)
        converted.push
          value: element
          text: element
    converted

class ST.TranslationHelper

  _translatedPlaceholder: () ->
    idetifier = "#{@base.ressourceName.toLowerCase()}.#{@base.fieldName.toLowerCase()}"
    name = @translator("simple_form.placeholders.#{idetifier}")
    name = false if name? and name.match(idetifier)?
    name

  translatedHint: () ->
    idetifier = "#{@base.ressourceName.toLowerCase()}.#{@base.fieldName.toLowerCase()}"
    name = @translator("simple_form.hints.#{idetifier}")
    name = false if name.match(idetifier)?
    name

  translatedLabelName: () ->
    idetifier = "#{@base.ressourceName.toLowerCase()}.#{@base.fieldName.toLowerCase()}"
    # check first for simple_form namespace
    name = @translator("simple_form.labels.#{idetifier}")
    if name? and name.match(idetifier)?
      name = @translator("activerecord.attributes.#{idetifier}")
      # check default translations
      if name? and name.match(idetifier)?
        name = @base.fieldName
    unless name
      name = false
    name

class ST.WrapperHelper

  # Base Wrapper
  wrapper: (inputHtml) ->
    html = ""
    # input-group
    html += "<div class='#{@options.wrapperClass}'>"
    if @options.addonText is false
      html +=   @label()
      html +=   inputHtml
    else
      html += @label()
      html += "<div class='input-group'>"
      if @options.addonPosition is 'left'
        html += @inputHtmlAddon(@options.addonText)
        html += inputHtml
      else
        html += inputHtml
        html += @inputAddon(@options.addonText)
      html += '</div>'
    html += @hint()
    html += '</div>'
    html

  # Special Checkbox Wrapper
  checkboxesWrapper: (inputHtml) ->
    html = "<div class='#{@options.wrapperClass}'>"
    html += "<div class='checkbox'>
      <label> #{inputHtml} #{@options.label}</label>
    </div>"
    html += "</div>"
    html

  radiobuttonsWrapper: (inputs) ->
    html = "<div class='#{@options.wrapperClass}'>"
    _.each inputs, (el) ->
      html += "<div class='radio'><label>#{el[0]} #{el[1]}</label></div>"
    html += "</div>"
    html

# All about Attributes related methods
class ST.MetaHelper

  inputValue: () ->
    val = if @options.value is false or @options.value is 'undefined'
      ""
    else
      if @options.as is 'text'
        @options.value
      else if 'text'
        "value='#{@options.value}'"
    val

  checked: (comparerator) ->
    'checked' if comparerator or comparerator is 'true'

  selected: (selected, range) ->
    if selected? and range? and _.isArray(range)
      if _.contains(range, selected)
        'selected=selected'
    else if _.isBoolean(selected)
      if selected
        'selected=selected'

  inputId: () ->
    "#{@base.ressourceName.toLowerCase()}_#{@base.fieldName.toLowerCase()}"

  inputName: () ->
    "#{@base.ressourceName.toLowerCase()}[#{@base.fieldName.toLowerCase()}]"

  inputMeta: () ->
    string  = "class='#{@options.inputClass}'"
    string += "name='#{@inputName()}' "
    string += "id='#{@inputId()}' "
    string += "placeholder='#{@options.placeholder}' " unless @options.placeholder is false
    string

  inputAddon: (text) ->
    "<span class='input-group-addon'>#{text}</span>"

class ST.ControlHelper

  _selectControl: () ->
    collection = @options.collection
    input  = ""
    input += "<select #{@inputMeta()} >"
    _.each @options.collection, (option) =>
      input += "<option #{@selected(option.value is @options.value)} value='#{option.value}'>#{option.text}</option>"
    input += "</select>"

  _booleanControl: () ->
    console.log "not yet implemented"

  _inputControl: (type) ->
    input = "<input type='#{type}'"
    unless _.isEmpty(@inputMeta())
      input += " #{@inputMeta()}"
    unless _.isEmpty(@inputValue())
      input += " #{@inputValue()}"
    input += ">"

class ST.DisplayHelper

  button: (text) ->
    html = "<div class='#{@options.wrapperClass}'>"
    html += "<button type='submit' class='btn btn-default'>#{text}</button>"
    html += "</div>"
    html

  inputInput: () ->
    @wrapper @_inputControl(@options.as)

  textareaInput: () ->
    input = "<textarea #{@inputMeta()}>#{@inputValue()}</textarea>"
    @wrapper input

  checkboxesInput: () ->
    input = "<input #{@inputMeta()} type='checkbox' #{@inputValue()}>"
    @["#{@options.typeName}Wrapper"](input)

  radiobuttonsInput: () ->
    els  = []
    _.each @options.collection, (option) =>
      els.push ["<input type='radio' #{@inputMeta()} value='#{option.value}'>", option.text]

    @["#{@options.typeName}Wrapper"](els)

  fileInput: () ->
    input = "<input type='#{@options.type}' #{@inputMeta()}>"
    @wrapper(input)

  selectInput: () ->
    input = @_selectControl()
    @wrapper(input)

  label: () ->
    if @options.label is false
      ""
    else
      "<label for='#{@inputId()}'>#{@options.label}</label>"

  hint: () ->
    if @options.hint is false
      ""
    else
      "<span class='help-block'>#{@options.hint}</span>"

# Main constructor and option Class
class ST.SimpleForm
  _.extend @::, ST.TranslationHelper::,
                ST.CollectionHelper::,
                ST.DisplayHelper::,
                ST.WrapperHelper::,
                ST.MetaHelper::,
                ST.ControlHelper::

  # Mapping:
  # datetime datetime select datetime/timestamp
  # date  date select date
  # time  time select time
  # select  select  belongs_to/has_many/has_and_belongs_to_many associations
  # radio_buttons collection of input[type=radio] belongs_to associations
  # check_boxes collection of input[type=checkbox]  has_many/has_and_belongs_to_many associations
  # country select (countries as options) string with name =~ /country/
  # time_zone select (timezones as options) string with name =~ /time_zone/
  INPUT_MAPPING =
    boolean: 'input'
    string:  'input'
    email: 'input'
    url: 'input'
    tel: 'input'
    password:  'input'
    search:  'input'
    file:  'input'
    hidden:  'input'
    integer: 'input'
    float: 'input'
    decimal: 'input'
    range: 'input'
    radiobuttons: 'radiobuttons'
    checkboxes: 'checkboxes'
    text: 'textarea', textarea: 'textarea'
    datetime: 'select'
    date: 'select'
    time: 'select'
    select: 'select'

  _translatorFunction: (translator) ->
    @translator = if translator?
      translator
    else if I18n?
      (identifier) => I18n.t(identifier)
    else
      (identifier) -> identifier

  constructor: ({translator}={}) ->
    @_translatorFunction(translator)

  _argumentsValidator: (args) ->
    unless args[0]?
      new ST.Error.Arguments('ressource')
    unless args[1]?
      new ST.Error.Arguments('ressourceFieldName')

  _ressoureDefinition: (ressource) ->
    if _.isString(ressource)
      @base.ressourceName = ressource
      @base.ressource     = false
    else if _.isObject(ressource)
      if ressource.modelName?
        @base.ressourceName = ressource.modelName
        @base.ressource     = ressource
      else if ressource.className?
        @base.ressourceName = ressource.className
        @base.ressource     = ressource
      else
        @base.ressourceName = ressource
        @base.ressource = ressource

  _inputValueDefinition: (value) ->
    @options.value = if value?
      value
    else if _.isObject(@base.ressource)
      if _.isFunction(@base.ressource.get)
        @base.ressource.get(@base.fieldName)
      else
        @base.ressource[@base.fieldName]
    else
      false

  _collectionDefinition: (collection) ->
    if collection?
      @options.collection = @collectionParser(collection)
      # overwrite default as value 'string'
      @options.as = 'select' if @options.as is 'string'

  # TODO: combine placeHolder, label and hint definition methods
  _placeHolderDefinition: (placeholder) ->
    @options.placeholder = if placeholder is false
      false
    else if placeholder?
      placeholder
    else
      translatedPlaceholder = @_translatedPlaceholder()
      if translatedPlaceholder?
        translatedPlaceholder
      else
        false

  _labelDefinition: (label) ->
    @options.label = if label is false
      false
    else
      label ?= @translatedLabelName()

  _hintDefinition: (hint) ->
    @options.hint = if hint is false
      false
    else if hint?
      hint ?= @translatedHint()
    else
      false

  # wrapper class and type (depends on addon/Text)
  _wrapperClassDefinition: (wrapperClass) ->
    wrapperClassNames = []
    wrapperClassNames.push('form-group')
    if wrapperClass?
      wrapperClassNames.push(wrapperClass)
    @options.wrapperClass = wrapperClassNames.join(" ")

  # depending on input type
  _inputClassDefinition: (inputClass) ->
    inputMapping = INPUT_MAPPING["#{@options.as}"]

    inputClassNames = ["form-#{inputMapping}"]
    if inputMapping is 'input' or inputMapping is 'textarea' or inputMapping is 'select'
      inputClassNames.push('form-control')
    if inputClass?
      inputClassNames.push(inputClass)

    @options.inputClass = inputClassNames.join(" ")

  _includeBlankDefinition: (includeBlank) ->
    @options.includeBlank = if includeBlank? and _.isString(includeBlank)
      includeBlank
    else if includeBlank is true
      true
    else if includeBlank is false
      false
    else if _.isString(@options.as)
      switch @options.as
        when 'radiobuttons'
          false
        when 'checkboxes'
          false
    else
      true

  # input( ressource, fieldName, {options})
  input: (ressource, fieldName, {model, collection, value, label, hint, as, required, placeholder, type, addonText, addonPosition, includeBlank, inputClass, wrapperClass, translator}={}) ->
    @_argumentsValidator(arguments)
    @base = fieldName: fieldName
    @options =
      as:            as ?= 'string'
      type:          type ?= 'text'
      required:      required ?= false
      addonText:     addonText ?= false
      addonPosition: addonPosition ?= 'right'


    @_ressoureDefinition(ressource)

    @_translatorFunction(translator)
    @_includeBlankDefinition(includeBlank)
    @_inputValueDefinition(value)
    @_collectionDefinition(collection)
    @_placeHolderDefinition(placeholder)
    @_labelDefinition(label)
    @_hintDefinition(hint)
    @_wrapperClassDefinition(wrapperClass)
    @_inputClassDefinition(inputClass)

    @options.typeName = INPUT_MAPPING["#{@options.as}"]

    @["#{@options.typeName}Input"]()
