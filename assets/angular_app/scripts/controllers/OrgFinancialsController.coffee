'use strict'

angular.module('subzapp').controller('OrgFinancialsController', [
  '$scope'
  '$rootScope'
  '$state'
  '$http'
  'RESOURCES'
  'alertify'
  'user'
  'COMMS'
  ( $scope, $rootScope, $state, $http, RESOURCES, alertify, user, COMMS ) ->
    console.log "OrgFinancialsController"

    user.get_user().then( ( res ) ->
      $scope.user = $rootScope.USER

      COMMS.GET(
        "/org/#{ $scope.user.org[0].id }"
      ).then ( ( res ) ->
        console.log "Got org info"
        console.log res.data.org
        $scope.org = res.data.org
        alertify.success "Got org info"
      ), ( errResponse ) ->
        console.log "Get org error"
        console.log. errResponse
        alertify.error "Failed to get org info"
    ) # end of get_user

])