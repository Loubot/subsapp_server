'use strict'

angular.module('subzapp').controller('EventController', [
  '$scope'
  '$rootScope'
  '$state'
  'COMMS'
  '$stateParams'
  'user'
  'RESOURCES'
  'alertify'
  ( $scope, $rootScope, $state, COMMS, $stateParams, user, RESOURCES, alertify ) ->
    console.log 'Event Controller'
    console.log $stateParams.id

    
    user.get_user().then ( (res) ->
      $scope.user = $rootScope.USER
      COMMS.GET(
        "/event/#{ $stateParams.id }"
      ).then ( ( resp ) ->
        console.log "Got event"
        console.log resp
        alertify.success "Got event info"
        $scope.event = resp.data
      ), ( event_err ) ->
        console.log "Failed to get event"
        console.log event_err
        alertify.error "Failed to get err "
      

    ), ( errResponse ) ->
      console.log "User get error #{ JSON.stringify errResponse }"
      window.USER = null
      $state.go 'login'
    
    
    

])
