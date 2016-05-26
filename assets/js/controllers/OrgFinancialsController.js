'use strict';
angular.module('subzapp').controller('OrgFinancialsController', [
  '$scope', '$rootScope', '$state', '$http', 'RESOURCES', '$location', 'alertify', 'user', 'COMMS', 'stripe', function($scope, $rootScope, $state, $http, RESOURCES, $location, alertify, user, COMMS, stripe) {
    var check_for_stripe_code;
    console.log("OrgFinancialsController");
    $scope.withdrawl = {};
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
          var error, error1, message;
          console.log("Authenticated stripe");
          console.log(res);
          try {
            message = JSON.parse(res.data.body);
            console.log(message.error_description);
          } catch (error1) {
            error = error1;
            alert("No good boss");
          }
          if ((message != null) && (message.error_description != null)) {
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
    $scope.add_bank_details = function() {
      console.log($scope.account);
      return stripe.bankAccount.createToken($scope.account).then((function(stripe_account) {
        console.log("Stripe response");
        return console.log(stripe_account);
      }), function(errResponse) {
        return console.log(errResponse);
      });
    };
    return $scope.withdraw_tokens = function() {
      return console.log($scope.withdrawl.amount);
    };
  }
]);

//# sourceMappingURL=../maps/controllers/OrgFinancialsController.js.map
