'use strict';
var return_team;

angular.module('subzapp').controller('TeamController', [
  '$scope', '$rootScope', '$state', 'COMMS', '$window', '$location', 'user', 'alertify', 'RESOURCES', '$filter', 'usSpinnerService', function($scope, $rootScope, $state, COMMS, $window, $location, user, alertify, RESOURCES, $filter, usSpinnerService) {
    var get_org_and_members, get_team_info, user_token;
    console.log('Team Controller');
    user_token = window.localStorage.getItem('user_token');
    $scope.location = null;
    get_team_info = function() {
      usSpinnerService.spin('spinner-1');
      if ($rootScope.USER.club_admin) {
        return COMMS.GET("/team/get-team-info/" + (window.localStorage.getItem('team_id'))).then((function(res) {
          usSpinnerService.stop('spinner-1');
          console.log("get_team_info response club admin");
          console.log(res);
          $scope.team = res.data.team;
          $scope.org_members = res.data.org.org_members;
          return $scope.locations = res.data.org.org_locations;
        }), function(errResponse) {
          usSpinnerService.stop('spinner-1');
          console.log("get_team_info error");
          return console.log(errResponse);
        });
      } else {
        return COMMS.GET("/team/" + (window.localStorage.getItem('team_id'))).then((function(res) {
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
    if (!($rootScope.USER != null)) {
      user.get_user().then((function(res) {
        $scope.user = $rootScope.USER;
        $scope.org = $rootScope.USER.orgs[0];
        $scope.teams = $rootScope.USER.teams;
        return_team($rootScope.USER.teams, $location.search().id);
        $scope.show_upload = $rootScope.USER.club_admin;
        if ($rootScope.USER.club_admin) {
          return get_team_info();
        }
      }), function(errResponse) {
        return $rootScope.USER = null;
      });
    } else {
      console.log("USER already defined");
      $scope.user = $rootScope.USER;
      $scope.org = $rootScope.USER.orgs[0];
      $scope.teams = $rootScope.USER.teams;
      $scope.user = $rootScope.USER;
      if ($rootScope.USER.club_admin) {
        get_team_info();
      }
    }
    $scope.create_event = function() {
      $scope.create_event_data.team_id = $scope.team.id;
      $scope.create_event_data.user_id = $rootScope.USER.id;
      console.log($scope.create_event_data);
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/event",
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
      console.log("Team members array");
      console.log($scope.team_members_array);
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
        $scope.team.eligible_date_end = moment(res.data[0].eligible_date_end).format('YYYY-MM-DD');
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
      if ($scope.team.eligible_date != null) {
        $scope.team.eligible_date = moment($scope.team.eligible_date).format('YYYY-MM-DD');
        $scope.team.eligible_date_end = moment($scope.team.eligible_date_end).format('YYYY-MM-DD');
        console.log($scope.team.eligible_date);
        return get_org_and_members();
      } else {
        return alertify.log("Please set the eligible date of this team. Click to dismiss", "", 0);
      }
    });
    get_org_and_members = function() {
      console.log("org id " + $scope.team.main_org.id);
      usSpinnerService.spin('spinner-1');
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/org/get-org-team-members/" + $scope.team.main_org.id,
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json",
          'Content-Type': 'application/json'
        },
        params: $scope.team
      }).then((function(res) {
        console.log("Get org info ");
        console.log(res.data);
        $scope.org_members = res.data.org.org_members;
        $scope.team_members_array = res.data.team.team_members.map(function(member) {
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
    return $scope.update_location = function(id) {
      return console.log($scope.location);
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
