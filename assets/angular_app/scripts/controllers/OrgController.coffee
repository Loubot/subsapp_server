'use strict'

angular.module('subzapp').controller('OrgController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  '$location'
  'message'
  'RESOURCES'
  ( $scope, $state, $http, $window, $location, message, RESOURCES ) ->    
    console.log 'Org Controller'
    console.log "check it #{ JSON.stringify $location.search() }"
    params = $location.search()
    console.log "params #{ params.id }"
    user_token = JSON.parse window.localStorage.getItem 'user_token'
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/get-business"
      headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      params: 
        org_id: params.id
    ).then ( (response) ->
      console.log "Org response #{ JSON.stringify response.data }"
      $scope.org = response.data
    ), ( errResponse ) ->
      console.log "Org error #{ JSON.stringify errResponse }"
      message.error( errResponse.data.message )
      # $scope.errorMessage = errResponse

    $scope.create_team = ->
      $scope.team_form_data.user_id = window.localStorage.getItem 'user_id'

      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN}/create-team"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: 
          $scope.team_form_data
      ).then ( (response) ->
        console.log "Team create response #{ JSON.stringify response }"
      ), (errResponse) ->
        console.log "Teacm create error #{ JSON.stringify errResponse }"

])