'use strict';
angular.module('subzapp').controller('OrgFinancialsController', [
  '$scope', '$rootScope', '$state', '$http', 'RESOURCES', 'alertify', 'user', 'COMMS', 'stripe', '$location', function($scope, $rootScope, $state, $http, RESOURCES, alertify, user, COMMS, stripe, $location) {
    var check_for_stripe_code;
    console.log("OrgFinancialsController");
    $scope.withdrawl = {};
    $scope.display_stripe = true;
    $scope.account = {};
    $scope.account.country = "IE";
    $scope.account.currency = "EUR";
    $scope.options = ["individual", "company"];
    stripe.setPublishableKey('pk_test_bedFzS7vnmzthkrQolmUjXNn');
    check_for_stripe_code = function() {
      var display_stripe;
      display_stripe = $rootScope.USER.tokens[0].stripe_user_id === null;
      if ($location.search().code != null) {
        console.log($location.search().code);
        return COMMS.POST("/payment/" + $scope.org.id + "/authenticate-stripe", {
          auth_code: $location.search().code
        }).then((function(res) {
          console.log("Authenticated stripe");
          console.log(res);
          return alertify.success("Authenticated stripe");
        }), function(errResponse) {
          console.log("Failed to authenticate stripe");
          alertify.error("Failed to authenticate stripe");
          return console.log(errResponse);
        });
      }
    };
    user.get_user().then(function(res) {
      $scope.user = $rootScope.USER;
      return COMMS.GET("/org/" + $rootScope.USER.org[0].id).then((function(res) {
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
    return $scope.withdraw_tokens = function() {
      return console.log($scope.withdrawl.amount);
    };
  }
]);

//# sourceMappingURL=../maps/controllers/OrgFinancialsController.js.map
