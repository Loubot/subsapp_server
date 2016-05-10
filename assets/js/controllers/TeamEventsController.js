'use strict';
angular.module('subzapp').controller('TeamEventsController', [
  '$scope', '$rootScope', '$state', 'COMMS', 'user', 'alertify', 'RESOURCES', function($scope, $rootScope, $state, COMMS, user, alertify, RESOURCES) {
    console.log('Team Events Controller');
    return user.get_user().then((function(res) {
      $scope.user = $rootScope.USER;
      return COMMS.GET("/team/" + (window.localStorage.getItem('team_id'))).then((function(team) {
        console.log("Got team info");
        console.log(team);
        $scope.team = team.data;
        return alertify.success("Got team info");
      }), function(team_err) {
        console.log("Team error");
        console.log(team_err);
        return alertify.error("Failed to get team");
      });
    }), function(errResponse) {
      $rootScope.USER = null;
      return $state.go('login');
    });
  }
]);

//# sourceMappingURL=../maps/controllers/TeamEventsController.js.map
