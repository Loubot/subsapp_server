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
        console.log "OrgController teams #{JSON.stringify window.USER.teams}"
        $scope.org = window.USER.orgs[0]
        # $scope.org = response.data.org
        $scope.teams =  window.USER.teams
        return res
      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        $state.go 'login'
    else
      console.log "USER already defined"
      $scope.org = window.USER.orgs[0]
        
      $scope.teams =  window.USER.teams

    console.log "check it #{ JSON.stringify $location.search() }"
    params = $location.search()
    

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

    $scope.delete_team = (id) ->
      user_token = JSON.parse window.localStorage.getItem 'user_token'
      $http(
        method: 'DELETE'
        url: "#{ RESOURCES.DOMAIN }/delete-team"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: 
          team_id: id
      ).then ( (res) ->
        console.log "Delete response #{ JSON.stringify res }"
      ), (errResponse) ->
        console.log "Delte team error #{ JSON.stringify errResponse }"

])