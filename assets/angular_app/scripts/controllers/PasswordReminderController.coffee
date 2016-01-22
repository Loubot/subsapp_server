'use strict'

angular.module('subzapp').controller('PasswordReminderController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  'user'
  '$location'
  'RESOURCES'
  ( $scope, $state, $http, $window, message, user, $location, RESOURCES ) ->
    console.log 'PasswordReminder Controller'
    user_token = window.localStorage.getItem 'user_token'
    #reminder_token = window.location.search.href
    console.log window.location.search.substring 1
    


    $scope.post_reset = ->
      console.log JSON.stringify $scope.post_reset_form_data
      
      console.log $scope.post_reset_form_data 
      


      if ($scope.post_reset_form_data.password == $scope.post_reset_form_data.password_confirm )
        validated_password = $scope.post_reset_form_data.password
      else
        validate_password = null

      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/reset"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: 
          remind_password_token: window.location.search.substring 1
          password: validated_password
          
      ).then ( (response) ->      
        console.log "Password Reset successfull "
        console.log response
        console.log message "Remind password token" + remind_password_token
        #window.localStorage.setItem 'user_token', response.data.data.token
        # console.log "user_token " + window.localStorage.getItem 'user_token'
        #window.localStorage.setItem 'user_id', response.data.data.user.id
        $state.go 'login'
      ), ( errResponse ) ->
        console.log "Password Reset failed "
        setTimeout ( ->
          $state.go 'login' 
        ), 5000
        console.log errResponse
   

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
        message.success "Password Reminder sent ok"
      ), ( errResponse ) ->
        console.log "Send Password Reminder email"
        console.log errResponse
        message.error errResponse.message
        $state.go 'password-reminder' 
])

