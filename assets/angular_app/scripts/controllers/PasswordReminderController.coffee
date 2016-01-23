'use strict'

angular.module('subzapp').controller('PasswordReminderController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'user'
  '$location'
  'RESOURCES'
  'alertify'
  ( $scope, $state, $http, $window, user, $location, RESOURCES, alertify ) ->
    console.log 'PasswordReminder Controller'
    user_token = window.localStorage.getItem 'user_token'
    remind_password_token = $location.search().remind_password_token

   # $http(
   #    method: 'GET'
   #    url: "#{ RESOURCES.DOMAIN }/get_reset"
   #    params:
   #      remind_password_token: $location.search().remind_password_token
   #  ).then ( ( response ) ->
   #    console.log "Get Reset response"
   #    console.log response.data
   #    # $scope.register_manager_form_data = response.data
   #    # $scope.register_manager_form_data.invited_email = response.data.invited_email
   #    $scope.post_reset_form_data = response.data
   #    $scope.post_reset_form_data.email = response.data.email
   #    $scope.post_reset_form.remind_password_token = response.data.remind_password_token

   #  ), ( errResponse ) ->
   #    console.log "Get Reset error"
   #    console.log errResponse


    # $scope.post_reset = ->
    #   console.log JSON.stringify $scope.post_reset_form_data
      
    #   console.log $scope.post_reset_form_data

    #   if ($scope.post_reset_form_data.password == $scope.post_reset_form_data.password_confirm )
    #     validated_password = $scope.post_reset_form_data.password

    #   $http(
    #     method: 'POST'
    #     url: "#{ RESOURCES.DOMAIN }/post_reset"
    #     data: 

    #       password: validated_password
          
    #   ).then ( (response) ->      
    #     console.log "Password Reset successfull "
    #     console.log response
    #     #window.localStorage.setItem 'user_token', response.data.data.token
    #     # console.log "user_token " + window.localStorage.getItem 'user_token'
    #     #window.localStorage.setItem 'user_id', response.data.data.user.id
    #     $state.go 'login'
    #   ), ( errResponse ) ->
    #     console.log "Password Reset failed "
    #     setTimeout ( ->
    #       $state.go 'login' 
    #     ), 5000
    #     console.log errResponse
   

    $scope.password_remind = ->
      console.log $scope.password_remind_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/post_remind"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data:
         
          user_email: $scope.password_remind_data.email
          
      ).then ( ( response ) ->
        console.log "Send password reminder mail"
        console.log response
        alertify.success "Password Reminder sent ok"
      ), ( errResponse ) ->
        console.log "Send Password Reminder email"
        console.log errResponse
        alertify.error errResponse.message
        $state.go 'password-reminder' 
])

