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
        class: 'form-group',
        addonText: false,
        addonPosition: 'left'
      })

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

  # Base Wrapper
  default: (inputHtml) ->
    html = ""
    # input-group
    html += "<div class='#{@options.class}'>"
    if @options.addonText is false
      html +=   @_label(@simpleFormOptions.label)
      html +=   inputHtml
    else
      html += @_label(@simpleFormOptions.label)
      html += "<div class='input-group'>"
      if @options.addonPosition is 'left'
        html += @inputHtmlAddon(@options.addonText)
        html += inputHtml
      else
        html += inputHtml
        html += @_addon(@options.addonText)
      html += '</div>'
    html += @_hint(@simpleFormOptions.hint) if _.isEmpty("#{@simpleFormOptions.hint}") is not true
    html += '</div>'
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
