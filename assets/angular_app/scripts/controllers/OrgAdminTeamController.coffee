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
    ), ( errResponse ) ->
      console.log "Get team error"
      console.log errResponse

    $scope.invite_manager = ->
      console.log $scope.invite_manager_data
      COMMS.POST(
        '/invite-manager'        
        org_id: $scope.org.id
        team_id: $location.search().id
        club_admin: $scope.user.id
        club_admin_email: $scope.user.email
        invited_email: $scope.invite_manager_data.invited_email
        main_org_name: $scope.org.name
        team_name: $scope.team.name
      ).then ( ( response ) ->
        console.log "Send invite mail"
        console.log response
        alertify.success "Invite sent ok"
      ), ( errResponse ) ->
        console.log "Send invite mail"
        console.log errResponse
        alertify.error errResponse.message 
])

