#Global variable for logged in user

window.USER = null

# See user service

'use strict'

angular.module('subzapp', [
    'ngAnimate'
    'ui.router'
    'ngRoute'
    'ui.bootstrap.datetimepicker'
])

angular.module('subzapp').constant('API', 'api/v1/')

#routes, using angular-ui-router
angular.module('subzapp').config ($stateProvider, $urlRouterProvider) ->

    $urlRouterProvider.otherwise "/"

    $stateProvider.state "user",
      url : "/user"
      templateUrl : 'angular_app/views/user/user.html'
      controller : "UserController"

    $stateProvider.state "edit-user",
      url : "/edit-user"
      templateUrl : 'angular_app/views/user/edit_user.html'
      controller : "EditUserController"

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
    $stateProvider.state "org",
      url : '/org'
      templateUrl : 'angular_app/views/org/org.html'
      controller : 'OrgController'

    # team state
    $stateProvider.state "team",
      url : '/team'
      templateUrl : 'angular_app/views/team/team.html'
      controller : 'TeamController'


angular.module('subzapp').constant 'RESOURCES', do ->
  # Define your variable
  console.log "url" + window.location.origin 
  url = window.location.origin 
  # Use the variable in your constants
  {
    DOMAIN: url
    # USERS_API: resource + '/users'
    # BASIC_INFO: resource + '/api/info'
  }

angular.module('subzapp').factory 'message', ->
  error: (mes) ->
    $('.message').removeClass 'success_message'
    $('.message').addClass 'error_message'
    $('.message').text mes
    $('.message').show 'slide', { direction: 'right' }, 1000
    # alert "This is an error #{ mes }"
    # return
  success: ( mes ) ->
    $('.message').removeClass 'error_message'
    $('.message').addClass 'success_message'
    $('.message').text mes
    $('.message').show 'slide', { direction: 'right' }, 1000
  

angular.module('subzapp').service 'user', ($http, $state, RESOURCES ) ->
  console.log "user service"
  {
    get_user: ->
      
      console.log "yyyyyyyyyyyyyyyyyyy"
      user_token = window.localStorage.getItem 'user_token'
      id = window.localStorage.getItem 'user_id'

      # console.log " token #{ user_token }"
      # console.log "id #{ id }"
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/user/#{ id }"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      ).success( (data) ->
        # console.log "Fetched user data #{ JSON.stringify data }"
        if !(data?)
          $state.go 'login'
          console.log "No user data"
          return false
        else
          window.USER = data
          return data
        
      ).error (err) ->
        console.log "Fetching user data error #{ JSON.stringify err }"
        $state.go 'login'
  }
    


# angular.module('subzapp').service 'params', ->
#   property = null
#   {
#     getProperty: ->
#       property
#     setProperty: (value) ->
#       property = value
#       return

#   }
