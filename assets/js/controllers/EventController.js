'use strict';
angular.module('subzapp').controller('EventController', [
  '$scope', '$rootScope', '$state', 'COMMS', '$stateParams', 'user', 'RESOURCES', 'alertify', function($scope, $rootScope, $state, COMMS, $stateParams, user, RESOURCES, alertify) {
    console.log('Event Controller');
    console.log($stateParams.id);
    $scope.format = "dd-MMMM-yyyy";
    user.get_user().then((function(res) {
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
    $scope.update_event = function() {
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
    $scope.today = function() {
      return $scope.event.start_date = new Date();
    };
    $scope.clear = function() {
      $scope.event = null;
    };
    $scope.open1 = function() {
      $scope.popup1.opened = true;
    };
    $scope.open2 = function() {
      $scope.popup2.opened = true;
    };
    $scope.setDate = function(year, month, day) {
      $scope.event = new Date(year, month, day);
    };
    $scope.format = "dd-MMMM-yyyy";
    $scope.popup1 = {
      opened: false
    };
    return $scope.popup2 = {
      opened: false
    };
  }
]);

//# sourceMappingURL=../maps/controllers/EventController.js.map
