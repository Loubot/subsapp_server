'use strict'

angular.module('subzapp').controller('RegisterManagerController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  '$location'
  'RESOURCES'
  ( $scope, $state, $http, $window, message, $location, RESOURCES ) ->
    console.log 'Register Manager Controller'
    $scope.register_manager_form_data = $location.search()

    console.log $scope.register_manager_form_data

    $scope.register_submit = ->
      $scope.register_manager_form_data.team_admin = true
      $scope.register_manager_form_data.team_id = $location.search().id
      console.log $scope.register_manager_form_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/auth/team_manager_signup"
        data: $scope.register_manager_form_data
      ).then ( (response) ->
        console.log "Registration successfull #{ JSON.stringify response }"
        window.localStorage.setItem 'user_token', response.data.data.token
        # console.log "user_token " + window.localStorage.getItem 'user_token'
        window.localStorage.setItem 'user_id', response.data.data.user.id
        $state.go 'org'
      ), ( errResponse ) ->
        console.log "Registration failed "
        setTimeout ( ->
          $state.go 'login' 
        ), 5000
        console.log errResponse
        console.log errResponse.data.invalidAttributes.email[0].message        
       
        message.error errResponse.data.invalidAttributes.email[0].message
       
        
])