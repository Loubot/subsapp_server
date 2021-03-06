'use strict';
angular.module('subzapp').controller('OrgAdminTeamController', [
  '$scope', '$state', '$http', '$window', 'user', '$location', 'RESOURCES', 'alertify', function($scope, $state, $http, $window, user, $location, RESOURCES, alertify) {
    var check_club_admin, user_token;
    console.log('OrgAdminTeam Controller');
    check_club_admin = function(user) {
      if (!user.club_admin) {
        $state.go('login');
        return alertify.error('You are not a club admin. Contact subzapp admin team for assitance');
      }
    };
    user_token = window.localStorage.getItem('user_token');
    user.get_user().then((function(res) {
      check_club_admin(res.data);
      $scope.user = res.data;
      return $scope.orgs = window.USER.orgs;
    }));
    console.log($location.search().id);
    $http({
      method: 'GET',
      url: RESOURCES.DOMAIN + "/get-team",
      headers: {
        'Authorization': "JWT " + user_token,
        "Content-Type": "application/json"
      },
      params: {
        team_id: $location.search().id
      }
    }).then((function(res) {
      console.log("Get team result");
      console.log(res);
      $scope.org = res.data.main_org;
      return $scope.team = res.data;
    }), function(errResponse) {
      console.log("Get team error");
      return console.log(errResponse);
    });
    return $scope.invite_manager = function() {
      console.log($scope.invite_manager_data);
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/invite-manager",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: {
          org_id: $scope.org.id,
          team_id: $location.search().id,
          club_admin: $scope.user.id,
          club_admin_email: $scope.user.email,
          invited_email: $scope.invite_manager_data.invited_email,
          main_org_name: $scope.org.name,
          team_name: $scope.team.name
        }
      }).then((function(response) {
        console.log("Send invite mail");
        console.log(response);
        return alertify.success("Invite sent ok");
      }), function(errResponse) {
        console.log("Send invite mail");
        console.log(errResponse);
        return alertify.error(errResponse.message);
      });
    };
  }
]);

//# sourceMappingURL=../maps/controllers/OrgAdminTeamController.js.map
