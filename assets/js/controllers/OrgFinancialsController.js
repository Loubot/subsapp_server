'use strict';
angular.module('subzapp').controller('OrgFinancialsController', [
  '$scope', '$rootScope', '$state', '$http', 'RESOURCES', 'alertify', 'user', 'COMMS', 'stripe', function($scope, $rootScope, $state, $http, RESOURCES, alertify, user, COMMS, stripe) {
    console.log("OrgFinancialsController");
    $scope.withdrawl = {};
    $scope.account = {};
    $scope.account.country = "IE";
    $scope.account.currency = "EUR";
    $scope.options = ["individual", "company"];
    stripe.setPublishableKey('pk_test_bedFzS7vnmzthkrQolmUjXNn');
    user.get_user().then(function(res) {
      $scope.user = $rootScope.USER;
      return COMMS.GET("/org/" + $rootScope.USER.org[0].id).then((function(res) {
        console.log("Got org info");
        console.log(res.data.org);
        $scope.org = res.data.org;
        return alertify.success("Got org info");
      }), function(errResponse) {
        console.log("Get org error");
        console.log.errResponse;
        return alertify.error("Failed to get org info");
      });
    });
    $scope.add_bank_details = function() {
      console.log($scope.account);
      return stripe.bankAccount.createToken($scope.account).then((function(stripe_account) {
        stripe_account.org_id = $scope.org.id;
        console.log("Stripe response");
        console.log(stripe_account);
        stripe_account.account_id = stripe_account.id;
        delete stripe_account.id;
        return COMMS.POST("/org/" + $scope.org.id + "/bank-account", stripe_account).then((function(account_saved) {
          console.log("Account saved");
          console.log(account_saved);
          return alertify.success("Account saved ok");
        }), function(account_err) {
          console.log("Save account err");
          console.log(account_err);
          return alertify.error("Failed to save account");
        });
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
