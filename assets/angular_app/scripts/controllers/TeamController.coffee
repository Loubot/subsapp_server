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
  '$filter'
  'usSpinnerService'
  ( $scope, $state, $http, $window, $location, user, alertify, RESOURCES, Upload, $filter, usSpinnerService ) ->    
    console.log 'Team Controller'
    user_token = window.localStorage.getItem 'user_token'

    get_team_info = ->
      if $scope.user.club_admin
        $http(
          method: 'GET'
          url: "#{ RESOURCES.DOMAIN }/team/get-team-info/#{ window.localStorage.getItem 'team_id' }"
          headers: { 
                    'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                    }
          
        ).then ( (res) ->
           console.log "get_team_info response club admin"
           console.log res
           $scope.team = res.data.team
           $scope.files = res.data.bucket_info.Contents
           $scope.org_members = res.data.org.org_members
           $scope.team.eligible_date = $filter('date')($scope.team.eligible_date, 'yyyy-MM-dd')
           
          )
        ), ( errResponse ) ->
          console.log "get_team_info error"
          console.log errResponse
      else
        $http(
          method: 'GET'
          url: "#{ RESOURCES.DOMAIN }/team/#{ window.localStorage.getItem 'team_id' }"
          headers: { 
                    'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                    }

        ).then ( (res) ->
           console.log "Get team info response"
           console.log res.data
           $scope.team = res.data
           
        ), ( errResponse ) ->
          console.log "Get team info error #{ JSON.stringify errResponse }"
          $state.go 'login'

    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify res }"
        # console.log "TeamController teams #{ JSON.stringify window.USER }"
        $scope.user = window.USER
        $scope.org = window.USER.orgs[0]
        $scope.teams = window.USER.teams
        return_team( USER.teams, $location.search().id )
        $scope.show_upload = window.USER.club_admin
        get_team_info() if $scope.user.club_admin
      ), ( errResponse ) ->
        window.USER = null
        # $state.go 'login'
    else
      console.log "USER already defined"
      $scope.user = window.USER
      $scope.org = window.USER.orgs[0]
      $scope.teams = window.USER.teams
      $scope.user = window.USER
      get_team_info() if $scope.user.club_admin
  
      
    $scope.create_event = ->
      $scope.create_event_data.team_id = $scope.team.id
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
      console.log "Upload"
      console.log file
      console.log JSON.stringify $scope.team.name
      Upload.upload(
        method: 'post'
        url: '/file/upload'
        data:
          org_id: $scope.team.main_org.id
          team_id: $scope.team.id
          team_name: $scope.team.name
        file: file        
          
      ).then ((resp) ->
        console.log 'Success ' + JSON.stringify resp + 'uploaded. Response: ' + JSON.stringify resp.data
        console.log resp
        $scope.files = resp.data.bucket_info.Contents
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

    $scope.get_players_by_year = ( id ) ->
      console.log "Find by date"
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/team/get-players-by-year/#{ $scope.team.id }"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
        # params:
        #   team_id: id
      ).then ( (res) ->
         console.log "Playsers by age response"
         console.log res
         
      ), ( errResponse ) ->
        console.log "DOwnload error #{ JSON.stringify errResponse }"

  
    $scope.download = ->
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/user/download-file"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
        
      ).then ( (res) ->
         console.log "Download response"
         console.log res
         
      ), ( errResponse ) ->
        console.log "DOwnload error #{ JSON.stringify errResponse }"

    $scope.update_members = ->
      console.log "team id #{ $scope.team.id }"
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/team/update-members/#{ $scope.team.id }"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json",
                  'Content-Type': 'application/json'
                  }

        data:
          team_members: $scope.team_members_array
      ).then ( ( res ) ->
        console.log "Update team members"
        console.log res
        alertify.success "Team members added successfully"
      ), ( errResponse ) ->
        console.log "Update team members error "
        console.log errResponse
        alertify.error "Failed to add team members"

    $scope.update_eligible_date = () ->
      console.log 'yep'
      console.log $scope.team.eligible_date
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/team/update/#{ $scope.team.id }"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json",
                  'Content-Type': 'application/json'
                  }
        data:
          eligible_date: $scope.team.eligible_date
      ).then ( ( res ) ->
        console.log "Update team date"
        console.log res.data[0].eligible_date
        $scope.team.eligible_date = $filter('date')(res.data[0].eligible_date, "yyyy-MM-dd" )
        alertify.success "Eligible date updated"
      ), ( errResponse ) ->
        console.log "Update date error "
        console.log errResponse
        alertify.error "Update failed"

    $('#select_player_modal').on 'shown.bs.modal', (e) ->
      usSpinnerService.spin('spinner-1')
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/org/get-org/#{ $scope.team.main_org.id }"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json",
                  'Content-Type': 'application/json'
                  }
       
      ).then ( ( res ) ->
        console.log "Get org info "
        console.log res.data.org_members
        $scope.team_members_array = $scope.team_members_array = res.data.org_members.map( ( member ) ->
            member.id
        usSpinnerService.stop('spinner-1')
        alertify.success "Got players info"
      ), ( errResponse ) ->
        console.log "Get org info error "
        usSpinnerService.stop('spinner-1')
        console.log errResponse
        alertify.error "Couldn't get players info"
    
])

return_team = ( teams, id ) ->
  team = (team for team in teams when team.id is parseInt( id ))
  console.log "Team #{ JSON.stringify team }"
  return team

 #  $scope.members = res.data.team.team_members
 # $scope.events = res.data.team.events
 # $scope.files = res.data.bucket_info.Contents


