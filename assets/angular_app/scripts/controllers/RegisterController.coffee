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
      $scope.register_form_data.manager_access = true
      console.log $scope.register_form_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/auth/signup"
        data: $scope.register_form_data
      ).then ( (response) ->
        console.log "Registration successfull #{ JSON.stringify response }"
        window.localStorage.setItem 'user_token', response.data.data.token
        # console.log "user_token " + window.localStorage.getItem 'user_token'
        window.localStorage.setItem 'user_id', response.data.data.user.id
        $state.go 'user'
      ), ( errResponse ) ->
        console.log "Registration failed "
        console.log errResponse
        window.USER = null
        message.error errResponse
       

])