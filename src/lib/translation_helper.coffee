window.JoB = {} if window.JoB is undefined
window.JoB.SimpleForm = {} if JoB.SimpleForm is undefined

class JoB.SimpleForm.TranslationHelper

  constructor: (base, {placeholder, hint, translator}={}) ->
    @base       = base
    @idetifier  = "#{@base.ressourceName.toLowerCase()}.#{@base.fieldName.toLowerCase()}"

    @placeholderN = placeholder || 'simple_form.placeholders'
    @hintN        = hint || 'simple_form.hints'

    @translator = if translator? and _.isFunction(translator)
      translator
    else if I18n?
      (identifier) => I18n.t(identifier)
    else
      (identifier) -> identifier

  _base: (namespace) ->
    name = @translator("#{namespace}.#{@idetifier}")
    name = false if name? and name.match(@idetifier)?
    name

  placeholder: () ->
    @_base(@placeholderN)

  hint: () ->
    @_base(@hintN)

  label: () ->
    # check simple_form namespace
    name = @_base('simple_form.labels')

    # check attributes namespace
    if name is false
      name = @_base('activerecord.attributes')

    # use fieldName as fallback
    if name is false
      name = @base.fieldName

    name
