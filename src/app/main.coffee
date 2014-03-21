require.config
  baseUrl: './dev/app'
  paths:
    'text': '/bower_components/requirejs-text/text'
    'jquery': '/bower_components/jquery/jquery'
    'underscore': '/bower_components/underscore-amd/underscore'

    'prism': '/bower_components/prism/prism'
    'coffeescript': '/bower_components/prism/components/prism-coffeescript.min'
    'simple_form': './simple_form'

require ['jquery', 'underscore', 'prism', 'coffeescript', 'simple_form'], ($) ->
  $ ->
    Prism.highlightAll()

    content = "<form class='form-horizontal'>
                <%= sf.input('user', 'name') %>
                <%= sf.input('user', 'password', {as: 'password'}) %>
                <%= sf.input('user', 'email', {as: 'email'}) %>
                <%= sf.input('user', 'gender', {collection: ['Male', 'Female']}) %>
                <%= sf.input('user', 'comment', {placeholder: 'write comment here', as: 'text'}) %>
                <%= sf.input('user', 'accept', {label: 'Accept Terms of Service', as: 'checkboxes'}) %>
                <%= sf.input('user', 'awesomeness', {as: 'radiobuttons', collection: awesomeness}) %>
                <%= sf.button('submit') %>
              </form>"

    data =
      sf: new ST.SimpleForm()
      awesomeness: [[0, 'bad'], [1, 'medium'], [1, 'awesome']]
    $("#eg-one").html _.template(content, data)
