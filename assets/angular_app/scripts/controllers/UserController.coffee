'use strict'

angular.module('subzapp').controller('UserController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'RESOURCES'
  ( $scope, $state, $http, $window, RESOURCES ) ->
    console.log 'User Controller'
    user_object = JSON.parse window.localStorage.getItem 'logged_in_user'
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/user"
      headers: { 'Authorization': "JWT #{ user_object.token }", "Content-Type": "application/json" }
    ).success( (data) ->
      console.log "Fetched user data #{ JSON.stringify data[0].email }"
      $scope.user = data[0] 
    ).error (err) ->
      console.log "Fetching user data error #{ JSON.stringify err }"
])