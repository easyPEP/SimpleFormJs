require.config
  baseUrl: './src/test'
  paths:
    'text': '/bower_components/requirejs-text/text'
    'jquery': '/bower_components/jquery/jquery'
    'underscore': '/bower_components/underscore-amd/underscore'
    'simple_form': '/src/app/simple_form'

    'chai' : '/bower_components/chai/chai'
    'sinon-chai' : '/bower_components/sinon-chai/lib/sinon-chai'
    'sinon' : '/bower_components/sinon/index'
    'expect' : '/bower_components/expect/expect'
    'js-fixtures' : '/bower_components/js-fixtures/index'
    'specs' : '/src/test/specs'
  #shim:
  #  'backbone': ['jquery']

require [
  'chai'
  'sinon-chai'
  'js-fixtures'
  'expect'
  'sinon'
  'jquery'
  'underscore'
  'simple_form'
], (chai, sinonChai, fixtures) ->
  mocha.setup 'bdd'
  chai.use sinonChai
  chai.should()
  fixtures.path = './src/test/fixtures/'

  require [
    './specs/collection_spec'
    './specs/wrapper_spec'
    './specs/label_spec'
    './specs/controls_spec'
  ], ->

    mocha.run()