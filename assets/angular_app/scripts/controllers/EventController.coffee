'use strict'

angular.module('subzapp').controller('EventController', [
  '$scope'
  '$state'
  '$http'
  '$location'
  '$window'
  'message'
  'user'
  'RESOURCES'
  ( $scope, $state, $http, $location, $window, message, user, RESOURCES ) ->
    console.log 'Event Controller'
    user_token = window.localStorage.getItem 'user_token'

    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log "User"
        # console.log res 
        

      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        window.USER = null
        $state.go 'login'
    else
      console.log "USER already defined"
      $scope.org = window.USER.orgs[0]
    
    console.log "id #{ $location.search().id }"
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/get-event-members"
      headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      params:
        event_id: $location.search().id
    ).then ( (res) ->
       console.log "Get team members response"
       console.log res
       $scope.event_members = res.data.event_user
       
    ), ( errResponse ) ->
      console.log "Get event members error "
      console.log errResponse

])
