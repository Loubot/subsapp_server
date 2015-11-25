'use strict'

angular.module('subzapp').controller('UserController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'RESOURCES'
  ( $scope, $state, $http, $window, RESOURCES ) ->
    console.log 'User Controller'
    user_token = JSON.parse window.localStorage.getItem 'user_token'
    
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/user"
      headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    ).success( (data) ->
      console.log "Fetched user data #{ JSON.stringify data }"
      $scope.user = data[0] 
    ).error (err) ->
      console.log "Fetching user data error #{ JSON.stringify err }"
      $state.go 'login'


    $scope.business_create = ->
      # $http(
      #   method: 'GET'
      #   url:    "#{ RESOURCES.DOMAIN }/find-all"
      #   headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      # ).then ( ( response ) ->
      #   console.log 'hellloo'
      # ), ( errResponse ) ->
      #   console.log "#{ JSON.stringify errResponse }"


      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/create-business"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: $scope.business_form_data
      ).then ( (response) ->
        console.log "Business create return #{ JSON.stringify response }"
      ), ( errResponse ) ->
        console.log "Business create error response #{ JSON.stringify errResponse }"
]) 