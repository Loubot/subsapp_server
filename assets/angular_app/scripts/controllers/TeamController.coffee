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
        return_team( USER.teams, $location.search().id )
        
        console.log "f #{ JSON.stringify USER.teams }"
      ), ( errResponse ) ->
        window.USER = null
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

return_team = ( teams, id ) ->
  team = (team for team in teams when team.id is parseInt( id ))
  console.log "Team #{ JSON.stringify team }"
  return team