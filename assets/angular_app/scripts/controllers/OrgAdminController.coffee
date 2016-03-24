'use strict'

angular.module('subzapp').controller('OrgAdminController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  'user'
  'RESOURCES'
  'alertify'
  'Upload'
  'usSpinnerService'
  'uiGmapGoogleMapApi'
  ( $scope, $state, $http, $window, user, RESOURCES, alertify, Upload, usSpinnerService, uiGmapGoogleMapApi ) ->
    
    check_club_admin = ( user ) ->
      if !user.club_admin
        $state.go 'login' 
        alertify.error 'You are not a club admin. Contact subzapp admin team for assitance'

    console.log 'OrgAdmin Controller'


    user_token = window.localStorage.getItem 'user_token'
    user.get_user().then ( (res) ->
      # console.log "Got user "
      check_club_admin(window.USER)
      # console.log window.USER.orgs.length == 0
      $scope.org = window.USER.orgs[0]
      console.log "org id #{ JSON.stringify $scope.org }"
      $scope.user = window.USER
      $scope.orgs = window.USER.orgs
      $scope.show_team_admin = ( window.USER.orgs.length == 0 )
      
      if $scope.org?
        usSpinnerService.spin('spinner-1')
        $http(
          method: 'GET'
          url: "#{ RESOURCES.DOMAIN }/org/#{ $scope.org.id }"
          headers: { 
                    'Authorization': "JWT #{ user_token }", "Content-Type": "application/json"
                    }
          params: 
            org_id: $scope.org.id
        ).then ( ( org_and_teams ) ->
          usSpinnerService.stop('spinner-1')
          console.log "Get org and teams"
          console.log org_and_teams
          $scope.teams = org_and_teams.data.org.teams
          $scope.files = org_and_teams.data.s3_object.Contents
        ), ( errResponse ) ->
          usSpinnerService.stop('spinner-1')
          console.log "Get teams failed"
          console.log  errResponse
          alertify.error 'Failed to fetch teams'
    )

    $scope.view_team = ( id ) -> # go to team page
      window.localStorage.setItem 'team_id', id
      $state.go 'team_manager'

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

        # console.log "Business create return "
        # console.log response
        $scope.orgs = response.data
        $scope.org = response.data[0]
        console.log "Org set: #{ JSON.stringify $scope.org }"
        alertify.success "Club created successfully"
        # $scope.business_form.$setPristine()
        $('.business_name').val ""
        $('.business_address').val ""

      ), ( errResponse ) ->
        console.log "Business create error response #{ JSON.stringify errResponse }"
        $state.go 'login'

    $scope.edit_org = ( id ) ->

      console.log "Org #{ JSON.stringify $scope.org }"

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
      console.log "Org id #{ JSON.stringify $scope.org }"
      $scope.team_form_data.org_id = $scope.org.id
      console.log "Form data #{ JSON.stringify $scope.team_form_data }"
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

    $scope.aws = ->
      
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/parse-players"
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

    # upload file

    $scope.submit = ->
      usSpinnerService.spin('spinner-1')
      $scope.upload $scope.file

    $scope.upload = (file) ->
      console.log "Upload"
      if ( $scope.file.info )?
        
        file_info = JSON.parse $scope.file.info
        console.log "Defined #{ file_info }"
        file_info = 
          org_id: $scope.org.id
          team_id: file_info[0]
          team_name: file_info[1]
        console.log "file_info #{ JSON.stringify file_info }"
      else
        console.log "Not defined "
        file_info = org_id: $scope.org.id
      

      # console.log "File #{ JSON.stringify file_info[1] }"
      Upload.upload(
        method: 'post'
        url: '/file/upload'
        data:
          file_info

        file: file     
          
      ).then ((resp) ->
        usSpinnerService.stop('spinner-1')
        console.log 'Success ' + JSON.stringify resp + 'uploaded. Response: ' + JSON.stringify resp.data
        console.log resp
        $scope.files = resp.data.bucket_info.Contents
        alertify.success "File uploaded ok"
        return
      ), ((resp) ->
        usSpinnerService.stop('spinner-1')
        console.log 'Error status: ' + resp.status
        alertify.error "File failed to upload"
        console.log resp

        alertify.error "File upload failed. Status: #{ resp.status }"
        return
      ), (evt) ->
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
        console.log 'progress: ' + progressPercentage + '% ' + evt.config.data

    
    $scope.convert_date = ( date ) ->
      console.log "date #{ date }"
      console.log "New date #{ moment( date ).format( "DD-MM-YYYY" ) }"
      return moment( date ).format( "DD-MM-YYYY" )

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