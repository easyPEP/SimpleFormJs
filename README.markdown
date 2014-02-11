# SimpleFormJs

Development stack to build web stuff using [Marionette](http://marionettejs.com "Marionette.js – A scalable and composite application architecture for Backbone.js"). Some other funny names involved are: [Require.js](http://requirejs.org "RequireJS"), [Bower](http://twitter.github.com/bower/ "BOWER"), [Mocha](ub.io/mocha/), [Chai](http://chaijs.com "Home - Chai"), [Grunt.js](http://gruntjs.com "grunt: a task-based command line build tool for JavaScript projects"), [LESS](http://lesscss.org "LESS &laquo; The Dynamic Stylesheet language").

## Caution

This is an extremely personal stack, with an extremely personal way of doing things. I feel comfortable doing stuff this way, but I change my mind easily. So if you have something to suggest, please do it. Fork it, change it, adapt it, enlighten me with better ways of doing things.

## Getting started

1. [Install Node.js and npm](http://nodejs.org/download/ "node.js")
2. [Install Grunt](http://gruntjs.com/getting-started "Getting started - Grunt: The JavaScript Task Runner")
3. [Install Bower](http://bower.io "BOWER: A package manager for the web")
4. Install npm dependencies: `npm install`
5. Install Bower dependencies: `bower install`
6. If you want to run the tests suite through the command line, [install PhantomJS](http://phantomjs.org/download.html "PhantomJS: Download and Install")
7. Run `grunt` (default task) and point your browser to `http://localhost:8000/dev/`
8. When your awesome app is done, run `grunt production`. Your awesome app will be under `production/` folder, ready to be deployed wherever you want

## App structure

### General

* `/bower.json`: Bower dependencies file
* `/Gruntfile.coffee`: Grunt tasks definition file
* `/package.json`: npm dependencies file

### App

* `/index.html`: Browser entry point for your application, it will be copied under `/dev` or `/production` depending on the executed build task
* `/test.html`: Tests suite runner page
* `/src/app/assets/`: Images for your app
* `/src/app/css/`: LESS files for your shiny styles
* `/src/app/app.coffee`: Application entry point. Your magnificent app will be defined and started here

#### Modules

Modules are independent parts of your app. If you divide your app in modules, like a puzzle, it will be easier to deal with, easier to test, easier to understand.

Some module examples may be: a Header or a Footer module, or on a classical TO-DO app you could have a Todo module.

On SimpleFormJs, modules are located under `/src/app/modules/`.

* `<module_name>/init.coffee`: The entry point for your module. Everything related to the module will be started up here
* `<module_name>/controllers/<controller>.coffee`: All your module controllers. Usually they will be related to CRUD operations (list, show, edit…), but you don't have to stop there, use any controller you need.
* `<module_name>/views/<view>.coffee`: Views will handle everything you see on screen and they will be saved here
* `<module_name>/template/<template>.html`: Templates for your views

### Testing

* `/src/test/specs/<spec>.coffee`: Here are the Mocha (with Chai) specs for your app
* `/src/test/fixtures/<fixture>`: If you need fixtures on your specs, put them here

## Framework

SimpleFormJs has his own micro framework on top of Backbone and Marionette. This will maximize your chances of customizing the behavior of your global objects, increasing flexibility and extension and minimizing repetition.

The framework object holding all other objects can be required through RequireJS using the dependency string `app.framework`.

```coffeescript
define ['app.framework'], (Framework) ->
	# Use framework objects at your will…
	console.log Framework.Application
	console.log Framework.Collection
	console.log Framework.Controller
	console.log Framework.ItemView
```

### Application

Extends from `Marionette.Application`.

When the application starts, a common task is to start the navigation history. With Framework.Application this is done for you. After the app has ben started, the history will be automatically started, and it will navigate to the default `rootRoute` (you can define it with `Application.history.setRootRoute`):

```coffeescript
App = new Framework.Application()
App.history.setRootRoute "sample/route"
App.start() # History will be started, and navigate to "sample/route"
```

To define the application default region (which will be used by default by controllers whithout an explicit region defined) you can use `Application.setDefaultRegion` method:

```coffeescript
App = new Framework.Application()

App.addRegions
	contentRegion: "#content-region"

App.setDefaultRegion App.contentRegion
```

Framework.Application also automatically attaches some `CommunicationBus` handlers to be used through the entire app while developing:

**Commands**

- `app:navigate`: Performs a history navigation to the given URL, passing given options (see http://backbonejs.org/#Router-navigate)

**Requests**

- `app:default:region`: Get default region for the app (defined through `setDefaultRegion()`)

### CommunicationBus

Expose all three `Backbone.Wreqr` object types: `vent`, `commands`, `reqres`. This object will be used in an app wide context to register commands, requests and listening to events… and, of course, executing and trigering them.

Since SimpleFormJs use RequireJS for modules management, I prefer having one global object to hold this messaging concerns instead of letting the modules objects or application object having their own messaging bus. This way I avoid possible circular dependencies (App requires ModuleA, and ModuleA wants to speak with App, so it has to require it… blah blah blah).

### Controller

Extends from `Marionette.Controller`.

If you need to show a View inside the region associated with your controller, use `show` method. It will liste to the close event on that view to close the controller as well.

```coffeescript
class FirstController extends Framework.Controller
	initialize: ->
		@show new FirstView
```

Controllers should have an associated `region` that you pass to them on instantiation. If you don't do it, they will look for the default region (it can be defined with your `Framework.Application` through its `setDefaultRegion` method)

```coffeescript
# Create application
App = new Framework.Application()

# Define app regions
App.addRegions
	headerRegion: "#header-region"
	contentRegion: "#content-region"

# Set default region and start app
App.setDefaultRegion App.contentRegion
App.start()

# Instanciate controller with region
controller1 = new SampleController1 region : App.headerRegion

# Instanciate controller without region
controller2 = new SampleController2

# Check regions
console.log controller1.region # => headerRegion
console.log controller2.region # => contentRegion
```
### Entities

This is not an instantiable class, but it defines some commands and make some changes to Backbone methods.

A global `when:fetched` command is defined, and should be used to execute a callback when a list of entities have ended fetching data from server:

```coffee
sampleModel1.fetch()
sampleModel2.fetch()

CommunicationBus.commands.execute 'when:fetched', [sampleModel1, sampleModel2], ->
	console.log 'Yayyy, both models have been fetched!!!'
```

This module also attach some custom events to Models and Collections:

- `sync:start`: this event will fire on the entity before it begins the communication with his source
- `sync:stop`: this event will fire on the entity when the communication with his source has ended

### Collection

Extends from `Backbone.Collection`.

### Model

Extends from `Backbone.Model`.

### Module

Expose a class to be used to create modules. Instances of this class will have some utility methods to work with the CommunicationBus directly:


- `setCommands`: Will create a CommunicationBus command for each item on the object given to the method. The `key` will be the command name, and the `value` will be the function to be executed.
- `setRequests`: Will create a CommunicationBus request for each item on the object given to the method. The `key` will be the request name, and the `value` will be the function to be executed.
- `setEvents`: Will create a CommunicationBus event listener for each item on the object given to the method. The `key` will be the event name, and the `value` will be the function to be executed.
- `resetCommands`: Remove all the commands attached by the module
- `resetRequests`: Remove all the requests attached by the module
- `resetEvents`: Remove all the events attached by the module

And also other util methods:

- `close`: Remove all messaging handlers attached by the methods explained above
- `setRoutes`: Create a new Framework.Router with the given routes object

Example:

```coffeescript
# Define the class extending from Framework.Module
# and setting one command, one request and one event
class ModuleName extends Framework.Module
	initialize:
		@setCommands
			"command:name": -> console.log "OH"

		@setRequests
			"request:name": -> return "MY"

		@setEventsevents
			"event:name": -> console.log "GOD!!!!"

# Instanciation will cause the creation of every
# command, request and event of your module
module = new ModuleName

# So you can execute them later
CommunicationBus.commands.execute "command:name" # "OH"
CommunicationBus.reqres.request "request:name" # "MY"
CommunicationBus.vent.trigger "command:name" # "GOD!!!!"

# And if you reset the commands with resetCommands(), they will dissapear
module.resetCommands()
CommunicationBus.commands.execute "command:name" # Handler not found!

# Or you can close() the module, and all module messaging handlers will dissappear
module.close()
CommunicationBus.reqres.request "request:name" # Handler not found!
CommunicationBus.vent.trigger "command:name" # Nothing happens…
```

### Router

Extends from `Marionette.AppRouter`.

### Views

#### CollectionView

Extends from `Marionette.CollectionView`.

#### CompositeView

Extends from `Marionette.CompositeView`.

#### ItemView

Extends from `Marionette.ItemView`.

#### Layout

Extends from `Marionette.Layout`.

## Grunt tasks

* `default`: Runs `dev` task and start an HTTP server using `connect:dev` task
* `dev`: Cleans `/dev`, compiles CoffeScript and LESS files under `/src` to `/dev`
* `production`: Cleans `/production`, compiles CoffeScript files under `/src` to `/dev`, runs the tests suite, compiles LESS files under `/src` to `/production` and optimize all JS files under `/dev` to `/production` using RequireJS
* `test`: compiles CoffeScript files under `/src` to `/dev`, launch an HTTP server using `connect:test` task and run all tests under `/dev/test`
* `watch`: Watches changes on CoffeeScript and LESS files to run appropiate tasks (for test files you should have a running test HTTP server with `grunt connect:dev` or `grunt` default task)

My preferred way of using these tasks for development is with three panes on my terminal. The first one with `grunt` (it will start everything up, including the HTTP server), second one with `grunt watch` (which will look for changes on my files) and the third one with my `$EDITOR`.

## Thanks

Huge thanks to [@derickbailey](https://github.com/derickbailey) for creating [Marionette](http://marionettejs.com "Marionette.js – A scalable and composite application architecture for Backbone.js"), and [@brian-mann](https://github.com/brian-mann) for his [BackboneRails](http://www.backbonerails.com "BackboneRails.com - Screencasts and Tutorials") screencast series.

And, of course, thanks a lot to the contributors:

* [@abovethewater](https://github.com/abovethewater)
* [@cockers](https://github.com/cockers)