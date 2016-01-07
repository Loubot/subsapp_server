// Generated by CoffeeScript 1.10.0
'use strict';
var return_org;

angular.module('subzapp').controller('OrgAdminController', [
  '$scope', '$state', '$http', '$window', 'message', 'user', '$location', 'RESOURCES', function($scope, $state, $http, $window, message, user, $location, RESOURCES) {
    var user_token;
    console.log('OrgAdmin Controller');
    user_token = window.localStorage.getItem('user_token');
    user.get_user().then((function(res) {
      $scope.user = res.data;
      $scope.orgs = window.USER.orgs;
      return $scope.org = return_org($scope.orgs, $location.search());
    }));
    console.log($location.search().id);
    $http({
      method: 'GET',
      url: RESOURCES.DOMAIN + "/org-admins",
      headers: {
        'Authorization': "JWT " + user_token,
        "Content-Type": "application/json"
      },
      params: {
        org_id: $location.search().id
      }
    }).then((function(response) {
      console.log("get org-admins");
      console.log(response);
      $scope.admins = response.data.admins;
      return $scope.teams = response.data.teams;
    }), function(errResponse) {
      console.log("Get org admins error");
      return console.log(errResponse);
    });
    return $scope.team_create = function() {
      $scope.team_form_data.org_id = $location.search().id;
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/create-team",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: $scope.team_form_data
      }).then((function(response) {
        console.log("Team create");
        console.log(response);
        return $scope.teams = response.data;
      }), function(errResponse) {
        console.log("Team create error");
        return console.log(errResponse);
      });
    };
  }
]);

return_org = function(orgs, search) {
  var i, len, org;
  for (i = 0, len = orgs.length; i < len; i++) {
    org = orgs[i];
    if (parseInt(org.id) === parseInt(search.id)) {
      return org;
    }
  }
};
