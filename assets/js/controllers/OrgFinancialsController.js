'use strict';
angular.module('subzapp').controller('OrgFinancialsController', [
  '$scope', '$rootScope', '$state', '$http', 'RESOURCES', 'alertify', 'user', 'COMMS', function($scope, $rootScope, $state, $http, RESOURCES, alertify, user, COMMS) {
    console.log("OrgFinancialsController");
    return user.get_user().then(function(res) {
      $scope.user = $rootScope.USER;
      return COMMS.GET("/org/" + $scope.user.org[0].id).then((function(res) {
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
  }
]);

//# sourceMappingURL=../maps/controllers/OrgFinancialsController.js.map
