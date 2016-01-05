// Generated by CoffeeScript 1.10.0
'use strict';
var return_teams;

angular.module('subzapp').controller('OrgController', [
  '$scope', '$state', '$http', '$window', '$location', 'user', 'message', 'RESOURCES', function($scope, $state, $http, $window, $location, user, message, RESOURCES) {
    var check_club_admin, params;
    check_club_admin = function(user) {
      $state.go('login');
      $message.error('You are not a club admin. Contact subzapp admin team for assitance');
      return false;
    };
    console.log('Org Controller');
    if (!(window.USER != null)) {
      user.get_user().then((function(res) {
        check_club_admin(window.User);
        return $scope.teams = return_teams(window.USER.teams, $location.search().id);
      }), function(errResponse) {
        console.log("User get error " + (JSON.stringify(errResponse)));
        window.USER = null;
        return $state.go('login');
      });
    } else {
      console.log("USER already defined");
      $scope.org = window.USER.orgs[0];
      $scope.teams = return_teams(window.USER.teams, $location.search().id);
    }
    console.log("check it " + (JSON.stringify($location.search())));
    params = $location.search();
    $scope.team_create = function() {
      var user_token;
      user_token = window.localStorage.getItem('user_token');
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
      }).then((function(teams) {
        console.log("Team create response " + (JSON.stringify(teams)));
        $('.team_name').val("");
        return $scope.teams = teams.data;
      }), function(errResponse) {
        return console.log("Teacm create error " + (JSON.stringify(errResponse)));
      });
    };
    return $scope.delete_team = function(id) {
      var user_token;
      user_token = window.localStorage.getItem('user_token');
      return $http({
        method: 'DELETE',
        url: RESOURCES.DOMAIN + "/delete-team",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: {
          team_id: id
        }
      }).then((function(res) {
        return console.log("Delete response " + (JSON.stringify(res)));
      }), function(errResponse) {
        return console.log("Delte team error " + (JSON.stringify(errResponse)));
      });
    };
  }
]);

return_teams = function(all_teams, id) {
  var teams;
  teams = [];
  $(window.USER.teams).each(function() {
    if (this.main_org === parseInt(id)) {
      return teams.push(this);
    }
  });
  return teams;
};
