#Global variable for logged in user

window.USER = null

# See user service

'use strict'

angular.module('subzapp', [
    'ngAnimate'
    'ui.router'
    'ngRoute'
    'ui.bootstrap.datetimepicker'
    "ngAlertify"
    'ngFileUpload'
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
      url : "/user/edit"
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

    $stateProvider.state "register_manager",
      url : '/register-manager'
      templateUrl : 'angular_app/views/register/register_manager.html'
      controller : 'RegisterManagerController'

    # busniess state
    $stateProvider.state "org",
      url : '/org'
      templateUrl : 'angular_app/views/org/org.html'
      controller : 'OrgController'

    $stateProvider.state "org_admin",
      url: '/org_admin'
      templateUrl : "angular_app/views/org/org_admin.html"
      controller : 'OrgAdminController'

    $stateProvider.state "org_admin_team",
      url: '/org_admin_team'
      templateUrl : "angular_app/views/org/org_admin_team.html"
      controller : 'OrgAdminTeamController'

    # team state
    $stateProvider.state "team",
      url : '/team'
      templateUrl : 'angular_app/views/team/team.html'
      controller : 'TeamController'

    $stateProvider.state 'team_manager_home',
      url: '/team-manager-home'
      templateUrl : 'angular_app/views/team/team_manager_home.html'
      controller : 'TeamController'

      
    $stateProvider.state 'team_manager',
      url: '/team-manager'
      templateUrl : 'angular_app/views/team/team_manager.html'
      controller : 'TeamController'

    $stateProvider.state 'event',
      url: '/event'
      templateUrl : 'angular_app/views/event/event.html'
      controller : 'EventController'

    $stateProvider.state 'password-reminder',
      url: '/password/remind'
      templateUrl : 'angular_app/views/password_reminder/password_reminder.html'
      controller : 'PasswordReminderController'

    $stateProvider.state 'password-reset',
      url: '/password/reset'
      templateUrl : 'angular_app/views/password_reminder/password_reset.html'
      controller : 'PasswordReminderController'



angular.module('subzapp').constant 'RESOURCES', do ->
  # Define your variable
  console.log "url" + window.location.origin 
  url = window.location.origin 
  # url = "https://subzapp.herokuapp.com"
  # Use the variable in your constants
  {
    DOMAIN: url
    # USERS_API: resource + '/users'
    # BASIC_INFO: resource + '/api/info'
  }
  
  

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
        # console.log "Fetched user data"
        # console.log data
        if !(data?)
          $state.go 'login'
          console.log "No user data"
          return false
        else
          console.log "Got user"
          # console.log data
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
