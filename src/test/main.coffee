require.config
  baseUrl: './dist/test'
  paths:
    'dependencies': '/dist/dependencies'
    'simple_form': '/dist/simple_form'

    'chai' : '/bower_components/chai/chai'
    'sinon-chai' : '/bower_components/sinon-chai/lib/sinon-chai'
    'sinon' : '/bower_components/sinon/index'
    'js-fixtures' : '/bower_components/js-fixtures/index'
    'expect' : '/bower_components/expect/expect'
    'specs' : '/dist/test/specs'
  #shim:
  #  'backbone': ['jquery']

require [
  'chai'
  'sinon-chai'
  'sinon'
  'js-fixtures'
  'expect'
  'js-fixtures'
  'dependencies'
  'simple_form'
], (chai, sinonChai, fixtures) ->
  mocha.setup 'bdd'
  chai.use sinonChai
  chai.should()
  fixtures.path = './dist/test/fixtures/'

  require [
    './specs/value_spec'
    './specs/collection_spec'
    './specs/wrapper_spec'
    './specs/label_spec'
    './specs/controls_spec'
  ], ->

    mocha.run()

# 'chai' : '/bower_components/chai/chai'
# 'sinon-chai' : '/bower_components/sinon-chai/lib/sinon-chai'
# 'sinon' : '/bower_components/sinon/index'
# 'expect' : '/bower_components/expect/expect'
# 'js-fixtures' : '/bower_components/js-fixtures/index'
# 'specs' : '/dev/test/specs'
