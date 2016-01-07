'use strict'

angular.module('subzapp').controller('OrgAdminTeamController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  'user'
  '$location'
  'RESOURCES'
  ( $scope, $state, $http, $window, message, user, $location, RESOURCES ) ->
    console.log 'OrgAdminTeam Controller'
    user_token = window.localStorage.getItem 'user_token'

    user.get_user().then ( (res) ->
      # console.log "Got user #{ JSON.stringify res }"
      $scope.user = res.data
      $scope.orgs = window.USER.orgs
      $scope.org = return_org($scope.orgs, $location.search())
    )
    console.log $location.search().id

    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/get-team"
      headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      params:
        team_id: $location.search().id
    ).then ( ( res ) ->
      console.log "Get team result"
      console.log res
      $scope.org = res.data.main_org.name
      $scope.team = res.data
    ), ( errResponse ) ->
      console.log "Get team error"
      console.log errResponse

    $scope.invite_manager = ->
      console.log $scope.invite_manager_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/send-mail"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data:
          manager_email: $scope.invite_manager_data.email
          manager_name: $scope.invite_manager_data.name
          team_id: $location.search().id
          url: "#{ RESOURCES.DOMAIN}/register_manager?team_id=#{ $location.search().id }"
      ).then ( ( response ) ->
        console.log "Send invite mail"
        console.log response
        
      ), ( errResponse ) ->
        console.log "Send invite mail"
        console.log errResponse

])

