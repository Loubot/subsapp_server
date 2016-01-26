'use strict'

angular.module('subzapp').controller('NavController', [
  '$scope'
  '$state'
  '$stateParams'
  ($scope, $state, $stateParams) ->
    console.log 'Nav controller'

    $scope.goto = (state) ->
      console.log "going to #{state}, so there..."
      $state.go state 

    $scope.log_out = ->
      window.localStorage.setItem 'user_token', null
      window.localStorage.setItem 'user_id', null

      $state.go 'login'
])