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

    console.log $location.search()

    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/get-invite"
      params:
        invite_id: $location.search().id
    ).then ( ( response ) ->
      console.log "Get invite response"
      console.log response
      $scope.register_manager_form_data.invited_email = response.data.invited_email
      $scope.team_id = response.data.team_id

    ), ( errResponse ) ->
      console.log "Get invite error"
      console.log errResponse

    $scope.register_manager_submit = ->
      console.log JSON.stringify $scope.register_manager_form_data
      $scope.register_manager_form_data.team_admin = true
      $scope.register_manager_form_data.team_id = $scope.team_id
      
      console.log $scope.register_manager_form_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/auth/team_manager_signup"
        data: $scope.register_manager_form_data
      ).then ( (response) ->
        console.log "Registration successfull "
        console.log response
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
            
       
        # message.error errResponse.data.invalidAttributes.email[0].message
       
        
])