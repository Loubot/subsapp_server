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
          "/org/#{ $scope.org.id }/authenticate-stripe"
          auth_code: $location.search().code
        ).then ( ( res ) ->
          console.log "Authenticated stripe"
          alertify.success "Authenticated stripe"
          console.log res
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



])