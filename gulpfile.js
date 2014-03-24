//

var gulp         = require('gulp'),
    gutil        = require('gulp-util'),
    autoprefixer = require('gulp-autoprefixer'),
    jshint       = require('gulp-jshint'),
    uglify       = require('gulp-uglify'),
    rename       = require('gulp-rename'),
    clean        = require('gulp-clean'),
    concat       = require('gulp-concat'),
    notify       = require('gulp-notify'),
    cache        = require('gulp-cache'),
    livereload   = require('gulp-livereload'),
    coffee       = require('gulp-coffee'),
    lr           = require('tiny-lr'),
    mocha        = require('gulp-mocha'),
    http         = require('http'),
    ecstatic     = require('ecstatic'),
    server       = lr(),
    paths        = {};


paths.javascripts = [
  './bower_components/jquery/jquery.js',
  './bower_components/underscore/underscore.js',
  './bower_components/backbone/backbone.js',
  './bower_components/JoB/dist/job.js'
]

gulp.task('javascripts', function() {
  return gulp.src(paths.javascripts)
    .pipe(concat('dependencies.js'))
    .pipe(gulp.dest('./dist/'))
    .pipe(notify({ message: 'javascripts task complete' }));
});

paths.coffeescripts = [
  './src/simple_form.coffee',
  './src/lib/translation_helper.coffee',
  './src/lib/wrapper_helper.coffee'
]

gulp.task('coffeescripts', function() {
  return gulp.src(paths.coffeescripts)
    .pipe(concat('simple_form.coffee'))
    .pipe(gulp.dest('./dist/')) // make the source available
    .pipe(coffee({bare: true, sourceMap: true}).on('error', gutil.log))
    .pipe(gulp.dest('./dist/'))
    .pipe(notify({ message: 'coffeescripts task complete' }));
});

//////////////////////////////////////////
// SERVER SETUP
gulp.task('server', function(){
  // App server
  http.createServer(
    ecstatic({ root: __dirname + '/' })
  ).listen(8080);
  console.log('Server listening on http://localhost:8080');
});

//////////////////////////////////////////
// TEST SETUP
paths.specFiles = ["./src/test/specs/**/*.coffee"]
paths.specMain = ["./src/test/main.coffee"]
gulp.task('specs', function () {
  gulp.src(paths.specMain)
    .pipe(coffee({bare: true}).on('error', gutil.log))
      .pipe(gulp.dest('./dist/test'))
        .pipe(notify({ message: 'Scripts task complete' }));

  return gulp.src(paths.specFiles)
          .pipe(coffee({bare: true}).on('error', gutil.log))
            .pipe(gulp.dest('./dist/test/specs/'))
})

// Rerun the task when a file changes
gulp.task('watch', function () {
  gulp.watch(paths.scripts,       ['scripts']       );
  gulp.watch(paths.coffeescripts, ['coffeescripts'] );
  gulp.watch(paths.specFiles,     ['specs']         );
});

gulp.task('default', [
                      'javascripts',
                      'coffeescripts',
                      'specs',
                      'server',
                      'watch'
                     ]);
