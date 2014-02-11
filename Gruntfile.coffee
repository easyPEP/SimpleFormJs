module.exports = (grunt) ->

  # IMPORTS
  # ------------------------------------------------------------------------------------
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-contrib-requirejs"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "grunt-mocha"
  grunt.loadNpmTasks "grunt-smushit"

  # GLOBAL VARS
  # ------------------------------------------------------------------------------------
  path = require('path')
  lintOptions = require("./coffeelint.json").options
  devFolder = "./dev"
  productionFolder = "./production"

  # TASKS DEFINITIONS
  # ------------------------------------------------------------------------------------
  grunt.initConfig

    # Clean
    # ----------------------------------------------------------------------------------
    clean:
      all : ["#{devFolder}/*", "#{productionFolder}/*"]
      dev : ["#{devFolder}/*"]
      production : ["#{productionFolder}/*"]

    # Connect
    # ----------------------------------------------------------------------------------
    connect:
      dev:
        options:
          port: 8000
          base: "."
          keepalive: true
      test:
        options:
          port: 8000
          base: "."

    # Lint
    # ----------------------------------------------------------------------------------
    coffeelint:
      options: lintOptions
      gruntfile: ["Gruntfile.coffee"]
      sources:
        files: [
          expand: true
          cwd: "./src/app"
          src: ["**/*.coffee"]
        ]

    # Copy
    # ----------------------------------------------------------------------------------
    copy:
      dev:
        files: [
          {
            expand: true
            cwd: "./src/app/assets"
            src: ["**"]
            dest: "#{devFolder}/app/assets"
          }
          {
            expand: true
            cwd: "./src/app"
            src: ["**/*.coffee"]
            dest: "#{devFolder}/app"
          }
          {
            expand: true
            cwd: "./"
            src: ["index.html"]
            dest: "#{devFolder}/"
          }
          {
            expand: true
            cwd: "./lib/requirejs/"
            src: ["require.js"]
            dest: "#{devFolder}"
          }
        ]
      templates:
        files: [
          expand: true
          cwd: "./src/app/modules"
          src: ["**/*.html"]
          dest: "#{devFolder}/app/modules"
        ]
      fixtures:
        files: [
          {
            expand: true
            cwd: "./src/test/fixtures"
            src: ["**"]
            dest: "#{devFolder}/test/fixtures"
          }
        ]
      test:
        files: [
          {
            expand: true
            cwd: "./src/test"
            src: ["**/*.coffee"]
            dest: "#{devFolder}/test"
          }
        ]
      production:
        files: [
          {
            expand: true
            cwd: "./src/app/assets"
            src: ["**"]
            dest: "#{productionFolder}/app/assets"
          }
          {
            expand: true
            cwd: "./"
            src: ["index.html"]
            dest: "#{productionFolder}/"
          }
          {
            expand: true
            cwd: "./lib/requirejs/"
            src: ["require.js"]
            dest: "#{productionFolder}"
          }
        ]

    # Smusher
    # ----------------------------------------------------------------------------------
    smushit:
      production:
        src: "#{productionFolder}/app/assets"

    # RequireJS
    # ----------------------------------------------------------------------------------
    requirejs:
      compile:
        options:
          baseUrl: "#{devFolder}/app"
          mainConfigFile: "#{devFolder}/app/main.js"
          out: "#{productionFolder}/app/main.js"
          include: "main"

    # CoffeeScript
    # ----------------------------------------------------------------------------------
    coffee:
      dev:
        options:
          sourceMap: true
          sourceRoot: ""
        files: [
          expand: true
          cwd: "./src/"
          src: ["**/*.coffee"]
          dest: devFolder
          ext: ".js"
        ]

    # LESS
    # ----------------------------------------------------------------------------------
    less:
      dev:
        files:
          [
            src: ["./src/app/css/main.less"]
            dest: "#{devFolder}/app/css/main.css"
          ]
      production:
        options:
          yuicompress: true
        files:
          [
            src: ["./src/app/css/main.less"]
            dest: "#{productionFolder}/app/css/main.css"
          ]

    # Tests
    # ----------------------------------------------------------------------------------
    mocha:
      test:
        options:
          urls: [ "http://localhost:8000/test.html"]
          reporter : "Dot"

    # Watch
    # ----------------------------------------------------------------------------------
    watch:
      options:
        livereload: true
      templates:
        files: "./src/app/**/*.html"
        tasks: []
        options:
          nospawn: true
      coffee:
        files: "./src/**/*.coffee"
        tasks: []
        options:
          nospawn: true
      less:
        files: "./src/**/*.less"
        tasks: ["less:dev"]
      fixtures:
        files: "./src/test/**/*.html"
        tasks: ["copy:fixtures", "mocha"]

  # WATCH EVENT
  # ------------------------------------------------------------------------------------
  grunt.event.on "watch", (action, filepath) ->
    cwd = "src/"
    filepath = filepath.replace cwd, ""
    isCoffee = path.extname(filepath) == ".coffee"
    isHTML = path.extname(filepath) == ".html"
    isTest = filepath.indexOf("test/specs") >= 0

    if isHTML and not isTest
      grunt.config.set "copy",
        templates:
          files: [
            expand: true
            cwd: cwd
            src: filepath
            dest: devFolder
          ]

      grunt.task.run "copy:templates"

    if isCoffee
      grunt.config.set "coffee",
        options: lintOptions
        changed:
          expand: true
          cwd: cwd
          src: filepath
          dest: devFolder
          ext: ".js"
          options:
            sourceMap: true
            sourceRoot: ""
            livereload: true

      grunt.config.set "copy",
        newSources:
          files: [
            expand: true
            cwd: cwd
            src: filepath
            dest: devFolder
          ]

      grunt.config.set "coffeelint",
        options: lintOptions
        newSources:
          files: [
            expand: true
            cwd: cwd
            src: filepath
          ]

      grunt.task.run "coffeelint:newSources"
      grunt.task.run "coffee:changed"
      grunt.task.run "copy:newSources"

    if isTest
      grunt.task.run "mocha"

  # REGISTERED TASKS
  # ------------------------------------------------------------------------------------
  grunt.registerTask "default", [
    "dev"
    "connect:dev"
  ]

  grunt.registerTask "dev", [
    "coffeelint"
    "clean:dev"
    "coffee"
    "less:dev"
    "copy:dev"
    "copy:test"
    "copy:fixtures"
    "copy:templates"
  ]

  grunt.registerTask "production", [
    "coffeelint"
    "clean:production"
    "test"
    "less:production"
    "copy:production"
    "copy:templates"
    "requirejs"
    "smushit:production"
  ]

  grunt.registerTask "test", [
    "coffee"
    "copy:test"
    "copy:fixtures"
    "connect:test"
    "mocha"
  ]
