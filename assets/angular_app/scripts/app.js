// Generated by CoffeeScript 1.10.0
window.USER = null;

'use strict';

angular.module('subzapp', ['ngAnimate', 'ui.router', 'ngRoute']);

angular.module('subzapp').constant('API', 'api/v1/');

angular.module('subzapp').config(function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise("/");
  $stateProvider.state("user", {
    url: "/user",
    templateUrl: 'angular_app/views/user/user.html',
    controller: "UserController"
  });
  $stateProvider.state("login", {
    url: "/",
    templateUrl: 'angular_app/views/login/login.html',
    controller: "LoginController"
  });
  $stateProvider.state("register", {
    url: '/register',
    templateUrl: 'angular_app/views/register/register.html',
    controller: 'RegisterController'
  });
  return $stateProvider.state("org", {
    url: '/org',
    templateUrl: 'angular_app/views/org/org.html',
    controller: 'OrgController'
  });
});

angular.module('subzapp').constant('RESOURCES', (function() {
  var url;
  url = 'http://localhost:1337';
  return {
    DOMAIN: url
  };
})());

angular.module('subzapp').factory('message', function() {
  return {
    error: function(mes) {
      $('.login_error').text(mes);
      return $('.login_error').show('slide', {
        direction: 'right'
      }, 1000);
    }
  };
});

angular.module('subzapp').service('user', function($http, $state, RESOURCES) {
  console.log("user service");
  return {
    get_user: function() {
      var user_token;
      user_token = JSON.parse(window.localStorage.getItem('user_token'));
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/user",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        }
      }).success(function(data) {
        if (!(data[0] != null)) {
          $state.go('login');
          console.log("No user data");
          return false;
        } else {
          window.USER = data[0];
          return data[0];
        }
      }).error(function(err) {
        console.log("Fetching user data error " + (JSON.stringify(err)));
        return $state.go('login');
      });
    }
  };
});
