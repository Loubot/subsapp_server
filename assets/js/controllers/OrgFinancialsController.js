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
    return user.get_user().then(function(res) {
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
  }
]);

//# sourceMappingURL=../maps/controllers/OrgFinancialsController.js.map
