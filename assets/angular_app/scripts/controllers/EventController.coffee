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
        $scope.setDate()
      ), ( event_err ) ->
        console.log "Failed to get event"
        console.log event_err
        alertify.error "Failed to get err "
      

    ), ( errResponse ) ->
      console.log "User get error #{ JSON.stringify errResponse }"
      window.USER = null
      $state.go 'login'

    $scope.update_event = ->
      console.log "Help"
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

    $scope.is_open = false

    $scope.toggle_open = ->
      $scope.is_open = !$scope.is_open
      if $scope.is_open 
        COMMS.GET(
          "/eventresponse/#{ $scope.event.id }/get-attendees-by-event-response"
        ).then ( ( resp ) ->
          console.log "Got users"
          console.log resp
          alertify.success "Got users"
          $scope.attendees resp.data
        ), ( errResponse ) ->

          console.log "Failed to get event users"
          console.log errResponse
          alertify.error "Failed to get event users"

    
    #################### calendar stuff ####################################
    
    $scope.setDate = ->
      $scope.event.start_date = moment( $scope.event.start_date ).format( 'YYYY-MM-DD HH:mm' )
      $scope.event.kick_off_date = moment( $scope.event.kick_off_date ).format( 'YYYY-MM-DD HH:mm' ) if $scope.event.kick_off_date?
      $scope.event.end_date = moment( $scope.event.end_date ).format( 'YYYY-MM-DD HH:mm' )
      


    $scope.onTimeSet = ( nd, od ) ->
      $scope.event.start_date = moment( nd ).format( 'YYYY-MM-DD HH:mm' )
      $scope.event.kick_off_date = moment( nd ).add( 1, 'hours' ).format( 'YYYY-MM-DD HH:mm' ) if $scope.event.kick_off_date?
      $scope.event.end_date = moment( nd ).add( 2, 'hours' ).format( 'YYYY-MM-DD HH:mm' )
    

])
