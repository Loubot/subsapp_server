'use strict'

angular.module('subzapp').controller('TeamController', [
  '$scope'
  '$state'
  '$http'
  '$window'
  '$location'
  'user'
  'message'
  'RESOURCES'
  ( $scope, $state, $http, $window, $location, user, message, RESOURCES ) ->    
    console.log 'Team Controller'
    if !(window.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify res }"
        console.log "TeamController teams #{ JSON.stringify window.USER }"
        $scope.user = window.USER
        $scope.org = window.USER.orgs[0]
        # $scope.org = response.data.org

        find_team = (id) ->
          team =  ( team for team in window.USER.teams when team.id = id )
          console.log "team #{ JSON.stringify $scope.team }"
          return team[0]

        $scope.team = find_team($location.search().id )
        
        console.log "f #{ JSON.stringify $scope.team}"
      ), ( errResponse ) ->
        console.log "User get error #{ JSON.stringify errResponse }"
        $state.go 'login'
    else
      console.log "USER already defined"
      $scope.org = window.USER.orgs[0]
    
    

      

    # console.log "check it #{ JSON.stringify $location.search().id }"
    # params = $location.search()
  

])