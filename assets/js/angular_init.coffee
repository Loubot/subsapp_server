window.logged_in_user = null

window.subzapp_server = angular.module('subzapp_server', [ 'ngRoute', 'ngAnimate' ])
angular.module('subzapp_server.controllers', [])
subzapp_server.config ($routeProvider) ->
  $routeProvider.when('/',
    # controller: 'login_controller'
    templateUrl: 'login/login')




subzapp_server.constant 'RESOURCES', do ->
  # Define your variable
  url = 'http://localhost:1337'
  # Use the variable in your constants
  {
    DOMAIN: url
    # USERS_API: resource + '/users'
    # BASIC_INFO: resource + '/api/info'
  }

window.subzapp_server.controller 'login_controller', ($scope, $http, $location, RESOURCES) ->
  console.log 'login conteroller'
  $scope.user = {}
  alert 'b'
  











  # init()
  # return
$(document).ready ->
  # $('body').css 'width', window.innerWidth()
  


  


  #
  
  