'use strict'

angular.module('subzapp').controller('TeamController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  '$location'
  'user'
  'alertify'
  'RESOURCES'
  'Upload'
  ( $scope, $state, $http, $window, $location, user, alertify, RESOURCES, Upload ) ->    
    console.log 'Team Controller'
    user_token = window.localStorage.getItem 'user_token'

    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify res }"
        # console.log "TeamController teams #{ JSON.stringify window.USER }"
        $scope.user = window.USER
        $scope.org = window.USER.orgs[0]
        $scope.teams = window.USER.teams
        return_team( USER.teams, $location.search().id )
        $scope.show_upload = window.USER.club_admin
        # if $location.$$path == '/team-manager'

        
        # console.log "f #{ JSON.stringify USER.teams }"
      ), ( errResponse ) ->
        window.USER = null
        # $state.go 'login'
    else
      console.log "USER already defined"
      $scope.user = window.USER
      $scope.org = window.USER.orgs[0]
      $scope.teams = window.USER.teams
      $scope.user = window.USER
    

    $http(
      method: 'GET'
      url: "#{ RESOURCES.DOMAIN }/get-team-info"
      headers: { 
                'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                }
      params:
        team_id: window.localStorage.getItem 'team_id'
    ).then ( (res) ->
       console.log "Get team info response"
       console.log res
       $scope.team = res.data.team
       $scope.members = res.data.team.team_members
       $scope.events = res.data.team.events
       $scope.files = res.data.file_trackers
    ), ( errResponse ) ->
      console.log "Get team info error #{ JSON.stringify errResponse }"
  
      
    $scope.create_event = ->
      $scope.create_event_data.team_id = $location.search().id
      console.log $scope.create_event_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/create-event"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json",
                  'Content-Type': 'application/json'
                  }
        data: $scope.create_event_data
      ).then ( (res) ->
        # console.log "Create event response"
        alertify.success("Event created")
        console.log res.data
        $scope.events = res.data
      ), ( errResponse ) ->
        console.log "Create event error"
        alertify.error "Create event failed"
        console.log errResponse


    # upload file

    $scope.submit = ->
      
      $scope.upload $scope.file

    $scope.upload = (file) ->
      console.log file
      Upload.upload(
        method: 'post'
        url: '/file/upload'
        file: file
        data:
          org_id: $scope.team.main_org.id
          team_id: $scope.team.id
          team_name: $scope.team.name
          
      ).then ((resp) ->
        console.log 'Success ' + JSON.stringify resp + 'uploaded. Response: ' + JSON.stringify resp.data
        console.log resp
        $scope.files = resp.data
        alertify.success "File uploaded ok"
        return
      ), ((resp) ->
        console.log 'Error status: ' + resp.status
        alertify.error "File failed to upload"
        console.log resp

        alertify.error "File upload failed. Status: #{ resp.status }"
        return
      ), (evt) ->
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
        console.log 'progress: ' + progressPercentage + '% ' + evt.config.data

  
    $scope.download = ->
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/download-file"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
        
      ).then ( (res) ->
         console.log "Download response"
         console.log res
         
      ), ( errResponse ) ->
        console.log "DOwnload error #{ JSON.stringify errResponse }"

])

return_team = ( teams, id ) ->
  team = (team for team in teams when team.id is parseInt( id ))
  console.log "Team #{ JSON.stringify team }"
  return team