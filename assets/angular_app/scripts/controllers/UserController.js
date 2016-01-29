'use strict';
angular.module('subzapp').controller('UserController', [
  '$scope', '$state', '$http', '$window', 'user', 'RESOURCES', function($scope, $state, $http, $window, user, RESOURCES) {
    console.log('User Controller');
    return user.get_user().then((function(res) {
      console.log("Got user ");
      console.log(window.USER);
      return $scope.teams = window.USER.teams;
    }));
  }
]);

//# sourceMappingURL=UserController.js.map
