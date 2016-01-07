'use strict'

angular.module('subzapp').controller('OrgController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  '$location'
  'user'
  'message'
  'RESOURCES'
  ( $scope, $state, $http, $window, $location, user, message, RESOURCES ) ->
    check_club_admin = ( user ) ->
      $state.go 'login' if !user.club_admin
      message.error 'You are not a club admin. Contact subzapp admin team for assitance'
      return false 

    console.log 'Org Controller'
    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify window.USER }"
        $scope.orgs = res.data.orgs
        check_club_admin(res.data)
        $scope.user = res.data
        $scope.teams = return_teams(window.USER.teams, $location.search().id)

      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        window.USER = null
        $state.go 'login'
    else
      console.log "USER already defined"
      $scope.org = window.USER.orgs[0]
        
      $scope.teams = return_teams(window.USER.teams, $location.search().id)

    console.log "check it #{ JSON.stringify $location.search() }"
    params = $location.search()

    $scope.business_create = ->
      # console.log "create #{JSON.stringify user}"
      user_token = window.localStorage.getItem 'user_token'
      $scope.business_form_data.user_id = window.localStorage.getItem 'user_id'
      console.log JSON.stringify $scope.business_form_data
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }/create-business"
        headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
        data: 
          $scope.business_form_data
      ).then ( (response) ->

        console.log "Business create return #{ JSON.stringify response.data }"
        $scope.orgs = response.data
        # $scope.business_form.$setPristine()
        $('.business_name').val ""
        $('.business_address').val ""

      ), ( errResponse ) ->
        console.log "Business create error response #{ JSON.stringify errResponse }"
        $state.go 'login'

    $scope.delete_business = (id) ->
      user_token = JSON.parse window.localStorage.getItem 'user_token'
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


    

    # $scope.team_create = ->
    #   user_token = window.localStorage.getItem 'user_token'
    #   $scope.team_form_data.user_id = window.localStorage.getItem 'user_id'
    #   $scope.team_form_data.org_id = params.id
    #   console.log "Form data #{ JSON.stringify $scope.team_form_data }"
    #   $http(
    #     method: 'POST'
    #     url: "#{ RESOURCES.DOMAIN}/create-team"
    #     headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    #     data: 
    #       $scope.team_form_data
    #   ).then ( (teams) ->
    #     console.log "Team create response #{ JSON.stringify teams }"
    #     $('.team_name').val ""
    #     $scope.teams = teams.data
    #   ), (errResponse) ->
    #     console.log "Teacm create error #{ JSON.stringify errResponse }"

    # $scope.delete_team = (id) ->
    #   user_token = window.localStorage.getItem 'user_token'
    #   $http(
    #     method: 'DELETE'
    #     url: "#{ RESOURCES.DOMAIN }/delete-team"
    #     headers: { 'Authorization': "JWT #{ user_token }", "Content-Type": "application/json" }
    #     data: 
    #       team_id: id
    #   ).then ( (res) ->
    #     console.log "Delete response #{ JSON.stringify res }"
    #   ), (errResponse) ->
    #     console.log "Delte team error #{ JSON.stringify errResponse }"

])


return_teams = (all_teams, id) ->
  teams = []
  $(window.USER.teams).each ->
    
    if @.main_org == parseInt(id)
      teams.push @

  return teams