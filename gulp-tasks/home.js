var gulp = require('gulp'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    elixir      = require('laravel-elixir'),
    gutil       = require('gulp-util'),
    compass     = require('gulp-compass'), //https://www.npmjs.com/package/gulp-compass
    minifyCss   = require('gulp-minify-css'),
    babel       = require('gulp-babel'),
    strip = require('gulp-strip-comments'),
    modernizr   = require('gulp-modernizr'),
    sass        = require('gulp-ruby-sass'),
    webpackStream = require('webpack-stream'),
    env = require("../environment.config"),
    webpack = require('webpack'),
    path = require('path'),
    requireFile = require('gulp-require-file');
var removeFile = require('gulp-clean');
var Task       = elixir.Task;
var assets = {
  input: {
    output:{
      jsPath: 'public/js',
      jsDesktop: 'home.js',
      jsProductionPath: 'dist'
    },
    desktop: {
      js: 'resources/assets/js/components/index.cjsx',
    }
  }
}

elixir.extend('home_app', function(message){
  new Task('home-scripts',function(){
    return gulp.src(assets.input.desktop.js)
      .pipe(webpackStream({
        output: {
          filename: assets.input.output.jsDesktop
          },
        module: {
          loaders: env.environment.loaders
        },
        plugins: env.environment.plugins,
      })).on('error',console.log)
      .pipe(gulp.dest(gutil.env.production !== undefined && gutil.env.production ? assets.input.output.jsProductionPath : assets.input.output.jsPath));
  }).watch(['resources/assets/**/*.cjsx','resources/assets/modules/**/*.scss']);
})
