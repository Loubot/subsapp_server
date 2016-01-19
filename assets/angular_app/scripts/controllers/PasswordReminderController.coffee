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

    # $http(
    #   method: 'GET'
    #   url: "#{ RESOURCES.DOMAIN }/get-team"
    #   headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    #   params:
    #     team_id: $location.search().id
    # ).then ( ( res ) ->
    #   console.log "Get team result"
    #   console.log res
    #   $scope.org = res.data.main_org.name
    #   $scope.team = res.data
    # ), ( errResponse ) ->
    #   console.log "Get team error"
    #   console.log errResponse

    $scope.post_remind = ->
      console.log $scope.post_remind_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/post_remind"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data:
          user_id: $scope.user.id
          user_email: $scope.user.email
          token:$scope.user.token
      ).then ( ( response ) ->
        console.log "Send password reminder mail"
        console.log response
        message.success "Password Reminder sent ok"
      ), ( errResponse ) ->
        console.log "Send Password Reminder email"
        console.log errResponse
        message.error errResponse.message 
])

