'use strict'

angular.module('subzapp').controller('OrgController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  '$location'
  'user'
  'message'
  'RESOURCES'
  ( $scope, $state, $http, $window, $location, user, message, RESOURCES ) ->    
    console.log 'Org Controller'
    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify res }"
        console.log "user controller #{JSON.stringify window.USER }"
        $scope.org = window.USER.orgs[0]
        # $scope.org = response.data.org
        $scope.teams =  window.USER.teams
        return res
      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        $state.go 'login'

    console.log "check it #{ JSON.stringify $location.search() }"
    params = $location.search()
    # console.log "params #{ params.id }"
    # user_token = JSON.parse window.localStorage.getItem 'user_token'
    # $http(
    #   method: 'GET'
    #   url: "#{ RESOURCES.DOMAIN }/get-business"
    #   headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    #   params: 
    #     org_id: params.id
    # ).then ( (response) ->
    #   console.log "Org response #{ JSON.stringify response.data }"
    #   $scope.org = response.data.org
    #   $scope.teams = response.data.teams
    # ), ( errResponse ) ->
    #   console.log "Org error #{ JSON.stringify errResponse }"
    #   message.error( errResponse.data.message )
      # $scope.errorMessage = errResponse

    $scope.team_create = ->
      user_token = JSON.parse window.localStorage.getItem 'user_token'
      $scope.team_form_data.user_id = window.localStorage.getItem 'user_id'
      $scope.team_form_data.org_id = params.id
      console.log "Form data #{ JSON.stringify $scope.team_form_data }"
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN}/create-team"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: 
          $scope.team_form_data
      ).then ( (teams) ->
        console.log "Team create response #{ JSON.stringify teams }"
        $scope.teams = teams.data
      ), (errResponse) ->
        console.log "Teacm create error #{ JSON.stringify errResponse }"

])