'use strict';
angular.module('subzapp').controller('EventController', [
  '$scope', '$rootScope', '$state', 'COMMS', '$stateParams', 'user', 'RESOURCES', 'alertify', function($scope, $rootScope, $state, COMMS, $stateParams, user, RESOURCES, alertify) {
    console.log('Event Controller');
    console.log($stateParams.id);
    return user.get_user().then((function(res) {
      $scope.user = $rootScope.USER;
      return COMMS.GET("/event/" + $stateParams.id).then((function(resp) {
        console.log("Got event");
        console.log(resp);
        alertify.success("Got event info");
        return $scope.event = resp.data;
      }), function(event_err) {
        console.log("Failed to get event");
        console.log(event_err);
        return alertify.error("Failed to get err ");
      });
    }), function(errResponse) {
      console.log("User get error " + (JSON.stringify(errResponse)));
      window.USER = null;
      return $state.go('login');
    });
  }
]);

//# sourceMappingURL=../maps/controllers/EventController.js.map
