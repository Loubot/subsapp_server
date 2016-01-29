'use strict';
angular.module('subzapp').controller('NavController', [
  '$scope', '$state', '$stateParams', function($scope, $state, $stateParams) {
    console.log('Nav controller');
    $scope.goto = function(state) {
      console.log("going to " + state + ", so there...");
      return $state.go(state);
    };
    return $scope.log_out = function() {
      window.localStorage.setItem('user_token', null);
      window.localStorage.setItem('user_id', null);
      return $state.go('login');
    };
  }
]);

//# sourceMappingURL=NavController.js.map
