'use strict'

angular.module('subzapp').controller('TeamEventsController', [
  '$scope'
  '$rootScope'
  '$state'
  'COMMS'
  'user'
  'alertify'
  'RESOURCES'
  ( $scope, $rootScope, $state, COMMS, user, alertify, RESOURCES ) ->    
    console.log 'Team Events Controller'

    if !( window.localStorage.getItem 'team_id' )?
      $state.go 'team_manager'

    user.get_user().then ( (res) ->
      $scope.user = $rootScope.USER
      COMMS.GET(
        "/team/#{ window.localStorage.getItem 'team_id' }"
      ).then ( ( team ) ->
        console.log "Got team info"
        console.log team
        $scope.team = team.data
        alertify.success "Got team info"
      ), ( team_err ) ->

        console.log "Team error"
        console.log team_err
        alertify.error "Failed to get team"
      
    ), ( errResponse ) ->
      $rootScope.USER = null
      $state.go 'login'
    

      #moment(res.data[0].eligible_date).format('YYYY-MM-DD')

    $scope.format_date = ( date ) ->
      console.log date
      return moment( date ).format( 'YYYY-MM-DD HH:mm' )

    $scope.onTimeSet = ( nd, od ) ->
      console.log nd
      console.log od
      console.log moment.duration( moment( od ).diff( moment( nd ) ) )
      $scope.date.from = moment( nd ).format( 'DD-MM-YYYY HH:mm' )
      $scope.date.to = moment( od ).format( 'DD-MM-YYYY HH:mm' )

    ###################### calendar stuff ############################

    $scope.dt = {}
   

    $scope.today = ->
      $scope.dt.start_date = new Date()
      

    $scope.today()

    $scope.clear = ->
      $scope.dt = null
      return

    $scope.open1 = ->
      $scope.popup1.opened = true
      return

    $scope.open2 = ->
      $scope.popup2.opened = true
      return

    $scope.setDate = (year, month, day) ->
      $scope.dt = new Date(year, month, day)
      return

    
    $scope.format = "dd-MMMM-yyyy"
    $scope.popup1 = opened: false
    $scope.popup2 = opened: false

  ##################### end of calendar stuff ##########################

    $scope.get_events = ->
      console.log "team #{ window.localStorage.getItem 'team_id' }"
      console.log $scope.dt
      COMMS.GET(
        "/team/#{ window.localStorage.getItem 'team_id' }/teams-events"
        $scope.dt
      ).then ( ( resp ) ->
        console.log resp
        $scope.events = resp.data
      ), ( errResponse ) ->
        console.log errResponse

    $scope.view_event = ( id ) ->
      console.log "View event #{ id }"
      COMMS.GET(
        "/event/#{ id }"
      ).then ( ( res) ->
        console.log "Got event"
        console.log res
        $('#view_event').modal 'show'
        alertify.success "Got event successfully"
        $scope.event = res.data
      ), ( errResponse ) ->
        console.log "Failed to get event "
        console.log errResponse
        alertify.error "Failed to get event"

])
