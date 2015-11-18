window.logged_in_user = null

window.subzapp_server = angular.module('subzapp_server', [ 'ngRoute', 'ngAnimate' ])
angular.module('subzapp_server.controllers', [])
myApp.config ($routeProvider) ->
  $routeProvider.when('/',
    # controller: 'login_controller'
    templateUrl: 'views/login/login.html').when('/register',
    # controller: 'register_controller',
    templateUrl: 'views/register/register.html').when('/user',
    # controller: 'users_controller', 
    templateUrl: 'views/user/user.html')





myApp.constant 'RESOURCES', do ->
  # Define your variable
  url = 'http://localhost:1337'
  # Use the variable in your constants
  {
    DOMAIN: url
    # USERS_API: resource + '/users'
    # BASIC_INFO: resource + '/api/info'
  }












  # init()
  # return
$(document).ready ->
  # $('body').css 'width', window.innerWidth()
  


  


  #
  
  