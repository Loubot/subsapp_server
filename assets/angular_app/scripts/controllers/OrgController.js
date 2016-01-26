// Generated by CoffeeScript 1.10.0
'use strict';
angular.module('subzapp').controller('OrgController', [
  '$scope', '$state', '$http', '$window', '$location', 'user', 'RESOURCES', 'alertify', 'Upload', function($scope, $state, $http, $window, $location, user, RESOURCES, alertify, Upload) {
    var check_club_admin, user_token;
    user_token = window.localStorage.getItem('user_token');
    $scope.submit = function() {
      return $scope.upload($scope.file);
    };
    $scope.upload = function(file) {
      console.log(file);
      return Upload.upload({
        method: 'post',
        url: '/file/upload',
        file: file
      }).then((function(resp) {
        console.log('Success ' + resp + 'uploaded. Response: ' + resp.data);
      }), (function(resp) {
        console.log('Error status: ' + resp.status);
      }), function(evt) {
        var progressPercentage;
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
        return console.log('progress: ' + progressPercentage + '% ' + evt.config.data);
      });
    };
    check_club_admin = function(user) {
      if (!user.team_admin) {
        $state.go('login');
      }
      alertify.error('You are not a club admin. Contact subzapp admin team for assitance');
      return false;
    };
    console.log('Org Controller');
    if (!(window.USER != null)) {
      user.get_user().then((function(res) {
        return $scope.org = window.USER.orgs[0];
      }), function(errResponse) {
        console.log("User get error " + (JSON.stringify(errResponse)));
        window.USER = null;
        return $state.go('login');
      });
    } else {
      console.log("USER already defined");
      $scope.org = window.USER.orgs[0];
    }
    $scope.parse_users = function() {
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/parse-users",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        }
      }).then((function(res) {
        console.log("parse users response");
        console.log(res);
        return $scope.parsed_data = res;
      }), function(errResponse) {
        console.log("Parse users error");
        return console.log(errResponse);
      });
    };
    return $scope.aws = function() {
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/aws",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        }
      }).then((function(res) {
        console.log("aws responses");
        console.log(res);
        return $scope.parsed_data = res;
      }), function(errResponse) {
        console.log("aws error");
        console.log(errResponse);
        return alertify.error(errResponse.data);
      });
    };
  }
]);
