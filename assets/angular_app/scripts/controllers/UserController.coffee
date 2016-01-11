'use strict'

angular.module('subzapp').controller('UserController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  'user'
  'RESOURCES'
  ( $scope, $state, $http, $window, message, user, RESOURCES ) ->
    console.log 'User Controller'
    
    user.get_user().then ( (res) ->
      console.log "Got user "
      console.log window.USER              
      $scope.teams = window.USER.teams

      
    )

])
