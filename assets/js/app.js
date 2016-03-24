window.USER = null;

'use strict';

angular.module('subzapp', ['ngAnimate', 'ui.router', 'ngRoute', 'ui.bootstrap.datetimepicker', "ngAlertify", 'ngFileUpload', "checklist-model", 'angularSpinner', 'uiGmapgoogle-maps']);

angular.module('subzapp').config(function(uiGmapGoogleMapApiProvider) {
  uiGmapGoogleMapApiProvider.configure({
    v: '3.20',
    libraries: 'weather,geometry,visualization'
  });
});

angular.module('subzapp').constant('API', 'api/v1/');

angular.module('subzapp').config(function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise("/");
  $stateProvider.state("user", {
    url: "/user",
    templateUrl: 'angular_app/views/user/user.html',
    controller: "UserController"
  });
  $stateProvider.state("edit-user", {
    url: "/user/edit",
    templateUrl: 'angular_app/views/user/edit_user.html',
    controller: "EditUserController"
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
  $stateProvider.state("register_manager", {
    url: '/register-manager',
    templateUrl: 'angular_app/views/register/register_manager.html',
    controller: 'RegisterManagerController'
  });
  $stateProvider.state("org", {
    url: '/org',
    templateUrl: 'angular_app/views/org/org.html',
    controller: 'OrgController'
  });
  $stateProvider.state("org_admin", {
    url: '/org_admin',
    templateUrl: "angular_app/views/org/org_admin.html",
    controller: 'OrgAdminController'
  });
  $stateProvider.state("org_admin_team", {
    url: '/org_admin_team',
    templateUrl: "angular_app/views/org/org_admin_team.html",
    controller: 'OrgAdminTeamController'
  });
  $stateProvider.state("team", {
    url: '/team',
    templateUrl: 'angular_app/views/team/team.html',
    controller: 'TeamController'
  });
  $stateProvider.state('team_manager_home', {
    url: '/team-manager-home',
    templateUrl: 'angular_app/views/team/team_manager_home.html',
    controller: 'TeamController'
  });
  $stateProvider.state('team_manager', {
    url: '/team-manager',
    templateUrl: 'angular_app/views/team/team_manager.html',
    controller: 'TeamController'
  });
  $stateProvider.state('event', {
    url: '/event',
    templateUrl: 'angular_app/views/event/event.html',
    controller: 'EventController'
  });
  $stateProvider.state('password-reminder', {
    url: '/password/remind',
    templateUrl: 'angular_app/views/password_reminder/password_reminder.html',
    controller: 'PasswordReminderController'
  });
  return $stateProvider.state('password-reset', {
    url: '/password/reset',
    templateUrl: 'angular_app/views/password_reminder/password_reset.html',
    controller: 'PasswordReminderController'
  });
});

angular.module('subzapp').constant('RESOURCES', (function() {
  var url;
  console.log("url" + window.location.origin);
  url = window.location.origin;
  return {
    DOMAIN: url
  };
})());

angular.module('subzapp').service('user', function($http, $state, RESOURCES) {
  console.log("user service");
  return {
    check_if_org_admin: function(user, id) {
      return parseInt(user.orgs[0].id) === parseInt(id);
    },
    get_user: function() {
      var id, user_token;
      console.log("yyyyyyyyyyyyyyyyyyy");
      user_token = window.localStorage.getItem('user_token');
      id = window.localStorage.getItem('user_id');
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/user/" + id,
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        }
      }).success(function(data) {
        console.log("Fetched user data");
        console.log(data);
        if (!(data != null)) {
          $state.go('login');
          console.log("No user data");
          return false;
        } else {
          console.log("Got user");
          window.USER = data;
          return data;
        }
      }).error(function(err) {
        console.log("Fetching user data error " + (JSON.stringify(err)));
        return $state.go('login');
      });
    }
  };
});

//# sourceMappingURL=maps/app.js.map
