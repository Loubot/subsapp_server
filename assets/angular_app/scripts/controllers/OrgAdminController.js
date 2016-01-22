// Generated by CoffeeScript 1.10.0
'use strict';
var return_org;

angular.module('subzapp').controller('OrgAdminController', [
  '$scope', '$state', '$http', '$window', 'message', 'user', '$location', 'RESOURCES', function($scope, $state, $http, $window, message, user, $location, RESOURCES) {
    var check_club_admin, user_token;
    check_club_admin = function(user) {
      if (!user.club_admin) {
        $state.go('login');
        return message.error('You are not a club admin. Contact subzapp admin team for assitance');
      }
    };
    console.log('OrgAdmin Controller');
    user_token = window.localStorage.getItem('user_token');
    user.get_user().then((function(res) {
      check_club_admin(window.USER);
      console.log(window.USER.orgs.length === 0);
      $scope.org = window.USER.orgs[0];
      $scope.user = window.USER;
      $scope.orgs = window.USER.orgs;
      $scope.show_team_admin = window.USER.orgs.length === 0;
      if ($scope.org != null) {
        return $http({
          method: 'GET',
          url: RESOURCES.DOMAIN + "/get-teams",
          headers: {
            'Authorization': "JWT " + user_token,
            "Content-Type": "application/json"
          },
          params: {
            org_id: $scope.org.id
          }
        }).then((function(org_and_teams) {
          console.log("Get org and teams");
          console.log(org_and_teams.data.teams);
          return $scope.teams = org_and_teams.data.teams;
        }), function(errResponse) {
          console.log("Get teams failed");
          console.log(errResponse);
          return message.error('Failed to fetch teams');
        });
      }
    }));
    $scope.org_create = function() {
      console.log(RESOURCES.DOMAIN + "/create-business");
      user_token = window.localStorage.getItem('user_token');
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
        console.log("Business create return ");
        console.log(response);
        $scope.orgs = response.data;
        $('.business_name').val("");
        return $('.business_address').val("");
      }), function(errResponse) {
        console.log("Business create error response " + (JSON.stringify(errResponse)));
        return $state.go('login');
      });
    };
    $scope.edit_org = function(id) {
      console.log("Org id " + $scope.org.id);
      $scope.show_team_admin = false;
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/org-admins",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        params: {
          org_id: $scope.org.id
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
    };
    $scope.team_create = function() {
      console.log("Org id " + $scope.org.id);
      $scope.team_form_data.org_id = $scope.org.id;
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
        message.success(response.data.message);
        $scope.teams = response.data.org.teams;
        $scope.team_form.$setPristine();
        return $scope.team_form_data = '';
      }), function(errResponse) {
        console.log("Team create error");
        console.log(errResponse);
        return message.error(errResponse);
      });
    };
    return $scope.delete_team = function(id) {
      return $http({
        url: RESOURCES.DOMAIN + "/delete-team",
        method: 'DELETE',
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: {
          team_id: id,
          org_id: $scope.org.id
        }
      }).then((function(res) {
        console.log("Team delete");
        console.log(res);
        return $scope.teams = res.data.teams;
      }), function(errResponse) {
        console.log("Team delete error");
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
