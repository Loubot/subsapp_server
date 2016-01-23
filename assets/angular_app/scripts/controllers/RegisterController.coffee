'use strict'

angular.module('subzapp').controller('RegisterController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'alertify'
  'RESOURCES'
  ( $scope, $state, $http, $window, alertify, RESOURCES ) ->
    console.log 'Register Controller'

    $scope.register_submit = ->
      $scope.register_form_data.club_admin = true
      $scope.register_form_data.team_admin = true
      console.log $scope.register_form_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/auth/signup"
        headers: {
                  'Content-Type': 'application/json'
                  }
        data: $scope.register_form_data
      ).then ( (response) ->
        console.log "Registration successfull #{ JSON.stringify response }"
        window.localStorage.setItem 'user_token', response.data.data.token
        # console.log "user_token " + window.localStorage.getItem 'user_token'
        window.localStorage.setItem 'user_id', response.data.data.user.id
        $state.go 'org_admin'
      ), ( errResponse ) ->
        console.log "Registration failed "
        setTimeout ( ->
          $state.go 'login' 
        ), 5000
        console.log errResponse
        console.log errResponse.data.invalidAttributes.email[0].message        
       
        alertify.error errResponse.data.invalidAttributes.email[0].message
       
        
])