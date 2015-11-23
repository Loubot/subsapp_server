'use strict'

angular.module('subzapp').controller('UserController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'RESOURCES'
  ( $scope, $state, $http, $window, RESOURCES ) ->
    console.log 'User Controller'
    user_token = JSON.parse window.localStorage.getItem 'user_token'
    
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/user"
      headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    ).success( (data) ->
      console.log "Fetched user data #{ JSON.stringify data }"
      $scope.user = data[0] 
    ).error (err) ->
      console.log "Fetching user data error #{ JSON.stringify err }"
      $state.go 'login'
])