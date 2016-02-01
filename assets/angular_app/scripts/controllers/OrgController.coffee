'use strict'

angular.module('subzapp').controller('OrgController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  '$location'
  'user'
  'RESOURCES'
  'alertify'
  ( $scope, $state, $http, $window, $location, user, RESOURCES, alertify ) ->
    user_token = window.localStorage.getItem 'user_token'
        

    check_club_admin = ( user ) ->
      $state.go 'login' if !user.team_admin
      alertify.error 'You are not a club admin. Contact subzapp admin team for assitance'
      return false 

    console.log 'Org Controller'
    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify window.USER }"
        $scope.org = window.USER.orgs[0]

      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        window.USER = null
        $state.go 'login'
    else
      console.log "USER already defined"
      $scope.org = window.USER.orgs[0]
        
      

    $scope.parse_users = ->
      console.log 'yep'
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/parse-players"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
        params:
          team_id: 1
      ).then ( ( res ) ->
        console.log "parse users response"
        console.log res
        $scope.parsed_data = res
      ), ( errResponse ) ->
        console.log "Parse users error"
        console.log errResponse

])


