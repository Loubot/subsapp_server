'use strict';
var return_team;

angular.module('subzapp').controller('TeamController', [
  '$scope', '$state', '$http', '$window', '$location', 'user', 'alertify', 'RESOURCES', 'Upload', '$filter', 'usSpinnerService', function($scope, $state, $http, $window, $location, user, alertify, RESOURCES, Upload, $filter, usSpinnerService) {
    var get_org_and_members, get_team_info, user_token;
    console.log('Team Controller');
    user_token = window.localStorage.getItem('user_token');
    get_team_info = function() {
      usSpinnerService.spin('spinner-1');
      if ($scope.user.club_admin) {
        return $http({
          method: 'GET',
          url: RESOURCES.DOMAIN + "/team/get-team-info/" + (window.localStorage.getItem('team_id')),
          headers: {
            'Authorization': "JWT " + user_token,
            "Content-Type": "application/json"
          }
        }).then((function(res) {
          usSpinnerService.stop('spinner-1');
          console.log("get_team_info response club admin");
          console.log(res);
          $scope.team = res.data.team;
          $scope.files = res.data.bucket_info.Contents;
          $scope.org_members = res.data.org.org_members;
          return $scope.team.eligible_date = moment($scope.team.eligible_date).format('YYYY-MM-DD');
        }), function(errResponse) {
          usSpinnerService.stop('spinner-1');
          console.log("get_team_info error");
          return console.log(errResponse);
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
          usSpinnerService.stop('spinner-1');
          console.log("Get team info response");
          console.log(res.data);
          return $scope.team = res.data;
        }), function(errResponse) {
          usSpinnerService.stop('spinner-1');
          console.log("Get team info error " + (JSON.stringify(errResponse)));
          return $state.go('login');
        });
      }
    };
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
        url: RESOURCES.DOMAIN + "/team/get-players-by-year/" + $scope.team.id,
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        }
      }).then((function(res) {
        console.log("Playsers by age response");
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
    $scope.update_members = function() {
      console.log("team id " + $scope.team.id);
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/team/update-members/" + $scope.team.id,
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json",
          'Content-Type': 'application/json'
        },
        data: {
          team_members: $scope.team_members_array
        }
      }).then((function(res) {
        console.log("Update team members");
        console.log(res);
        $scope.team_members_array = res.data.team_members.map(function(member) {
          return member.id;
        });
        return alertify.success("Team members updated successfully");
      }), function(errResponse) {
        console.log("Update team members error ");
        console.log(errResponse);
        return alertify.error("Failed to add team members");
      });
    };
    $scope.update_eligible_date = function() {
      usSpinnerService.stop('spinner-1');
      console.log($scope.team);
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/team/update/" + $scope.team.id,
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json",
          'Content-Type': 'application/json'
        },
        data: $scope.team
      }).then((function(res) {
        console.log("Update team date");
        console.log(res.data);
        $scope.team.eligible_date = moment(res.data[0].eligible_date).format('YYYY-MM-DD');
        get_org_and_members();
        return alertify.success("Eligible date updated");
      }), function(errResponse) {
        usSpinnerService.stop('spinner-1');
        console.log("Update date error ");
        console.log(errResponse);
        return alertify.error("Update failed");
      });
    };
    $('#select_player_modal').on('shown.bs.modal', function(e) {
      return get_org_and_members();
    });
    return get_org_and_members = function() {
      usSpinnerService.spin('spinner-1');
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/org/get-org/" + $scope.team.main_org.id,
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json",
          'Content-Type': 'application/json'
        },
        params: {
          date: moment($scope.team.eligible_date, "YYYY-MM-DD").toISOString()
        }
      }).then((function(res) {
        console.log("Get org info ");
        console.log(res.data);
        $scope.org_members = res.data.org_members;
        $scope.team_members_array = $scope.team.team_members.map(function(member) {
          return member.id;
        });
        usSpinnerService.stop('spinner-1');
        return alertify.success("Got players info");
      }), function(errResponse) {
        console.log("Get org info error ");
        usSpinnerService.stop('spinner-1');
        console.log(errResponse);
        return alertify.error("Couldn't get players info");
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

//# sourceMappingURL=../maps/controllers/TeamController.js.map
