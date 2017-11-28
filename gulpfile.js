var gulp = require('gulp'),
    elixir = require('laravel-elixir'),
    util = require('gulp-util').env,
    Task = elixir.Task;

require('./gulp-tasks/home');

elixir(function(mix){
  var page = util.page === undefined ? undefined : util.page.split(',');
  var build = page === undefined ? [
    'home_app'
  ] : page;
  for(var i=0;i<= build.length-1;i++){
      if(typeof mix[build[i]] == 'function'){
          mix[build[i]]();
      }
  }
});
