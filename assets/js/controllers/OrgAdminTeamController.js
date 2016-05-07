'use strict';
angular.module('subzapp').controller('OrgAdminTeamController', [
  '$scope', '$rootScope', '$state', '$http', '$window', 'user', 'RESOURCES', 'alertify', 'COMMS', function($scope, $rootScope, $state, $http, $window, user, RESOURCES, alertify, COMMS) {
    var check_club_admin, team_id;
    console.log('OrgAdminTeam Controller');
    check_club_admin = function(user) {
      if (!user.club_admin) {
        $state.go('login');
        return alertify.error('You are not a club admin. Contact subzapp admin team for assitance');
      }
    };
    team_id = window.localStorage.getItem('team_id');
    user.get_user().then((function(res) {
      check_club_admin(res.data);
      $scope.user = $rootScope.USER;
      return $scope.orgs = $rootScope.USER.orgs;
    }));
    COMMS.GET('/get-team', {
      team_id: team_id
    }).then((function(res) {
      console.log("Get team result");
      console.log(res);
      $scope.org = res.data.main_org;
      $scope.team = res.data;
      return alertify.success("Got team info");
    }), function(errResponse) {
      console.log("Get team error");
      console.log(errResponse);
      return alertify.error("Failed to get team info");
    });
    return $scope.invite_manager = function() {
      console.log($scope.invite_manager_data);
      return COMMS.POST('/invite-manager', {
        org_id: $scope.org.id,
        team_id: $location.search().id,
        club_admin: $scope.user.id,
        club_admin_email: $scope.user.email,
        invited_email: $scope.invite_manager_data.invited_email,
        main_org_name: $scope.org.name,
        team_name: $scope.team.name
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
