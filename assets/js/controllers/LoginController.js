'use strict';
angular.module('subzapp').controller('LoginController', [
  '$scope', '$rootScope', '$state', 'COMMS', '$window', 'RESOURCES', 'alertify', function($scope, $rootScope, $state, COMMS, $window, RESOURCES, alertify) {
    console.log('Login Controller');
    $scope.login_submit = function() {
      return COMMS.POST("/auth/signin", $scope.login_form_data).then((function(response) {
        console.log("Logged in " + response.data.user);
        console.log(response);
        $rootScope.USER = response.data.user;
        window.localStorage.setItem('user_token', response.data.token);
        window.localStorage.setItem('user_id', response.data.user.id);
        if ($rootScope.USER.club_admin) {
          console.log('club_admin');
          return $state.go('org_admin');
        } else {
          console.log('team_manager');
          return $state.go('team_manager_home');
        }
      }), function(errResponse) {
        console.log("Error response " + (JSON.stringify(errResponse.data)));
        $rootScope.USER = null;
        return alertify.error(errResponse.data.message);
      });
    };
    return $scope.credentials = {
      email: '',
      password: ''
    };
  }
]);

//# sourceMappingURL=../maps/controllers/LoginController.js.map
