module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffee: {
      coffee_to_js: {
        options: {
          bare: true,
          sourceMap: true
        },
        expand: true,
        flatten: false,
        cwd: "assets",
        src: ["**/*.coffee"],
        dest: 'assets',
        ext: ".js"
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-coffee');
  // return grunt.registerTask('compile', ['coffee']);
};
