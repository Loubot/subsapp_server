'use strict'

angular.module('subzapp', [
    'ngAnimate'
    'ui.router'
    'ngRoute'
])

angular.module('subzapp').constant('API', 'api/v1/')

#routes, using angular-ui-router
angular.module('subzapp').config ($stateProvider, $urlRouterProvider) ->

    $urlRouterProvider.otherwise "/"

    #login state
    # $stateProvider.state "login",
    #     url : "/"
    #     templateUrl : 'angular_app/views/login/login.html'
    #     controller : "LoginController"


