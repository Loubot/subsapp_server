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

      COMMS.GET(
        "/team/#{ window.localStorage.getItem 'team_id' }/teams-events"
      ).then ( ( team ) ->
        console.log "Got events info"
        console.log team
        $scope.events = team.data
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
      date = new Date()
      $scope.dt.end_date = date.setDate( date.getDate() + 1 )
      console.log "Date #{ $scope.dt.end_date }"
      return

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
      COMMS.GET(
        "/team/#{ window.localStorage.getItem 'team_id' }/teams-events"
        $scope.dt
      ).then ( ( resp ) ->
        console.log resp
      ), ( errResponse ) ->
        console.log errResponse
])
