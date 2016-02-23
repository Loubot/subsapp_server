'use strict';
var return_team;

angular.module('subzapp').controller('TeamController', [
  '$scope', '$state', '$http', '$window', '$location', 'user', 'alertify', 'RESOURCES', 'Upload', function($scope, $state, $http, $window, $location, user, alertify, RESOURCES, Upload) {
    var get_team_info, user_token;
    console.log('Team Controller');
    user_token = window.localStorage.getItem('user_token');
    if (!(window.USER != null)) {
      user.get_user().then((function(res) {
        $scope.user = window.USER;
        $scope.org = window.USER.orgs[0];
        $scope.teams = window.USER.teams;
        return_team(USER.teams, $location.search().id);
        $scope.show_upload = window.USER.club_admin;
        if ($scope.user.club_admin) {
          return get_team_info();
        }
      }), function(errResponse) {
        return window.USER = null;
      });
    } else {
      console.log("USER already defined");
      $scope.user = window.USER;
      $scope.org = window.USER.orgs[0];
      $scope.teams = window.USER.teams;
      $scope.user = window.USER;
      if ($scope.user.club_admin) {
        get_team_info();
      }
    }
    $scope.create_event = function() {
      $scope.create_event_data.team_id = $scope.team.id;
      console.log($scope.create_event_data);
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/create-event",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json",
          'Content-Type': 'application/json'
        },
        data: $scope.create_event_data
      }).then((function(res) {
        alertify.success("Event created");
        console.log(res.data);
        return $scope.events = res.data;
      }), function(errResponse) {
        console.log("Create event error");
        alertify.error("Create event failed");
        return console.log(errResponse);
      });
    };
    $scope.submit = function() {
      return $scope.upload($scope.file);
    };
    $scope.upload = function(file) {
      console.log("Upload");
      console.log(file);
      console.log(JSON.stringify($scope.team.name));
      return Upload.upload({
        method: 'post',
        url: '/file/upload',
        data: {
          org_id: $scope.team.main_org.id,
          team_id: $scope.team.id,
          team_name: $scope.team.name
        },
        file: file
      }).then((function(resp) {
        console.log('Success ' + JSON.stringify(resp + 'uploaded. Response: ' + JSON.stringify(resp.data)));
        console.log(resp);
        $scope.files = resp.data.bucket_info.Contents;
        alertify.success("File uploaded ok");
      }), (function(resp) {
        console.log('Error status: ' + resp.status);
        alertify.error("File failed to upload");
        console.log(resp);
        alertify.error("File upload failed. Status: " + resp.status);
      }), function(evt) {
        var progressPercentage;
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
        return console.log('progress: ' + progressPercentage + '% ' + evt.config.data);
      });
    };
    $scope.get_players_by_year = function(id) {
      console.log("Find by date");
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/user/get-players-by-year",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        params: {
          team_id: id
        }
      }).then((function(res) {
        console.log("Download response");
        return console.log(res);
      }), function(errResponse) {
        return console.log("DOwnload error " + (JSON.stringify(errResponse)));
      });
    };
    $scope.download = function() {
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/user/download-file",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        }
      }).then((function(res) {
        console.log("Download response");
        return console.log(res);
      }), function(errResponse) {
        return console.log("DOwnload error " + (JSON.stringify(errResponse)));
      });
    };
    return get_team_info = function() {
      if ($scope.user.club_admin) {
        return $http({
          method: 'GET',
          url: RESOURCES.DOMAIN + "/team/get-team-info/" + (window.localStorage.getItem('team_id')),
          headers: {
            'Authorization': "JWT " + user_token,
            "Content-Type": "application/json"
          }
        }).then((function(res) {
          console.log("get_team_info response");
          return console.log(res);
        }), function(errResponse) {
          return console.log("get_team_info error " + (JSON.stringify(errResponse)));
        });
      } else {
        return $http({
          method: 'GET',
          url: RESOURCES.DOMAIN + "/team/" + (window.localStorage.getItem('team_id')),
          headers: {
            'Authorization': "JWT " + user_token,
            "Content-Type": "application/json"
          }
        }).then((function(res) {
          console.log("Get team info response");
          console.log(res.data);
          return $scope.team = res.data;
        }), function(errResponse) {
          return console.log("Get team info error " + (JSON.stringify(errResponse)));
        });
      }
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

//# sourceMappingURL=../maps/controllers/TeamController.js.map
