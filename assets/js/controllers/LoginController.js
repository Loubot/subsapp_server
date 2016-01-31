'use strict';
angular.module('subzapp').controller('LoginController', [
  '$scope', '$state', '$http', '$window', 'RESOURCES', 'alertify', function($scope, $state, $http, $window, RESOURCES, alertify) {
    console.log('Login Controller');
    $scope.login_submit = function() {
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/auth/signin",
        headers: {
          'Content-Type': 'application/json'
        },
        data: $scope.login_form_data
      }).then((function(response) {
        console.log("User id " + response.data.user);
        console.log(response);
        $scope.user = response.data.user;
        window.localStorage.setItem('user_token', response.data.token);
        window.localStorage.setItem('user_id', response.data.user.id);
        if ($scope.user.club_admin) {
          console.log('club_admin');
          return $state.go('org_admin');
        } else {
          console.log('team_manager');
          return $state.go('team_manager_home');
        }
      }), function(errResponse) {
        console.log("Error response " + (JSON.stringify(errResponse.data)));
        window.USER = null;
        return alertify.error(errResponse.data.message);
      });
    };
    return $scope.credentials = {
      email: '',
      password: ''
    };
  }
]);
