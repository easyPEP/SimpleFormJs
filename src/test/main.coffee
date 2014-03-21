require.config
  baseUrl: './dist/test'
  paths:
    'dependencies': '/dist/dependencies'
    'simple_form': '/dist/simple_form'

    'chai' : '/bower_components/chai/chai'
    'sinon-chai' : '/bower_components/sinon-chai/lib/sinon-chai'
    'sinon' : '/bower_components/sinon/index'
    'fixtures' : '/bower_components/fixtures/fixtures'
    'specs' : '/dist/test/specs'

require [
  'chai'
  'sinon-chai'
 'fixtures'
 'sinon'
  'dependencies'
  'simple_form'
], (chai, sinonChai, fixtures) ->
  mocha.setup 'bdd'
  chai.use sinonChai
  chai.should()
  fixtures.path = './src/test/fixtures/'

  require [
    './specs/value_spec'
    './specs/collection_spec'
    './specs/wrapper_spec'
    './specs/label_spec'
    './specs/controls_spec'
  ], ->

    mocha.run()
