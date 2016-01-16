'use strict'

angular.module('subzapp').controller('OrgAdminController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  'user'
  '$location'
  'RESOURCES'
  ( $scope, $state, $http, $window, message, user, $location, RESOURCES ) ->
    console.log 'OrgAdmin Controller'
    user_token = window.localStorage.getItem 'user_token'
    user.get_user().then ( (res) ->
      console.log "Got user "
      console.log res
      $scope.org = window.USER.orgs[0]
      $scope.user = res.data
      $scope.orgs = window.USER.orgs
      # $scope.org = return_org($scope.orgs, $location.search())
    )


    $scope.edit_org = ( id ) ->
      $scope.show_team_admin = true
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/org-admins"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        params:
          org_id: id
      ).then ( ( response ) ->
        console.log "get org-admins"
        console.log response
        $scope.admins = response.data.admins
        $scope.teams = response.data.teams
      ), ( errResponse ) ->
        console.log "Get org admins error"
        console.log errResponse

    

    $scope.team_create = ->
      $scope.team_form_data.org_id = $location.search().id
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/create-team"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: $scope.team_form_data
      ).then ( ( response ) ->
        console.log "Team create"
        console.log response
        message.success = response.data.message
        $scope.teams = response.data
        $scope.team_form.$setPristine()
        $scope.team_form_data = ''
      ), ( errResponse ) ->
        console.log "Team create error"
        console.log errResponse
        message.error errResponse

    $scope.delete_team = ( id ) ->
      $http(
        url: "#{ RESOURCES.DOMAIN }/delete-team"
        method: 'DELETE'
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data:
          team_id: id
          org_id: $scope.org.id
      ).then ( ( res ) ->
        console.log "Team delete"
        console.log res
        $scope.teams = res.data.teams
      ), ( errResponse ) ->
        console.log "Team delete error"
        console.log errResponse

])

return_org = ( orgs, search) ->

  for org in orgs    
    if parseInt( org.id ) == parseInt( search.id )
      return org


# $http(
#   method: 'POST'
#   url: "#{ RESOURCES.DOMAIN }/send-mail"
#   headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
  
# ).then ( ( response ) ->
#   console.log "get mandrill-object"
#   console.log response
  
# ), ( errResponse ) ->
#   console.log "Get mandrill-object"
#   console.log errResponse