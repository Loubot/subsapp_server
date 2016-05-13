'use strict';
angular.module('subzapp').controller('OrgFinancialsController', [
  '$scope', '$rootScope', '$state', '$http', 'RESOURCES', '$location', 'alertify', 'user', 'COMMS', function($scope, $rootScope, $state, $http, RESOURCES, $location, alertify, user, COMMS) {
    var check_for_stripe_code;
    console.log("OrgFinancialsController");
    check_for_stripe_code = function() {
      if ($location.search().code != null) {
        console.log($location.search().code);
        return COMMS.POST("/payment/" + $scope.org.id + "/authenticate-stripe", {
          auth_code: $location.search().code
        }).then((function(res) {
          var message;
          console.log("Authenticated stripe");
          message = JSON.parse(res.data.body);
          console.log(message.error_description);
          if (message.error_description != null) {
            return alertify.error(message.error_description);
          } else {
            return alertify.success("Authenticated stripe");
          }
        }), function(errResponse) {
          console.log("Failed to authenticate stripe");
          alertify.error("Failed to authenticate stripe");
          return console.log(errResponse);
        });
      }
    };
    user.get_user().then(function(res) {
      $scope.user = $rootScope.USER;
      return COMMS.GET("/org/" + $scope.user.org[0].id).then((function(res) {
        console.log("Got org info");
        console.log(res.data.org);
        $scope.org = res.data.org;
        alertify.success("Got org info");
        return check_for_stripe_code();
      }), function(errResponse) {
        console.log("Get org error");
        console.log.errResponse;
        return alertify.error("Failed to get org info");
      });
    });
    $scope.dt = {};
    $scope.today = function() {
      var date;
      $scope.dt.start_date = new Date();
      date = new Date();
      $scope.dt.end_date = date.setDate(date.getDate() + 1);
      console.log("Date " + $scope.dt.end_date);
    };
    $scope.today();
    $scope.clear = function() {
      $scope.dt = null;
    };
    $scope.open1 = function() {
      $scope.popup1.opened = true;
    };
    $scope.open2 = function() {
      $scope.popup2.opened = true;
    };
    $scope.setDate = function(year, month, day) {
      $scope.dt = new Date(year, month, day);
    };
    $scope.format = "dd-MMMM-yyyy";
    $scope.popup1 = {
      opened: false
    };
    $scope.popup2 = {
      opened: false
    };
    return $scope.get_events = function() {
      return COMMS.GET("/team/:id/teams-events", $scope.dt).then((function(resp) {
        return console.log(resp);
      }), function(errResponse) {
        return console.log(errResponse);
      });
    };
  }
]);

//# sourceMappingURL=../maps/controllers/OrgFinancialsController.js.map
