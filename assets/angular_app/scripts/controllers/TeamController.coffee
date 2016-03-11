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
      usSpinnerService.spin('spinner-1')
      if $scope.user.club_admin
        $http(
          method: 'GET'
          url: "#{ RESOURCES.DOMAIN }/team/get-team-info/#{ window.localStorage.getItem 'team_id' }"
          headers: { 
                    'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                    }
          
        ).then ( (res) ->
          usSpinnerService.stop('spinner-1')
          console.log "get_team_info response club admin"
          console.log res
          $scope.team = res.data.team
          
          $scope.org_members = res.data.org.org_members
           
          
        ), ( errResponse ) ->
          usSpinnerService.stop('spinner-1')
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
          usSpinnerService.stop('spinner-1')
          console.log "Get team info response"
          console.log res.data
          $scope.team = res.data
           
        ), ( errResponse ) ->
          usSpinnerService.stop('spinner-1')
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
        $scope.team_members_array = res.data.team_members.map( ( member ) ->
          member.id
        )
        # $('#select_player_modal').modal('hide')
        alertify.success "Team members updated successfully"
      ), ( errResponse ) ->
        console.log "Update team members error "
        console.log errResponse
        alertify.error "Failed to add team members"

    $scope.update_eligible_date = () ->
      usSpinnerService.stop('spinner-1')
      console.log $scope.team
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/team/update/#{ $scope.team.id }"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json",
                  'Content-Type': 'application/json'
                  }
        data: $scope.team
      ).then ( ( res ) ->
        console.log "Update team date"
        console.log res.data
        $scope.team.eligible_date =  moment(res.data[0].eligible_date).format('YYYY-MM-DD')
        $scope.team.eligible_date_end =  moment(res.data[0].eligible_date_end).format('YYYY-MM-DD')
        get_org_and_members()
        alertify.success "Eligible date updated"
      ), ( errResponse ) ->
        usSpinnerService.stop('spinner-1')
        console.log "Update date error "
        console.log errResponse
        alertify.error "Update failed"

    $('#select_player_modal').on 'shown.bs.modal', (e) -> #get team players when modal is opened
      if $scope.team.eligible_date?
        $scope.team.eligible_date = moment($scope.team.eligible_date).format('YYYY-MM-DD')
        $scope.team.eligible_date_end = moment($scope.team.eligible_date_end).format('YYYY-MM-DD')
        console.log $scope.team.eligible_date
        get_org_and_members() #update eligible player list. 
      else
        alertify.log("Please set the eligible date of this team. Click to dismiss", "", 0)
        
      
      
      


    get_org_and_members = -> #fetch org info with members. Only members under the teams eligible age. 
      usSpinnerService.spin('spinner-1')
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/org/get-org/#{ $scope.team.main_org.id }"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json",
                  'Content-Type': 'application/json'
                  }
        params: $scope.team
      ).then ( ( res ) ->
        console.log "Get org info "
        console.log res.data
        $scope.org_members = res.data.org_members
        $scope.team_members_array = $scope.team.team_members.map( ( member ) ->
            member.id ) #create array containing team members user.id
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


