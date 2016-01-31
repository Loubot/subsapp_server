var gulp = require('gulp');
var gutil = require('gulp-util');
var clean = require('gulp-clean');
var watch = require('gulp-watch');
var plumber = require('gulp-plumber');
var debug = require('gulp-debug');
var coffee = require('gulp-coffee');
var runSeq = require('run-sequence');


gulp.task('coffee_compile_1', function() {
  gulp.src('./assets/angular_app/scripts/controllers/*.coffee')
    .pipe(plumber())
    .pipe(coffee({bare:true}).on('error', gutil.log))
    .pipe(gulp.dest('./output_folder_1'));
});


// gulp.task('coffee_compile', function() {
//   gulp.src('.assets/angular_app/scripts/controllers/*.coffee').pipe(plumber()).pipe(coffee{})

// });