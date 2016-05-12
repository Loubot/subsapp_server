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
])
