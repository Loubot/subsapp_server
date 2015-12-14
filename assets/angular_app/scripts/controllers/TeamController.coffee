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
        
        # console.log "f #{ JSON.stringify USER.teams }"
      ), ( errResponse ) ->
        window.USER = null
        $state.go 'login'
    else
      console.log "USER already defined"
      $scope.user = window.USER
      $scope.org = window.USER.orgs[0]
    
  
    # get team members
    console.log $location.search().id
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/get-team-info"
      headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      params:
        team_id: $location.search().id
    ).then ( (res) ->
       # console.log "Get team members response #{ JSON.stringify res }"
       console.log res
       $scope.team = res.data
       $scope.mems = res.data.team_members
       $scope.events = res.data.events
    ), ( errResponse ) ->
      console.log "Get team members error #{ JSON.stringify errResponse }"
  
      
    $scope.create_event = ->
      $scope.create_event_data.team_id = $location.search().id
      console.log $scope.create_event_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/create-event"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: $scope.create_event_data
      ).then ( (res) ->
        # console.log "Create event response"
        message.success("Event created")
        console.log res.data
        $scope.events = res.data
      ), ( errResponse ) ->
        console.log "Create event error"
        message.error "Create event failed"
        console.log errResponse
  

])

return_team = ( teams, id ) ->
  team = (team for team in teams when team.id is parseInt( id ))
  console.log "Team #{ JSON.stringify team }"
  return team