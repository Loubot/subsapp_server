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
  'Upload'
  ( $scope, $state, $http, $window, $location, user, RESOURCES, alertify , Upload) ->
    user_token = window.localStorage.getItem 'user_token'

    $scope.submit = ->
      
      $scope.upload $scope.file

    $scope.upload = (file) ->
      console.log file
      Upload.upload(
        method: 'post'
        url: '/file/upload'
        file: file).then ((resp) ->
        console.log 'Success ' + resp + 'uploaded. Response: ' + resp.data
        return
      ), ((resp) ->
        console.log 'Error status: ' + resp.status
        return
      ), (evt) ->
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
        console.log 'progress: ' + progressPercentage + '% ' + evt.config.data
        

    check_club_admin = ( user ) ->
      $state.go 'login' if !user.team_admin
      alertify.error 'You are not a club admin. Contact subzapp admin team for assitance'
      return false 

    console.log 'Org Controller'
    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify window.USER }"
        $scope.org = window.USER.orgs[0]

      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        window.USER = null
        $state.go 'login'
    else
      console.log "USER already defined"
      $scope.org = window.USER.orgs[0]
        
      

    $scope.parse_users = ->
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/parse-users"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
      ).then ( ( res ) ->
        console.log "parse users response"
        console.log res
        $scope.parsed_data = res
      ), ( errResponse ) ->
        console.log "Parse users error"
        console.log errResponse

        
    $scope.aws = ->
      
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/aws"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
      ).then ( ( res ) ->
        console.log "aws responses"
        console.log res
        $scope.parsed_data = res
      ), ( errResponse ) ->
        console.log "aws error"
        console.log errResponse
        alertify.error errResponse.data

])


