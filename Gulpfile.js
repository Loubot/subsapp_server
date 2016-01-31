var gulp = require('gulp');
var gutil = require('gulp-util');
var clean = require('gulp-clean');
var watch = require('gulp-watch');
var plumber = require('gulp-plumber');
var debug = require('gulp-debug');
var coffee = require('gulp-coffee');
var runSeq = require('run-sequence');
var sourcemaps = require('gulp-sourcemaps');


gulp.task('coffee_compile_1', function() {
  gulp.src('./assets/angular_app/scripts/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(plumber())
    .pipe(coffee({bare:true}).on('error', gutil.log))
    .pipe(sourcemaps.write('./maps/'))
    .pipe(gulp.dest('./assets/js/'));
});

gulp.task('watch', ['coffee_compile_1'], function() {
  gulp.watch('./assets/angular_app/scripts/controllers/*.coffee', ['coffee_compile_1']);
});