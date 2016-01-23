'use strict'

angular.module('subzapp').controller('OrgAdminTeamController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'user'
  '$location'
  'RESOURCES'
  'alertify'
  ( $scope, $state, $http, $window, user, $location, RESOURCES, alertify ) ->
    console.log 'OrgAdminTeam Controller'
    check_club_admin = ( user ) ->
      if !user.club_admin
        $state.go 'login' 
        alertify.error 'You are not a club admin. Contact subzapp admin team for assitance'
        

    user_token = window.localStorage.getItem 'user_token'

    user.get_user().then ( (res) ->
      check_club_admin(res.data)
      # console.log "Got user #{ JSON.stringify res }"
      $scope.user = res.data
      $scope.orgs = window.USER.orgs
      
    )
    console.log $location.search().id
# "https://ie-mg42.mail.yahoo.com/neo/launch?.rand=3kv9scfolg9ma#"
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/get-team"
      headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
      params:
        team_id: $location.search().id
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
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/invite-manager"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
        data:
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

