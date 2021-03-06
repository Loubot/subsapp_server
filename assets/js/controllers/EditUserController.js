'use strict';
angular.module('subzapp').controller('EditUserController', [
  '$scope', '$state', '$http', '$window', 'user', 'RESOURCES', 'alertify', function($scope, $state, $http, $window, user, RESOURCES, alertify) {
    var user_token;
    console.log('User Controller');
    user_token = window.localStorage.getItem('user_token');
    if (!(window.USER != null)) {
      user.get_user().then((function(res) {
        $scope.orgs = window.USER.orgs;
        return $scope.user = USER;
      }), function(errResponse) {
        console.log("User get error " + (JSON.stringify(errResponse)));
        window.USER = null;
        return $state.go('login');
      });
    } else {
      console.log('else');
      $scope.orgs = window.USER.orgs;
      $scope.user = USER;
    }
    return $scope.edit_user = function() {
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/edit-user",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: {
          id: $scope.user.id,
          firstName: $scope.user.firstName,
          lastName: $scope.user.lastName
        }
      }).then((function(response) {
        console.log("Edit user response " + (JSON.stringify(response)));
        return alertify.success('User updated ok');
      }), function(errResponse) {
        console.log("Edit user error " + (JSON.stringify(errResponse)));
        return alertify.error("User not updated");
      });
    };
  }
]);

//# sourceMappingURL=../maps/controllers/EditUserController.js.map
