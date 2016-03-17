'use strict'

angular.module('subzapp').controller('OrgController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  '$location'
  'user'
  'RESOURCES'
  'alertify'
  'usSpinnerService'
  ( $scope, $state, $http, $window, $location, user, RESOURCES, alertify, usSpinnerService ) ->
    user_token = window.localStorage.getItem 'user_token'

    get_orgs = ->
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/orgs"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
      ).then( ( orgs ) ->
        console.log "Got orgs "
        console.log orgs.data
        $scope.orgs = orgs.data
      ).catch( ( err ) ->
        console.log "Got orgs error"
        console.log err
        if err.status == 401
          alertify.error "You are not authorised to view this page"
          $state.go 'login'
      )
        

    console.log 'Org Controller'
    if !(window.USER?)
      user.get_user().then ( (res) ->
        get_orgs()

      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        window.USER = null
        $state.go 'login'
    else
      get_orgs()
      console.log "USER already defined"
      
      
    $scope.get_org_info = ( id ) ->
      usSpinnerService.spin('spinner-1')
      console.log $scope.org
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/org/s3-info/#{ $scope.org }"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }

      ).then ( ( res ) ->
        usSpinnerService.stop('spinner-1')
        console.log "s3_info response"
        console.log res.data
        $scope.files = res.data.Contents
      ), ( errResponse ) ->
        usSpinnerService.stop('spinner-1')
        console.log "s3_info error response"
        console.log err
        if err.status == 401
          alertify.error "You are not authorised to view this page"
          $state.go 'login'
      

    $scope.parse_users = ->
      console.log 'yep'
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/file/parse-players"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
        data:
          org_id: 1
      ).then ( ( res ) ->
        console.log "parse users response"
        console.log res
        $scope.parsed_data = res
      ), ( errResponse ) ->
        console.log "Parse users error"
        console.log errResponse

])


