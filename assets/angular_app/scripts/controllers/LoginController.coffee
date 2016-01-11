'use strict'

angular.module('subzapp').controller('LoginController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  'RESOURCES'
  # 'AuthService'
  ( $scope, $state, $http, $window, message, RESOURCES ) ->
    console.log 'Login Controller'
    
    $scope.login_submit = ->
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/auth/signin"
        data: $scope.login_form_data
      ).then ( (response) ->
        console.log "User id #{ response.data.user }"
        console.log response
        $scope.user = response.data.user
        window.localStorage.setItem 'user_token', response.data.token
        window.localStorage.setItem 'user_id', response.data.user.id
        # console.log "Success response token #{ JSON.stringify response.data.token }"
        # $state.go 'org'
        if $scope.user.club_admin
          console.log 'club_admin'
          $state.go 'org_admin'
        else
          console.log 'team_manager'
          $state.go 'team_manager_home'
      ), ( errResponse ) ->
        console.log "Error response #{ JSON.stringify errResponse.data }"
        window.USER = null
        message.error( errResponse.data.message )
        # $scope.errorMessage = errResponse
        



      # $http.post("#{ RESOURCES.DOMAIN }/auth/signin", $scope.login_form_data).success( (data) ->
      #   console.log "returned #{ JSON.stringify data }"
      #   window.localStorage.setItem 'logged_in_user', JSON.stringify data
      #   $scope.login_form_data = {}
      #   $scope.returned = data

      #   $state.go 'user'

      # ).fail( (error) ->
      #   console.log "new error"
      # ).error (err) ->
      #   $('.login_error').show 'slide', { direction: 'right' }, 1000
      #   $scope.errorMessage = err
      #   console.log "error!!!!!" + JSON.stringify err

    $scope.credentials = {
      email : ''
      password : ''
    }

    # $scope.login = ->
    #   AuthService.login $scope.credentials, (response) ->
    #     console.log response

])
