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
      
    ), ( errResponse ) ->
      $rootScope.USER = null
      $state.go 'login'
    

      

])
