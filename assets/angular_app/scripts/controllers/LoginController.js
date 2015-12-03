// Generated by CoffeeScript 1.10.0
'use strict';
angular.module('subzapp').controller('LoginController', [
  '$scope', '$state', '$http', '$window', 'message', 'RESOURCES', function($scope, $state, $http, $window, message, RESOURCES) {
    console.log('Login Controller');
    $scope.login_submit = function() {
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/auth/signin",
        data: $scope.login_form_data
      }).then((function(response) {
        console.log("User id " + response.data.user);
        console.log(response);
        window.localStorage.setItem('user_token', JSON.stringify(response.data.token));
        window.localStorage.setItem('user_id', response.data.user.id);
        return $state.go('user');
      }), function(errResponse) {
        console.log("Error response " + (JSON.stringify(errResponse.data)));
        return message.error(errResponse.data.message);
      });
    };
    return $scope.credentials = {
      email: '',
      password: ''
    };
  }
]);
