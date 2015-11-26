'use strict'

angular.module('subzapp', [
    'ngAnimate'
    'ui.router'
    'ngRoute'
])

angular.module('subzapp').constant('API', 'api/v1/')

#routes, using angular-ui-router
angular.module('subzapp').config ($stateProvider, $urlRouterProvider) ->

    $urlRouterProvider.otherwise "/"

    $stateProvider.state "user",
      url : "/user"
      templateUrl : 'angular_app/views/user/user.html'
      controller : "UserController"

    # login state
    $stateProvider.state "login",
      url : "/"
      templateUrl : 'angular_app/views/login/login.html'
      controller : "LoginController"
    
    # register state
    $stateProvider.state "register",
      url : '/register'
      templateUrl : 'angular_app/views/register/register.html'
      controller: 'RegisterController'

    # busniess state
    $stateProvider.state "business",
      url : '/business'
      templateUrl : 'angular_app/views/business/business.html'
      controller : 'BusinessController'


angular.module('subzapp').constant 'RESOURCES', do ->
  # Define your variable
  url = 'http://localhost:1337'
  # Use the variable in your constants
  {
    DOMAIN: url
    # USERS_API: resource + '/users'
    # BASIC_INFO: resource + '/api/info'
  }

angular.module('subzapp').factory 'message', ->
  { error: (mes) ->
    $('.login_error').text mes
    $('.login_error').show 'slide', { direction: 'right' }, 1000
    # alert "This is an error #{ mes }"
    # return
 }