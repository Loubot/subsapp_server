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
    "checklist-model"
    'angularSpinner'
    'uiGmapgoogle-maps'
])

angular.module('subzapp').config (uiGmapGoogleMapApiProvider) ->
  uiGmapGoogleMapApiProvider.configure
    key: 'AIzaSyCwEGjP02TnzKzlAHNeLD8M_7cMw0fPATM'
    v: '3.23'
    libraries: 'weather,geometry,visualization,places'
  

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
      url: '/org-admin-team'
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
  
  

angular.module('subzapp').service 'user', ($http, $state, RESOURCES, $rootScope, alertify ) ->
  console.log "user service"
  {

    check_if_org_admin: ( user, id ) -> #check if user is org admin of club referenced by id
      return parseInt( user.orgs[0].id ) == parseInt( id )

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
        console.log "Fetched user data"
        console.log data
        if !(data?)
          $state.go 'login'
          console.log "No user data"
          return false
        else
          console.log "Got user"
          if data.length <= 0
            alertify.error "No user data"
            $state.go 'login'
            return false
          $rootScope.USER = data
          return data
        
      ).catch (err) ->
        console.log "Fetching user data error #{ JSON.stringify err }"
        $state.go 'login'
  }
    
angular.module('subzapp').service 'COMMS', ( $http, $state, RESOURCES, $rootScope, $q, usSpinnerService ) ->
  console.log "comms service"
  user_token = window.localStorage.getItem 'user_token'
  POST: ( url, data ) ->
    usSpinnerService.spin('spinner-1')
    $q ( resolve, reject ) ->
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }#{ url }"
        headers: { 
                    'Authorization': "JWT #{ user_token }"
                    "Content-Type": "application/json"
                  }
        data: data
      ).then( ( result ) ->
        usSpinnerService.stop('spinner-1')
        if result.user != undefined
          $rootScope.USER = result.user
        resolve result
      ).catch( ( err_result ) ->
        usSpinnerService.stop('spinner-1')
        reject err_result
      )
        

  GET: ( url, data ) ->
    usSpinnerService.spin('spinner-1')
    $q ( resolve, reject ) ->
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }#{ url }"
        headers: { 
                    'Authorization': "JWT #{ user_token }"
                    "Content-Type": "application/json"
                  }
        params: data
      ).then( ( result ) ->
        usSpinnerService.stop('spinner-1')
        resolve result
      ).catch( ( err_result ) ->
        usSpinnerService.stop('spinner-1')
        reject err_result
      )

  DELETE: ( url, data ) ->
    usSpinnerService.spin('spinner-1')
    $q ( resolve, reject ) ->
      $http(
        method: 'DELETE'
        url: "#{ RESOURCES.DOMAIN }#{ url }"
        headers: { 
                    'Authorization': "JWT #{ user_token }"
                    "Content-Type": "application/json"
                  }
        data: data 
      ).then( ( deleted ) ->
        usSpinnerService.stop('spinner-1')
        resolve deleted
      ).catch( ( err_deleting ) ->
        usSpinnerService.stop('spinner-1')
        reject err_deleting
      )
