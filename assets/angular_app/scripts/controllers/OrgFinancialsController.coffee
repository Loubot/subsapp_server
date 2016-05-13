'use strict'

angular.module('subzapp').controller('OrgFinancialsController', [
  '$scope'
  '$rootScope'
  '$state'
  '$http'
  'RESOURCES'
  '$location'
  'alertify'
  'user'
  'COMMS'
  ( $scope, $rootScope, $state, $http, RESOURCES, $location, alertify, user, COMMS ) ->
    console.log "OrgFinancialsController"

    check_for_stripe_code = ->
      if $location.search().code?
        console.log $location.search().code
        COMMS.POST(
          "/payment/#{ $scope.org.id }/authenticate-stripe"
          auth_code: $location.search().code
        ).then ( ( res ) ->
          console.log "Authenticated stripe"
          
          
          message = JSON.parse res.data.body
          console.log message.error_description
          if message.error_description?
            alertify.error message.error_description
          else
            alertify.success "Authenticated stripe"

        ), ( errResponse ) ->

          console.log "Failed to authenticate stripe"
          alertify.error "Failed to authenticate stripe"
          console.log errResponse


    user.get_user().then( ( res ) ->
      $scope.user = $rootScope.USER

      COMMS.GET(
        "/org/#{ $scope.user.org[0].id }"
      ).then ( ( res ) ->
        console.log "Got org info"
        console.log res.data.org
        $scope.org = res.data.org
        alertify.success "Got org info"
        check_for_stripe_code()
      ), ( errResponse ) ->
        console.log "Get org error"
        console.log. errResponse
        alertify.error "Failed to get org info"
    ) # end of get_user


  ###################### calendar stuff ############################

    $scope.dt = {}
   

    $scope.today = ->
      $scope.dt.start_date = new Date()
      date = new Date()
      $scope.dt.end_date = date.setDate( date.getDate() + 1 )
      console.log "Date #{ $scope.dt.end_date }"
      return

    $scope.today()

    $scope.clear = ->
      $scope.dt = null
      return




    $scope.open1 = ->
      $scope.popup1.opened = true
      return

    $scope.open2 = ->
      $scope.popup2.opened = true
      return

    $scope.setDate = (year, month, day) ->
      $scope.dt = new Date(year, month, day)
      return

    
    $scope.format = "dd-MMMM-yyyy"
    $scope.popup1 = opened: false
    $scope.popup2 = opened: false

  ##################### end of calendar stuff ##########################

    $scope.get_events = ->
      console.log "team #{ window.localStorage.getItem 'team_id' }"
      COMMS.GET(
        "/team/#{ window.localStorage.getItem 'team_id' }/teams-events"
        $scope.dt
      ).then ( ( resp ) ->
        console.log resp
      ), ( errResponse ) ->
        console.log errResponse
])