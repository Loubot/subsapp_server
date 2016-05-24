'use strict';
angular.module('subzapp').controller('EventController', [
  '$scope', '$rootScope', '$state', 'COMMS', '$stateParams', 'user', 'RESOURCES', 'alertify', function($scope, $rootScope, $state, COMMS, $stateParams, user, RESOURCES, alertify) {
    console.log('Event Controller');
    console.log($stateParams.id);
    $scope.format = "dd-MMMM-yyyy";
    user.get_user().then((function(res) {
      $scope.user = $rootScope.USER;
      return COMMS.GET("/user/find-by-eventresponse/" + $stateParams.id).then((function(resp) {
        console.log("Got event");
        console.log(resp);
        alertify.success("Got event info");
        $scope.event = resp.data;
        return $scope.setDate();
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
    $scope.update_event = function() {
      console.log("Help");
      console.log($scope.event);
      return COMMS.POST("/event/" + $stateParams.id, $scope.event).then((function(res) {
        console.log("Event updated");
        console.log(res);
        return alertify.success("Event updated successfully");
      }), function(errResponse) {
        console.log("Event update error ");
        console.log(errResponse);
        return alertify.error("Event update error");
      });
    };
    $scope.setDate = function() {
      $scope.event.start_date = moment($scope.event.start_date).format('YYYY-MM-DD HH:mm');
      if ($scope.event.kick_off_date != null) {
        $scope.event.kick_off_date = moment($scope.event.kick_off_date).format('YYYY-MM-DD HH:mm');
      }
      return $scope.event.end_date = moment($scope.event.end_date).format('YYYY-MM-DD HH:mm');
    };
    return $scope.onTimeSet = function(nd, od) {
      $scope.event.start_date = moment(nd).format('YYYY-MM-DD HH:mm');
      if ($scope.event.kick_off_date != null) {
        $scope.event.kick_off_date = moment(nd).add(1, 'hours').format('YYYY-MM-DD HH:mm');
      }
      return $scope.event.end_date = moment(nd).add(2, 'hours').format('YYYY-MM-DD HH:mm');
    };
  }
]);

//# sourceMappingURL=../maps/controllers/EventController.js.map
