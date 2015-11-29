'use strict'

angular.module('subzapp').controller('UserController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'message'
  'user'
  'RESOURCES'
  ( $scope, $state, $http, $window, message, user, RESOURCES ) ->
    console.log 'User Controller'
    

    logged_in = user.get_user().then ( (res) ->
      console.log "User set to #{ JSON.stringify res }"
      return res
    ), ( errResponse ) ->
      # console.log "User get error #{ JSON.stringify errResponse }"

    
    console.log "user controller #{JSON.stringify logged_in }"
    
    # console.log "User data #{ sails.config.user_data.name }"
    # $http(
    #   method: 'GET'
    #   url: "#{ RESOURCES.DOMAIN }/user"
    #   headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    # ).success( (data) ->
    #   console.log "Fetched user data #{ JSON.stringify data[0] }"

    #   $scope.orgs = if (data[0]?) then data[0].orgs else []
    #   # user = data[0]
    #   $scope.user = data[0] 
    # ).error (err) ->
    #   console.log "Fetching user data error #{ JSON.stringify err }"
    #   $state.go 'login'


    $scope.business_create = ->
      console.log "create #{JSON.stringify user}"
      # $scope.business_form_data.user_id = window.localStorage.getItem 'user_id'
      # console.log JSON.stringify $scope.business_form_data
      # $http(
      #   method: 'POST'
      #   url: "#{ RESOURCES.DOMAIN }/create-business"
      #   headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
      #   data: 
      #     $scope.business_form_data
      # ).then ( (response) ->

      #   console.log "Business create return #{ JSON.stringify response.data }"
      #   $scope.orgs = response.data
      #   $scope.business_form_data.$setPristine()

      # ), ( errResponse ) ->
      #   console.log "Business create error response #{ JSON.stringify errResponse }"
      #   $state.go 'login'

    $scope.delete_business = (id) ->
      $http(
        method: 'DELETE'
        url: "#{ RESOURCES.DOMAIN }/delete-business"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: 
          org_id: id
      ).then ( (response) ->
        console.log "Delete response #{ JSON.stringify response}"
      ), ( errResponse ) ->
        console.log "Delete error response #{ JSON.stringify errResponse }"
]) 