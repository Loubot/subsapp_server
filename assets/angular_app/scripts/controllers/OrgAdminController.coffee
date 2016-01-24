'use strict'

angular.module('subzapp').controller('OrgAdminController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'user'
  '$location'
  'RESOURCES'
  'alertify'
  ( $scope, $state, $http, $window, user, $location, RESOURCES, alertify ) ->
    check_club_admin = ( user ) ->
      if !user.club_admin
        $state.go 'login' 
        alertify.error 'You are not a club admin. Contact subzapp admin team for assitance'

    console.log 'OrgAdmin Controller'

    alertify.success("Success log message")

    user_token = window.localStorage.getItem 'user_token'
    user.get_user().then ( (res) ->
      # console.log "Got user "
      check_club_admin(window.USER)
      console.log window.USER.orgs.length == 0
      $scope.org = window.USER.orgs[0]
      $scope.user = window.USER
      $scope.orgs = window.USER.orgs
      $scope.show_team_admin = ( window.USER.orgs.length == 0 )
      
      if $scope.org?
        $http(
          method: 'GET'
          url: "#{ RESOURCES.DOMAIN }/get-teams"
          headers: { 
                    'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                    }
          params: 
            org_id: $scope.org.id
        ).then ( ( org_and_teams ) ->
          console.log "Get org and teams"
          console.log org_and_teams.data.teams
          $scope.teams = org_and_teams.data.teams
        ), ( errResponse ) ->
          console.log "Get teams failed"
          console.log  errResponse
          alertify.error 'Failed to fetch teams'
    )

    $scope.org_create = ->
      # console.log "create #{JSON.stringify user}"
      console.log "#{ RESOURCES.DOMAIN }/create-business"
      user_token = window.localStorage.getItem 'user_token'
      $scope.business_form_data.user_id = window.localStorage.getItem 'user_id'
      console.log JSON.stringify $scope.business_form_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/create-business"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
        data: 
          $scope.business_form_data
      ).then ( (response) ->

        console.log "Business create return "
        console.log response
        $scope.orgs = response.data
        # $scope.business_form.$setPristine()
        $('.business_name').val ""
        $('.business_address').val ""

      ), ( errResponse ) ->
        console.log "Business create error response #{ JSON.stringify errResponse }"
        $state.go 'login'

    $scope.edit_org = ( id ) ->
      # $scope.org_id = id

      console.log "Org id #{ $scope.org.id }"
      $scope.show_team_admin = false
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/org-admins"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
        params:
          org_id: id
      ).then ( ( response ) ->
        console.log "get org-admins"
        console.log response
        
        $scope.admins = response.data.admins
        $scope.teams = response.data.teams
      ), ( errResponse ) ->
        console.log "Get org admins error"
        console.log errResponse

    

    $scope.team_create = ->
      console.log "Org id #{ $scope.org.id }"
      $scope.team_form_data.org_id = $scope.org.id
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/create-team"
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
        data: $scope.team_form_data
      ).then ( ( response ) ->
        console.log "Team create"
        console.log response
        alertify.success response.data.message
        $scope.teams = response.data.org.teams
        $scope.team_form.$setPristine()
        $scope.team_form_data = ''
      ), ( errResponse ) ->
        console.log "Team create error"
        console.log errResponse
        alertify.error errResponse

    $scope.delete_team = ( id ) ->
      $http(
        url: "#{ RESOURCES.DOMAIN }/delete-team"
        method: 'DELETE'
        headers: { 
                  'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                  }
        data:
          team_id: id
          org_id: $scope.org.id
      ).then ( ( res ) ->
        console.log "Team delete"
        console.log res
        $scope.teams = res.data.teams
      ), ( errResponse ) ->
        console.log "Team delete error"
        console.log errResponse
    
    

])

return_org = ( orgs, search) ->

  for org in orgs    
    if parseInt( org.id ) == parseInt( search.id )
      return org




# $http(
#   method: 'POST'
#   url: "#{ RESOURCES.DOMAIN }/send-mail"
#   headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
  
# ).then ( ( response ) ->
#   console.log "get mandrill-object"
#   console.log response
  
# ), ( errResponse ) ->
#   console.log "Get mandrill-object"
#   console.log errResponse