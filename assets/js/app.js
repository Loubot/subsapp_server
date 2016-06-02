'use strict';
angular.module('subzapp', ['angular-stripe', 'ngAnimate', 'ui.router', 'ngRoute', 'ui.bootstrap.datetimepicker', "ngAlertify", 'ngFileUpload', "checklist-model", 'angularSpinner', 'uiGmapgoogle-maps', 'ui.bootstrap', 'ui.dateTimeInput']);

angular.module('subzapp').config(function(uiGmapGoogleMapApiProvider) {
  return uiGmapGoogleMapApiProvider.configure({
    key: 'AIzaSyCwEGjP02TnzKzlAHNeLD8M_7cMw0fPATM',
    v: '3.23',
    libraries: 'weather,geometry,visualization,places'
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
    url: '/org-admin',
    templateUrl: "angular_app/views/org/org_admin.html",
    controller: 'OrgAdminController'
  });
  $stateProvider.state("org_admin_team", {
    url: '/org-admin-team',
    templateUrl: "angular_app/views/org/org_admin_team.html",
    controller: 'OrgAdminTeamController'
  });
  $stateProvider.state("org_financials", {
    url: '/org-financials',
    templateUrl: "angular_app/views/org/org_financials.html",
    controller: 'OrgFinancialsController'
  });
  $stateProvider.state('team_manager', {
    url: '/team-manager',
    templateUrl: 'angular_app/views/team/team_manager.html',
    controller: 'TeamController'
  });
  $stateProvider.state('team_events', {
    url: '/team-events',
    templateUrl: 'angular_app/views/team/team_events.html',
    controller: 'TeamEventsController'
  });
  $stateProvider.state('event', {
    url: '/event/:id',
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

angular.module('subzapp').service('user', function($http, $state, RESOURCES, $rootScope, alertify) {
  console.log("user service");
  return {
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
        if (!(data != null)) {
          $state.go('login');
          console.log("No user data");
          return false;
        } else {
          console.log("Got user");
          if (data.length <= 0) {
            alertify.error("No user data");
            $state.go('login');
            return false;
          }
          $rootScope.USER = data;
          return data;
        }
      })["catch"](function(err) {
        console.log("Fetching user data error " + (JSON.stringify(err)));
        return $state.go('login');
      });
    }
  };
});

angular.module('subzapp').service('COMMS', function($http, $state, RESOURCES, $rootScope, $q, usSpinnerService) {
  console.log("comms service");
  return {
    POST: function(url, data) {
      var user_token;
      console.log("Url " + RESOURCES.DOMAIN + url);
      user_token = window.localStorage.getItem('user_token');
      usSpinnerService.spin('spinner-1');
      return $q(function(resolve, reject) {
        return $http({
          method: 'POST',
          url: "" + RESOURCES.DOMAIN + url,
          headers: {
            'Authorization': "JWT " + user_token,
            "Content-Type": "application/json"
          },
          data: data
        }).then(function(result) {
          usSpinnerService.stop('spinner-1');
          if (result.user !== void 0) {
            $rootScope.USER = result.user;
          }
          return resolve(result);
        })["catch"](function(err_result) {
          usSpinnerService.stop('spinner-1');
          return reject(err_result);
        });
      });
    },
    GET: function(url, data) {
      var user_token;
      user_token = window.localStorage.getItem('user_token');
      usSpinnerService.spin('spinner-1');
      return $q(function(resolve, reject) {
        return $http({
          method: 'GET',
          url: "" + RESOURCES.DOMAIN + url,
          headers: {
            'Authorization': "JWT " + user_token,
            "Content-Type": "application/json"
          },
          params: data
        }).then(function(result) {
          usSpinnerService.stop('spinner-1');
          return resolve(result);
        })["catch"](function(err_result) {
          usSpinnerService.stop('spinner-1');
          return reject(err_result);
        });
      });
    },
    PATCH: function(url, data) {
      var user_token;
      user_token = window.localStorage.getItem('user_token');
      usSpinnerService.spin('spinner-1');
      return $q(function(resolve, reject) {
        return $http({
          method: 'PATCH',
          url: "" + RESOURCES.DOMAIN + url,
          headers: {
            'Authorization': "JWT " + user_token,
            "Content-Type": "application/json"
          },
          params: data
        }).then(function(result) {
          usSpinnerService.stop('spinner-1');
          return resolve(result);
        })["catch"](function(err_result) {
          usSpinnerService.stop('spinner-1');
          return reject(err_result);
        });
      });
    },
    DELETE: function(url, data) {
      var user_token;
      user_token = window.localStorage.getItem('user_token');
      usSpinnerService.spin('spinner-1');
      return $q(function(resolve, reject) {
        return $http({
          method: 'DELETE',
          url: "" + RESOURCES.DOMAIN + url,
          headers: {
            'Authorization': "JWT " + user_token,
            "Content-Type": "application/json"
          },
          data: data
        }).then(function(deleted) {
          usSpinnerService.stop('spinner-1');
          return resolve(deleted);
        })["catch"](function(err_deleting) {
          usSpinnerService.stop('spinner-1');
          return reject(err_deleting);
        });
      });
    }
  };
});

//# sourceMappingURL=maps/app.js.map
