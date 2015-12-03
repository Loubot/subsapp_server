// Generated by CoffeeScript 1.10.0
'use strict';
angular.module('subzapp').controller('UserController', [
  '$scope', '$state', '$http', '$window', 'message', 'user', 'RESOURCES', function($scope, $state, $http, $window, message, user, RESOURCES) {
    console.log('User Controller');
    if (!(window.USER != null)) {
      user.get_user().then((function(res) {
        $scope.orgs = window.USER.orgs;
        return res;
      }), function(errResponse) {
        console.log("User get error " + (JSON.stringify(errResponse)));
        return $state.go('login');
      });
    }
    $scope.business_create = function() {
      var user_token;
      console.log("create " + (JSON.stringify(user)));
      user_token = JSON.parse(window.localStorage.getItem('user_token'));
      $scope.business_form_data.user_id = window.localStorage.getItem('user_id');
      console.log(JSON.stringify($scope.business_form_data));
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/create-business",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: $scope.business_form_data
      }).then((function(response) {
        console.log("Business create return " + (JSON.stringify(response.data)));
        $scope.orgs = response.data;
        return $scope.business_form.$setPristine();
      }), function(errResponse) {
        console.log("Business create error response " + (JSON.stringify(errResponse)));
        return $state.go('login');
      });
    };
    return $scope.delete_business = function(id) {
      var user_token;
      user_token = JSON.parse(window.localStorage.getItem('user_token'));
      return $http({
        method: 'DELETE',
        url: RESOURCES.DOMAIN + "/delete-business",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: {
          org_id: id
        }
      }).then((function(response) {
        return console.log("Delete response " + (JSON.stringify(response)));
      }), function(errResponse) {
        return console.log("Delete error response " + (JSON.stringify(errResponse)));
      });
    };
  }
]);
