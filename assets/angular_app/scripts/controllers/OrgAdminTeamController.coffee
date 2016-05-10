'use strict'

angular.module('subzapp').controller('OrgAdminTeamController', [
  '$scope'
  '$rootScope'
  '$state'
  '$http'
  '$window'
  'user'
  'RESOURCES'
  'alertify'
  'COMMS'
  ( $scope, $rootScope, $state, $http, $window, user, RESOURCES, alertify, COMMS ) ->
    console.log 'OrgAdminTeam Controller'
    check_club_admin = ( user ) ->
      if !user.club_admin
        $state.go 'login' 
        alertify.error 'You are not a club admin. Contact subzapp admin team for assitance'

    team_id = window.localStorage.getItem 'team_id'

    user.get_user().then ( (res) ->
      check_club_admin(res.data)
      # console.log "Got user #{ JSON.stringify res }"
      $scope.user = $rootScope.USER
      $scope.orgs = $rootScope.USER.orgs
      
    )
# "https://ie-mg42.mail.yahoo.com/neo/launch?.rand=3kv9scfolg9ma#"
    COMMS.GET(

      '/get-team', team_id: team_id

    ).then ( ( res ) ->
      console.log "Get team result"
      console.log res
      $scope.org = res.data.main_org
      $scope.team = res.data
      alertify.success "Got team info"
    ), ( errResponse ) ->
      console.log "Get team error"
      console.log errResponse
      alertify.error "Failed to get team info"
    
])

