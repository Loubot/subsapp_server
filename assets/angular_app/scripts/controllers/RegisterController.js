// Generated by CoffeeScript 1.10.0
'use strict';
angular.module('subzapp').controller('RegisterController', [
  '$scope', '$state', '$http', '$window', 'RESOURCES', function($scope, $state, $http, $window, RESOURCES) {
    console.log('Register Controller');
    return $scope.register_submit = function() {
      $scope.register_form_data.manager_access = true;
      console.log($scope.register_form_data);
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/auth/signup",
        data: $scope.register_form_data
      }).then((function(response) {
        console.log("Registration successfull " + (JSON.stringify(response)));
        window.localStorage.setItem('user_token', response.data.data.token);
        window.localStorage.setItem('user_id', response.data.data.user.id);
        return $state.go('user');
      }), function(errResponse) {
        console.log("Registration failed " + (JSON.stringify(errResponse.data.invalidAttributes.email[0].message)));
        window.USER = null;
        return message.error(errResponse);
      });
    };
  }
]);
