'use strict'

angular.module('subzapp').controller('OrgController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  'RESOURCES'
  ( $scope, $state, $http, $window,message, RESOURCES ) ->    
    console.log 'Org Controller'
    user_token = JSON.parse window.localStorage.getItem 'user_token'
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/find-all"
      headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    ).then ( (response) ->
      console.log "Org respons #{ JSON.stringify response }"
    ), ( errResponse ) ->
      console.log "Org error #{ JSON.stringify err }"
      message.error( errResponse.data.message )
      # $scope.errorMessage = errResponse
])