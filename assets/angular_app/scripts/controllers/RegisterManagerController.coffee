'use strict'

angular.module('subzapp').controller('RegisterManagerController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'alertify'
  '$location'
  'RESOURCES'
  'COMMS'
  ( $scope, $state, $http, $window, alertify, $location, RESOURCES, COMMS ) ->
    console.log 'Register Manager Controller'
    $scope.register_manager_form_data = $location.search()

    console.log $location.search()

    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/get-invite"
      headers: { 
                  'Content-Type': 'application/json'
                }
      params:
        invite_id: $location.search().id
    ).then ( ( response ) ->
      console.log "Get invite response"
      console.log response.data
      window.localStorage.setItem 'team_id', response.data.team_id
      $scope.register_manager_form_data = response.data
      $scope.register_manager_form_data.invited_email = response.data.invited_email
      $scope.team_id = response.data.team_id

    ), ( errResponse ) ->
      console.log "Get invite error"
      console.log errResponse

    $scope.register_manager_submit = ->
      console.log JSON.stringify $scope.register_manager_form_data
      $scope.register_manager_form_data.team_admin = true
      $scope.register_manager_form_data.team_id = $scope.team_id
      $scope.register_manager_form_data.email = $scope.register_manager_form_data.invited_email
      delete $scope.register_manager_form_data.invited_email
      
      console.log $scope.register_manager_form_data
      COMMS.POST(
        "/auth/signup/team_manager"
        $scope.register_manager_form_data
      ).then ( (response) ->
        console.log "Registration successfull "
        console.log response
        window.localStorage.setItem 'user_token', response.data.token
        # console.log "user_token " + window.localStorage.getItem 'user_token'
        window.localStorage.setItem 'user_id', response.data.user.id
        $state.go 'team_manager'
      ), ( errResponse ) ->
        console.log "Registration failed "
        alertify.error "Registration failed #{ JSON.stringify errResponse }"
        setTimeout ( ->
          $state.go 'login' 
        ), 5000
        console.log errResponse
            
       
        # message.error errResponse.data.invalidAttributes.email[0].message
       
        
])