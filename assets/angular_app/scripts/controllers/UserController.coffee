'use strict'

angular.module('subzapp').controller('UserController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  'RESOURCES'
  ( $scope, $state, $http, $window,message, RESOURCES ) ->
    console.log 'User Controller'
    user_token = JSON.parse window.localStorage.getItem 'user_token'
    # console.log "User data #{ sails.config.user_data.name }"
    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/user"
      headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    ).success( (data) ->
      console.log "Fetched user data #{ JSON.stringify data[0] }"
      $scope.orgs = data[0].orgs
      # user = data[0]
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
      $scope.business_form_data.user_id = window.localStorage.getItem 'user_id'
      console.log JSON.stringify $scope.business_form_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/create-business"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: $scope.business_form_data
      ).then ( (response) ->

        console.log "Business create return #{ JSON.stringify response.data }"
        $scope.orgs = response.data
        $('.business_name').val ""
        $('.business_address').val ""

      ), ( errResponse ) ->
        console.log "Business create error response #{ JSON.stringify errResponse }"
        $state.go 'login'

    $scope.delete_business = (id) ->
      $http(
        method: 'DELETE'
        url: "#{ RESOURCES.DOMAIN }/delete-business"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: 
          org_id: id
      ).then ( (response) ->
        
      ), ( errResponse ) ->
        
]) 