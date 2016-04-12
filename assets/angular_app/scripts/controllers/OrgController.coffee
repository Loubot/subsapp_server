'use strict'

angular.module('subzapp').controller('OrgController', [
  '$scope'
  '$state'
  'COMMS'
  '$window'
  '$location'
  'user'
  'RESOURCES'
  'alertify'
  ( $scope, $state, COMMS, $window, $location, user, RESOURCES, alertify ) ->
    user_token = window.localStorage.getItem 'user_token'

    get_orgs = ->
      COMMS.GET(
        '/orgs'
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
      console.log "/org/s3-info/#{ $scope.org }"
      console.log $scope.org
      COMMS.GET(
        "/org/s3-info/#{ $scope.org }"
      ).then ( ( res ) ->
        
        console.log "s3_info response"
        console.log res.data
        $scope.files = res.data.Contents
      ), ( errResponse ) ->
        
        console.log "s3_info error response"
        console.log errResponse
        if errResponse.status == 401
          alertify.error "You are not authorised to view this page"
          $state.go 'login'
      

    $scope.parse_users = ->
      console.log 'yep'
      COMMS.POST(
        "/file/parse-players/"
        data:
          org_id: $scope.org
      ).then ( ( res ) ->
        console.log "parse users response"
        console.log res
        $scope.parsed_data = res
      ), ( errResponse ) ->
        console.log "Parse users error"
        console.log errResponse

])


