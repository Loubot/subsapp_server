'use strict'

angular.module('subzapp').controller('TeamController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  '$location'
  'user'
  'message'
  'RESOURCES'
  ( $scope, $state, $http, $window, $location, user, message, RESOURCES ) ->    
    console.log 'Team Controller'
    user_token = window.localStorage.getItem 'user_token'

    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify res }"
        # console.log "TeamController teams #{ JSON.stringify window.USER }"
        $scope.user = window.USER
        $scope.org = window.USER.orgs[0]
        # $scope.org = response.data.org
        
        console.log "f #{ JSON.stringify $scope.team}"
      ), ( errResponse ) ->
        # console.log "User get error #{ JSON.stringify errResponse }"
        $state.go 'login'
    else
      console.log "USER already defined"
      $scope.org = window.USER.orgs[0]
    
  
    # get team members
    console.log $location.search().id
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/get-team-members"
      headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      params:
        team_id: $location.search().id
    ).then ( (res) ->
       console.log "Get team members response #{ JSON.stringify res }"
       $scope.mems = res.data.team_members
    ), ( errResponse ) ->
      console.log "Get team members error #{ JSON.stringify errResponse }"
  
      
  

])