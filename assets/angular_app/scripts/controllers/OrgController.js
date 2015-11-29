// Generated by CoffeeScript 1.10.0
'use strict';
angular.module('subzapp').controller('OrgController', [
  '$scope', '$state', '$http', '$window', '$location', 'message', 'RESOURCES', function($scope, $state, $http, $window, $location, message, RESOURCES) {
    var params, user_token;
    console.log('Org Controller');
    console.log("check it " + (JSON.stringify($location.search())));
    params = $location.search();
    console.log("params " + params.id);
    user_token = JSON.parse(window.localStorage.getItem('user_token'));
    $http({
      method: 'GET',
      url: RESOURCES.DOMAIN + "/get-business",
      headers: {
        'Authorization': "JWT " + user_token,
        "Content-Type": "application/json"
      },
      params: {
        org_id: params.id
      }
    }).then((function(response) {
      console.log("Org response " + (JSON.stringify(response.data)));
      $scope.org = response.data.org;
      return $scope.teams = response.data.teams;
    }), function(errResponse) {
      console.log("Org error " + (JSON.stringify(errResponse)));
      return message.error(errResponse.data.message);
    });
    return $scope.team_create = function() {
      $scope.team_form_data.user_id = window.localStorage.getItem('user_id');
      $scope.team_form_data.org_id = params.id;
      console.log("Form data " + (JSON.stringify($scope.team_form_data)));
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/create-team",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: $scope.team_form_data
      }).then((function(team) {
        return console.log("Team create response " + (JSON.stringify(team)));
      }), function(errResponse) {
        return console.log("Teacm create error " + (JSON.stringify(errResponse)));
      });
    };
  }
]);
