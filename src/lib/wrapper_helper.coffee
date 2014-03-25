window.JoB = {} if window.JoB is undefined
window.JoB.SimpleForm = {} if JoB.SimpleForm is undefined

# WrapperHelper
# the WrapperHelper is reponsible for markup around the
# input field, like:
# * lables
# * wrappers
class JoB.SimpleForm.WrapperHelper

  constructor: (base, simpleFormOptions, labelOptions, wrapperOptions) ->
    # initiate options
    @base = base
    @simpleFormOptions = simpleFormOptions
    @labelOptions = labelOptions
    @options = _.defaults(
      wrapperOptions,
      {
        class: '',
        addonText: false,
        addonPosition: 'left'
      })
    @options['class'] += " form-group"

    # initiate helpers
    @formTagHelper = new JoB.Form.TagHelper()
    @tagHelper = new JoB.Lib.Tag()
    @translationHelper = new JoB.SimpleForm.TranslationHelper(@base)

  _labelText: (label) ->
    text = ""
    if _.isString(label)
      text = label
    else
      text = @translationHelper.label()
    text

  _label: () ->
    if @simpleFormOptions.label is false
      ""
    else
      @formTagHelper.labelTag(
        @base.ressourceName, @base.fieldName,
        @_labelText(@simpleFormOptions.label),
        @labelOptions
      )

  _hint: (text) ->
    @tagHelper.contentTag('span', text, {class: 'help-block'})

  _addon: (addonText) ->
    @tagHelper.contentTag('span', addonText, {class: 'input-group-addon'})

  template: (wrapperClass, label, input, icon, hint, addonText, addonPosition) ->
    html =  "<div class='#{wrapperClass}'>"
    html += label if label
    if addonText && addonPosition
      html += "<div class='input-group'>"
      if(addonPosition is 'left')
        html += "<span class='input-group-addon'>#{addonText}</span>"
      if(input)
        html += input
      if addonPosition is 'right'
        html += "<span class='input-group-addon'>#{addonText}</span>"
      html += "</div>"
    else
      if(input)
        html += input
      if(icon)
        html += "<span class='#{icon}'></span>"
      if(hint)
        html += "<span class='help-block'>#{hint}</span>"
    html += "</div>"

    html

  # Base Wrapper
  default: (inputHtml) ->
    label = @_label(@simpleFormOptions.label)
    html = @template(
      @options.class, label, inputHtml, @simpleFormOptions.icons, @simpleFormOptions.hint,
      @simpleFormOptions.addonText, @simpleFormOptions.addonPosition
    )
    html


  # Special Checkbox
  checkbox: (inputTag, labelText) ->
    "<div class='checkbox'><label>#{inputTag}#{labelText}</label></div>"

  radiobutton: (inputTag, labelText) ->
    "<div class='radio'><label>#{inputTag}#{labelText}</label></div>"

  radiobuttons: (inputs) ->
    html = ""
    _.each inputs, (input) =>
      html += @radiobutton(input, "")
    html
