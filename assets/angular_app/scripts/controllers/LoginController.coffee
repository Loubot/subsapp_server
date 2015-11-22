'use strict'

angular.module('subzapp').controller('LoginController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'RESOURCES'
  # 'AuthService'
  ( $scope, $state, $http, $window, RESOURCES ) ->
    console.log 'Login Controller'

    $scope.login_submit = ->
      $http.post("#{ RESOURCES.DOMAIN }/auth/signin", $scope.login_form_data).success( (data) ->
        console.log "returned #{ JSON.stringify data }"
        window.localStorage.setItem 'logged_in_user', JSON.stringify data
        $scope.login_form_data = {}
        $scope.returned = data

        $state.go 'user'

      ).error (err) ->
        $('.login_error').show 'slide', { direction: 'right' }, 1000
        $scope.errorMessage = err
        console.log "error!!!!!" + JSON.stringify err

    $scope.credentials = {
      email : ''
      password : ''
    }

    # $scope.login = ->
    #   AuthService.login $scope.credentials, (response) ->
    #     console.log response

])
