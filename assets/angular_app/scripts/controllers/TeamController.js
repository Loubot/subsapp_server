// Generated by CoffeeScript 1.10.0
'use strict';
var return_team;

angular.module('subzapp').controller('TeamController', [
  '$scope', '$state', '$http', '$window', '$location', 'user', 'message', 'RESOURCES', function($scope, $state, $http, $window, $location, user, message, RESOURCES) {
    var user_token;
    console.log('Team Controller');
    user_token = window.localStorage.getItem('user_token');
    if (!(window.USER != null)) {
      user.get_user().then((function(res) {
        $scope.user = window.USER;
        $scope.org = window.USER.orgs[0];
        return_team(USER.teams, $location.search().id);
        return console.log("f " + (JSON.stringify(USER.teams)));
      }), function(errResponse) {
        window.USER = null;
        return $state.go('login');
      });
    } else {
      console.log("USER already defined");
      $scope.user = window.USER;
      $scope.org = window.USER.orgs[0];
    }
    console.log($location.search().id);
    $http({
      method: 'GET',
      url: RESOURCES.DOMAIN + "/get-team-members",
      headers: {
        'Authorization': "JWT " + user_token,
        "Content-Type": "application/json"
      },
      params: {
        team_id: $location.search().id
      }
    }).then((function(res) {
      console.log("Get team members response " + (JSON.stringify(res)));
      return $scope.mems = res.data.team_members;
    }), function(errResponse) {
      return console.log("Get team members error " + (JSON.stringify(errResponse)));
    });
    return $scope.create_event = function() {
      $scope.create_event_data.team_id = $location.search().id;
      console.log($scope.create_event_data);
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/create-event",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: $scope.create_event_data
      }).then((function(res) {
        console.log("Create event response");
        return console.log(res);
      }), function(errResponse) {
        console.log("Create event error");
        return console.log(errResponse);
      });
    };
  }
]);

return_team = function(teams, id) {
  var team;
  team = (function() {
    var i, len, results;
    results = [];
    for (i = 0, len = teams.length; i < len; i++) {
      team = teams[i];
      if (team.id === parseInt(id)) {
        results.push(team);
      }
    }
    return results;
  })();
  console.log("Team " + (JSON.stringify(team)));
  return team;
};
