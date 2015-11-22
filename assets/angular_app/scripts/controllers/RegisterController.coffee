'use strict'

angular.module('subzapp').controller('RegisterController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'RESOURCES'
  ( $scope, $state, $http, $window, RESOURCES ) ->
    console.log 'Register Controller'

    $scope.register_submit = ->
      $http.post("#{ RESOURCES.DOMAIN }/auth/signup", $scope.register_form_data).success( (data) ->
        console.log "Registry attempt return #{ JSON.stringify data }"
        window.localStorage.setItem 'logged_in_user', JSON.stringify data
        $state.goto '/user'
      ).error (err) ->
        console.log "Register error #{ JSON.stringify err }"
])