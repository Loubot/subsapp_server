'use strict'

angular.module('subzapp').controller('OrgController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  '$location'
  'user'
  'message'
  'RESOURCES'
  ( $scope, $state, $http, $window, $location, user, message, RESOURCES ) ->
    user_token = window.localStorage.getItem 'user_token'

    check_club_admin = ( user ) ->
      $state.go 'login' if !user.team_admin
      message.error 'You are not a club admin. Contact subzapp admin team for assitance'
      return false 

    console.log 'Org Controller'
    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify window.USER }"
        

      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        window.USER = null
        # $state.go 'login'
    else
      console.log "USER already defined"
      $scope.org = window.USER.orgs[0]
        
      

    $scope.parse_users = ->
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/parse-users"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      ).then ( ( res ) ->
        console.log "parse users response"
        console.log res
      ), ( errResponse ) ->
        console.log "Parse users error"
        console.log errResponse

    $scope.aws = ->
      
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/aws"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      ).then ( ( res ) ->
        console.log "aws response"
        console.log res
      ), ( errResponse ) ->
        console.log "aws error"
        console.log errResponse
    

])


