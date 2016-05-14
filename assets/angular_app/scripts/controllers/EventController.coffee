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

    $scope.format = "dd-MMMM-yyyy"

    
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

    $scope.update_event = ->
      console.log $scope.event

      COMMS.POST(
        "/event/#{ $stateParams.id }"
        $scope.event
      ).then ( ( res ) ->
        console.log "Event updated"
        console.log res
        alertify.success "Event updated successfully"
      ), ( errResponse ) ->
        console.log "Event update error "
        console.log errResponse
        alertify.error "Event update error"

    
    $scope.today = ->
      $scope.event.start_date = new Date()
      

    # $scope.today()

    $scope.clear = ->
      $scope.event = null
      return

    $scope.open1 = ->
      $scope.popup1.opened = true
      return

    $scope.open2 = ->
      $scope.popup2.opened = true
      return

    $scope.setDate = (year, month, day) ->
      $scope.event = new Date(year, month, day)
      return

    
    $scope.format = "dd-MMMM-yyyy"
    $scope.popup1 = opened: false
    $scope.popup2 = opened: false
    

])
